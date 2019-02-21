
@{

# Script module or binary module file associated with this manifest.
RootModule = 'ISEScriptingGeek.psm1'

# Version number of this module.
ModuleVersion = '3.4.0'

# ID used to uniquely identify this module
GUID = '6d1078ea-36c8-443a-9476-6d6c4d6ac834'

# Author of this module
Author = 'Jeff Hicks'

# Company or vendor of this module
CompanyName = 'JDH Information Technology Solutions, Inc.'

# Copyright statement for this module
Copyright = '2013-2019 JDH Information Technology Solutions, Inc. All Rights Reserved.'

# Description of the functionality provided by this module
Description = 'Functions and add-ons for the Windows PowerShell ISE v4.0 and later'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '4.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
CLRVersion = '4.0'

# Processor architecture (None, X86, Amd64) required by this module
ProcessorArchitecture = 'None'

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = 'Add-CurrentProject', 'Add-ISEBookmark', 'CloseAllFiles',
               'CloseAllFilesButCurrent', 'Convert-AliasDefinition',
               'Convert-CodetoSnippet', 'Convert-CommandtoHash', 'ConvertFrom-Alias',
               'ConvertFrom-MultiLineComment', 'ConvertTo-CommentHelp',
               'ConvertTo-Definition', 'ConvertTo-MultiLineComment',
               'ConvertTo-TextFile', 'Copy-ToWord', 'Edit-CurrentProject',
               'Edit-Snippet', 'Find-InFile', 'Get-ASTProfile', 'Get-CommandMetadata',
               'Get-ISEBookmark', 'Get-NextISETab', 'Get-ScriptComments',
               'Get-ScriptingHelp', 'Get-SearchResult', 'Import-CurrentProject',
               'New-CIMCommand', 'New-CommentHelp', 'New-DSCResourceSnippet',
               'New-FileHere', 'New-Inputbox', 'New-PSCommand',
               'Open-ISEBookmark', 'Open-SelectedISE', 'Out-ISETab',
               'Remove-ISEBookmark', 'Reset-ISEFile', 'Send-ToPrinter',
               'Start-MyScript', 'Update-ISEBookmark', 'Write-Signature',
               'New-Function','Set-ScriptLocation'

# Cmdlets to export from this module
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = 'MySnippets', 'MyModules', 'MyPowerShell', 'CurrentProjectList'

# Aliases to export from this module
AliasesToExport = 'ccs','gcfg','gcfgs','gcmd','glcm','pbcfg','rtcfg','sacfg','slcm','tab','tcfg','upcfg','sd'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
#FileList = ''

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    #Category of this module
    Category = 'PowerShell ISE'

    #IsPrerelease of this module
    IsPrerelease = 'False'

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'ISE','Snippets','Scripting'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/jdhitsolutions/ISEScriptingGeek/blob/master/License.txt'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/jdhitsolutions/ISEScriptingGeek'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

