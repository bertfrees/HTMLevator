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
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="div[@class='docx-body']">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
    <xsl:call-template name="section-assembly">
      <!-- FOR DEBUGGING WHEN WE ENTER, $who should be select="*" level="0"     -->
      <!--<xsl:with-param name="who" select="$grouped"/>-->
    </xsl:call-template>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="xsw:*">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="section-assembly">
    <!-- $who is a run of one or more contiguous siblings -->
    <!-- When we enter we operate on all child elements of the context.
         They should all be xsw:div as provided in the previous step. --> 
    <xsl:param name="who" select="child::*" as="element(xsw:div)*"/>
    <xsl:param name="level" select="0"/>
    <xsl:for-each-group select="$who" group-starting-with="xsw:div[@level=$level]">
      <xsl:choose>
        <!-- It's possible for a level to be skipped, creating no section -->
        <xsl:when test="@level > $level">
            <xsl:call-template name="section-assembly">
              <xsl:with-param name="who" select="$who"/>
              <xsl:with-param name="level" select="$level + 1"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <section>
            <xsl:apply-templates select="."/>
            <xsl:call-template name="section-assembly">
              <!-- Notice when $who becomes empty the template will fall through -->
              <xsl:with-param name="who" select="current-group() except ."/>
              <xsl:with-param name="level" select="$level + 1"/>
            </xsl:call-template>
          </section>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>