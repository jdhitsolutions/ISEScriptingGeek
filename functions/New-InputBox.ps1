Function New-InputBox {
    [CmdletBinding()]
    Param (
        [Parameter(Position = 0, Mandatory, HelpMessage = 'Enter a message prompt')]
        [ValidateNotNullOrEmpty()]
        [String]$Prompt,
        [Parameter(Position = 1)]
        [String]$Title = 'Input',
        [Parameter(Position = 2)]
        [String]$Default

    )

    Try {
        Add-Type -AssemblyName 'Microsoft.VisualBasic' -ErrorAction Stop
        [Microsoft.VisualBasic.interaction]::InputBox($Prompt, $Title, $Default)
    }
    Catch {
        Write-Warning 'There was a problem creating the InputBox'
        Write-Warning $_.Exception.Message
    }

} #end New-InputBox
