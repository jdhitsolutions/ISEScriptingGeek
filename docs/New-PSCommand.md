---
external help file: ISEScriptingGeek-help.xml
Module Name: ISEScriptingGeek
online version: http://jdhitsolutions.com/blog/2012/12/create-powershell-scripts-with-a-single-command
schema: 2.0.0
---

# New-PSCommand

## SYNOPSIS

Create an advanced function outline

## SYNTAX

```yaml
New-PSCommand [-Name] <String> [[-NewParameters] <Object>] [-ShouldProcess] [[-Synopsis] <String>]
 [[-Description] <String>] [[-BeginCode] <String>] [[-ProcessCode] <String>] [[-EndCode] <String>] [-UseISE]
 [<CommonParameters>]
```

## DESCRIPTION

This command will create the outline of an advanced function based on a hash table of new parameter values.
You will still need to flesh out the function and insert the actual commands.

You might need to tweak parameters in the resulting code for items such a default value, help message, parameter aliases and validation.

The New-PSCommand command takes a lot of the grunt work out of the scripting process so you can focus on the actual working part of the function.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> $paramhash=@{Name="string[]";Test="switch";Path="string"}
PS C:\> New-PSCommand -name "Set-MyScript" -Newparameters $paramhash | out-file "c:\scripts\set-myscript.ps1"
```

Create an advanced script outline for Set-MyScript with parameters of Name, Test and Path. Results are saved to a file.

### EXAMPLE 2

```powershell
PS C:\> $hash = [ordered]@{Name="string[]",$True,$True,$False,0;Path="string",$false,$false,$false,1;Size="int",$false,$false,$true;Recurse="switch"}

PS C:\> $begin={
#initialize some variables
$arr=@()
$a=$True
$b=123
}
PS C:\> $end="write-host 'Finished' -foreground Green"
PS C:\> $synopsis = "Get user data"
PS C:\> $desc = @"
This command will do something really amazing.
All you need to do is provide
the right amount of pixie dust and shavings from a unicorn horn.

This requires PowerShell v4 and a full moon.
"@

PS C:\> New-PSCommand -Name Get-UserData -NewParameters $hash -BeginCode $begin -EndCode $end -Synopsis $synopsis -Description $desc -useise
```

Create an advanced function from the ordered hash table. This expression will also insert extra code into the Begin and End scriptblocks as well as enter text for the help synopsis and description. The new command will be opened in the ISE.

## PARAMETERS

### -Name

The name of the new function

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

### -NewParameters

A hash table of new parameter values. The key should be the parameter name.  The entry value should be the object type. You can also indicate if it should be an array by using \[\] with the object type.
Here's an example:

@{Name="string\[\]";Test="switch";Path="string"}

Or you can use an "advanced" version of the hash table to specify optional parameter attributes that follows the format:

@{ParamName="type\[\]",Mandatory,ValuefromPipeline,ValuefromPipelinebyPropertyName,Position}

Here's an example:

$h = @{Name="string\[\]",$True,$True,$False,0;
  Path="string",$false,$false,$false,1;
  Size="int",$false,$false,$true;
  Recurse="switch"
  }

You can also specify an ordered hash table if you are running PowerShell v or later.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Parameters

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShouldProcess

Set SupportsShouldProcess to True in the new function.

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

### -Synopsis

Provide a brief synopsis of your command.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description

Provide a description for your command. You can always add and edit this later.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BeginCode

A block of code to insert in the Begin scriptblock. This can be either a scriptblock or a string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProcessCode

A block of code to insert at the start of the Process scriptblock. This can be either a scriptblock or a string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndCode

A block of code to insert at the start of the End scriptblock. This can be either a scriptblock or a string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseISE

If you are running this command in the ISE, send the new function to the editor as a new file.

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

This command was described at http://jdhitsolutions.com/blog/2012/12/create-powershell-scripts-with-a-single-command

## RELATED LINKS
