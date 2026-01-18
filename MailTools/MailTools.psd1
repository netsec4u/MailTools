@{

# Script module or binary module file associated with this manifest.
RootModule = 'MailTools.psm1'

# Version number of this module.
ModuleVersion = '2.2.10.1'

# Supported PSEditions
CompatiblePSEditions = @('Core', 'Desktop')

# ID used to uniquely identify this module
GUID = '2e6c86d5-98ac-4bb7-bc9a-9ff2fab701a0'

# Author of this module
Author = 'Robert Eder'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = '(c) 2024 Robert Eder. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Module provides eMail functions.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
#RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
#TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
#FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
	'Build-MailBody',
	'ConvertTo-ErrorXML',
	'ConvertTo-ObjectXML',
	'ConvertTo-RecordXML',
	'Format-MailAttachment',
	'Format-XslTemplate',
	'Send-MailToolMessage'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
# CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
# AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @(
	'MailTools.psm1',
	'Data\mimeData.json',
	'Templates\MessageTemplate.xsl'
)

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

	PSData = @{

		# Tags applied to this module. These help with module discovery in online galleries.
		Tags = @('Mail', 'XSL')

		# A URL to the license for this module.
		LicenseUri = 'https://raw.githubusercontent.com/netsec4u/MailTools/main/LICENSE'

		# A URL to the main website for this project.
		ProjectUri = 'https://github.com/netsec4u/MailTools'

		# A URL to an icon representing this module.
		# IconUri = ''

		# ReleaseNotes of this module
		ReleaseNotes = '
			Mime data from:
				https://mimetype.io/all-types
				https://github.com/patrickmccallum/mimetype-io/blob/master/src/mimeData.json
		'

		# Prerelease string of this module
		# Prerelease = ''

		# Flag to indicate whether the module requires explicit user acceptance for install/update/save
		# RequireLicenseAcceptance = $true

		# External dependent modules of this module
		# ExternalModuleDependencies = @()
	} # End of PSData hashtable

	TemplateFiles = @{
		MessageTemplate = 'Templates\MessageTemplate.xsl'
	}

} # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://github.com/netsec4u/MailTools/blob/main/docs/MailTools.md'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
