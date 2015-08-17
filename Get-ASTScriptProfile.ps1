#requires -version 3.0

#Get-ASTScriptProfile.ps1

Function Get-ASTProfile {
<#
.Synopsis
Profile a PowerShell script
.Description
This script will parse a PowerShell script using the AST to identify elements and any items that might be dangerous. The output is a text report which by default is turned into a help topic stored in your Windows PowerShell folder under Documents, although you can specify an alternate location.

DETAILS
The script takes the name of a script to profile. You can specify a ps1 or psm1 filename. Using the AST the script will prepare a text report showing you any script requirements, script parameters, commands and type names. You will see all commands used including those that can't be resolved as well as those that I thought might be considered potentially dangerous such as cmdlets that use the verbs Remove or Stop. 
Because some people might invoke methods from .NET classes directly I've also captured all typenames. Most of them will probably be related to parameters but as least you'll know what to look for. 

The report won't detail parameters from nested functions but you'll still see what commands they will use. The script uses Get-Command to identify commands which might entail loading a module. Most of the time this shouldn't be an issue but you still might want to profile the script in virtualized or test environment. 

Any unresolved command you see is either from a module that couldn't be loaded or it might be an internally defined command. Once you know what to look for you can open the script in your favorite editor and search for the mystery commands.

Note that if the script uses application names like Main or Control for function names, they might be misinterpreted. In that case, search the script for the name, ie "main". 

This version will only analyze files with an extension of .ps1, .psm1 or .txt.
.Parameter Path
The path to the script file. It should have an extension of .ps1, .psm1 or .bat.
.Parameter FilePath
The path for the report file. The default is your WindowsPowerShell folder. This paramter has aliases of fp and out.
.Example
PS C:\> c:\scripts\Get-ASTScriptProfile c:\download\UnknownScript.ps1 

This will analyze the script UnknownScript.ps1 and show the results in a help window. It will also create a text file in your Documents\WindowsPowerShell folder called UnknownScript.help.txt.
.Example
PS C:\> c:\scripts\Get-ASTScriptProfile c:\download\UnknownScript.ps1 -filepath c:\work

This command is the same as the first example except the help file will be created in C:\Work.

.Notes
Version      : 3.0
Last Updated : October 29, 2014
Author       : Jeffery Hicks (http://twitter.com/jeffhicks)

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/


   ****************************************************************
   * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
   * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
   * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
   * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
   ****************************************************************
 
.Inputs
None
.Outputs
Help topic
.Link
Get-Command
Get-Alias
#>

[cmdletbinding()]
Param(
[Parameter(Position=0,HelpMessage="Enter the path of a PowerShell script")]
[ValidateScript({Test-Path $_})]
[ValidatePattern( "\.(ps1|psm1|txt)$")]
[string]$Path=$(Read-Host "Enter the filename and path to a PowerShell script"),
[ValidateScript({Test-Path $_})]
[Alias("fp","out")]
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

$AST = [System.Management.Automation.Language.Parser]::ParseFile($Path,[ref]$astTokens,[ref]$astErr)

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
 Select Name,DefaultValue,StaticType,Attributes |
 Format-List | Out-String).Trim()
 )
}
else {
 $foundParams = "-->None detected. Parameters for nested commands not tested."
}


#define the report text
$report=@"
This is an analysis of a PowerShell script or module. Analysis will most likely NOT be 100% thorough. 

"@

Write-Verbose "Getting requirements and parameters"
$report+=@"

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
       $commands+= Get-Command -Name $command.text -ErrorAction Stop
    }
    Catch {
      $unresolved+= $command.Text
    }
}

foreach ($command in $aliases) {
Try {
       $commands+= Get-Command -Name $command.text -erroraction Stop |
       foreach { 
         #get the resolved command
         Get-Command -Name $_.Definition  
       }
    }
    Catch {
        $unresolved+= $command.Text
    }
}

Write-Verbose "All commands"
$report+=@"

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

$report+=@"

UNRESOLVED    
These commands may be called from nested commands or unknown modules.

$unresolvedtext
"@

Write-Verbose "Potentially dangerous commands"
#identify dangerous commands
$danger="Remove","Stop","Disconnect","Suspend","Block",
"Disable","Deny","Unpublish","Dismount","Reset","Resize",
"Rename","Redo","Lock","Hide","Clear"

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
Sort @{expression={$_.text.toupper()}} -unique | 
Select -ExpandProperty Text | foreach { "[$_]"} | Out-String
}
else {
    $foundTypes = "-->None detected"
}

$report+=@"

TYPENAMES
These are identified .NET type names that might be used as accelerators.

$foundTypes
"@

$report+=@"

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