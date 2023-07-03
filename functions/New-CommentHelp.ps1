# Comments:
#This works best in the ISE with your function already loaded.

Function New-CommentHelp {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "What is the name of your function or command?" )]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Position = 1, Mandatory, HelpMessage = "Enter a brief synopsis" )]
        [ValidateNotNullOrEmpty()]
        [String]$Synopsis,

        [Parameter(Position = 2, Mandatory, HelpMessage = "Enter a description. You can expand and edit later" )]
        [ValidateNotNullOrEmpty()]
        [String]$Description
    )

    #define beginning of comment based string

    $comment = @"
<#
.SYNOPSIS
{0}
.DESCRIPTION
{1}

"@


    #Create comment based help string
    $help = $comment -f $synopsis, $description

    #test if command is loaded and if so get parameters
    #ignore common:
    $common = "VERBOSE|DEBUG|ERRORACTION|WARNINGACTION|ERRORVARIABLE|WARNINGVARIABLE|OUTVARIABLE|OUTBUFFER|PIPELINEVARIABLE|WhatIf|CONFIRM|INFORMATIONVARIABLE|INFORMATIONACTION"
    Try {
        $command = Get-Command -Name $name -ErrorAction Stop
        $params = $command.parameters.keys | Where-Object {$_ -notmatch $common}
    }
    Catch {
        #otherwise prompt
        $ScriptName = Read-Host "If your command is a script file, enter the full file name with extension. Otherwise leave blank"
        if ($ScriptName) {
            Try {
                $command = Get-Command -Name $ScriptName -ErrorAction Stop
                $params = $command.parameters.keys | Where-Object {$_ -notmatch $common}
            }
            Catch {
                Write-Warning "Failed to find $ScriptName"
                #BAIL OUT
                Return
            }

        } #if $ScriptName
        else {
            #prompt for a comma separated list of parameter names
            $EnterParams = Read-Host "Enter a comma separated list of parameter names"
            $Params = $EnterParams.Split(",")
        }
    }

    #get parameters from help or prompt for comma separated list
    if ($params) {
        Foreach ($param in $params) {
            #get aliases from the command
            $aliases = $command.parameters[$param].aliases
            #get parameter attribute
            $pa = $command.parameters[$param].Attributes  | Where-Object {$_.GetType().name -eq "ParameterAttribute"}
            #extract any parameter help messages
            if ($pa.HelpMessage) {
                [String]$paramDesc = $pa.HelpMessage
            }
            if ($aliases) {
                $paramDesc += " This command has aliases of: $($aliases -join ",")"
            }
            #define a new line
            #this must be left justified to avoid a parsing error
            $paramHelp = @"
.PARAMETER $Param
$paramDesc

"@

            #append the parameter to the help comment
            $help += $paramHelp
        } #foreach param
    } #if $params

    #Define a default example using the command name
    #this must be left justified to avoid a parsing error
    $exHelp = @"
.EXAMPLE
PS C:\> $Name


"@

    #add the example to the help comment
    $help += $exHelp

    #stuff for the Notes section
    $version = "1.0"
    $verDate = (Get-Date).ToShortDateString()


    #construct a Notes section
    $NoteHere = @"
.NOTES
NAME        :  {0}
VERSION     :  {1}
LAST UPDATED:  {2}
AUTHOR      :  {3}\{4}

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-PowerShell-resources/

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************

"@

    #insert the values
    $Notes = $NoteHere -f $Name, $version, $verDate, $env:userdomain, $env:username

    #add the section to help
    $help += $Notes

    #define a here string for any links you might want to add
    $linkHelp = @"
.LINK

"@

    #add the section to help
    $help += $linkHelp

    #}

    #Inputs
    $inputHelp = @"
.INPUTS

"@

    $help += $InputHelp

    #outputs
    $outputHelp = @"
.OUTPUTS

"@

    $help += $OutputHelp

    #close the help comment
    $help += "#>"

    #if ISE insert into current file
    if ($psISE) {
        $psISE.CurrentFile.Editor.InsertText($help) | Out-Null
    }
    else {
        #else write to the pipeline
        $help
    }

} #end function
