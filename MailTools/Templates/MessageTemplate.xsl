<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" version="4.0" encoding="UTF-8" omit-xml-declaration="yes" indent="no" />

<xsl:param name="EventDate" />

<xsl:variable name="Title" select="'Message Notification'"/>

<xsl:template match="/">
	<html>
	<head>
		<title><xsl:value-of select="$Title" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width,initial-scale=1 user-scalable=yes" />
		<meta name="color-scheme" content="light only" />
		<meta name="supported-color-schemes" content="light only" />
		<meta name="x-apple-disable-message-reformatting" />
		<meta name="format-detection" content="telephone=no, date=no, address=no, email=no, url=no" />
		<style>
			<xsl:call-template name="EmailStyles"/>
		</style>
	</head>
	<body>
		<table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" id="bodyTable">
			<tr>
				<td align="center" valign="top">
					<table border="0" cellpadding="20" cellspacing="0" width="600" id="emailContainer">
						<tr>
							<td align="center" valign="top">
								<table border="0" cellpadding="20" cellspacing="0" width="100%" id="emailHeader">
									<tr>
										<td align="center" valign="top">
											<xsl:call-template name="EmailHeader"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="center" valign="top">
								<table border="0" cellpadding="20" cellspacing="0" width="100%" id="emailBody">
									<tr>
										<td align="center" valign="top">
											<xsl:call-template name="EmailBody"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="center" valign="top">
								<table border="0" cellpadding="20" cellspacing="0" width="100%" id="emailFooter">
									<tr>
										<td align="center" valign="top">
											<xsl:call-template name = "EmailFooter" />
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</body>
	</html>
</xsl:template>

