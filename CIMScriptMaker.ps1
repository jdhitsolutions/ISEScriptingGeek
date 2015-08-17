#requires -version 3.0

<#
Version: 3.0
Author : Jeff Hicks
         @jeffhicks
         http://jdhitsolutions.com/blog

"Those who forget to script are doomed to repeat their work."

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

   ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
#>

Function New-CIMCommand {
Param([string]$computername = $env:COMPUTERNAME)

Function Get-Namespace {
#this function will recursively enumerate namespaces

Param(
[string]$Namespace="Root",
[Microsoft.Management.Infrastructure.CimSession]$CimSession
)

 $nspaces = $cimsession | Get-CimInstance -Namespace $Namespace -ClassName __Namespace
  foreach ($nspace in $nspaces) {

  $child = Join-Path -Path $Namespace -ChildPath $nspace.Name
  $child
  Get-Namespace $child $CimSession
  }
}

#create a CIMSession
$cimsess = New-CimSession -ComputerName $computername

#browse namespaces
Write-Host "Enumerating namspaces on $computername....please wait..." -ForegroundColor Cyan
$ns = Get-Namespace -CimSession $cimsess | Sort |
Out-GridView -Title "$($cimsess.Computername): Select a namespace" -OutputMode Single

if ($ns) {
    #get classes filtering out system classes
    Write-Host "Enumerating classes...please wait..." -ForegroundColor Cyan
    $class = $cimsess | Get-CimClass -Namespace $ns | 
    Where {$_.cimclassname -notmatch "^__" -AND $_.CimClassProperties.Name -notcontains "Antecedent"} | 
    Sort CimClassName | Select CimClassName,CimClassProperties |
    Out-GridView -Title "$NS : Select a class name" -OutputMode Single
}

if ($class) {

    #create a VBScript message box
    $wshell = New-Object -ComObject "Wscript.Shell"
    $r = $wshell.Popup("Do you want to test this class?",-1,$class.CimClassname,32+4)

    if ($r -eq 6) {
        #Yes
        $test = $cimsess | Get-CimInstance -Namespace $ns -ClassName $class.CimClassName 
        if ($test) {
         $test | Out-GridView -Title "$NS\$($Class.cimClassName)" -Wait
         $prompt="Do you want to continue?"
         $icon=32+4
        }
        else {
          $prompt="No results were returned. Do you want to continue?"
          $icon=16+4
        }

        $r = $wshell.Popup($prompt,-1,$class.CimClassname,$icon)
        if ($r -eq 7) {
          Write-Host "Exiting. Please try again later." -ForegroundColor Yellow
          #bail out
          Return
        }

    } #if r = 6

    #define basic command
    $cmd = "Get-CimInstance @cimParam"
    
    #create a filter
    $filterProperty = $class.CimClassProperties | Select Name,CimType,Flags |
    Out-GridView -Title "Select a property to filter on or cancel to not filter." -OutputMode Single

    if ($filterProperty) {
        $operator = "=","<",">","<>",">=","<=","like" | 
        Out-GridView -Title "Select an operator. Default if you cancel is =" -OutputMode Single

        #create a VBSCript inputbox
        Add-Type -AssemblyName "microsoft.visualbasic" -ErrorAction Stop 
        $Prompt = "Enter a value for your filter. If using a string, wrap the value in ''. If using Like, use % as the wildcard character."
        $title= "-filter ""$($filterproperty.Name) $operator ?"""
        $value=[microsoft.visualbasic.interaction]::InputBox($Prompt,$Title)

        $filter = "-filter ""$($filterproperty.Name) $operator $value"""
        
        $cmd+=" $filter"
    } #if filterproperty

    #show properties
    Write-Host "Getting class properties" -ForegroundColor Cyan
    $properties = $class.CimClassProperties | select Name,CimType,Flags | 
    Out-Gridview -Title "$($class.CimClassName) : Select one or more properties. Cancel will select *" -PassThru

    if ($properties) {
     $select = $properties.name -join ","
     $cmd+= @"
 | 
    Select-Object -property $select,PSComputername
"@
    } #if properties

} #if $class

#define a name for the function using the class name
#remove _ from class name
$cname = $class.CimClassName.Replace("_","")
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
PS C:\> Get-CimSession | $cmdName | Out-Gridview -title $cmdName

Get all CIMSessions and pipe them to this command sending results to Out-Gridview.
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

[cmdletbinding(DefaultParameterSetName="Computer")]
Param(
[Parameter(Position=0,ValueFromPipelinebyPropertyName=`$True,
ParameterSetName="Computer")]
[ValidateNotNullorEmpty()]
[Alias("CN","Host")]
[string[]]`$Computername=`$env:Computername,

[Parameter(Position=0,ValueFromPipeline=`$True,
ParameterSetName="Session")]
[string[]]`$CimSession

)

Begin {
 Write-Verbose "Starting command `$(`$MyInvocation.Mycommand)"
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
   #must be a cimsession
   `$cimParam.CIMSession=`$CimSession
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
 Write-Verbose "Ending command `$(`$MyInvocation.Mycommand)"
} #end

} #end function
"@

$myScript | Out-ISETab

#remove the cimsession
$cimsess | Remove-CimSession

} #end function