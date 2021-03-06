
Function Out-ISETab {

    [cmdletbinding()]
    [alias("tab")]

    Param (
        [Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $True)]
        [object[]]$InputObject,
        [Switch]$UseCurrentFile
    )

    Begin {

        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        if ($UseCurrentFile) {
            Write-Verbose "Using current file"
            $tab = $psise.CurrentFile
        }
        else {
            #create a new file
            Write-Verbose "Creating a new tab"
            $tab = $psise.CurrentPowerShellTab.Files.Add()
        }

        $data = @()
    }
    Process {
        #add each piped object
        $data += $InputObject


    } #process

    End {
        #send the data to the ISE tab
        $tab.Editor.InsertText(($data | Out-String))
        Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
    }

} #end function

