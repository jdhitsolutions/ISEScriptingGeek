#requires -version 3.0

#convert selected text into a multi-line comment

Function ConvertTo-MultiLineComment {
[cmdletbinding()]
Param([string]$Text = $psise.CurrentFile.Editor.SelectedText)

if ($text -match "^<#" -AND $text -match "#>$") {
 Write-Warning "Selected text already appears to be a multiline comment"
}
elseif ($text -match "^#") {
    #strip off # in text
    $text = $text.Replace("#","")
    $replace="<#`n$text`n#>"
    
}
else {
 $replace=@"
<#
$Text
#>
"@

} #else

if ($replace) {
    $psise.currentfile.editor.InsertText($replace)
}
} #end function

Function ConvertFrom-MultiLineComment {
[cmdletbinding()]
Param([string]$Text = $psise.CurrentFile.Editor.SelectedText)

#trim off leading and trailing spaces
$MyText = $Text.Trim()

if ($MyText.StartsWith("<#") -AND $MyText.EndsWith("#>")) {
    #get everything between the first 2 and last 2 characters
    $replace = $myText.Substring(2,$MyText.length -4)

    #insert a #character 
    [string[]]$newText = $replace.split("`n") |
    select -Skip 1 -First ($MyText.Split("`n").count-2) | foreach {("#$_").Trim()}
    $psise.currentfile.editor.InsertText(($newtext.trim() | out-string))
}
else {
    Write-Warning "Could not detect that selected text is a multiline comment"
}

} #end function


