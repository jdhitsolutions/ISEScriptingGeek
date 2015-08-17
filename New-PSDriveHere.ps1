#requires -version 2.0

Function New-PSDriveHere {

<#
.Synopsis
Create a new PSDrive at the current location.

.Description
This function will create a new PSDrive at the specified location. The default is the current location, but you can specify any PSPath. The function will take the last word of the path and use it as the name of the new PSDrive. If you prefer to use the first word of the location, use -First. If you prefer to specify a totally different name, then use the -Name parameter.
.Parameter Path
The path for the new PSDrive. The default is the current location.
.Parameter Name
The name for the new PSDrive. The default is the last word in the specified location, 
unless you use -First.
.Parameter First
Use the first word of the current location for the new PSDrive.
.Parameter SetLocation
Set location to this new drive.
.Example
PS C:\users\jeff\Documents\Enterprise Mgmt Webinar> new-psdrivehere

Name           Used (GB)     Free (GB) Provider      Root                                 CurrentLocation
----           ---------     --------- --------      ----                                 ---------------
Webinar                         146.57 FileSystem    C:\users\jeff\Documents\Enter...
.Example
PS C:\users\jeff\Documents\Enterprise Mgmt Webinar> new-psdrivehere -first

Name           Used (GB)     Free (GB) Provider      Root                                 CurrentLocation
----           ---------     --------- --------      ----                                 ---------------
Enterprise                      146.57 FileSystem    C:\users\jeff\Documents\Enter...
.Example
PS C:\> new-psdrivehere HKLM:\software\microsoft

Name           Used (GB)     Free (GB) Provider      Root                                 CurrentLocation
----           ---------     --------- --------      ----                                 ---------------
microsoft                              Registry      HKEY_LOCAL_MACHINE\software\micr...

.Example
PS C:\> new-psdrivehere -Path "\\jdh-nvnas\files\powershell" -Name PSFiles            
                                                                                      
Name           Used (GB)     Free (GB) Provider      Root                                 CurrentLocation
----           ---------     --------- --------      ----                                 ---------------
PSFiles                                FileSystem    \\jdh-nvnas\files\powershell     
.Example
PS C:\Users\Jeff\Documents\DeepDive> new-psdrivehere . DeepDive -setlocation

Name           Used (GB)     Free (GB) Provider      Root                                 CurrentLocation
----           ---------     --------- --------      ----                                 ---------------
DeepDive                        130.53 FileSystem    C:\Users\Jeff\Documents\DeepDive


PS DeepDive:\>

Set a new PSDrive and change to it.

.Inputs
None. You cannot pipe to this function.
.Outputs
System.Management.Automation.PSDrive
.Link
http://jdhitsolutions.com/blog/2010/08/new-psdrivehere/
.Link
    Get-PSDrive
    New-PSDrive
    
.Notes
 NAME:      New-PSDriveHere
 VERSION:   2.0
 AUTHOR:    Jeffery Hicks
 LASTEDIT:  Octber 15, 2011
 
Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

#>

[cmdletBinding(SupportsShouldProcess=$True)]

Param(
[Parameter(Position=0)]
[ValidateScript({Test-Path $_})]
[string]$Path=".",
	
[Parameter(Position=1)]
[string]$Name,

[switch]$First,

[Alias("cd")]
[switch]$SetLocation
)

#get the specified location
$location=Get-Item -Path $path

#did the user specify a name?
if ($Name) {
		Write-Verbose "Name parameter used for $name"	
} #if $name
else {	
		if ($first) {
		    $pattern="^\w+"
		}
		else {
		    $pattern="\w+$"
		}
		#Make sure name contains valid characters. This function
		#should work for all but the oddest named folders.

		if ($location.Name -match $pattern) {
		    $name=$matches[0]
		}
		else {
		    #The location has something odd about it so bail out
    		Write-Warning "$path doesn't meet the criteria"
			Break
 			}
		
	} #else $name not specified

    #verify a PSDrive doesn't already exist
    Write-Verbose "Testing $($name):"
   
	If (-not (Test-Path -path "$($name):")) {
        Write-Verbose "Creating PSDrive for $name"
        New-PSDrive -Name $name -PSProvider $location.PSProvider -Root $Path `
        -Description "Created $(get-date)" -scope Global  
        if ($SetLocation) {
            Write-Verbose "Setting location to $($name):"
            set-location -Path "$($name):"
        }      
    }
    else {
        Write-Warning "A PSDrive for $name already exists"
    }

} #function

#create an alias for the function
Set-Alias -Name npsd -Value New-PSDriveHere


