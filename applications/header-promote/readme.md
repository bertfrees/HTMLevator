# XSweet Header Promotion

XSweet supports three methods of header promotion. Additionally, XSweet provides a single XSLT that can be used to dispatch logic to any of the others, based on switches. The latter XSLT provides the default behavior.

Of the three methods supported, only one is a simple transformation; the others are meta-transformations (i.e. they work by executing dynamically generated XSLT). One works by producing an XSLT from a configuration file; the other reads the source file itself.

XSLT -

header-induction.xsl

accepts runtime parameter `method` as in

`method='

Text
