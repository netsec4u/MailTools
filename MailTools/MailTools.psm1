Set-StrictMode -Version Latest

#Region Global Configuration
try {
	$PSManifestFile = $PSCommandPath -replace '.psm1$', '.psd1'

	$PrivateData = (Import-PowerShellDataFile -LiteralPath $PSManifestFile).PrivateData

	$Script:TemplateFiles = @{}

	foreach ($Item in $PrivateData.TemplateFiles.GetEnumerator()) {
		$TemplatePath = Join-Path -Path $PSScriptRoot -ChildPath $Item.Value -Resolve

		$Script:TemplateFiles.Add($Item.Name, $TemplatePath)
	}
}
catch {
	throw $_
}
#EndRegion

#Region Classes
Class ErrorRecordXml {
	#Region Properties
	[System.Xml.XmlElement]$XmlElement
	#EndRegion

	#Region Constructors
	ErrorRecordXml($Exception, [string]$ElementName) {
		$this.SetErrorRecordXml($Exception, $ElementName, 5, 0)
	}

	ErrorRecordXml($Exception, [string]$ElementName, [int]$MaxDepth) {
		$this.SetErrorRecordXml($Exception, $ElementName, $MaxDepth, 0)
	}

	ErrorRecordXml($Exception, [string]$ElementName, [int]$MaxDepth, [int]$CurrentDepth) {
		$this.SetErrorRecordXml($Exception, $ElementName, $MaxDepth, $CurrentDepth)
	}
	#EndRegion

	#Region Methods
	hidden SetErrorRecordXml($Exception, [string]$ElementName, [int]$MaxDepth, [int]$CurrentDepth) {
		if ($CurrentDepth -ge $MaxDepth) {
			return
		}

		$CurrentDepth++

		$XmlDocument = [System.Xml.XmlDocument]::New()

		$ChildObject = $XmlDocument.CreateElement($ElementName)

		foreach ($Property in $Exception.PSObject.Properties) {
			switch ($Property.Name) {
				{$_ -in @('Data', 'TargetSite')} {
					$PropertyNode = $XmlDocument.CreateElement($Property.Name)

					if ($null -eq $Property.Value) {
						$PropertyNode.InnerText = $null
					} else {
						$PropertyNode.InnerText = $Property.Value.ToString()
					}

					[void]$ChildObject.AppendChild($PropertyNode)
				}
				{$_ -in @('Exception', 'InnerException')} {
					if ($null -eq $Exception.$($Property.Name)) {
						$PropertyNode = $XmlDocument.CreateElement($Property.Name)
						$PropertyNode.InnerText = $Property.Value

						[void]$ChildObject.AppendChild($PropertyNode)
					} else {
						$InnerProperty = $Exception.$($Property.Name)
						$InnerPropertyXml = [ErrorRecordXml]::New($InnerProperty, $Property.Name, $MaxDepth, $CurrentDepth)

						if ($null -ne $InnerPropertyXml.XmlElement) {
							$ChildElement = $XmlDocument.ImportNode($InnerPropertyXml.XmlElement, $true)

							[void]$ChildObject.AppendChild($ChildElement)
						}
					}
				}
				'Errors' {
					$PropertyNode = $XmlDocument.CreateElement($Property.Name)
					$ErrorsChild = $ChildObject.AppendChild($PropertyNode)

					foreach ($ErrorItem in $Exception.$($Property.Name)) {
						$ErrorXml = [ErrorRecordXml]::New($ErrorItem, 'Error', $MaxDepth, $CurrentDepth)

						if ($null -ne $ErrorXml.XmlElement) {
							$ChildElement = $XmlDocument.ImportNode($ErrorXml.XmlElement, $true)

							[void]$ErrorsChild.AppendChild($ChildElement)
						}
					}
				}
				Default {
					if ($null -eq $Exception.$($Property.Name)) {
						$PropertyNode = $XmlDocument.CreateElement($Property.Name)
						$PropertyNode.InnerText = $Property.Value

						[void]$ChildObject.AppendChild($PropertyNode)
					} else {
						$Type = $Exception.$($Property.Name).GetType()

						if ($Type.IsSerializable) {
							$PropertyNode = $XmlDocument.CreateElement($Property.Name)
							$PropertyNode.InnerText = $Property.Value

							[void]$ChildObject.AppendChild($PropertyNode)
						} else {
							$InnerProperty = $Exception.$($Property.Name)
							$InnerPropertyXml = [ErrorRecordXml]::New($InnerProperty, $Property.Name, $MaxDepth, $CurrentDepth)

							if ($null -ne $InnerPropertyXml.XmlElement) {
								$ChildElement = $XmlDocument.ImportNode($InnerPropertyXml.XmlElement, $true)

								[void]$ChildObject.AppendChild($ChildElement)
							}
						}
					}
				}
			}
		}

		$this.XmlElement = $ChildObject
	}
	#EndRegion
}

