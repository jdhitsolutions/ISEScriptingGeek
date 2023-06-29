---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version:
schema: 2.0.0
---

# New-DSCResourceSnippet

## SYNOPSIS

Create ISE snippets for DSC Resources

## SYNTAX

### Name (Default)

```yaml
New-DSCResourceSnippet [-Name] <String[]> [-Author <String>] [-Passthru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Resource

```yaml
New-DSCResourceSnippet [-DSCResource] <DscResourceInfo[]> [-Author <String>] [-Passthru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

This command will convert the syntax for a DSC resource into an ISE snippet. Snippets will be created in the default location. Snippet names will take the name "DSC \<resource name\>". The snippet description uses the format "\<Resource Name\> resource from module \<module name\> \<vendor\>".You will end up with a description like this:

xWinEventLog resource from module xWinEventLog Microsoft Corporation

You must run this command in the PowerShell ISE.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> New-DSCResourceSnippet -name xsmbshare -author "Jeff Hicks" -passthru

Directory: C:\Users\Jeff\documents\WindowsPowerShell\Snippets


Mode                LastWriteTime     Length Name
----                -------------     ------ ----
-a---        10/20/2014   8:48 AM       1157 DSC xSmbShare Resource.snippets.ps1xml
```

Create a snippet from a single resource.

### EXAMPLE 2

```powershell
PS C:\> Get-DSCResource | New-DSCResourceSnippet
```

This command will create snippets for every installed DSC resource. Existing snippet files will be overwritten.

## PARAMETERS

### -Name

Enter the name of a DSC resource

```yaml
Type: String[]
Parameter Sets: Name
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DSCResource

Enter the name of a DSC resource

```yaml
Type: DscResourceInfo[]
Parameter Sets: Resource
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Author

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $env:username
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-DSCResource]()

[New-ISESnippet]()

