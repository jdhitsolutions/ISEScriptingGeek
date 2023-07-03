Function ConvertTo-CommentHelp {
    [CmdletBinding()]
    Param()

    Add-Type -AssemblyName 'Microsoft.VisualBasic' -ErrorAction Stop
    $Prompt = 'Enter the name of a cmdlet. Leave blank to cancel'
    $Default = ''
    $Title = $MyInvocation.MyCommand.Name
    [String]$command = [Microsoft.VisualBasic.interaction]::InputBox($Prompt, $Title, $Default)

    if ($command) {
        Try {

            $help = Get-Help -Name $command -Full -ErrorAction Stop
        }
        Catch {
            Throw $_
            #bail out
            Return
        }
    }
    Else {
        #cancelled
    }

    If ($help) {
        $myHelp = @"
<#
.Synopsis
$($help.Synopsis)
.Description
$($help.description.Text)
$(foreach ($param in $help.parameters.parameter) {
".Parameter $($param.name)`n"
"$($param.Description.Text)"
"`n"
})
.Inputs
$(($help.inputTypes | Out-String).trim())
.Outputs
$(($help.returnValues | Out-String).trim())
.Notes
$($help.alertSet.alert | ForEach-Object {"$($_.text)`n"})
$(foreach ($item in $help.examples.example) {
".Example`n"
 $($item.code)
 "`n"
 $(($item.remarks| Out-String).trimEnd())
 "`n"
})
.Link
$(($help.relatedLinks | Out-String).Trim())
#>
"@

        $myHelp | Out-ISETab
    } #if $help

}
