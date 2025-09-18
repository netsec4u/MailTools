---
document type: cmdlet
external help file: MailTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: MailTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Build-MailBody
---

# Build-MailBody

## SYNOPSIS

Provides functions to build HTML message body from Error or record set objects.

## SYNTAX

### __AllParameterSets

```
Build-MailBody
  -Xml <xml>
  [-SummaryItem <ordered>]
  [-DebugItem <ordered>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Build HTML message body from Error or record set objects.

## EXAMPLES

### EXAMPLE 1: Build HTML email body

$XmlDocument = '<Root></root>'
$OrderedHashtable = [ordered]@{
	Server = 'MyServer'
	Status = 'Down'
}

Build-MailBody -Xml $XmlDocument -SummaryItem $OrderedHashtable

Builds HTML body.

## PARAMETERS

### -DebugItem

Hashtable containing debug information.

```yaml
Type: System.Collections.Specialized.OrderedDictionary
DefaultValue: None
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

### -SummaryItem

Hashtable containing items for summary table in email output.

```yaml
Type: System.Collections.Specialized.OrderedDictionary
DefaultValue: None
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

### -Xml

Xml with error or record set object.

```yaml
Type: System.Xml.XmlDocument
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
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

## OUTPUTS

### System.String



## NOTES




## RELATED LINKS

None.

