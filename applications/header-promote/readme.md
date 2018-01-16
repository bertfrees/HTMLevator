# XSweet Header Promotion

Processing XML in the XHTML namespace, producing the same format.

XSweet supports three methods of header promotion. Additionally, XSweet provides a single XSLT that can be used to dispatch logic to any of the others, based on switches. The latter XSLT provides the default behavior.

Of the three methods supported, only one is a simple transformation; the others are meta-transformations (i.e. they work by executing dynamically generated XSLT). One works by producing an XSLT from a configuration file; the other reads the source file itself.

Due to these complications, it is recommended you save yourself trouble by running the too-level XSLT, which knows how to orchestrate the others to produce the correct outputs in each case, without serializing intermediate files.

## How to run the XSLT

The "master stylesheet: is `header-promotion-CHOOSE.xsl`. Using it plus a single runtime parameter setting, you can designate the header promotion strategy you prefer.

If you fail to designate one, that is also okay, the XSLT will "do its best".

The flag (runtime parameter) is called`method` with any of three values recognized:

 * `method=outline-level` indicates headers will be assigned based on assigned outline level

 * `method=ranked-format` indicates headers will be assigned based on a comparative analysis and ranking of paragraphs based on their formatting

 * `method=my-styles.xml` indicates headers will be mapped (assigned to paragraphs) on the basis of assigned styles and/or contents, matching with regular expressions. `my-styles.xml` is a configuration file you create for your own mappings, which recognizes the styles you designate. Either named styles in Word (which result in `@class` in HTML produced by XSweet), or contents (such as a paragraph whose only contents is "Introduction"), may be matched.

If you fail to indicate any of these values, the method falls back to "rank format" unless there are outline levels assigned to multiple paragraphs (i.e. more than one) in the document. In other words, the rule is to use "outline level" if there is a reason to think it will work, otherwise "rank format".

## Details

Depending on the value of the switch at runtime, an input document will be processed according to one of the following approaches. Note that any of them may also be achieved by running its XSLT (or sequence) standalone, i.e. without the orchestration stylesheet (`header-promotion-CHOOSE.xsl`).

### `method=outline-level`

The input document should be processed with the XSLT `outline-headers.xsl`; the resulting document is a copy with headers promoted.

### `method=ranked-format`

The input document should be processed with the XSLT `digest-paragraphs.xsl`. The results of this stylesheet should be transformed using `make-header-escalator.xsl`. The resulting XSLT should be applied to the original input document whose result is a copy, with headers promoted.

### `method=my-styles.xml`

The file `my-styles.xml` (or other XML document so designated) should be processed with the XSLT `make-header-mapper.xsl`; the resulting XSLT transformation should be applied to the source document, producing a copy of it with promoted headers.


## Supporting XSLT

| Transformation  | Function |
|--|--|
| `outline-headers.xsl` | Promotes paragraphs to headers based on outline level | 
| `digest-paragraphs.xsl` | Produces a ranked analysis of paragraphs by property, as input to `make-header-escalator.xsl` |
| `make-header-escalator-xslt.xsl` | Consumes the ranked inputs of `digest-paragraphs.xsl` to produce an XSLT for header promotion |
| `make-header-mapper-xslt.xsl` | Consumes a "regex-matching" XML specification document such as `config-mockup.xml` to produce an XSLT for header promotion |
| `config-mockup.xml` | Demonstration of configuration file showing mappings of style or contents into header element types. |