<xsl:template name="EmailStyles">
	:root {
		color-scheme: light only;
		supported-color-schemes: light only;
	}

	* { font-family:Arial; font-size:12pt; }
	h1, h5, th { text-align: center; }
	table { margin: auto; border: thin ridge grey; border-collapse:collapse; font-size:12pt; table-layout:fixed;  }
	th { background: #0046c3; color: #fff; padding: 4px 8px; }
	td { text-align:left; vertical-align:top; padding: 4px 8px; color: #000; }
	/*
	tr:nth-child(even) { background: #dae5f4; }
	tr:nth-child(odd) { background: #b8d1f3; }
	*/
	#bodyTable { border:none; width:100%; max-width:1280px; }
	#emailContainer { border:none; width:100%; max-width:1276px; }
	#emailHeader { border:none; width:100%; max-width:1272px; }
	#emailBody { border:none; width:100%; max-width:1272px; }
	#emailFooter { border:none; width:100%; max-width:1272px; }

	.SummaryTable { border:none; width:100%; max-width:1268px; }
	.SummaryTable tr .Property { width:160px; }
	.SummaryTable tr .Value { width:available; }

	.ObjectTable { width:100%; max-width:2048px; table-layout:auto; }
	.ObjectTable th { border-left: 1px solid #fff; }
	.ObjectTable td { border-left: 1px solid #fff; }

	.RecordSetTable { width:100%; max-width:2048px; table-layout:auto; }
	.RecordSetTable th { border-left: 1px solid #fff; }
	.RecordSetTable td { border-left: 1px solid #fff; }

	.ErrorDetailTable { width:100%; max-width:2048px; }
	.ErrorDetailTable tr .Property { width:248px; font-weight: bold; }
	.ErrorDetailTable tr .Value { width:available; }
	.ErrorDetailTable th { border-left: 1px solid #fff; }
	.ErrorDetailTable td { border-left: 1px solid #fff; }

	.tr-even { background:#dae5f4; }
	.tr-odd { background:#b8d1f3; }
</xsl:template>

<xsl:template name="EmailHeader">
	<table class="SummaryTable">
		<tr>
			<td class="Property">Date:</td>
			<td class="Value"><xsl:value-of select="$EventDate" /></td>
		</tr>
		<tr><td colspan="2">&#32;</td></tr>

		<xsl:apply-templates select = "Message/Summary" />

		<tr><td colspan="2">&#32;</td></tr>
	</table>
</xsl:template>

<xsl:template name="EmailBody">
	<xsl:apply-templates select = "Message/ErrorRecord" />
	<xsl:apply-templates select = "Message/Objects" />
	<xsl:apply-templates select = "Message/Records/Table" />
</xsl:template>

<xsl:template name="EmailFooter">
	<xsl:call-template name = "nbsp" />
</xsl:template>

<xsl:template match = "Message/Summary">
	<xsl:for-each select="*">
		<tr>
			<td class="Property"><xsl:value-of select ="local-name(.)"/>:</td>
			<td class="Value"><xsl:value-of select="."/></td>
		</tr>
	</xsl:for-each>
</xsl:template>

<xsl:template match = "Message/ErrorRecord">
	<xsl:call-template name="ErrorTable">
		<xsl:with-param name="n" select="." />
	</xsl:call-template>
</xsl:template>

<xsl:template name="ErrorTable">
	<xsl:param name="n" />
	<xsl:for-each select="$n">
		<table class="ErrorDetailTable">
			<tr>
				<th class="Property">&#32;</th>
				<th class="Value">&#32;</th>
			</tr>

			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="position() mod 2 = 0">
						<tr class="tr-even">
							<xsl:call-template name="ErrorCells"/>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr class="tr-odd">
							<xsl:call-template name="ErrorCells"/>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<tr><td colspan="2">&#32;</td></tr>
		</table>
	</xsl:for-each>
</xsl:template>

<xsl:template name="ErrorCells">
	<td class="Property"><xsl:value-of select ="local-name(.)"/></td>
	<td class="Value">
		<xsl:choose>
			<xsl:when test="count(./*) &gt; 0">
				<xsl:call-template name="ErrorTable">
					<xsl:with-param name="n" select="." />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="replace_sab">
					<xsl:with-param name="s" select="." />
					<xsl:with-param name="a" select="'&#xA;'" />
					<xsl:with-param name="b"><br /></xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</td>
</xsl:template>

<xsl:template match = "Message/Objects">
	<xsl:for-each select=".">
		<table class="ObjectTable">
			<tr>
				<xsl:for-each select="Object[1]/*">
					<th><xsl:value-of select ="@Name"/></th>
				</xsl:for-each>
			</tr>

			<xsl:for-each select="Object">
				<xsl:choose>
					<xsl:when test="position() mod 2 = 0">
						<tr class="tr-even">
							<xsl:call-template name="ObjectRow"/>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr class="tr-odd">
							<xsl:call-template name="ObjectRow"/>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</table>
	</xsl:for-each>
</xsl:template>

<xsl:template name="ObjectRow">
	<xsl:for-each select="*">
		<td><xsl:value-of select="."/></td>
	</xsl:for-each>
</xsl:template>

<xsl:template match = "Message/Records/Table">
	<xsl:for-each select=".">
		<table class="RecordSetTable">
			<tr>
				<xsl:for-each select="Row[1]/*">
					<th><xsl:value-of select ="local-name(.)"/></th>
				</xsl:for-each>
			</tr>

			<xsl:for-each select="Row">
				<xsl:choose>
					<xsl:when test="position() mod 2 = 0">
						<tr class="tr-even">
							<xsl:call-template name="TableRow"/>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr class="tr-odd">
							<xsl:call-template name="TableRow"/>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</table>
	</xsl:for-each>
</xsl:template>

<xsl:template name="TableRow">
	<xsl:for-each select="*">
		<td><xsl:value-of select="."/></td>
	</xsl:for-each>
</xsl:template>

<xsl:template name="replace_sab">
	<!-- with string s, replace substring a by string b -->
	<!-- s, a and b are parameters determined upon calling  -->
	<xsl:param name="s" />
	<xsl:param name="a" />
	<xsl:param name="b" />
	<xsl:choose>
		<xsl:when test="contains($s,$a)">
			<xsl:value-of select="substring-before($s,$a)" />
			<xsl:copy-of select="$b" />
			<xsl:call-template name="replace_sab">
				<xsl:with-param name="s" select="substring-after($s,$a)" />
				<xsl:with-param name="a" select="$a" />
				<xsl:with-param name="b" select="$b" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$s" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="nbsp" >
	&#160;
<!--	@nbsp;	-->
</xsl:template>

</xsl:stylesheet>
