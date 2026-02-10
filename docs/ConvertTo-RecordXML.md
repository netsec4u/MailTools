---
document type: cmdlet
external help file: MailTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: MailTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: ConvertTo-RecordXML
---

# ConvertTo-RecordXML

## SYNOPSIS

Converts record set object to XML.

## SYNTAX

### __AllParameterSets

```
ConvertTo-RecordXML
  -InputObject <DataSet>
  [-RootNodeName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Converts record set object to XML.

## EXAMPLES

### Example 1

```powershell
$RecordSet = Get-SqlClientDataSet -ServerInstance . -DatabaseName master -SqlCommandText 'SELECT * FROM sys.tables;' -OutputAs DataRow
ConvertTo-RecordXML -InputObject $RecordSet -RootNodeName "Records"
```

Converts record set object to Xml with root node named Records.

### Example 2

```powershell
Get-SqlClientDataSet -ServerInstance . -DatabaseName master -SqlCommandText 'SELECT * FROM sys.tables;' -OutputAs DataRow | ConvertTo-RecordXML -RootNodeName "Records"
```

Converts record set object to Xml with root node named Records.

## PARAMETERS

### -InputObject

Input object.

```yaml
Type: System.Data.DataSet
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RootNodeName

XML Root node name.

```yaml
Type: System.String
DefaultValue: Records
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Data.DataSet



## OUTPUTS

### System.Xml.XmlDocument



## NOTES




## RELATED LINKS

None.

