---
external help file: MailTools-help.xml
Module Name: MailTools
online version:
schema: 2.0.0
---

# Send-MailToolMessage

## SYNOPSIS
Send an email message.

## SYNTAX

### Network (Default)
```
Send-MailToolMessage
	-MailFrom <MailAddress>
	-MailTo <MailAddress[]>
	[-ReplyTo <MailAddress[]>]
	[-CarbonCopy <MailAddress[]>]
	[-BlindCarbonCopy <MailAddress[]>]
	-Subject <String>
	[-MailAttachment <Attachment[]>]
	-Body <String>
	[-BodyAsHtml]
	[-Priority <MailPriority>]
	[-DeliveryNotificationOption <DeliveryNotificationOptions>]
	[-SmtpDeliveryMethod <SmtpDeliveryMethod>]
	-SmtpServer <String>
	[-SmtpPort <Int32>]
	[-UseTLS]
	[-Credential <PSCredential>]
	[<CommonParameters>]
```

### PickupDirectory
```
Send-MailToolMessage
	-MailFrom <MailAddress>
	-MailTo <MailAddress[]>
	[-ReplyTo <MailAddress[]>]
	[-CarbonCopy <MailAddress[]>]
	[-BlindCarbonCopy <MailAddress[]>]
	-Subject <String>
	[-MailAttachment <Attachment[]>]
	-Body <String>
	[-BodyAsHtml]
	[-Priority <MailPriority>]
	[-DeliveryNotificationOption <DeliveryNotificationOptions>]
	[-SmtpDeliveryMethod <SmtpDeliveryMethod>]
	-PickupDirectoryPath <DirectoryInfo>
	[<CommonParameters>]
```

## DESCRIPTION
Send an email message.

## EXAMPLES

### EXAMPLE 1: Send email message using SMTP server
```powershell
Send-MailToolMessage -MailFrom "Joe<joe@example.com>" -MailTo "John<john@example.com>" -Subject "Test Email" -Body "This is a test message." -SmtpServer mail.example.com
```

Sends email message through SMTP server.

### EXAMPLE 2: Send email message using pickup folder
```powershell
Send-MailToolMessage -MailFrom "Joe<joe@example.com>" -MailTo "John<john@example.com>" -Subject "Test Email" -Body "This is a test message." -SmtpDeliveryMethod "SpecifiedPickupDirectory" -PickupDirectoryPath "C:\inetpub\mailroot\pickup"
```

Sends email message via drop folder.

## PARAMETERS

### -BlindCarbonCopy
Specifies the addresses to which the mail blind copy is sent.
Enter names (optional) and the email address, such as Name\<someone@example.com\>.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
Specifies the body of the email message.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BodyAsHtml
Indicates that the value of the Body parameter contains HTML.

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

### -CarbonCopy
Specifies the addresses to which the mail copy is sent.
Enter names (optional) and the email address, such as Name\<someone@example.com\>.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specifies a user account that has permission to perform this action.
The default is the current user.

```yaml
Type: PSCredential
Parameter Sets: Network
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeliveryNotificationOption
Describes the delivery notification options for email.

```yaml
Type: DeliveryNotificationOptions
Parameter Sets: (All)
Aliases:
Accepted values: None, OnSuccess, OnFailure, Delay, Never

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailAttachment
Specifies attachment object.

```yaml
Type: Attachment[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailFrom
Specifies the address from which the mail is sent.
Enter a name (optional) and email address, such as Name\<someone@example.com\>.

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailTo
Specifies the addresses to which the mail is sent.
Enter names (optional) and the email address, such as Name\<someone@example.com\>.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PickupDirectoryPath
Specifies the path the SMTP Server pickup directory.

```yaml
Type: DirectoryInfo
Parameter Sets: PickupDirectory
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Priority
Specifies the priority of the email message.

```yaml
Type: MailPriority
Parameter Sets: (All)
Aliases:
Accepted values: Normal, Low, High

Required: False
Position: Named
Default value: Normal
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReplyTo
Specifies the reply to address where replies will be sent.
Enter names (optional) and the email address, such as Name\<someone@example.com\>.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpDeliveryMethod
Specifies the method used for delivery.

```yaml
Type: SmtpDeliveryMethod
Parameter Sets: (All)
Aliases:
Accepted values: Network, SpecifiedPickupDirectory, PickupDirectoryFromIis

Required: False
Position: Named
Default value: Network
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpPort
Specifies an alternate port on the SMTP server.
The default value is 25, which is the default SMTP port.

```yaml
Type: Int32
Parameter Sets: Network
Aliases:

Required: False
Position: Named
Default value: 25
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpServer
Specifies the name of the SMTP server that sends the email message.

```yaml
Type: String
Parameter Sets: Network
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subject
Specifies the subject of the email message.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseTLS
Indicates that the cmdlet uses the Secure Sockets Layer (SSL) protocol to establish a connection to the remote computer to send mail.

```yaml
Type: SwitchParameter
Parameter Sets: Network
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

### System.Void

## NOTES

## RELATED LINKS
