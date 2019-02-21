

Function Get-ASTProfile {

    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, HelpMessage = "Enter the path of a PowerShell script")]
        [ValidateScript( {Test-Path $_})]
        [ValidatePattern( "\.(ps1|psm1|txt)$")]
        [string]$Path = $(Read-Host "Enter the filename and path to a PowerShell script"),
        [ValidateScript( {Test-Path $_})]
        [Alias("fp", "out")]
        [string]$FilePath = "$env:userprofile\Documents\WindowsPowerShell"
    )

    Write-Verbose "Starting $($myinvocation.MyCommand)"

    #region setup profiling
    #need to resolve full path and convert it
    $Path = (Resolve-Path -Path $Path).Path | Convert-Path
    Write-Verbose "Analyzing $Path"

    Write-Verbose "Parsing File for AST"
    New-Variable astTokens -force
    New-Variable astErr -force

    $AST = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$astTokens, [ref]$astErr)

    #endregion

    #region generate AST data

    #include PowerShell version information
    Write-Verbose "PSVersionTable"
    Write-Verbose ($PSversionTable | Out-String)

    if ($ast.ScriptRequirements) {
        $requirements = ($ast.ScriptRequirements | Out-String).Trim()
    }
    else {
        $requirements = "-->None detected"
    }

    if ($ast.ParamBlock.Parameters ) {
        write-verbose "Parameters detected"
        $foundParams = $(($ast.ParamBlock.Parameters |
                    Select Name, DefaultValue, StaticType, Attributes |
                    Format-List | Out-String).Trim()
        )
    }
    else {
        $foundParams = "-->None detected. Parameters for nested commands not tested."
    }


    #define the report text
    $report = @"
This is an analysis of a PowerShell script or module. Analysis will most likely NOT be 100% thorough.

"@

    Write-Verbose "Getting requirements and parameters"
    $report += @"

REQUIREMENTS
$requirements

PARAMETERS
$foundparams

"@

    Write-Verbose "Getting all command elements"

    $commands = @()
    $unresolved = @()

    $genericCommands = $astTokens |
        where {$_.tokenflags -eq 'commandname' -AND $_.kind -eq 'generic'}

    $aliases = $astTokens |
        where {$_.tokenflags -eq 'commandname' -AND $_.kind -eq 'identifier'}

    Write-Verbose "Parsing commands"
    foreach ($command in $genericCommands) {
        Try {
            $commands += Get-Command -Name $command.text -ErrorAction Stop
        }
        Catch {
            $unresolved += $command.Text
        }
    }

    foreach ($command in $aliases) {
        Try {
            $commands += Get-Command -Name $command.text -erroraction Stop |
                foreach {
                #get the resolved command
                Get-Command -Name $_.Definition
            }
        }
        Catch {
            $unresolved += $command.Text
        }
    }

    Write-Verbose "All commands"
    $report += @"

ALL COMMANDS
All possible PowerShell commands. This list may not be complete or even correct.

$(($Commands | Sort -Unique | Format-Table -autosize | Out-String).Trim())

"@

    Write-Verbose "Unresolved commands"
    if ($unresolved) {
        $unresolvedText = $Unresolved | Sort -Unique | Format-Table -autosize | Out-String
    }
    else {
        $unresolvedText = "-->None detected"
    }

    $report += @"

UNRESOLVED
These commands may be called from nested commands or unknown modules.

$unresolvedtext
"@

    Write-Verbose "Potentially dangerous commands"
    #identify dangerous commands
    $danger = "Remove", "Stop", "Disconnect", "Suspend", "Block",
    "Disable", "Deny", "Unpublish", "Dismount", "Reset", "Resize",
    "Rename", "Redo", "Lock", "Hide", "Clear"

    $danger = $commands | where {$danger -contains $_.verb} | Sort Name | Get-Unique

    if ($danger) {
        $dangercommands = $($danger | Format-Table -AutoSize | Out-String).Trim()
    }
    else {
        $dangercommands = "-->None detected"
    }

    #get type names, some of which may come from parameters
    Write-Verbose "Typenames"

    $typetokens = $asttokens | where {$_.tokenflags -eq 'TypeName'}
    if ($typetokens ) {
        $foundTypes = $typetokens |
            Sort @{expression = {$_.text.toupper()}} -unique |
            Select -ExpandProperty Text | foreach { "[$_]"} | Out-String
    }
    else {
        $foundTypes = "-->None detected"
    }

    $report += @"

TYPENAMES
These are identified .NET type names that might be used as accelerators.

$foundTypes
"@

    $report += @"

WARNING
These are potentially dangerous commands.

$dangercommands
"@

    #endregion

    Write-Verbose "Display results"
    #region create and display the result

    #create a help topic file using the script basename
    $basename = (Get-Item $Path).basename
    #stored in the Documents folder
    $reportFile = Join-Path -Path $FilePath -ChildPath "ABOUT_$basename.help.txt"

    Write-Verbose "Saving report to $reportFile"
    #insert the Topic line so help recognizes it
    @"
TOPIC
about $basename profile

"@ |Out-File -FilePath $reportFile -Encoding ascii

    #create the report
    @"
SHORT DESCRIPTION
Script Profile report for: $Path

"@ | Out-File -FilePath $reportFile -Encoding ascii -Append

    @"
LONG DESCRIPTION
$report
"@  | Out-File -FilePath $reportFile -Encoding ascii -Append

    #view the report with Notepad

    Notepad $reportFile

    #endregion

    Write-Verbose "Profiling complete."
} #end of function