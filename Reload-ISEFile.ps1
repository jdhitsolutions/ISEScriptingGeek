#requires -version 4.0

<#
reload an file in the ISE that might have been modified outside
of the ISE.

#>
Function Reset-ISEFile {

#save the current file path
$path = $psise.CurrentFile.FullPath
#get current index
$i = $psise.CurrentPowerShellTab.files.IndexOf($psise.CurrentFile)
#remove the file
$psise.CurrentPowerShellTab.Files.Remove($psise.CurrentFile) | out-null
$psise.CurrentPowerShellTab.Files.Add($path) | out-null
#file always added to the end
$psise.CurrentPowerShellTab.files.Move(($psise.CurrentPowerShellTab.files.count-1),$i) | out-Null

}