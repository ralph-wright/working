<?xml version="1.0" encoding="UTF-8"?>
<!-- This stylesheet will write a YAML with just the control number and title.
     It's ideal for parsing by the rake file -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://scap.nist.gov/schema/sp800-53/2.0"
    xmlns:controls="http://scap.nist.gov/schema/sp800-53/feed/2.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://scap.nist.gov/schema/sp800-53/feed/2.0 http://scap.nist.gov/schema/sp800-53/feed/2.0/sp800-53-feed_2.0.xsd"
    version="2.0">
    <xsl:output method="text" omit-xml-declaration="yes" />
    
    <xsl:template match="c:statement">
        <xsl:value-of select="c:number"/>:<xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates select="c:statement"/>
    </xsl:template>
    
    <xsl:template name="control-info">
        <xsl:text>&#xa;</xsl:text>
        <xsl:value-of select="c:number"/>:<xsl:text>&#xa;</xsl:text>
        <xsl:text>  TITLE: </xsl:text>
        <xsl:value-of select="c:title"/>
    </xsl:template>
    
    <xsl:template match="/controls:controls">
        <xsl:text>---</xsl:text>
        <xsl:for-each select="controls:control">
            <!-- Controls -->
            <xsl:call-template name="control-info"/>
            <xsl:text>&#xa;</xsl:text>
            <!-- Statements -->
            <xsl:apply-templates select="c:statement/c:statement"/>
            <!-- Control Enhancements -->
            <xsl:for-each select="c:control-enhancements/c:control-enhancement">
                <xsl:call-template name="control-info"/>
                <xsl:text>&#xa;</xsl:text>
                <xsl:apply-templates select="c:statement/c:statement"/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
