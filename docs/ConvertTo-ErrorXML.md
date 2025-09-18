---
document type: cmdlet
external help file: MailTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: MailTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: ConvertTo-ErrorXML
---

# ConvertTo-ErrorXML

## SYNOPSIS

Convert error object to XML.

## SYNTAX

### __AllParameterSets

```
ConvertTo-ErrorXML
  -ErrorObject <ErrorRecord>
  [-RootNodeName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Convert error object to XML.

## EXAMPLES

### EXAMPLE 1

$ErrorObject = Get-Error

ConvertTo-ErrorXML -ErrorObject $ErrorObject -RootNodeName "Errors"

Converts error object to Xml with root node named Errors.

### EXAMPLE 2

Get-Error | ConvertTo-ErrorXML -RootNodeName "Errors"

Converts error object to Xml with root node named Errors.

## PARAMETERS

### -ErrorObject

Error object.

```yaml
Type: System.Management.Automation.ErrorRecord
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
DefaultValue: ErrorRecord
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

### System.Management.Automation.ErrorRecord



## OUTPUTS

### System.Xml.XmlDocument



## NOTES




## RELATED LINKS

None.

