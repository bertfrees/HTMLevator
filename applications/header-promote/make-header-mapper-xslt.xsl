<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsw="http://coko.foundation/xsweet"
  xmlns="http://www.w3.org/1999/xhtml"
  xpath-default-namespace="http://www.w3.org/1999/xhtml">

  <xsl:namespace-alias stylesheet-prefix="xsw" result-prefix="xsl"/>
  
  
  <xsl:output indent="yes"/>
  
  <xsl:mode on-no-match="shallow-copy"/>
  <xsl:template match="/">
    <xsl:apply-templates mode="xslt-map"/>
  </xsl:template>
  
  <xsl:template match="body | /*" mode="xslt-map">
    
    <!--       xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:xsw="http://coko.foundation/xsweet"
      xmlns="http://www.w3.org/1999/xhtml"

    -->
    <xsw:stylesheet version="3.0"
      xpath-default-namespace="http://www.w3.org/1999/xhtml"
      exclude-result-prefixes="#all">
      
      <xsw:output method="xml"  omit-xml-declaration="yes"/>
      
      <xsw:mode on-no-match="shallow-copy"/>
      
      <xsl:apply-templates mode="xslt-map"/>
      
    </xsw:stylesheet>
  </xsl:template>
  
  <xsl:template mode="xslt-map" priority="2" match="id('header-map')/*">
    <xsl:variable name="match-pattern" as="xs:string">
      <xsl:value-of expand-text="true">
      <xsl:text>p</xsl:text>
      <xsl:for-each select="@class[matches(.,'\S')]">[matches(@class,'{.}')]</xsl:for-each>
      <xsl:if test="matches(.,'\S')">[matches(.,'{.}')]</xsl:if>
      </xsl:value-of>
    </xsl:variable>
    <xsw:template match="{$match-pattern}">
      <xsl:element name="{ local-name() }" namespace="http://www.w3.org/1999/xhtml">
        <xsw:copy-of select="@*"/>
        <xsw:apply-templates/>
      </xsl:element>
    </xsw:template>
  </xsl:template>
  
  
</xsl:stylesheet>