Class ObjectXml {
	#Region Properties
	[System.Xml.XmlElement]$XmlElement
	#EndRegion

	#Region Constructors
	ObjectXml($Object, [string]$ElementName) {
		$this.SetObjectXml($Object, $ElementName, 5, 0)
	}

	ObjectXml($Object, [string]$ElementName, [int]$MaxDepth) {
		$this.SetObjectXml($Object, $ElementName, $MaxDepth, 0)
	}

	ObjectXml($Object, [string]$ElementName, [int]$MaxDepth, [int]$CurrentDepth) {
		$this.SetObjectXml($Object, $ElementName, $MaxDepth, $CurrentDepth)
	}
	#EndRegion

	#Region Methods
	hidden SetObjectXml($Object, [string]$ElementName, [int]$MaxDepth, [int]$CurrentDepth) {
		if ($CurrentDepth -ge $MaxDepth) {
			return
		}

		$CurrentDepth++

		$XmlDocument = [System.Xml.XmlDocument]::New()

		$ChildObject = $XmlDocument.CreateElement($ElementName)

		foreach ($Property in $Object.PSObject.Properties) {
			if ($null -eq $Object.$($Property.Name)) {
				$PropertyNode = $XmlDocument.CreateElement($Property.Name)
				$PropertyNode.InnerText = $Property.Value

				[void]$ChildObject.AppendChild($PropertyNode)
			} else {
				$Type = $Object.$($Property.Name).GetType()

				if ($Type.BaseType.Name -eq 'Array') {
					$PropertyNode = $XmlDocument.CreateElement($Property.Name)
					$ObjectChild = $ChildObject.AppendChild($PropertyNode)

					foreach ($Item in $Object.$($Property.Name)) {
						$ITemXml = [ErrorRecordXml]::New($Item, 'Item', $MaxDepth, $CurrentDepth)

						if ($null -ne $ItemXml.XmlElement) {
							$ChildElement = $XmlDocument.ImportNode($ItemXml.XmlElement, $true)

							[void]$ObjectChild.AppendChild($ChildElement)
						}
					}
				} elseif ($Type.IsSerializable) {
					$PropertyNode = $XmlDocument.CreateElement($Property.Name)
					$PropertyNode.InnerText = $Property.Value

					[void]$ChildObject.AppendChild($PropertyNode)
				} else {
					$InnerProperty = $Object.$($Property.Name)
					$InnerPropertyXml = [ObjectXml]::New($InnerProperty, $Property.Name, $MaxDepth, $CurrentDepth)

					if ($null -ne $InnerPropertyXml.XmlElement) {
						$ChildElement = $XmlDocument.ImportNode($InnerPropertyXml.XmlElement, $true)

						[void]$ChildObject.AppendChild($ChildElement)
					}
				}
			}
		}

		$this.XmlElement = $ChildObject
	}
	#EndRegion
}

class TransformPath : System.Management.Automation.ArgumentTransformationAttribute {
	[object]Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, [object]$InputData) {
		if ([System.IO.Path]::IsPathRooted($InputData)) {
			return $InputData
		} else {
			return [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PWD.Path, $InputData))
		}

		throw [System.InvalidOperationException]::New('Unexpected error.')
	}
}

class ValidatePathExists : System.Management.Automation.ValidateArgumentsAttribute {
	[string]$PathType = 'Any'

	ValidatePathExists([string]$PathType) {
		$this.PathType = $PathType
	}

