#requires -version 2.0

<#

 Comments: This function is intended to be used in the ISE to print the current script file
 to the default printer.

 #>
 
Function Send-ToPrinter {

Param([string]$path=$PSISE.CurrentFile.FullPath)

Start-Process -filepath Notepad.exe -ArgumentList "/p",$path -WindowStyle Hidden

<#
this is an alternative way using the default printer
  get-content -Path $path | out-printer
#>

} #end function

