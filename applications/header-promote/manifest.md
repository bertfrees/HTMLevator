

#### digest-paragraphs.xsl

XSLT stylesheet version 2.0 (11 templates)

XSweet: paragraph property analysis in support of header promotion: header promotion step 1 [1]

Input: an HTML typescript file

Output: an XML file showing the results of analysis, for input to `make-header-escalator.xsl`

#### header-promotion-CHOOSE.xsl

XSLT stylesheet version 3.0 (7 templates)

Declared dependency: `make-header-mapper-xslt.xsl`

Declared dependency: `outline-headers.xsl`

Declared dependency: `digest-paragraphs.xsl`

Declared dependency: `make-header-escalator-xslt.xsl`

Declared dependency: `outline-headers.xsl`

Declared dependency: `digest-paragraphs.xsl`

Declared dependency: `make-header-escalator-xslt.xsl`

#### make-header-escalator-xslt.xsl

XSLT stylesheet version 2.0 (2 templates)

#### make-header-mapper-xslt.xsl

XSLT stylesheet version 2.0 (4 templates)

#### outline-headers.xsl

XSLT stylesheet version 2.0 (2 templates)

#### html-header-promote.xpl

XProc pipeline version 1.0 (5 steps)

Runtime dependency: `digest-paragraphs.xsl`

Runtime dependency: `make-header-escalator-xslt.xsl`

#### config-mockup.xml

#### readme.md