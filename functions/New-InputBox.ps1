Function New-Inputbox {

    [cmdletbinding()]

    Param (
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter a message prompt")]
        [ValidateNotNullorEmpty()]
        [string]$Prompt,
        [Parameter(Position = 1)]
        [string]$Title = "Input",
        [Parameter(Position = 2)]
        [string]$Default

    )

    Try {
        Add-Type -AssemblyName "microsoft.visualbasic" -ErrorAction Stop
        [microsoft.visualbasic.interaction]::InputBox($Prompt, $Title, $Default)
    }
    Catch {
        Write-Warning "There was a problem creating the inputbox"
        Write-Warning $_.Exception.Message
    }

} #end New-Inputbox