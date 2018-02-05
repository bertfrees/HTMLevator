<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns="http://www.w3.org/1999/xhtml"
  xpath-default-namespace="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xs math"
  version="2.0">

  <!-- XSweet: Performs header promotion based on outline level [2] -->
  <!-- Input:  an HTML Typescript document (wf) -->
  <!-- Output: a copy, with headers promoted according to outline levels detected on paragraphs -->
  
  <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  
<!-- Produces header elements by matching on nominal outline level as given in an xsweet-outline-level CSS pseudo-property
     (treated here with brute force). -->
  
  <xsl:template match="p[matches(@style,'xsweet-outline-level')]">
    <xsl:variable name="outline-spec" select="replace(@style,'^.*xsweet\-outline\-level:\s*','')"/>
    <xsl:variable name="outline-level" select="replace($outline-spec,'\D.*$','')"/>
    <xsl:variable name="level" select="string(number($outline-level) + 1)"/>
    <xsl:element name="{ concat('h',$level) }" namespace="http://www.w3.org/1999/xhtml">
      <xsl:copy-of select="@*"/>
      <!--<xsl:comment expand-text="true">{ $level }</xsl:comment>-->
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>