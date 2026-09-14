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
	MailTools-Help.xml
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
	MailTools-Help.xml
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
	MailTools-Help.xml
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
	MailTools-Help.xml
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
	MailTools-Help.xml
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
					$MailAttachment = [Net.Mail.Attachment]::New($FilePath.FullName, $MimeContentType)
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
	MailTools-Help.xml
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
	MailTools-Help.xml
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

					if ($PSBoundParameters.ContainsKey('Credential')) {
						$SmtpClient.Credentials = $Credential
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
						[Exception]::New('Unknown SMTP delivery method.'),
						'2',
						[System.Management.Automation.ErrorCategory]::InvalidType,
						$SmtpDeliveryMethod
					)
				}
			}

			for ($i = 0; $i -lt 5; $i++) {
				try {
					$SmtpClient.Send($MailMessage)

					break
				}
				catch {
					if ($i -eq 4) {
						throw $_
					} else {
						Start-Sleep -Seconds $([Math]::Pow(2, $i) * 5)
					}
				}
			}
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

# SIG # Begin signature block
# MIInywYJKoZIhvcNAQcCoIInvDCCJ7gCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDS6EeA4/z+6Kt6
# V9VbxOaHN8AjYrxbs3KGi41ZfMMMfKCCINswggWNMIIEdaADAgECAhAOmxiO+dAt
# 5+/bUOIIQBhaMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNV
# BAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yMjA4MDEwMDAwMDBa
# Fw0zMTExMDkyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2Vy
# dCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lD
# ZXJ0IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoC
# ggIBAL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3E
# MB/zG6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKy
# unWZanMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsF
# xl7sWxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU1
# 5zHL2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJB
# MtfbBHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObUR
# WBf3JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6
# nj3cAORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxB
# YKqxYxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5S
# UUd0viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+x
# q4aLT8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjggE6MIIB
# NjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/57qYrhwP
# TzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzAOBgNVHQ8BAf8EBAMC
# AYYweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdp
# Y2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0
# aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENB
# LmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEMBQADggEBAHCgv0Nc
# Vec4X6CjdBs9thbX979XB72arKGHLOyFXqkauyL4hxppVCLtpIh3bb0aFPQTSnov
# Lbc47/T/gLn4offyct4kvFIDyE7QKt76LVbP+fT3rDB6mouyXtTP0UNEm0Mh65Zy
# oUi0mcudT6cGAxN3J0TU53/oWajwvy8LpunyNDzs9wPHh6jSTEAZNUZqaVSwuKFW
# juyk1T3osdz9HNj0d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAcAgPLILCsWKAOQGPF
# mCLBsln1VWvPJ6tsds5vIy30fnFqI2si/xK4VC0nftg62fC2h5b9W9FcrBjDTZ9z
# twGpn1eqXijiuZQwgga0MIIEnKADAgECAhANx6xXBf8hmS5AQyIMOkmGMA0GCSqG
# SIb3DQEBCwUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMx
# GTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRy
# dXN0ZWQgUm9vdCBHNDAeFw0yNTA1MDcwMDAwMDBaFw0zODAxMTQyMzU5NTlaMGkx
# CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4
# RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEyNTYg
# MjAyNSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC0eDHTCphB
# cr48RsAcrHXbo0ZodLRRF51NrY0NlLWZloMsVO1DahGPNRcybEKq+RuwOnPhof6p
# vF4uGjwjqNjfEvUi6wuim5bap+0lgloM2zX4kftn5B1IpYzTqpyFQ/4Bt0mAxAHe
# HYNnQxqXmRinvuNgxVBdJkf77S2uPoCj7GH8BLuxBG5AvftBdsOECS1UkxBvMgEd
# gkFiDNYiOTx4OtiFcMSkqTtF2hfQz3zQSku2Ws3IfDReb6e3mmdglTcaarps0wjU
# jsZvkgFkriK9tUKJm/s80FiocSk1VYLZlDwFt+cVFBURJg6zMUjZa/zbCclF83bR
# VFLeGkuAhHiGPMvSGmhgaTzVyhYn4p0+8y9oHRaQT/aofEnS5xLrfxnGpTXiUOeS
# LsJygoLPp66bkDX1ZlAeSpQl92QOMeRxykvq6gbylsXQskBBBnGy3tW/AMOMCZIV
# NSaz7BX8VtYGqLt9MmeOreGPRdtBx3yGOP+rx3rKWDEJlIqLXvJWnY0v5ydPpOjL
# 6s36czwzsucuoKs7Yk/ehb//Wx+5kMqIMRvUBDx6z1ev+7psNOdgJMoiwOrUG2Zd
# SoQbU2rMkpLiQ6bGRinZbI4OLu9BMIFm1UUl9VnePs6BaaeEWvjJSjNm2qA+sdFU
# eEY0qVjPKOWug/G6X5uAiynM7Bu2ayBjUwIDAQABo4IBXTCCAVkwEgYDVR0TAQH/
# BAgwBgEB/wIBADAdBgNVHQ4EFgQU729TSunkBnx6yuKQVvYv1Ensy04wHwYDVR0j
# BBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1Ud
# JQQMMAoGCCsGAQUFBwMIMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0
# cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0
# cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8E
# PDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVz
# dGVkUm9vdEc0LmNybDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEw
# DQYJKoZIhvcNAQELBQADggIBABfO+xaAHP4HPRF2cTC9vgvItTSmf83Qh8WIGjB/
# T8ObXAZz8OjuhUxjaaFdleMM0lBryPTQM2qEJPe36zwbSI/mS83afsl3YTj+IQhQ
# E7jU/kXjjytJgnn0hvrV6hqWGd3rLAUt6vJy9lMDPjTLxLgXf9r5nWMQwr8Myb9r
# EVKChHyfpzee5kH0F8HABBgr0UdqirZ7bowe9Vj2AIMD8liyrukZ2iA/wdG2th9y
# 1IsA0QF8dTXqvcnTmpfeQh35k5zOCPmSNq1UH410ANVko43+Cdmu4y81hjajV/gx
# dEkMx1NKU4uHQcKfZxAvBAKqMVuqte69M9J6A47OvgRaPs+2ykgcGV00TYr2Lr3t
# y9qIijanrUR3anzEwlvzZiiyfTPjLbnFRsjsYg39OlV8cipDoq7+qNNjqFzeGxcy
# tL5TTLL4ZaoBdqbhOhZ3ZRDUphPvSRmMThi0vw9vODRzW6AxnJll38F0cuJG7uEB
# YTptMSbhdhGQDpOXgpIUsWTjd6xpR6oaQf/DJbg3s6KCLPAlZ66RzIg9sC+NJpud
# /v4+7RWsWCiKi9EOLLHfMR2ZyJ/+xhCx9yHbxtl5TPau1j/1MIDpMPx0LckTetiS
# uEtQvLsNz3Qbp7wGWqbIiOWCnb5WqxL3/BAPvIXKUjPSxyZsq8WhbaM2tszWkPZP
# ubdcMIIGuTCCBKGgAwIBAgIRAJmjgAomVTtlq9xuhKaz6jkwDQYJKoZIhvcNAQEM
# BQAwgYAxCzAJBgNVBAYTAlBMMSIwIAYDVQQKExlVbml6ZXRvIFRlY2hub2xvZ2ll
# cyBTLkEuMScwJQYDVQQLEx5DZXJ0dW0gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkx
# JDAiBgNVBAMTG0NlcnR1bSBUcnVzdGVkIE5ldHdvcmsgQ0EgMjAeFw0yMTA1MTkw
# NTMyMThaFw0zNjA1MTgwNTMyMThaMFYxCzAJBgNVBAYTAlBMMSEwHwYDVQQKExhB
# c3NlY28gRGF0YSBTeXN0ZW1zIFMuQS4xJDAiBgNVBAMTG0NlcnR1bSBDb2RlIFNp
# Z25pbmcgMjAyMSBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJ0j
# zwQwIzvBRiznM3M+Y116dbq+XE26vest+L7k5n5TeJkgH4Cyk74IL9uP61olRsxs
# U/WBAElTMNQI/HsE0uCJ3VPLO1UufnY0qDHG7yCnJOvoSNbIbMpT+Cci75scCx7U
# sKK1fcJo4TXetu4du2vEXa09Tx/bndCBfp47zJNsamzUyD7J1rcNxOw5g6FJg0Im
# Iv7nCeNn3B6gZG28WAwe0mDqLrvU49chyKIc7gvCjan3GH+2eP4mYJASflBTQ3HO
# s6JGdriSMVoD1lzBJobtYDF4L/GhlLEXWgrVQ9m0pW37KuwYqpY42grp/kSYE4BU
# QrbLgBMNKRvfhQPskDfZ/5GbTCyvlqPN+0OEDmYGKlVkOMenDO/xtMrMINRJS5SY
# +jWCi8PRHAVxO0xdx8m2bWL4/ZQ1dp0/JhUpHEpABMc3eKax8GI1F03mSJVV6o/n
# mmKqDE6TK34eTAgDiBuZJzeEPyR7rq30yOVw2DvetlmWssewAhX+cnSaaBKMEj9O
# 2GgYkPJ16Q5Da1APYO6n/6wpCm1qUOW6Ln1J6tVImDyAB5Xs3+JriasaiJ7P5KpX
# eiVV/HIsW3ej85A6cGaOEpQA2gotiUqZSkoQUjQ9+hPxDVb/Lqz0tMjp6RuLSKAR
# sVQgETwoNQZ8jCeKwSQHDkpwFndfCceZ/OfCUqjxAgMBAAGjggFVMIIBUTAPBgNV
# HRMBAf8EBTADAQH/MB0GA1UdDgQWBBTddF1MANt7n6B0yrFu9zzAMsBwzTAfBgNV
# HSMEGDAWgBS2oVQ5AsOgP46KvPrU+Bym0ToO/TAOBgNVHQ8BAf8EBAMCAQYwEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwMAYDVR0fBCkwJzAloCOgIYYfaHR0cDovL2NybC5j
# ZXJ0dW0ucGwvY3RuY2EyLmNybDBsBggrBgEFBQcBAQRgMF4wKAYIKwYBBQUHMAGG
# HGh0dHA6Ly9zdWJjYS5vY3NwLWNlcnR1bS5jb20wMgYIKwYBBQUHMAKGJmh0dHA6
# Ly9yZXBvc2l0b3J5LmNlcnR1bS5wbC9jdG5jYTIuY2VyMDkGA1UdIAQyMDAwLgYE
# VR0gADAmMCQGCCsGAQUFBwIBFhhodHRwOi8vd3d3LmNlcnR1bS5wbC9DUFMwDQYJ
# KoZIhvcNAQEMBQADggIBAHWIWA/lj1AomlOfEOxD/PQ7bcmahmJ9l0Q4SZC+j/v0
# 9CD2csX8Yl7pmJQETIMEcy0VErSZePdC/eAvSxhd7488x/Cat4ke+AUZZDtfCd8y
# HZgikGuS8mePCHyAiU2VSXgoQ1MrkMuqxg8S1FALDtHqnizYS1bIMOv8znyJjZQE
# Sp9RT+6NH024/IqTRsRwSLrYkbFq4VjNn/KV3Xd8dpmyQiirZdrONoPSlCRxCIi5
# 4vQcqKiFLpeBm5S0IoDtLoIe21kSw5tAnWPazS6sgN2oXvFpcVVpMcq0C4x/CLSN
# e0XckmmGsl9z4UUguAJtf+5gE8GVsEg/ge3jHGTYaZ/MyfujE8hOmKBAUkVa7NMx
# RSB1EdPFpNIpEn/pSHuSL+kWN/2xQBJaDFPr1AX0qLgkXmcEi6PFnaw5T17UdIIn
# A58rTu3mefNuzUtse4AgYmxEmJDodf8NbVcU6VdjWtz0e58WFZT7tST6EWQmx/Oo
# HPelE77lojq7lpsjhDCzhhp4kfsfszxf9g2hoCtltXhCX6NqsqwTT7xe8LgMkH4h
# Vy8L1h2pqGLT2aNCx7h/F95/QvsTeGGjY7dssMzq/rSshFQKLZ8lPb8hFTmiGDJN
# yHga5hZ59IGynk08mHhBFM/0MLeBzlAQq1utNjQprztZ5vv/NJy8ua9AGbwkMWkO
# MIIG4DCCBMigAwIBAgIQQ7s0QZ8qUnHOP66HyvajHjANBgkqhkiG9w0BAQsFADBW
# MQswCQYDVQQGEwJQTDEhMB8GA1UEChMYQXNzZWNvIERhdGEgU3lzdGVtcyBTLkEu
# MSQwIgYDVQQDExtDZXJ0dW0gQ29kZSBTaWduaW5nIDIwMjEgQ0EwHhcNMjYwOTEy
# MjEzNTQ3WhcNMjcwOTEyMjEzNTQ2WjCBhTELMAkGA1UEBhMCVVMxFzAVBgNVBAgM
# DlNvdXRoIENhcm9saW5hMREwDwYDVQQHDAhOZXdiZXJyeTEeMBwGA1UECgwVT3Bl
# biBTb3VyY2UgRGV2ZWxvcGVyMSowKAYDVQQDDCFPcGVuIFNvdXJjZSBEZXZlbG9w
# ZXIgUm9iZXJ0IEVkZXIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC6
# 72ybkWUB620cgb49nkhI4VvtWKABeSD8277f0Jww+/5fKUxoX2vC77QjmaSXU+I9
# LB2YTj8yCSTDVlxIwJoS7KgsIN9P2EC6ehJe9FRI0n2Rt33/VlRY8kuSh2XsIVGg
# i6Y3RooWVjVmYCAOXuV5zrqjGY1P72nrSIekxcGCTo1Y0nmRwsECCIYn7b3ZM065
# u9b3AtYf3oI4grblWhtY0kbuHNCSeDjpp+qExQgeIs6OpFACJSDASFiDnF8+L+bB
# V+UtUcFbvlu0WpQyblXw9vdN7BEIdqZ/1fxyhjHxqpSuOoTqoZcyDjilXtnMOfWp
# gfgdKPFRc6NHwrmxUyNLAYHOsqBC+bMxamurB1qCJ/16lFbW/YWJRrJsaeA2WaPw
# 8ulkUnZUoP9JgyVE1nwZbhZOgE3YwlVLmBBsAKsRiyJWBYqG1VdaMpfzLYJVNTc8
# 4F/90uC2BvIoafcFfNyc8dIpdd7Ni17JmYuD0+/u1gqUi3p+Qdlk/y+Vgsb1x+0z
# kaMA6CzjFA83szdzwRLFDDnaUOVngyRR8+JLnSNuEw9nNM3G5WWRGBDOkLbwq+NO
# H1gWWAaJJYOlTARrg7ea2JHLl66CBJaaledp2u8hBl1Y5yQTpIkVYx0VPt1Oa7Nq
# kOkXlNjmmlYsZm5pe3fSTBPx5YdUOeIl1sAWXGH/+QIDAQABo4IBeDCCAXQwDAYD
# VR0TAQH/BAIwADA9BgNVHR8ENjA0MDKgMKAuhixodHRwOi8vY2NzY2EyMDIxLmNy
# bC5jZXJ0dW0ucGwvY2NzY2EyMDIxLmNybDBzBggrBgEFBQcBAQRnMGUwLAYIKwYB
# BQUHMAGGIGh0dHA6Ly9jY3NjYTIwMjEub2NzcC1jZXJ0dW0uY29tMDUGCCsGAQUF
# BzAChilodHRwOi8vcmVwb3NpdG9yeS5jZXJ0dW0ucGwvY2NzY2EyMDIxLmNlcjAf
# BgNVHSMEGDAWgBTddF1MANt7n6B0yrFu9zzAMsBwzTAdBgNVHQ4EFgQUCdHvF5Qw
# xL78QY6vfJNPC89uTWEwSwYDVR0gBEQwQjAIBgZngQwBBAEwNgYLKoRoAYb2dwIF
# AQQwJzAlBggrBgEFBQcCARYZaHR0cHM6Ly93d3cuY2VydHVtLnBsL0NQUzATBgNV
# HSUEDDAKBggrBgEFBQcDAzAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQAD
# ggIBADGvhUwApFlOiMwxr4muEgH+EK8xGwyw7qZGQZYdHQZV7E6ev+4i0u2ywMbF
# H0XcYpaB4xubprYIGbltJhIXoIM+BmIB6mgzgAtKMJBIWMECnACZKPAWPJ5vp3Xu
# GLCg0gwQGZEKJInwEFLzplH3G5g8hTO8KSLmWLVWoWHTTA3WI4LgTf/XRs3QYqur
# bB1gWRWa+vx8J/4I6znbpnpRDxy/jCYh9qtv21Dk3BovIPnfaj50JOWJhWeongQ6
# Dgd4/FZhM/U1Fj/g1W7WDMal9q43MABwmrHPbxrIEK1V5vXwAhK1m9eSaZ8bqbeA
# SId0wOYzIyEziquoO5TCdf/lSi8nD4BIm2E+h738pLQXWvr6tYWyvqaUN0uk5f27
# NsXlVRYp8EUZPP83BJMaQJFgTsYPMeZejAndk3nuqPVGeCL6WW90M7eK5sPbTAmW
# WrSnYFx4pgnMR3X3s14074ytJ3o3ycKa0bxjhMcoCTfMDmV7jUUhATpW8iZ2/E4b
# +0s7DmbN37VsBngsj04vMyVxhcNLSwdFDTQEgkEwHccChlw0anfoZJ7Xui4x5RSr
# j3rOyyrf7mFYIpsbDYjVxBo5/JVJuu5h2+BRxY9MLoSMknm391tCI7aVC/XTl/zW
# rX1kJeCx0nYBnZnmjWCRrCXWOX5V8QaLAnK/R6durGeXnlo3MIIG7TCCBNWgAwIB
# AgIQCE/cM09+RU7bww+P+ZIYNTANBgkqhkiG9w0BAQsFADBpMQswCQYDVQQGEwJV
# UzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRy
# dXN0ZWQgRzQgVGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIwMjUgQ0ExMB4X
# DTI2MDgwNTAwMDAwMFoXDTM3MTEwNDIzNTk1OVowYzELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBTSEEyNTYg
# UlNBNDA5NiBUaW1lc3RhbXAgUmVzcG9uZGVyIDIwMjYgMTCCAiIwDQYJKoZIhvcN
# AQEBBQADggIPADCCAgoCggIBALZ7pvLJ/s1K+NSbTGWz/TjGMPh8CQ6RucZCLv5a
# nHzWJjF/NWJrFIhy24fcpKXlgRiky4WAawDfU3YP0BMxt9l3Dm5oCG5Z69AqEN1k
# gHg2epx+l+lZBcmJCcN0ASURML5uFIS80sZsDwO3BSkUxDjLJhBI+qiZP3aixAC/
# qEGLjsBNlLol9VZ7pfGEXiMlneJIC5/YKuizVzNFKZZEeoy/0B8Zm+nzKBgSWG52
# lCO1w+nCg6XpCtklTJXeIg283hw7TmmsZXR+SMbjbrEOvZ3fP2VxIgeR28Y90ZSt
# d3F9VuA5RVynb/whITPAo9b75Zr4Ta6Mj3URm26QZYMn/FnbuTegcoRcFEZ9FOqM
# 5T6MTdtr/n74lIT/ug0eeOzmZ6QTFg33otX+bFRsIolvykE1jive4PuESaT8zzVe
# FWDAMDtozNgLctkGD1ZjkEyZtJrLl5ya0m5doH/ScpaZCZVl6pNUOCybMc/kxC6E
# AmSJY24L0yYKD1Nkddsnb/ItVKi/2nXpQNMu1PT5prW83vV8d67WowuUs0HdY4H8
# AMLGvdL/WHEj3ZnqMqAQQP9u3Ai9t+5eQ02GDwy0ODjdzi0xlp70W+ow63/0++YD
# EX1M0iwgUHwbrJvfpklkZQvw3+kv3vUPItdwroczk9icflf55W1zOEKAcJVAIXpc
# MCU9AgMBAAGjggGVMIIBkTAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBQUyWOKMC7U
# SvtulPPm40B+9ezN4jAfBgNVHSMEGDAWgBTvb1NK6eQGfHrK4pBW9i/USezLTjAO
# BgNVHQ8BAf8EBAMCB4AwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwgZUGCCsGAQUF
# BwEBBIGIMIGFMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20w
# XQYIKwYBBQUHMAKGUWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2Vy
# dFRydXN0ZWRHNFRpbWVTdGFtcGluZ1JTQTQwOTZTSEEyNTYyMDI1Q0ExLmNydDBf
# BgNVHR8EWDBWMFSgUqBQhk5odHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRUcnVzdGVkRzRUaW1lU3RhbXBpbmdSU0E0MDk2U0hBMjU2MjAyNUNBMS5jcmww
# IAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUA
# A4ICAQCNxTphHp1SCt+ZrAmAfn0oQLFr0mLywSLaDXQIENoyKqxrFbJblzCVP/pk
# XmwXOdrOpWygLzlT12os5ipDCy35RBCg2UMeApEtrfGhz45F4Wt4WGdNdIbRWt3Y
# TYJmpR+b7lr4d7Uwn+H600u4D7RnOGf8Wj4UNgAdZkfHhHv1mx9EVh71SJelcEN/
# oORSjXzdjfw1iZH9d8Nh/thn6hH23d+VsPAr6GAYyzSA02nXD1nYLI7Ijmiv+xLC
# iYC41DSFYL3GhTiy0PxpawPtGRyaBVGzq+UiTfM8pD7KVyF5aQyWP4KhVGUUTnmm
# /RlYJoW3TiXA/+t0YcT2oRVBm3JETjajHug2AL+v5jhtKVnd3D0rbHXEu27o+Q8p
# 4sEWPMqKDB+qbceb6T/6WcwTwXmQ9lOCLLYcsQeSWmvKqzpAec9etE14jOQAzLKW
# dE3w/TCaKtLRaRT7LCkRYVnhA2D73FLje1O5b3HR5eHs0NzU/+xX7NbEdcofy0W3
# Wdwd1XOqtlpg/JgwtKfZM5dqO94lbUveOiJBI+xZEbGRsMNbXmMREUTgu+Oca7Y7
# 3MPWcslIx2VhkSKSXjDbD6rgg39H5Mh7QfieAIjWagkJNt68Yfim6cjEzVSiLSeZ
# fdkr5dtFPTW6jATlWJdYeeDRGCyatf8R1hSjzSvdN8yWQPT9gzGCBkYwggZCAgEB
# MGowVjELMAkGA1UEBhMCUEwxITAfBgNVBAoTGEFzc2VjbyBEYXRhIFN5c3RlbXMg
# Uy5BLjEkMCIGA1UEAxMbQ2VydHVtIENvZGUgU2lnbmluZyAyMDIxIENBAhBDuzRB
# nypScc4/rofK9qMeMA0GCWCGSAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAI
# oAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIB
# CzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIFyR3J4Q43VvL6CiTP94
# IXRbk8ACrXEuUBtETKJ88DHHMA0GCSqGSIb3DQEBAQUABIICAAm76qulAgMewW+h
# essZsscu0tkB0HsQigASt2NQg6TfKg4zObzeyMftFl5X9gMgHdKM0XBKXcaNSpo9
# nXFusW92XIbCQ59ZkapijzeZ/D6UkF30aQjjJWda5D3rCp5GZ9h9vjZ0QT7g2ByS
# 9VTxauJXb3TWV1sX2A0lSDZENz+NzX7iHngBMGxRy8xgniFxtBFI1b4+aKvWa6bO
# 8QttuwzlJpuM9A+3cSY8iFvnxTjJnmrK7fUHl7FC0NPTAmt2EOSXRMEmh55e/4wF
# qOS6bdmG5CChgtOVOcVBoDPEHUQU7O3JNKLRGeG9mapTlWF5U8n712ljPPh2CASm
# qaWCfOwzfhaZQKDqFs0inAE/++eRIP1F1YTDZR6xBWOnqzoawN2Rg2p1JXhxF+A2
# 8FnlNs1D0f3GOQmesBaU5wtXY+LUffo3tDCMMY+T9oA5rxMW2AIAmT1xM7UOPh6/
# FEtt50dgEvSOLG+O8KZx/Lbx/RO6J7EOSmyVgpf/5shzNH8zmC+FIpsTM7mvgeS9
# Yzqcj9iOO9rq+AKxmNJmWkYz0h4Ku94jppW/iIT8FQzknndJCH9RfoD7PFFnnxA3
# gYM2Y8TxQJbK21J4GznHkSAKhjCj+2VR6i4oGIRO7PAsTGwImYTI7BrSAJ0Qfsro
# ruPacTtVwr2B0U40ZQoIRQvndLA0oYIDJjCCAyIGCSqGSIb3DQEJBjGCAxMwggMP
# AgEBMH0waTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEw
# PwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0IFRpbWVTdGFtcGluZyBSU0E0MDk2
# IFNIQTI1NiAyMDI1IENBMQIQCE/cM09+RU7bww+P+ZIYNTANBglghkgBZQMEAgEF
# AKBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
# MDkxMzE5MzU0NVowLwYJKoZIhvcNAQkEMSIEIJ5vtT83XN03KBYmR7jzPU+1ESu1
# K+TCbQ1vyke5zGPeMA0GCSqGSIb3DQEBAQUABIICAJceMoPWd7widDzdfxDRkdZZ
# YeT3R0YPwOSF9LKffxeZAq+hzrIvMkFsGqDwXL5+rpXgNvxM98f3ZSre15Lz/E6r
# UFg1BGIkoCkINAWfihBrKztpK2qt9p+Se1Dd+oRRf1y5793OE+j4wPz05/pWL3Dg
# LFvAZTXYc0zRoWBz949PfdpVQ5kVY/Y7TdPL/ip13+lAQsqmT6QL9mjyFvLZZxMC
# i6Cve4Jfq5Q73wEtRWUdwHlAq0vGBPLaQiYH/A7kpwrcUHmnLGNF+8TOQ9WXjBOn
# WtdrOprKyJ2gFcD/SgxvQ53iVP0f3uPbovhYAlEE8CulgQEMhD/gtm7IMAfAaHr3
# hGiGm69klhVeueoGmEipb+R8MbGYYx2V9aCj0/m011xOCptGNY0s5y0/PZqHx9yS
# RGz+5+WrVR9X4guonPTkhH4jg9YsyaJ+zfGpqbzGAnQ2hN9NPviEdMNov3OeXv3y
# exWp8RMymquAFyhE9qTBP9nJ1nIyz+8s7yl71v2cS7XNLC1SSzkN9XYBQALuT9ZQ
# z/p/B5C5K5R4fhPuVtT36RM4PSkmOpErDsfCwE9+Asx809mzyXGwaXPAtx/Tb50e
# pEtehAlQFBcghqdWD5FgvMKB3y0QeN8NxL02Wb5epwr7n/j6IPlD8EiAnvAgA6mi
# 9KSBBTspMPUFufQeO+fW
# SIG # End signature block
