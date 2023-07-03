
Function Reset-ISEFile {
    [cmdletbinding()]
    Param()
    #save the current file path
    $path = $psISE.CurrentFile.FullPath
    #get current index
    $i = $psISE.CurrentPowerShellTab.files.IndexOf($psISE.CurrentFile)
    #remove the file
    [void]$psISE.CurrentPowerShellTab.Files.Remove($psISE.CurrentFile)
    [void]$psISE.CurrentPowerShellTab.Files.Add($path)
    #file always added to the end
    [void]$psISE.CurrentPowerShellTab.files.Move(($psISE.CurrentPowerShellTab.files.count - 1), $i)

}
