#requires -version 4.0

<#
view snippets and edit selected in the PowerShell ISE
Changes won't be effective until the next ISE session or tab
#>
Function Edit-Snippet {
Param(
[string]$Path = "$env:userprofile\Documents\WindowsPowerShell\Snippets"
)

#display snippets by name without the .snippet.ps1xml extension
$snips = dir $path | Select @{Name="Name";Expression={$_.name.split(".")[0]}} |
Out-Gridview -title "Select one or more snippets to edit" -OutputMode Multiple

foreach ($snip in $snips) {
   $file = join-path -Path $path -ChildPath "$($snip.name).snippets.ps1xml"
   psedit $file
}

}

