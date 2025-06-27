---
external help file: MailTools-help.xml
Module Name: MailTools
online version:
schema: 2.0.0
---

# ConvertTo-ErrorXML

## SYNOPSIS
Convert error object to XML.

## SYNTAX

```
ConvertTo-ErrorXML
	-ErrorObject <ErrorRecord>
	[-RootNodeName <String>]
	[<CommonParameters>]
```

## DESCRIPTION
Convert error object to XML.

## EXAMPLES

### EXAMPLE 1
```powershell
$ErrorObject = Get-Error

ConvertTo-ErrorXML -ErrorObject $ErrorObject -RootNodeName "Errors"
```

Converts error object to Xml with root node named Errors.

### EXAMPLE 2
```powershell
Get-Error | ConvertTo-ErrorXML -RootNodeName "Errors"
```

Converts error object to Xml with root node named Errors.

## PARAMETERS

### -ErrorObject
Error object.

```yaml
Type: ErrorRecord
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
Default value: ErrorRecord
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.ErrorRecord

## OUTPUTS

### System.Xml.XmlDocument

## NOTES

## RELATED LINKS
