---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version: http://jdhitsolutions.com/blog/2012/12/create-powershell-scripts-with-a-single-command
schema: 2.0.0
---

# Out-ISETab

## SYNOPSIS

Send command output to an ISE tab

## SYNTAX

```yaml
Out-ISETab [-InputObject] <Object[]> [-UseCurrentFile] [<CommonParameters>]
```

## DESCRIPTION

This command will accept pipelined input and place it in a new PowerShell ISE tab.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> get-process | sort WS -descending | Select -first 5 | out-isetab
```

## PARAMETERS

### -InputObject

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UseCurrentFile

Insert the text into the current ISE tab.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
