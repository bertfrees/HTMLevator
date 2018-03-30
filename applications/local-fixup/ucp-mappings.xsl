<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsw="http://coko.foundation/xsweet"
  xpath-default-namespace="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="#all">
  
  <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  
<!-- XSweet: Some small adjustments to tagging as required by a local process. -->
<!-- Input: HTML Typescript -->
<!-- Output: A copy, with modifications. -->
  
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xsl:template match="b | u">
    <i>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </i>
  </xsl:template>
   
</xsl:stylesheet>