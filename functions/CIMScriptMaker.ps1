

Function New-CIMCommand {
    Param([String]$computername = $env:COMPUTERNAME)

    Function Get-Namespace {
        #this function will recursively enumerate namespaces

        Param(
            [String]$Namespace = 'Root',
            [Microsoft.Management.Infrastructure.CimSession]$CimSession
        )

        $nSpaces = $CimSession | Get-CimInstance -Namespace $Namespace -ClassName __Namespace
        foreach ($nSpace in $nSpaces) {

            $child = Join-Path -Path $Namespace -ChildPath $nspace.Name
            $child
            Get-Namespace $child $CimSession
        }
    }

    #create a CimSession
    $cimSess = New-CimSession -ComputerName $computername

    #browse namespaces
    Write-Host "Enumerating namespaces on $computername....please wait..." -ForegroundColor Cyan
    $ns = Get-Namespace -CimSession $cimsess | Sort-Object |
    Out-GridView -Title "$($cimsess.Computername): Select a namespace" -OutputMode Single

    if ($ns) {
        #get classes filtering out system classes
        Write-Host 'Enumerating classes...please wait...' -ForegroundColor Cyan
        $class = $cimsess | Get-CimClass -Namespace $ns |
        Where-Object { $_.cimClassName -notmatch '^__' -AND $_.CimClassProperties.Name -notcontains 'Antecedent' } |
        Sort-Object CimClassName | Select-Object CimClassName, CimClassProperties |
        Out-GridView -Title "$NS : Select a class name" -OutputMode Single
    }

    if ($class) {

        #create a VBScript message box
        $wshell = New-Object -ComObject 'Wscript.Shell'
        $r = $wshell.Popup('Do you want to test this class?', -1, $class.CimClassName, 32 + 4)

        if ($r -eq 6) {
            #Yes
            $test = $cimsess | Get-CimInstance -Namespace $ns -ClassName $class.CimClassName
            if ($test) {
                $test | Out-GridView -Title "$NS\$($Class.cimClassName)" -Wait
                $prompt = 'Do you want to continue?'
                $icon = 32 + 4
            }
            else {
                $prompt = 'No results were returned. Do you want to continue?'
                $icon = 16 + 4
            }

            $r = $wshell.Popup($prompt, -1, $class.CimClassName, $icon)
            if ($r -eq 7) {
                Write-Host 'Exiting. Please try again later.' -ForegroundColor Yellow
                #bail out
                Return
            }

        } #if r = 6

        #define basic command
        $cmd = 'Get-CimInstance @cimParam'

        #create a filter
        $FilterProperty = $class.CimClassProperties | Select-Object Name, CimType, Flags |
        Out-GridView -Title 'Select a property to filter on or cancel to not filter.' -OutputMode Single

        if ($FilterProperty) {
            $operator = '=', '<', '>', '<>', '>=', '<=', 'like' |
            Out-GridView -Title 'Select an operator. Default if you cancel is =' -OutputMode Single

            #create a VBScript InputBox
            Add-Type -AssemblyName 'Microsoft.VisualBasic' -ErrorAction Stop
            $Prompt = "Enter a value for your filter. If using a string, wrap the value in ''. If using Like, use % as the wildcard character."
            $title = "-filter ""$($FilterProperty.Name) $operator ?"""
            $value = [Microsoft.VisualBasic.interaction]::InputBox($Prompt, $Title)

            $filter = "-filter ""$($FilterProperty.Name) $operator $value"""

            $cmd += " $filter"
        } #if FilterProperty

        #show properties
        Write-Host 'Getting class properties' -ForegroundColor Cyan
        $properties = $class.CimClassProperties | Select-Object Name, CimType, Flags |
        Out-GridView -Title "$($class.CimClassName) : Select one or more properties. Cancel will select *" -PassThru

        if ($properties) {
            $select = $properties.name -join ','
            $cmd += @"
 |
    Select-Object -property $select,PSComputername
"@
        } #if properties

    } #if $class

    #define a name for the function using the class name
    #remove _ from class name
    $cname = $class.CimClassName.Replace('_', '')
    $cmdName = "Get-$cname"

    #the auto-generated PowerShell code
    $myScript = @"
#Requires -version 3.0

Function $cmdName  {
<#
.Synopsis
Get $($Class.CimClassName) information
.Description
This command uses the CIM cmdlets to query a remote computer for information from the $($Class.CimClassName) class in the $NS namespace.
This command requires PowerShell 3.0 or later.
.Parameter Computername
The name of a computer to query. It should be running PowerShell 3.0 or later.
This parameter also supports aliases of CN and Host.
.Parameter CimSession
A previously created CimSession. Works best when you pipe the CimSession
to this command. See examples.
.Example
PS C:\> $cmdName

Run the command defaulting to the local computername.
.Example
PS C:\> Get-CimSession | $cmdName | Out-GridView -title $cmdName

Get all CimSessions and pipe them to this command sending results to Out-GridView.
.Notes
Version     : 1.0
Author      : $($env:userdomain)\$($env:username)
Last Updated: $((Get-Date).ToShortDateString())
.Inputs
String or CimSession
.Outputs
CIMObject or custom object
.Link
Get-CimInstance
Get-CimSession
#>

[CmdletBinding(DefaultParameterSetName="Computer")]
Param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=`$True,
ParameterSetName="Computer")]
[ValidateNotNullOrEmpty()]
[Alias("CN","Host")]
[string[]]`$Computername=`$env:Computername,

[Parameter(Position=0,ValueFromPipeline=`$True,
ParameterSetName="Session")]
[string[]]`$CimSession

)

Begin {
    Write-Verbose "Starting command `$(`$MyInvocation.MyCommand)"
    #create a hashtable of parameters to splat against Get-CimInstance
    `$cimParam=@{
    Namespace = "$NS"
    ClassName = "$($Class.CimClassName) "
    ErrorAction = "Stop"
    }
} #begin

Process {
    if (`$computername) {
    `$cimParam.Computername=`$computername
    Write-Verbose "Processing `$Computername"
    }
    else {
    #must be a CimSession
    `$cimParam.CimSession=`$CimSession
    Write-Verbose "Processing `$(`$CimSession.ComputerName)"
    }

    Try {
        $cmd
    } #try
    Catch {
        Write-Warning "Failed to retrieve information. `$(`$_.Exception.Message)"
    } #catch
} #Process

End {
    Write-Verbose "Ending command `$(`$MyInvocation.MyCommand)"
} #end

} #end function
"@

    $myScript | Out-ISETab

    #remove the CimSession
    $cimsess | Remove-CimSession

} #end function
