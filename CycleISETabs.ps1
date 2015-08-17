#requires -version 3.0

#cycle through PowerShell Tabs
#this needs to be in your PowerShell ISE profile to work properly

Function Get-NextISETab {
[cmdletbinding()]
Param()

$iseTabs = $psISE.PowerShellTabs

#get current tab
for ($i=0; $i -le $iseTabs.count-1; $i++) {
   Write-Verbose $iseTabs[$i].Displayname
  if ($iseTabs[$i].Displayname -eq $psISE.CurrentPowerShellTab.DisplayName) {
   $current = $i   
  }
}

#check if the next index number if valid
if ($current++ -ge $iseTabs.count-1) {
  $next = 0
}
else {
  $next = $current++
}

$nextTab = $iseTabs[$next]

$iseTabs.SelectedPowerShellTab = $NextTab

}

