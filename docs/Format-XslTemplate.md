---
external help file: MailTools-help.xml
Module Name: MailTools
online version:
schema: 2.0.0
---

# Format-XslTemplate

## SYNOPSIS
Transform Xsl template.

## SYNTAX

```
Format-XslTemplate
	-XslTemplatePath <FileInfo>
	[-XmlContent <XmlDocument>]
	[-XsltArgumentList <XsltArgumentList>]
	[<CommonParameters>]
```

## DESCRIPTION
Transform Xsl template.

## EXAMPLES

### EXAMPLE 1
```powershell
Format-XslTemplate -XmlContent . -XslTemplatePath .\MyTemplate.xsl
```

Transforms Xsl template.

## PARAMETERS

### -XmlContent
XML content to transform into Xsl.

```yaml
Type: XmlDocument
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: <root/>
Accept pipeline input: False
Accept wildcard characters: False
```

### -XsltArgumentList
Xsl Transform argument list.

```yaml
Type: XsltArgumentList
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -XslTemplatePath
Path to Xsl template.

```yaml
Type: FileInfo
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

### System.Xml.XmlDocument

## NOTES

## RELATED LINKS
