
Function Reset-ISEFile {

    Param()
    #save the current file path
    $path = $psise.CurrentFile.FullPath
    #get current index
    $i = $psise.CurrentPowerShellTab.files.IndexOf($psise.CurrentFile)
    #remove the file
    [void]$psise.CurrentPowerShellTab.Files.Remove($psise.CurrentFile)
    [void]$psise.CurrentPowerShellTab.Files.Add($path)
    #file always added to the end
    [void]$psise.CurrentPowerShellTab.files.Move(($psise.CurrentPowerShellTab.files.count - 1), $i) 

}