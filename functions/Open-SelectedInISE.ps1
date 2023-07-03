

Function Open-SelectedISE {
    [CmdletBinding()]
    Param([String]$Text = $psISE.CurrentFile.Editor.SelectedText)

    #trim off any spaces
    $file = $Text.Trim()

    if (Test-Path -Path $file ) {
        psedit $file
    }
    else {
        Write-Warning "Can't find $file"
    }

} #end function

