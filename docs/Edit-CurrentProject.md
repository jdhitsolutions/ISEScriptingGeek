---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version:
schema: 2.0.0
---

# Edit-CurrentProject

## SYNOPSIS

Edit the current project list file

## SYNTAX

```yaml
Edit-CurrentProject [-List] <String> [<CommonParameters>]
```

## DESCRIPTION

Open the current project list in the PowerShell ISE to view or edit. You will need to manually remove items.
The list is simply a text file with full file names to a group of scripts that you might be working on.

The ISEScriptingGeek module uses a built-in variable, $currentProjectList.

## PARAMETERS

### -List

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

[Add-CurrentProject]()

[Import-CurrentProject]()
