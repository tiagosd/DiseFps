<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:output method="text" media-type="text/csv" encoding="UTF-8"/>
	<xsl:param name="RowDelim">,</xsl:param>
	<xsl:param name="FieldDelim">,</xsl:param>
	<xsl:param name="StringDelim">"</xsl:param>
	<xsl:param name="DateFormat">yyyy-MM-dd HH:mm:ss</xsl:param>

	<xsl:template match="/">
		<xsl:for-each select="Rowsets">
			<xsl:call-template name="PrintFatalError"/>
			<xsl:for-each select="Rowset">
				[<xsl:variable name="CurrentColumns" select="Columns"/>
				<xsl:for-each select="Row">
					{<xsl:for-each select="*">
						<xsl:variable name="ColName">
							<xsl:value-of select="name(.)"/>
						</xsl:variable>
						<xsl:variable name="ColType">
							<xsl:value-of select="$CurrentColumns/Column[@Name=$ColName]/@SQLDataType"/>
						</xsl:variable>
					       <xsl:value-of select="$StringDelim"/>
					       	<xsl:value-of select="$ColName"/>
					       <xsl:value-of select="$StringDelim"/>: 
						<xsl:choose>
							<xsl:when test="$ColType= '2' or $ColType= '3' or $ColType= '4' or $ColType= '5' or $ColType= '6' or $ColType= '7' or $ColType= '8' or $ColType= '-7' or $ColType= '-5' or $ColType= '-6'">
								<xsl:value-of select="."/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$StringDelim"/>
								<xsl:choose>
									<xsl:when test="$ColType= '91' or $ColType= '92' or $ColType= '93'">
										<xsl:choose>
											<xsl:when test=". = 'TimeUnavailable'">
												<xsl:value-of select="."/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="java:com.sap.xmii.Illuminator.ext.ExtFunctions.dateFromXMLFormat(string(.),$DateFormat)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="$StringDelim"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="not(position() = last())">
							<xsl:value-of select="$FieldDelim"/>
						</xsl:if>
					</xsl:for-each>
				         <xsl:text>}</xsl:text>
					<xsl:if test="not(position() = last())">
						<xsl:value-of select="$RowDelim"/>
					</xsl:if>
				</xsl:for-each>]
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="PrintFatalError">
		<xsl:for-each select="FatalError">
			<xsl:text>Fatal Error - </xsl:text>
			<xsl:value-of select="."/>
			<xsl:value-of select="$RowDelim"/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
