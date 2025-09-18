---
document type: cmdlet
external help file: MailTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: MailTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Send-MailToolMessage
---

# Send-MailToolMessage

## SYNOPSIS

Send an email message.

## SYNTAX

### Network (Default)

```
Send-MailToolMessage
  -MailFrom <mailaddress>
  -MailTo <mailaddress[]>
  -Subject <string>
  -Body <string>
  -SmtpServer <string>
  [-ReplyTo <mailaddress[]>]
  [-CarbonCopy <mailaddress[]>]
  [-BlindCarbonCopy <mailaddress[]>]
  [-MailAttachment <Attachment[]>]
  [-BodyAsHtml]
  [-Priority <MailPriority>]
  [-DeliveryNotificationOption <DeliveryNotificationOptions>]
  [-SmtpDeliveryMethod <SmtpDeliveryMethod>]
  [-SmtpPort <int>]
  [-UseTLS]
  [-Credential <pscredential>]
  [<CommonParameters>]
```

### PickupDirectory

```
Send-MailToolMessage
  -MailFrom <mailaddress>
  -MailTo <mailaddress[]>
  -Subject <string>
  -Body <string>
  -PickupDirectoryPath <DirectoryInfo>
  [-ReplyTo <mailaddress[]>]
  [-CarbonCopy <mailaddress[]>]
  [-BlindCarbonCopy <mailaddress[]>]
  [-MailAttachment <Attachment[]>]
  [-BodyAsHtml]
  [-Priority <MailPriority>]
  [-DeliveryNotificationOption <DeliveryNotificationOptions>]
  [-SmtpDeliveryMethod <SmtpDeliveryMethod>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Send an email message.

## EXAMPLES

### EXAMPLE 1: Send email message using SMTP server

Send-MailToolMessage -MailFrom "Joe<joe@example.com>" -MailTo "John<john@example.com>" -Subject "Test Email" -Body "This is a test message." -SmtpServer mail.example.com

Sends email message through SMTP server.

### EXAMPLE 2: Send email message using pickup folder

Send-MailToolMessage -MailFrom "Joe<joe@example.com>" -MailTo "John<john@example.com>" -Subject "Test Email" -Body "This is a test message." -SmtpDeliveryMethod "SpecifiedPickupDirectory" -PickupDirectoryPath "C:\inetpub\mailroot\pickup"

Sends email message via drop folder.

## PARAMETERS

### -BlindCarbonCopy

Specifies the addresses to which the mail blind copy is sent.
Enter names (optional) and the email address, such as Name<someone@example.com>.

```yaml
Type: System.Net.Mail.MailAddress[]
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

### -Body

Specifies the body of the email message.

```yaml
Type: System.String
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

### -BodyAsHtml

Indicates that the value of the Body parameter contains HTML.

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

### -CarbonCopy

Specifies the addresses to which the mail copy is sent.
Enter names (optional) and the email address, such as Name<someone@example.com>.

```yaml
Type: System.Net.Mail.MailAddress[]
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

### -Credential

Specifies a user account that has permission to perform this action.
The default is the current user.

```yaml
Type: System.Management.Automation.PSCredential
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Network
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DeliveryNotificationOption

Describes the delivery notification options for email.

```yaml
Type: System.Net.Mail.DeliveryNotificationOptions
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

### -MailAttachment

Specifies attachment object.

```yaml
Type: System.Net.Mail.Attachment[]
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

### -MailFrom

Specifies the address from which the mail is sent.
Enter a name (optional) and email address, such as Name<someone@example.com>.

```yaml
Type: System.Net.Mail.MailAddress
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

### -MailTo

Specifies the addresses to which the mail is sent.
Enter names (optional) and the email address, such as Name<someone@example.com>.

```yaml
Type: System.Net.Mail.MailAddress[]
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

### -PickupDirectoryPath

Specifies the path the SMTP Server pickup directory.

```yaml
Type: System.IO.DirectoryInfo
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PickupDirectory
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Priority

Specifies the priority of the email message.

```yaml
Type: System.Net.Mail.MailPriority
DefaultValue: Normal
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

### -ReplyTo

Specifies the reply to address where replies will be sent.
Enter names (optional) and the email address, such as Name<someone@example.com>.

```yaml
Type: System.Net.Mail.MailAddress[]
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

### -SmtpDeliveryMethod

Specifies the method used for delivery.

```yaml
Type: System.Net.Mail.SmtpDeliveryMethod
DefaultValue: Network
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

### -SmtpPort

Specifies an alternate port on the SMTP server.
The default value is 25, which is the default SMTP port.

```yaml
Type: System.Int32
DefaultValue: 25
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Network
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SmtpServer

Specifies the name of the SMTP server that sends the email message.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Network
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Subject

Specifies the subject of the email message.

```yaml
Type: System.String
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

### -UseTLS

Indicates that the cmdlet uses the Secure Sockets Layer (SSL) protocol to establish a connection to the remote computer to send mail.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Network
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

### System.Void



## NOTES




## RELATED LINKS

None.

