---
external help file: MailTools-help.xml
Module Name: MailTools
online version:
schema: 2.0.0
---

# ConvertTo-ObjectXML

## SYNOPSIS
Convert object to XML.

## SYNTAX

```
ConvertTo-ObjectXML
	-Object <Object>
	[-RootNodeName <String>]
	[<CommonParameters>]
```

## DESCRIPTION
Convert object to XML.

## EXAMPLES

### EXAMPLE 1
```powershell
$Object = Get-ChildItem

ConvertTo-ObjectXML -Object $Object -RootNodeName "Object"
```

Converts PowerShell object to Xml with root node named Object.

### EXAMPLE 2
```powershell
Get-ChildItem | ConvertTo-ObjectXML -RootNodeName "Object"
```

Converts PowerShell object to Xml with root node named Object.

## PARAMETERS

### -Object
Object to convert to Xml.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -RootNodeName
XML Root node name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ObjectRecord
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Xml.XmlDocument

## NOTES

## RELATED LINKS
