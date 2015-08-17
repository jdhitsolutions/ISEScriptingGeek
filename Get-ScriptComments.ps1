#requires -version 4.0

#parse a script file for comments only

Function Get-ScriptComments {
<#
.Synopsis
Get comments from a PowerShell script file.
.Description
This command will use the AST parser to go through a PowerShell script, either a .ps1 or .psm1 file, and display only the comments.
.Example
PS C:\> get-scriptcomments c:\scripts\MyScript.ps1
#>

[cmdletbinding()]
Param(
[Parameter(Position=0,Mandatory,HelpMessage="Enter the path of a PS1 file",
ValueFromPipeline,ValueFromPipelineByPropertyName)]
[Alias("PSPath","Name")]
[ValidateScript({Test-Path $_})]
[ValidatePattern("\.ps(1|m1)$")]
[string]$Path
)

Begin { 
#Begin scriptblock
    Write-Verbose -Message "Starting $($MyInvocation.Mycommand)" 
    #initialization commands 
    #explicitly define some AST variables
    New-Variable astTokens -force
    New-Variable astErr -force
} #close begin

Process {
#Process scriptblock
    #convert each path to a nice filesystem path
    $Path= Convert-Path -Path $Path

    Write-Verbose -Message "Parsing $Path"
    #Parse the file
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($Path,[ref]$astTokens,[ref]$astErr)

    #filter tokens for comments and display text
    $asttokens.where({$_.kind -eq 'comment'}) | 
    Select-Object -ExpandProperty Text
} #close process

End {
#end scriptblock

    #ending the function
    Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
} #close end

} #close function