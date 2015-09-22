#requires -version 4.0

#close all saved files in the ISE

Function CloseAllFiles {
[cmdletbinding()]
Param()

$saved = $psISE.CurrentPowerShellTab.Files.Where({$_.isSaved})
foreach ($file in $saved) {
  write-Verbose "closing $($file.FullPath)"
  $psISE.CurrentPowerShellTab.files.Remove($file) | out-null
}

} #end function

#close all other saved files except for the active file
Function CloseAllFilesButCurrent {
[cmdletbinding()]
Param()

$saved = $psISE.CurrentPowerShellTab.Files.Where({$_.isSaved -AND $_.fullpath -ne $psISE.CurrentFile.FullPath })
foreach ($file in $saved) {
  write-Verbose "closing $($file.FullPath)"
  $psISE.CurrentPowerShellTab.files.Remove($file) | out-null
}

} #end function