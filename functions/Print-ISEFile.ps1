

<#
this is an alternative way using the default printer
  get-content -Path $path | out-printer
#>

Function Send-ToPrinter {

    Param([string]$path = $PSISE.CurrentFile.FullPath)

    Start-Process -filepath Notepad.exe -ArgumentList "/p", $path -WindowStyle Hidden


} #end function

