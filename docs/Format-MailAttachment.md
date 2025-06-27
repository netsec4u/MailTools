---
external help file: MailTools-help.xml
Module Name: MailTools
online version:
schema: 2.0.0
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
	-FileName <String>
	-FileStream <Stream>
	[-Inline]
	[<CommonParameters>]
```

## DESCRIPTION
Create mail attachment object.

## EXAMPLES

### EXAMPLE 1
```powershell
Format-MailAttachment -FilePath C:\Temp\MyFile.txt
```

Creates new mail attachment object using MyFile.txt.

### EXAMPLE 2
```powershell
$FileStreamObject = [System.IO.FileStream]::New('C:\MyFile.txt', [System.IO.FileMode]::Open)

Format-MailAttachment -FileName image.png -FileStream $FileStreamObject -Inline
```

Creates new mail attachment called image.png from file stream object.

## PARAMETERS

### -FileName
Sets the MIME content ID for this attachment.

```yaml
Type: String
Parameter Sets: FileStream
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
Specifies the path and file names of file to be attached.

```yaml
Type: FileInfo
Parameter Sets: FilePath
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileStream
A readable Stream that contains the content for this attachment.

```yaml
Type: Stream
Parameter Sets: FileStream
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Inline
Sets the disposition type as Inline for an email attachment.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
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

### System.Net.Mail.Attachment

## NOTES

## RELATED LINKS
