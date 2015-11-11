#requires -version 3.0

#open selected file in an ISE Tab.

#modified to trim off any extra spaces and write if warning if file not found

Function Open-SelectedISE {
[cmdletbinding()]
Param([string]$Text = $psise.CurrentFile.Editor.SelectedText)

#trim off any spaces
$file = $Text.Trim()

if (Test-Path -Path $file ) {
    psedit $file
} 
else {
  Write-Warning "Can't find $file"  
}

} #end function

