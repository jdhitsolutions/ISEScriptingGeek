#requires -version 2.0

Function Convert-AliasDefinition {

[cmdletBinding(DefaultParameterSetName="ToDefinition")]

Param(
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter a string to convert")]
[string]$Text,
[Parameter(ParameterSetName="ToAlias")]
[switch]$ToAlias,
[Parameter(ParameterSetName="ToDefinition")]
[switch]$ToDefinition
)

#make sure we are using the ISE
if ($host.name -match "ISE") {
    Try  {
        #get alias if it exists otherwise throw an exception that 
        #will be caught
        if ($ToAlias) {
            #get alias by definition and convert to name
            $alias=get-alias -definition $Text -ErrorAction Stop
            #there might be multiples so use the first one found
            if ($alias -is [array]) {
                $replace=$alias[0].name
            }
            else  {
                $replace=$alias.name
            }
        }
        else {
            #get alias by name and convert to definition
            
            #if the text is ?, this is a special character so
            #we'll just assume it is Where-Object
            if ($Text -eq "?") {
                $Replace="Where-Object"
            }
            else {
                $alias= Get-Alias -name $Text -ErrorAction Stop
                $replace=$alias.definition
            }
        } #Else ToDefinition
        
    } #close Try

    Catch  {
        Write-Host "Nothing for for $text" -ForegroundColor Cyan   
    }

    #make changes if an alias was found
    If ($replace)  {
        #Insert the replacment
        $psise.currentfile.editor.insertText($replace)
    }

} #if ISE
else {
    Write-Warning "You must be using the PowerShell ISE"
}

} #end function

