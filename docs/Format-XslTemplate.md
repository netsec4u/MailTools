---
document type: cmdlet
external help file: MailTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: MailTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Format-XslTemplate
---

# Format-XslTemplate

## SYNOPSIS

Transform Xsl template.

## SYNTAX

### __AllParameterSets

```
Format-XslTemplate
  -XslTemplatePath <FileInfo>
  [-XmlContent <xml>]
  [-XsltArgumentList <XsltArgumentList>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Transform Xsl template.

## EXAMPLES

### Example 1

```powershell
Format-XslTemplate -XmlContent . -XslTemplatePath .\MyTemplate.xsl
```

Transforms Xsl template.

## PARAMETERS

### -XmlContent

XML content to transform into Xsl.

```yaml
Type: System.Xml.XmlDocument
DefaultValue: <root/>
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

### -XsltArgumentList

Xsl Transform argument list.

```yaml
Type: System.Xml.Xsl.XsltArgumentList
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

### -XslTemplatePath

Path to Xsl template.

```yaml
Type: System.IO.FileInfo
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

### System.Xml.XmlDocument



## NOTES




## RELATED LINKS

None.

