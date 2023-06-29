

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

