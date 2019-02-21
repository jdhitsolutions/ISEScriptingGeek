---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version:
schema: 2.0.0
---

# Add-CurrentProject

## SYNOPSIS

This command adds the current file path to the current project list.

## SYNTAX

```yaml
Add-CurrentProject [[-List] <String>] [<CommonParameters>]
```

## DESCRIPTION

This command adds the current file path to the current project list. The list is simply a text file with full file names to a group of scripts that you might be working on. The ISEScriptingGeek module uses a built-in variable, $currentProjectList.


## PARAMETERS

### -List

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $currentProjectList
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

[Edit-CurrentProject]()

[Import-CurrentProject]()
