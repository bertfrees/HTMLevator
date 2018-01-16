<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsw="http://coko.foundation/xsweet"
  exclude-result-prefixes="#all">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<!-- Use this XQuery to get a list of stylesheets called by an XProc pipeline:

declare namespace p='http://www.w3.org/ns/xproc';
declare namespace xsw ="http://coko.foundation/xsweet";

<xsw:variable name="transformation-sequence">
{ //p:input[@port='stylesheet']/*/@href/
  <xsw:transform>{string(.)}</xsw:transform> 

}</xsw:variable>

  -->
 
 
<!-- XSLT promotes headers in an HTML Typescript file produced by XSweet -->
<!-- The logic it uses to do this is determined dynamically, or provided by the user. -->

<!-- $method can be provided at runtime
     recognized values:
  method='outline-level' infers based on outline level numbering in the Word data
  method='ranked-format'   tries to assign header levels based on paragraph-level properties (format)
  or: anyURI will point to anyURI as the source for a mapping specification
    e.g. method="styles-mapping.xml" will use 'styles-mapping.xml' as the mapping file.
  
  
  
  -->
 
 <xsl:variable name="outlined" select="count(p[matches(@style, 'xsweet-outline-level')]) gt 1"/>
  
<!-- $override $method at runtime. Values:
     *.xml is treated as regex mapping document to follow
     or 'outline-level' if by outline level
     or 'ranked-format' if by ranking property sets on paragraphs
     if two outline levels are found, outline level is used otherwise property sets are used
     Specify method='ranked-format' to be sure it is used -->
 <xsl:param name="method" as="xs:string">default</xsl:param>
 
 <!-- $mapping-spec provides the name of an XML document found at location on $method e.g. method='my-mapping.xml' -->
 <!-- if there is no such document it is empty -->
 <xsl:variable name="mapping-spec" as="xs:string?"
   select="$method[matches(.,'\.xml$')] ! ( if (doc-available(.)) then (.) else () )"/>

  <xsl:variable name="transformation-sequence">
    <xsl:choose>
      <xsl:when test="exists($mapping-spec)">
        <!-- if a mapping spec exists, we produce a tranformation from it ...      -->
        <xsw:transform>
          <!-- The sequence child produces a stylesheet, which is applied -->
          <xsw:produce-xslt>
            <xsw:document>
              <xsl:value-of select="$mapping-spec"/>
            </xsw:document>
            <xsw:transform>make-header-mapper-xslt.xsl</xsw:transform>
          </xsw:produce-xslt>
        </xsw:transform>
        <xsw:annotate xsl:expand-text="true"> element mapping applied: { $mapping-spec } </xsw:annotate>
      </xsl:when>
      <xsl:when test="$method = 'outline-level'">
        <xsw:transform>outline-headers.xsl</xsw:transform>
        <xsw:annotate> header promotion by outline levels (as called) </xsw:annotate>
      </xsl:when>
      <xsl:when test="$method = 'ranked-format'">
        <xsw:transform>
          <xsw:produce-xslt>
            <xsw:transform>digest-paragraphs.xsl</xsw:transform>
            <xsw:transform>make-header-escalator-xslt.xsl</xsw:transform>
          </xsw:produce-xslt>
        </xsw:transform>
        <xsw:annotate> header promotion by ranking paragraph formatting (as called) </xsw:annotate>
      </xsl:when>
      <xsl:when test="$outlined">
        <xsw:transform>outline-headers.xsl</xsw:transform>
        <xsw:annotate> header promotion by outline levels (by default) </xsw:annotate>
      </xsl:when>
      <xsl:otherwise>
        <!-- value is either 'default' or something else not recognized or a file name -->
        <xsw:transform>
          <xsw:produce-xslt>
            <xsw:transform>digest-paragraphs.xsl</xsw:transform>
            <xsw:transform>make-header-escalator-xslt.xsl</xsw:transform>
          </xsw:produce-xslt>
        </xsw:transform>
        <xsw:annotate> header promotion by ranking paragraph formatting (fingers crossed) </xsw:annotate>
      </xsl:otherwise>
    </xsl:choose>
    <!--  <xsw:transform>collapse-paragraphs.xsl</xsw:transform>-->
  </xsl:variable> 
 
  <!-- Dummy template quiets anxious XSLT engines.  -->
  <xsl:template match="/html:html" xmlns:html="http://www.w3.org/1999/xhtml">
    <xsl:next-match/>
  </xsl:template>
  
  <!-- traps the root node of the source and passes it down the chain of transformation references -->
  <xsl:template match="/">
    <xsl:variable name="source" select="."/>
    <xsl:iterate select="$transformation-sequence/*">
      <xsl:param name="sourcedoc" select="$source" as="document-node()"/>
      <xsl:on-completion select="$sourcedoc"/>
      <xsl:next-iteration>
        <xsl:with-param name="sourcedoc">
          <xsl:apply-templates select=".">
            <xsl:with-param name="sourcedoc" select="$sourcedoc"/>
          </xsl:apply-templates>
        </xsl:with-param>
      </xsl:next-iteration>
    </xsl:iterate>
  </xsl:template>
  
  <xsl:template match="xsw:document">
    <xsl:sequence select="document(.)"/>
  </xsl:template>
    
  <!-- xsw:produce-xslt is a subpipeline with XSLT coming out the end ... -->
  <xsl:template match="xsw:produce-xslt">
    <xsl:param name="sourcedoc" as="document-node()"/>
    <xsl:iterate select="*">
      <xsl:param name="sourcedoc" select="$sourcedoc" as="document-node()"/>
      <xsl:on-completion select="$sourcedoc"/>
      <xsl:next-iteration>
        <xsl:with-param name="sourcedoc">
          <xsl:apply-templates select=".">
            <xsl:with-param name="sourcedoc" select="$sourcedoc"/>
          </xsl:apply-templates>
        </xsl:with-param>
      </xsl:next-iteration>
    </xsl:iterate>
  </xsl:template>
  
  <xsl:template match="xsw:transform[xsw:produce-xslt]">
    <xsl:param name="sourcedoc" as="document-node()"/>
    <xsl:variable name="xslt" as="document-node()">
       <xsl:apply-templates select="xsw:produce-xslt">
         <xsl:with-param name="sourcedoc" select="$sourcedoc"/>
       </xsl:apply-templates>
    </xsl:variable>
    
    <!-- don't just copy it, apply it -->
    <!--<xsl:copy-of select="$xslt"/>-->
    <xsl:variable name="runtime"   select="map {
      'xslt-version'        : if (empty(@version)) then 3.0 else xs:decimal(@version),
      'stylesheet-node'     : $xslt,
      'source-node'         : $sourcedoc }" />
    <!-- The function returns a map; primary results are under 'output'
         unless a base output URI is given
         https://www.w3.org/TR/xpath-functions-31/#func-transform -->
    <xsl:sequence select="transform($runtime)?output"/>
    
  </xsl:template>
  
  <xsl:template match="xsw:transform[exists(text()[matches(.,'\S')])]">
    <xsl:param    name="sourcedoc" as="document-node()"/>
    <xsl:variable name="xslt-spec" select="."/>
    <xsl:variable name="runtime"   select="map {
      'xslt-version'        : if (empty(@version)) then 3.0 else xs:decimal(@version),
      'stylesheet-location' : string($xslt-spec),
      'source-node'         : $sourcedoc }" />
    <!-- The function returns a map; primary results are under 'output'
         unless a base output URI is given
         https://www.w3.org/TR/xpath-functions-31/#func-transform -->
    <xsl:sequence select="transform($runtime)?output"/>
  </xsl:template>

  <!-- Not knowing any better, we simply pass along. -->
  <xsl:template match="*">
    <xsl:param    name="sourcedoc" as="document-node()"/>
    <xsl:sequence select="$sourcedoc"/>
  </xsl:template>
  
  <xsl:template match="xsw:annotate">
    <xsl:param    name="sourcedoc" as="document-node()"/>
    <xsl:processing-instruction expand-text="true" name="xsweet">{ . }</xsl:processing-instruction>
    <xsl:text>&#xA;</xsl:text>
    <xsl:sequence select="$sourcedoc"/>
  </xsl:template>
  
  <!-- Next up: an xsw:annotate element! -->
  
</xsl:stylesheet>