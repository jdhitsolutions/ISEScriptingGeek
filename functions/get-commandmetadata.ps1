

Function Get-CommandMetadata {
    [CmdletBinding()]
    [alias('gcmd')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Enter the name of a PowerShell command'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Command,
        [String]$NewName,
        [Switch]$NoHelp
    )

    Try {
        Write-Verbose "Getting command metadata for $command"
        $gcm = Get-Command -Name $command -ErrorAction Stop
        #allow an alias or command name
        if ($gcm.CommandType -eq 'Alias') {
            $CmdName = $gcm.ResolvedCommandName
        }
        else {
            $CmdName = $gcm.Name
        }
        Write-Verbose "Resolved to $CmdName"
        $cmd = New-Object System.Management.Automation.CommandMetaData ($gcm)
    }
    Catch {
        Write-Warning "Failed to create command metadata for $command"
        Write-Warning $_.Exception.Message
    }

    if ($cmd) {
        #create the metadata

        if ($NewName) {
            $Name = $NewName
        }
        else {
            $Name = $cmd.Name
        }

        if ($noHelp) {
            #remove help link
            $cmd.HelpUri = $Null

            Write-Verbose 'Defining a new comment based help block'
            #define outline for comment based help
            $myHelp = @"

.Synopsis
PUT SYNTAX HERE
.Description
PUT DESCRIPTION HERE
.Notes
Created:`t$(Get-Date -Format d)

.Example
PS C:\> $Name

.Link
$CmdName

"@
            Write-Verbose 'Creating proxy command with help'
            $metadata = [System.Management.Automation.ProxyCommand]::Create($cmd, $myHelp)

        } #noHelp
        else {
            Write-Verbose 'Creating proxy command'
            $metadata = [System.Management.Automation.ProxyCommand]::Create($cmd)
        }

        Write-Verbose 'Cleaning up parameter names'
        [regex]$rx = '[\s+]\$\{\w+\}[,|)]'
        $metadata = $metadata.split("`n") | ForEach-Object {
            If ($rx.IsMatch($_)) {
                #strip off { } around parameter names
                $rx.Match($_).Value.Replace('{', '').Replace('}', '')
                # "`n"
            }
            else {
                #just write the line
                $_
            }
        } #foreach

        #define the text for the new command
        $text = @"
#requires -version $($PSVersionTable.PSVersion)

Function $Name {

$metadata

} #end function $Name
"@
        if ($host.Name -match 'PowerShell ISE') {
            #open in a new ISE tab
            $tab = $psISE.CurrentPowerShellTab.Files.Add()

            Write-Verbose 'Opening metadata in a new ISE tab'
            $tab.editor.InsertText($Text)

            #jump to the top
            $tab.Editor.SetCaretPosition(1, 1)
        }
        else {
            $Text
        }
    }
    Write-Verbose "Ending $($MyInvocation.MyCommand)"

} #end function