	[void]Validate([object]$Path, [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
		if([string]::IsNullOrWhiteSpace($Path)) {
			throw [System.ArgumentNullException]::New()
		}

		if(-not (Test-Path -Path $Path -PathType $this.PathType)) {
			switch ($this.PathType) {
				'Container' {
					throw [System.IO.DirectoryNotFoundException]::New()
				}
				'Leaf' {
					throw [System.IO.FileNotFoundException]::New()
				}
				Default {
					throw [System.InvalidOperationException]::New('An unexpected error has occurred.')
				}
			}
		}
	}
}
#EndRegion


function Build-MailBody {
	<#
	.EXTERNALHELP
	MailTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([string])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[xml]$Xml,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Collections.Specialized.OrderedDictionary]$SummaryItem,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Collections.Specialized.OrderedDictionary]$DebugItem
	)

	begin {
		$MessageTemplate = $Script:TemplateFiles.MessageTemplate
	}

	process {
		#Region Build XML
		$XmlDocument = [System.Xml.XmlDocument]::New()
		[void]$XmlDocument.AppendChild($XmlDocument.CreateXmlDeclaration('1.0', 'UTF-8', $null))

		$RootElement = $XmlDocument.CreateElement('Message')
		$ChildElement = $XmlDocument.CreateElement('Summary')

		foreach ($Item in $SummaryItem.GetEnumerator()) {
			$PropertyNode = $XmlDocument.CreateElement($Item.Name)
			$PropertyNode.InnerText = $Item.Value

			[void]$ChildElement.AppendChild($PropertyNode)
		}

		[void]$RootElement.AppendChild($ChildElement)

		if ($PSBoundParameters.ContainsKey('DebugItem')) {
			$ChildElement = $XmlDocument.CreateElement('Debug')

			foreach ($Item in $DebugItem.GetEnumerator()) {
				$PropertyNode = $XmlDocument.CreateElement($Item.Name)
				$PropertyNode.InnerText = $Item.Value

				[void]$ChildElement.AppendChild($PropertyNode)
			}

			[void]$RootElement.AppendChild($ChildElement)
		}

		$ChildElement = $XmlDocument.ImportNode($Xml.DocumentElement, $true)

		[void]$RootElement.AppendChild($ChildElement)
		[void]$XmlDocument.AppendChild($RootElement)
		#EndRegion

		#Region Build HTML
		$XsltArgumentList = [System.Xml.Xsl.XsltArgumentList]::New()
		$XsltArgumentList.Clear()
		$XsltArgumentList.AddParam('EventDate', $null, $(Get-Date).DateTime)

		$EmailBody = Format-XslTemplate -XslTemplatePath $MessageTemplate -XmlContent $XmlDocument -XsltArgumentList $XsltArgumentList

		$EmailBody
		#EndRegion
	}

	end {
	}
}

function ConvertTo-ErrorXML {
	<#
	.EXTERNALHELP
	MailTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([xml])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Management.Automation.ErrorRecord]$ErrorObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$RootNodeName = 'ErrorRecord'
	)

	begin {
		$XmlDocument = [System.Xml.XmlDocument]::New()
		[void]$XmlDocument.AppendChild($XmlDocument.CreateXmlDeclaration('1.0', 'UTF-8', $null))
	}

	process {
		try {
			$ErrorRecordXml = [ErrorRecordXml]::New($ErrorObject, $RootNodeName)

			$ChildElement = $XmlDocument.ImportNode($ErrorRecordXml.XmlElement, $true)

			[void]$XmlDocument.AppendChild($ChildElement)

			$XmlDocument.OuterXml
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function ConvertTo-ObjectXML {
	<#
	.EXTERNALHELP
	MailTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([xml])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $false
		)]
		[object]$Object,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$RootNodeName = 'ObjectRecord'
	)

	begin {
		$XmlDocument = [System.Xml.XmlDocument]::New()
		[void]$XmlDocument.AppendChild($XmlDocument.CreateXmlDeclaration('1.0', 'UTF-8', $null))
	}

	process {
		try {
			$ObjectXml = [ObjectXml]::New($Object, $RootNodeName)

			$ChildElement = $XmlDocument.ImportNode($ObjectXml.XmlElement, $true)

			[void]$XmlDocument.AppendChild($ChildElement)

			$XmlDocument.OuterXml
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function ConvertTo-RecordXML {
	<#
	.EXTERNALHELP
	MailTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([xml])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Data.DataSet]$InputObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$RootNodeName = 'Records'
	)

	begin {
		$XmlDocument = [System.Xml.XmlDocument]::New()
		[void]$XmlDocument.AppendChild($XmlDocument.CreateXmlDeclaration('1.0', 'UTF-8', $null))

		$RootNode = $XmlDocument.AppendChild($XmlDocument.CreateElement($RootNodeName))

		$ExcludedPSObjectProperties = ('RowError', 'RowState', 'Table', 'ItemArray', 'HasErrors')
	}

	process {
		try {
			foreach ($Table in $InputObject.Tables) {
				$TableObject = $XmlDocument.CreateElement('Table')

				foreach ($Row in $Table.Rows) {
					$RowObject = $XmlDocument.CreateElement('Row')

					foreach ($Property in $Row.PsObject.Properties) {
						if ($Property.Name -NotIn $ExcludedPSObjectProperties) {
							$PropertyNode = $XmlDocument.CreateElement($Property.Name)
							$PropertyNode.InnerText = $Property.Value

							[void]$RowObject.AppendChild($PropertyNode)
						}
					}

					[void]$TableObject.AppendChild($RowObject)
				}

				[void]$RootNode.AppendChild($TableObject)
			}

			$XmlDocument.OuterXml
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Get-MimeContentType {
	<#
	.SYNOPSIS
	Returns MINE content type object.
	.DESCRIPTION
	Returns MINE content type object.
	.PARAMETER FilePath
	Specifies the path and file names of file to be attached.
	.PARAMETER FileName
	Sets the MIME content ID for this attachment.
	.EXAMPLE
	Get-MimeContentType -FilePath C:\Temp\MyFile.txt
	.EXAMPLE
	Get-MimeContentType -FileName image.png
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'FilePath'
	)]

	[OutputType([System.Net.Mime.ContentType])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'FilePath'
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo]$FilePath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'FileName'
		)]
		[string]$FileName
	)

	begin {
		$DataPath = Join-Path -Path $PSScriptRoot -ChildPath 'Data\mimeData.json' -Resolve

		$MimeData = Get-Content -Path $DataPath -Raw | ConvertFrom-Json

		if ($PSCmdlet.ParameterSetName -eq 'FilePath') {
			$FileName = $FilePath.Name
		}
	}

	process {
		$Extension = [System.IO.Path]::GetExtension($FileName)

		$ContentType = $MimeData.Where({$_.fileTypes -contains $Extension})

		if ($ContentType.Count -eq 0) {
			[System.Net.Mime.ContentType]::New()
		} elseif ($ContentType.Count -eq 1) {
			[System.Net.Mime.ContentType]::New($ContentType.name)
		} else {
			# Lacking a programmatic way to determine best match.
			[System.Net.Mime.ContentType]::New($ContentType[0].name)
		}
	}

	end {
	}
}

