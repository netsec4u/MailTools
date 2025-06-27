---
external help file: MailTools-help.xml
Module Name: MailTools
online version:
schema: 2.0.0
---

# Build-MailBody

## SYNOPSIS
Build HTML message body from Xml data.

## SYNTAX

```
Build-MailBody
	-Xml <XmlDocument>
	[-SummaryItem <OrderedDictionary>]
	[-DebugItem <OrderedDictionary>]
	[<CommonParameters>]
```

## DESCRIPTION
Build HTML message body from Error or record set objects.

## EXAMPLES

### EXAMPLE 1: Build HTML email body
```powershell
$XmlDocument = '<Root></root>'
$OrderedHashtable = [ordered]@{
	Server = 'MyServer'
	Status = 'Down'
}

Build-MailBody -Xml $XmlDocument -SummaryItem $OrderedHashtable
```

Builds HTML body.

## PARAMETERS

### -DebugItem
Hashtable containing debug information.

```yaml
Type: OrderedDictionary
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SummaryItem
Hashtable containing items for summary table in email output.

```yaml
Type: OrderedDictionary
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Xml
Xml with error or record set object.

```yaml
Type: XmlDocument
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS
