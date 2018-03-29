

#### ucp-text-macros.xsl

XSLT stylesheet version 3.0 (15 templates)

XSweet: provides a "bridge filter" for final tuning of HTML contents; a generalized sub-editorial preprocessor supporting string replacement. [3]

Input: HTML

Output: A copy of the input, with text munging

Limitation: Doesn't discriminate between ws that is "safe to munge" (eg paragraph content) and "significant" ws (eg code blocks or ASCII art): this will treat all text indiscriminately.

#### hyperlink-inferencer.xsl

XSLT stylesheet version 3.0 (2 templates)

XSweet: picks up URI substrings and renders them as (HTML) anchors with (purported or matched) links

Input: HTML Typescript or relatively clean HTML or XML.

Output: A copy, except that URIs now appear as live links (`a` elements).

#### ucp-mappings.xsl

XSLT stylesheet version 3.0 (1 template)

XSweet: Some small adjustments to tagging as required by a local process.

Input: HTML Typescript

Output: A copy, with modifications.