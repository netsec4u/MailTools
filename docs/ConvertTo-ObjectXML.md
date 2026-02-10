---
document type: cmdlet
external help file: MailTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: MailTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: ConvertTo-ObjectXML
---

# ConvertTo-ObjectXML

## SYNOPSIS

Convert PowerShell object to XML.

## SYNTAX

### __AllParameterSets

```
ConvertTo-ObjectXML
  -Object <Object>
  [-RootNodeName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Convert object to XML.

## EXAMPLES

### Example 1

```powershell
$Object = Get-ChildItem
ConvertTo-ObjectXML -Object $Object -RootNodeName "Object"
```

Converts PowerShell object to Xml with root node named Object.

### Example 2

```powershell
Get-ChildItem | ConvertTo-ObjectXML -RootNodeName "Object"
```

Converts PowerShell object to Xml with root node named Object.

## PARAMETERS

### -Object

Object to convert to Xml.

```yaml
Type: System.Object
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
DefaultValue: ObjectRecord
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

### System.Object



## OUTPUTS

### System.Xml.XmlDocument



## NOTES




## RELATED LINKS

None.

