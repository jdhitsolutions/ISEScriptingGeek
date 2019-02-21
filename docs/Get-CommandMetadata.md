---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version: http://jdhitsolutions.com/blog/2014/09/friday-fun-creating-powershell-scripts-with-powershell
schema: 2.0.0
---

# Get-CommandMetadata

## SYNOPSIS

Create a proxy function of a PowerShell command.

## SYNTAX

```yaml
Get-CommandMetadata [-Command] <String> [-NewName <String>] [-NoHelp] [<CommonParameters>]
```

## DESCRIPTION

This command will create a proxy version of a PowerShell cmdlet, function or alias. The intent is to simplify creating a new function from command metadata. You can give your command and opt to remove help references for the original command.

If you run this in the PowerShell ISE, code for the new function will be inserted into a new Powershell tab.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-CommandMetadata Get-WMIObject -nohelp -newname Get-MyOS
```

Create a proxy function for Get-WMIObject that will be called Get-MyOS. Help references will be replaced with a comment-help block.

## PARAMETERS

### -Command

The name of a PowerShell command to proxy. This can be a cmdlet, function or alias.

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

### -NewName

The name you want to use for your new command.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoHelp

Remove references to existing command help. Using this parameter will insert a comment-based help outline.

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

This command was first described at http://jdhitsolutions.com/blog/2014/09/friday-fun-creating-powershell-scripts-with-powershell

## RELATED LINKS

