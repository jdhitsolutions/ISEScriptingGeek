#requires -version 3.0

#open selected file in an ISE Tab.

Function Open-SelectedISE {
[cmdletbinding()]
Param([string]$Text = $psise.CurrentFile.Editor.SelectedText)

if (Test-path $Text ) {
    psedit $text
} 
else {
  #open a new ISE tab and insert the text
  $new = $psise.CurrentPowerShellTab.Files.add()
  $new.editor.InsertText($text)
}

}

