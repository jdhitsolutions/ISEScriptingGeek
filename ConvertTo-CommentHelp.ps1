#requires -version 3.0

<#

this function will make a best effort to convert help from an existing cmdlet to comment
based help. This is handy when building a proxy function.
Converted help will be opened in a new ISE Tab.
#>

Function ConvertTo-CommentHelp {

Param()

Add-Type -AssemblyName "microsoft.visualbasic" -ErrorAction Stop 
$Prompt = "Enter the name of a cmdlet. Leave blank to cancel"
$Default = ""
$Title = $MyInvocation.MyCommand.Name
[string]$command = [microsoft.visualbasic.interaction]::InputBox($Prompt,$Title,$Default)

if ($command) {
Try {

    $help = get-help -Name $command -full -errorAction Stop
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
$(($help.inputTypes | out-string).trim())
.Outputs
$(($help.returnValues | out-string).trim())
.Notes
$($help.alertSet.alert | foreach {"$($_.text)`n"})
$(foreach ($item in $help.examples.example) {
".Example`n"
 $($item.code)
 "`n"
 $(($item.remarks| out-string).trimEnd())
 "`n"
})
.Link
$(($help.relatedLinks | out-string).Trim())
#>
"@

$myHelp | Out-ISETab
} #if $help

}