---
external help file: MailTools-help.xml
Module Name: MailTools
online version:
schema: 2.0.0
---

# ConvertTo-RecordXML

## SYNOPSIS
Converts record set object to XML.

## SYNTAX

```
ConvertTo-RecordXML
	-InputObject <DataSet>
	[-RootNodeName <Object>]
	[<CommonParameters>]
```

## DESCRIPTION
Converts record set object to XML.

## EXAMPLES

### EXAMPLE 1
```powershell
$RecordSet = Get-SqlClientDataSet -ServerInstance . -DatabaseName master -SqlCommandText 'SELECT * FROM sys.tables;' -OutputAs DataRow

ConvertTo-RecordXML -InputObject $RecordSet -RootNodeName "Records"
```

Converts record set object to Xml with root node named Records.

### EXAMPLE 2
```powershell
Get-SqlClientDataSet -ServerInstance . -DatabaseName master -SqlCommandText 'SELECT * FROM sys.tables;' -OutputAs DataRow | ConvertTo-RecordXML -RootNodeName "Records"
```

Converts record set object to Xml with root node named Records.

## PARAMETERS

### -InputObject
Input object.

```yaml
Type: DataSet
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
Default value: Records
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Data.DataSet

## OUTPUTS

### System.Xml.XmlDocument

## NOTES

## RELATED LINKS
