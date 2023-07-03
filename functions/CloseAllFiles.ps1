

#close all saved files in the ISE

Function CloseAllFiles {
    [CmdletBinding()]
    Param()

    $saved = $psISE.CurrentPowerShellTab.Files.Where( { $_.isSaved })
    foreach ($file in $saved) {
        Write-Verbose "closing $($file.FullPath)"
        [void]$psISE.CurrentPowerShellTab.files.Remove($file)
    }

} #end function

#close all other saved files except for the active file
Function CloseAllFilesButCurrent {
    [CmdletBinding()]
    Param()

    $saved = $psISE.CurrentPowerShellTab.Files.Where( { $_.isSaved -AND $_.FullPath -ne $psISE.CurrentFile.FullPath })
    foreach ($file in $saved) {
        Write-Verbose "closing $($file.FullPath)"
        [void]$psISE.CurrentPowerShellTab.files.Remove($file)
    }

} #end function
