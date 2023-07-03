<#
this is an alternative way using the default printer
  get-content -Path $path | out-printer
#>

Function Send-ToPrinter {
  [CmdletBinding()]
  Param([String]$path = $psISE.CurrentFile.FullPath)

  Start-Process -FilePath Notepad.exe -ArgumentList '/p', $path -WindowStyle Hidden


} #end function