function Format-MailAttachment {
	<#
	.EXTERNALHELP
	MailTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'FilePath'
	)]

	[OutputType([Net.Mail.Attachment])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'FilePath'
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo][TransformPath()]$FilePath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'FileStream'
		)]
		[string]$FileName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'FileStream'
		)]
		[System.IO.Stream]$FileStream,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$Inline
	)

	begin {
		if ($PSCmdlet.ParameterSetName -eq 'FilePath') {
			$FileName = $FilePath.Name
		}
	}

	process {
		try {
			$MimeContentType = Get-MimeContentType -FileName $FileName

			switch ($PSCmdlet.ParameterSetName) {
				'FilePath' {
					$MailAttachment = [Net.Mail.Attachment]::New((Resolve-Path -Path $FilePath).Path, $MimeContentType)
				}
				'FileStream' {
					$MailAttachment = [Net.Mail.Attachment]::New($FileStream, $MimeContentType)
				}
			}

			$MailAttachment.ContentId = $FileName

			if ($PSBoundParameters.ContainsKey('Inline')) {
				$MailAttachment.ContentDisposition.Inline = $Inline

				if ($Inline) {
					$MailAttachment.ContentDisposition.DispositionType = 'inline'
				} else {
					$MailAttachment.ContentDisposition.DispositionType = 'attachment'
				}
			}

			$MailAttachment
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Format-XslTemplate {
	<#
	.EXTERNALHELP
	MailTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([xml])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo][TransformPath()]$XslTemplatePath,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[xml]$XmlContent = '<root/>',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Xml.Xsl.XsltArgumentList]$XsltArgumentList
	)

	begin {
		#	$BaseXmlDocument = [System.Xml.XmlDocument]::New()
		#	$BaseXmlDocument.LoadXml($XmlContent)
		$BaseXmlDocument = $XmlContent
		#	$XsltArgumentList = [System.Xml.Xsl.XsltArgumentList]::New()
		#	$XsltArgumentList.Clear()
		#	$XsltArgumentList.AddParam('Name', $null, $ADUser.Name)
		#	$XsltArgumentList.AddParam('CompanyName', $null, $CompanyName)
	}

	process {
		try {
			$MemoryStream = [System.IO.MemoryStream]::New()
			$XmlWriter = [System.Xml.XmlWriter]::Create($MemoryStream)

			$XslCompiledTransform = [System.Xml.Xsl.XslCompiledTransform]::New()
			$XslCompiledTransform.Load($(Resolve-Path -Path $XslTemplatePath).Path)
			$XslCompiledTransform.Transform($BaseXmlDocument, $XsltArgumentList, $XmlWriter)

			$XmlWriter.Flush()
			$MemoryStream.Position = 0

			$FinalXmlDocument = [System.Xml.XmlDocument]::New()
			$FinalXmlDocument.Load($MemoryStream)

			$FinalXmlDocument.Get_OuterXML()
		}
		catch {
			throw $_
		}
	}

	end {
		if (Test-Path -Path Variable:MemoryStream) {
			$MemoryStream.Close()
			$MemoryStream.Dispose()
		}
	}
}

