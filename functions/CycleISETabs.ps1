#cycle through PowerShell ISE Tabs


Function Get-NextISETab {
    [CmdletBinding()]
    Param()

    $iseTabs = $psISE.PowerShellTabs

    #get current tab
    for ($i = 0; $i -le $iseTabs.count - 1; $i++) {
        Write-Verbose $iseTabs[$i].DisplayName
        if ($iseTabs[$i].DisplayName -eq $psISE.CurrentPowerShellTab.DisplayName) {
            $current = $i
        }
    }

    #check if the next index number if valid
    if ($current++ -ge $iseTabs.count - 1) {
        $next = 0
    }
    else {
        $next = $current++
    }

    $nextTab = $iseTabs[$next]

    $iseTabs.SelectedPowerShellTab = $NextTab

}

