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
  
  <xsl:template match="xsw:sequence">
    <!-- $zero is the zero-level group, when present.
         (Some sequences begin with elements before a header; these are grouped in xsw:group[@level=0]-->
    <xsl:variable name="zero" select="xsw:group[@level = 0]"/>

    <!-- We want the content of zero but w/o a section wrapper. -->
    <xsl:apply-templates select="$zero"/>
    <!-- We want section wrappers for anything remaining. -->
    <xsl:call-template name="section-assembly">
      <xsl:with-param name="who" select="xsw:group except $zero"/>
    </xsl:call-template>

  </xsl:template>
  
  <!-- Groups can be unwrapped since the induced section structure takes care of everything. -->
  <xsl:template match="xsw:group">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="section-assembly">
    <!-- $who is a run of one or more contiguous siblings.
         When $who is empty we fall through so recursion is safe as long as $who is reduced. -->
    <!-- When we enter we operate on all xsw:group child elements of the context except level 0.
         All children should be xsw:group as provided in the previous step. --> 
    <xsl:param name="who"   required="yes" as="element(xsw:group)*"/>
    <xsl:param name="level" select="1"     as="xs:integer"/>
    
    <xsl:for-each-group select="$who" group-starting-with="xsw:group[@level = $level]">
      <!-- Since we group-starting-with, we will have a single $me at most.
           Either this group belongs at this level - exists($me) -
           or it belongs deeper - empty($me) - which happens when levels are skipped
           (e.g. an h4 appears without an h3 giving us a group[@level=4] inside a group[@level=2].) -->
      <xsl:variable name="me" select="current-group()[@level = $level]"/>
      
      <!-- When $empty(me) the group is passed in again at the next deeper level,
           without making a section here. -->
      <xsl:call-template name="section-assembly">
        <xsl:with-param name="who" select="current-group()[empty($me)]"/>
        <xsl:with-param name="level" select="$level + 1"/>
      </xsl:call-template>

      <!-- $me exists when the group is on the right level. -->
      <xsl:if test="exists($me)">
        <section>
          <!-- Now we emit the contents of the group, unwrapped. -->
          <xsl:apply-templates select="$me"/>
          <!-- Next we subgroup the remaining groups within the section created for $me.-->
          <!-- Note the new $who is empty when $me is the only group left. -->
          <xsl:call-template name="section-assembly">
            <xsl:with-param name="who" select="current-group() except $me"/>
            <xsl:with-param name="level" select="$level + 1"/>
          </xsl:call-template>
        </section>
      </xsl:if>
    </xsl:for-each-group>
  </xsl:template>
  
</xsl:stylesheet>