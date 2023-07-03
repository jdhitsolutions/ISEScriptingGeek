#requires -module PSDesiredStateConfiguration

Function New-DSCResourceSnippet {

    [CmdletBinding(SupportsShouldProcess = $True, DefaultParameterSetName = 'Name')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Enter the name of a DSC resource',
            ParameterSetName = 'Name'
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Enter the name of a DSC resource',
            ValueFromPipeline,
            ParameterSetName = 'Resource'
        )]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.DesiredStateConfiguration.DscResourceInfo[]] $DSCResource,
        [ValidateNotNullOrEmpty()]
        [String]$Author = $env:username,
        [Switch]$PassThru
    )

    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            #get the resource from the name
            Try {
                Write-Verbose "Getting DSC Resource $Name"
                $DSCResource = Get-DscResource -Name $Name -ErrorAction Stop
            }
            Catch {
                Throw
            }
        }

        foreach ($resource in $DSCResource) {

            #create the entry based on resource properties
            [string[]]$entry = "`n$($resource.name) <ResourceID> {`n"

            Write-Verbose "Creating resource entry for $($resource.name)"
            $entry += "`t#from module $($resource.module.name)"
            $entry += foreach ($item in $resource.Properties) {
                if ($item.IsMandatory) {
                    $ResourceName = "`t*$($item.name)"
                }
                else {
                    $ResourceName = "`t$($item.name)"
                }

                if ($item.PropertyType -eq '[bool]') {
                    $possibleValues = "`$True | `$False"
                }
                elseif ($item.values) {
                    $possibleValues = "'$($item.Values -join "' | '")'"
                }
                else {
                    $possibleValues = $item.PropertyType
                }
                "$ResourceName = $($possibleValues)"

            } #foreach

            $entry += "`n} #end $($resource.name) resource`n`n"

            $title = "DSC $($resource.name) Resource"
            $description = "$($resource.name) resource from module $($resource.module) $($resource.CompanyName)"

            Write-Verbose "Creating snippet $title"
            Write-Verbose $description
            Write-Verbose ($entry | Out-String)

            $paramHash = @{
                Title       = $Title
                Description = $description
                Text        = ($Entry | Out-String)
                Author      = $Author
                Force       = $True
                ErrorAction = 'Stop'
            }

            Write-Verbose ($paramHash | Out-String)
            if ($PSCmdlet.ShouldProcess($Resource.name)) {

                Try {
                    Write-Debug 'Creating snippet file'
                    New-IseSnippet @paramHash

                    if ($PassThru) {
                        #build the path
                        $SnipPath = Join-Path -Path "$env:Userprofile\documents\WindowsPowerShell\Snippets" -ChildPath "$title.snippets.ps1xml"
                        Get-Item -Path $SnipPath
                    }
                }
                Catch {
                    Throw
                }

            } #if ShouldProcess
        } #foreach resource

    } #process

    End {
        #import the new snippets into the current session. They will
        #automatically be loaded next time.
        Write-Verbose 'Importing new snippets'
        Import-IseSnippet -Path "$env:Userprofile\documents\WindowsPowerShell\Snippets"
        Write-Verbose -Message "Ending $($MyInvocation.MyCommand)"
    } #end


} #end function
