<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsw="http://coko.foundation/xsweet"
  xmlns="http://www.w3.org/1999/xhtml"
  xpath-default-namespace="http://www.w3.org/1999/xhtml"
  
  exclude-result-prefixes="#all">

  <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="div[@class='docx-body']">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="sequence-by-headers"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Same. Note we do not match sections that have (a) one header at most, and (b) it is first (not preceded).
       These are considered already well-structured, and are passed through. -->
  <xsl:template match="section[exists((h1|h2|h3|h4|h5|h6)[1]/preceding-sibling::* | (h1|h2|h3|h4|h5|h6)[2])]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="sequence-by-headers"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="sequence-by-headers">
    <xsw:sequence>
      <xsl:for-each-group select="*" group-starting-with="h1 | h2 | h3 | h4 | h5 | h6">
        <!-- Remember . is current-group()[1], so $leader is the header (when found) -->
        <xsl:variable name="leader"
          select="self::h1 | self::h2 | self::h3 | self::h4 | self::h5 | self::h6"/>
        <!-- group/@level is X for hX, 0 if there is no leader.  -->
        <xsw:group level="{($leader/replace(local-name(),'\D',''),0)[1]}">
          <xsl:apply-templates select="current-group()"/>
        </xsw:group>
      </xsl:for-each-group>
    </xsw:sequence>
  </xsl:template>
  
</xsl:stylesheet>