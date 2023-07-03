Function Convert-AliasDefinition {
    [CmdletBinding(DefaultParameterSetName = 'ToDefinition')]

    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = 'Enter a string to convert')]
        [String]$Text,
        [Parameter(ParameterSetName = 'ToAlias')]
        [Switch]$ToAlias,
        [Parameter(ParameterSetName = 'ToDefinition')]
        [Switch]$ToDefinition
    )

    #make sure we are using the ISE
    if ($host.name -match 'ISE') {
        Try {
            #get alias if it exists otherwise throw an exception that
            #will be caught
            if ($ToAlias) {
                #get alias by definition and convert to name
                $alias = Get-Alias -Definition $Text -ErrorAction Stop
                #there might be multiples so use the first one found
                if ($alias -is [array]) {
                    $replace = $alias[0].name
                }
                else {
                    $replace = $alias.name
                }
            }
            else {
                #get alias by name and convert to definition

                #if the text is ?, this is a special character so
                #we'll just assume it is Where-Object
                if ($Text -eq '?') {
                    $Replace = 'Where-Object'
                }
                else {
                    $alias = Get-Alias -Name $Text -ErrorAction Stop
                    $replace = $alias.definition
                }
            } #Else ToDefinition

        } #close Try

        Catch {
            Write-Host "Nothing for for $text" -ForegroundColor Cyan
        }

        #make changes if an alias was found
        If ($replace) {
            #Insert the replacement
            $psISE.CurrentFile.editor.insertText($replace)
        }

    } #if ISE
    else {
        Write-Warning 'You must be using the PowerShell ISE'
    }

} #end function

