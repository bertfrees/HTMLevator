<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                version="3.0"
                xpath-default-namespace="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all">
   <xsl:output method="xml" omit-xml-declaration="yes"/>
   <xsl:mode on-no-match="shallow-copy"/>
  
  
  
  <xsl:template match="p[matches(@class,'(H|h)ead(er|ing)?\s*1')][matches(.,'\S')]">
      <h1>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </h1>
   </xsl:template>
  <xsl:template match="p[matches(@class,'(H|h)ead(er|ing)?\s*2')][matches(.,'\S')]">
      <h2>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </h2>
   </xsl:template>
  <xsl:template match="p[matches(@class,'(H|h)ead(er|ing)?\s*3')][matches(.,'\S')]">
      <h3>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </h3>
   </xsl:template>
  <xsl:template match="p[matches(@class,'(H|h)ead(er|ing)?\s*4')][matches(.,'\S')]">
      <h4>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </h4>
   </xsl:template>
  <xsl:template match="p[matches(@class,'(H|h)ead(er|ing)?\s*5')][matches(.,'\S')]">
      <h5>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </h5>
   </xsl:template>
  <xsl:template match="p[matches(@class,'(H|h)ead(er|ing)?\s*6')][matches(.,'\S')]">
      <h6>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </h6>
   </xsl:template>
  
  
  <xsl:template match="p[matches(@class,'[Ss]ubtitle')][matches(.,'\S')]">
      <h2>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </h2>
   </xsl:template>
  
  
  <xsl:template match="p[matches(.,'^Introduction\s*$')]">
      <h2>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </h2>
   </xsl:template>
</xsl:stylesheet>