function Send-MailToolMessage {
	<#
	.EXTERNALHELP
	MailTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'Network'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.MailAddress]$MailFrom,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.MailAddress[]]$MailTo,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.MailAddress[]]$ReplyTo,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.MailAddress[]]$CarbonCopy,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.MailAddress[]]$BlindCarbonCopy,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 78)]
		[string]$Subject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.Attachment[]]$MailAttachment,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$Body,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$BodyAsHtml,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Net.Mail.MailPriority]$Priority = 'Normal',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Net.Mail.DeliveryNotificationOptions]$DeliveryNotificationOption,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Net.Mail.SmtpDeliveryMethod]$SmtpDeliveryMethod = 'Network',

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Network'
		)]
		[ValidateLength(1, 128)]
		[string]$SmtpServer,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Network'
		)]
		[ValidateRange(1, 65535)]
		[int]$SmtpPort = 25,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Network'
		)]
		[switch]$UseTLS,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Network'
		)]
		[System.Management.Automation.PSCredential]$Credential,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'PickupDirectory'
		)]
		[ValidatePathExists('Container')]
		[System.IO.DirectoryInfo]$PickupDirectoryPath
	)

	begin {
	}

	process {
		try {
			$MailMessage = [System.Net.Mail.MailMessage]::New()

			$MailMessage.From = $MailFrom

			foreach ($Recipient in $MailTo) {
				$MailMessage.To.add($Recipient)
			}

			if ($PSBoundParameters.ContainsKey('CarbonCopy')) {
				foreach ($Recipient in $CarbonCopy) {
					$MailMessage.CC.add($Recipient)
				}
			}

			if ($PSBoundParameters.ContainsKey('BlindCarbonCopy')) {
				foreach ($Recipient in $BlindCarbonCopy) {
					$MailMessage.Bcc.add($Recipient)
				}
			}

			if ($PSBoundParameters.ContainsKey('ReplyTo')) {
				foreach ($Recipient in $ReplyTo) {
					$MailMessage.ReplyToList.add($Recipient)
				}
			}

			$MailMessage.Priority = $Priority
			$MailMessage.Subject = $Subject
			$MailMessage.Body = $Body

			if ($BodyAsHtml) {
				$MailMessage.IsBodyHTML = $true
			}

			foreach ($Attachment in $MailAttachment) {
				$MailMessage.Attachments.Add($Attachment)
			}

			if ($PSBoundParameters.ContainsKey('DeliveryNotificationOption')) {
				$MailMessage.DeliveryNotificationOption = $DeliveryNotificationOption
			}

			$SmtpClient = [System.Net.Mail.SmtpClient]::New()
			$SmtpClient.DeliveryMethod = $SmtpDeliveryMethod

			switch ($SmtpDeliveryMethod) {
				'Network' {
					$SmtpClient.Host = $SmtpServer
					$SmtpClient.Port = $SmtpPort

					if ($UseTLS) {
						$SmtpClient.EnableSsl = $true
					}

					if ($PSBoundParameters.ContainsKey('Credentials')) {
						$SmtpClient.Credentials = [System.Net.NetworkCredential]::New($SMTPUsername, $SMTPPassword)
					} else {
						$SmtpClient.UseDefaultCredentials = $true
					}
				}
				'SpecifiedPickupDirectory' {
					$SmtpClient.Host = 'localhost'
					$SmtpClient.PickupDirectoryLocation = $(Resolve-Path -Path $PickupDirectoryPath).Path
				}
				'PickupDirectoryFromIis' {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('PickupDirectoryFromIis is not implemented.'),
						'2',
						[System.Management.Automation.ErrorCategory]::NotImplemented,
						$SmtpDeliveryMethod
					)
				}
				Default {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Invalid SMTP delivery method.'),
						'2',
						[System.Management.Automation.ErrorCategory]::InvalidType,
						$SmtpDeliveryMethod
					)
				}
			}

			$SmtpClient.Send($MailMessage)
		}
		catch {
			throw $_
		}
		finally {
			foreach ($Attachment in $MailAttachment) {
				$Attachment.Dispose()
			}

			if (Test-Path -Path Variable:MailMessage) {
				$MailMessage.Dispose()
			}

			if (Test-Path -Path Variable:SmtpClient) {
				$SmtpClient.Dispose()
			}
		}
	}

	end {
	}
}
