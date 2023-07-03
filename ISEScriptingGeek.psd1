
@{

    RootModule           = 'ISEScriptingGeek.psm1'
    ModuleVersion        = '3.5.0'
    CompatiblePSEditions = @('Desktop')
    GUID                 = '6d1078ea-36c8-443a-9476-6d6c4d6ac834'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '2013-2023 JDH Information Technology Solutions, Inc. All Rights Reserved.'
    Description          = 'Functions and add-ons for the Windows PowerShell ISE and later. This module is a kind of resource kit for the PowerShell ISE.'
    PowerShellVersion    = '5.1'
    TypesToProcess       = @()
    FormatsToProcess     = @()
    FunctionsToExport    = 'Add-CurrentProject', 'Add-ISEBookmark', 'CloseAllFiles',
    'CloseAllFilesButCurrent', 'Convert-AliasDefinition',
    'Convert-CodeToSnippet', 'Convert-CommandToHash', 'ConvertFrom-Alias',
    'ConvertFrom-MultiLineComment', 'ConvertTo-CommentHelp',
    'ConvertTo-Definition', 'ConvertTo-MultiLineComment',
    'ConvertTo-TextFile', 'Copy-ToWord', 'Edit-CurrentProject',
    'Edit-Snippet', 'Find-InFile', 'Get-ASTProfile', 'Get-CommandMetadata',
    'Get-ISEBookmark', 'Get-NextISETab', 'Get-ScriptComments',
    'Get-ScriptingHelp', 'Get-SearchResult', 'Import-CurrentProject',
    'New-CIMCommand', 'New-CommentHelp', 'New-DSCResourceSnippet',
    'New-FileHere', 'New-InputBox', 'New-PSCommand',
    'Open-ISEBookmark', 'Open-SelectedISE', 'Out-ISETab',
    'Remove-ISEBookmark', 'Reset-ISEFile', 'Send-ToPrinter',
    'Start-MyScript', 'Update-ISEBookmark', 'Write-Signature',
    'New-Function', 'Set-ScriptLocation'

    CmdletsToExport      = @()
    VariablesToExport    = 'MySnippets', 'MyModules', 'MyPowerShell', 'CurrentProjectList'
    AliasesToExport      = 'ccs', 'gcmd', 'glcm''tab', 'sd'
    PrivateData          = @{
        PSData = @{
            Tags       = 'ISE', 'Snippets', 'Scripting', 'PowerShellISE'
            LicenseUri = 'https://github.com/jdhitsolutions/ISEScriptingGeek/blob/master/License.txt'
            ProjectUri = 'https://github.com/jdhitsolutions/ISEScriptingGeek'
        } # End of PSData hashtable

    } # End of PrivateData hashtable


}

