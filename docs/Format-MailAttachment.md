---
document type: cmdlet
external help file: MailTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: MailTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Format-MailAttachment
---

# Format-MailAttachment

## SYNOPSIS

Create mail attachment object.

## SYNTAX

### FilePath (Default)

```
Format-MailAttachment
  -FilePath <FileInfo>
  [-Inline]
  [<CommonParameters>]
```

### FileStream

```
Format-MailAttachment
  -FileName <string>
  -FileStream <Stream>
  [-Inline]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Create mail attachment object.

## EXAMPLES

### Example 1

```powershell
Format-MailAttachment -FilePath C:\Temp\MyFile.txt
```

Creates new mail attachment object using MyFile.txt.

### Example 2

```powershell
$FileStreamObject = [System.IO.FileStream]::New('C:\MyFile.txt', [System.IO.FileMode]::Open)
Format-MailAttachment -FileName image.png -FileStream $FileStreamObject -Inline
```

Creates new mail attachment called image.png from file stream object.

## PARAMETERS

### -FileName

Sets the MIME content ID for this attachment.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: FileStream
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FilePath

Specifies the path and file names of file to be attached.

```yaml
Type: System.IO.FileInfo
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: FilePath
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FileStream

A readable Stream that contains the content for this attachment.

```yaml
Type: System.IO.Stream
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: FileStream
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Inline

Sets the disposition type as Inline for an email attachment.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

## OUTPUTS

### System.Net.Mail.Attachment



## NOTES




## RELATED LINKS

None.

