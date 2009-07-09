<?xml version='1.0'?>
<!-- ==================================================================== -->
<!-- IT Mill Customizations to PDF formatting.                            -->
<!-- ==================================================================== -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:import href="../xsl/fo/docbook.xsl"/>

  <!-- For syntax color highlighting. -->
  <xsl:import href="../xsl/highlighting/common.xsl"/>
  <xsl:import href="../xsl/fo/highlight.xsl"/>

  <xsl:param name="manual.fonts.custom" select="false"/>

  <!-- Enable syntax color highlighting. -->
  <xsl:param name="highlight.source" select="1"/>

  <xsl:attribute-set name="monospace.verbatim.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 0.80"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>  
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.6"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.4"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.2"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level4.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="margin-left">1.7cm</xsl:attribute>
  </xsl:attribute-set>

  <!-- Turn off Part ToC. -->
  <xsl:template name="generate.part.toc">
  </xsl:template>

  <!-- Make some elements look bold. -->
  <xsl:template match="guibutton">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>
  <xsl:template match="guilabel">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>
  <xsl:template match="guimenu">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>
  <xsl:template match="guisubmenu">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>
  <xsl:template match="guimenuitem">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>
  <xsl:template match="classname">
    <xsl:call-template name="inline.boldseq"/>
  </xsl:template>

  <!-- Turn hyphenation off in monospace (parameter)-->
  <xsl:attribute-set name="monospace.properties">
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-style">normal</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="monospace.verbatim.properties">
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-style">normal</xsl:attribute>
  </xsl:attribute-set>

  <!-- Deeper indentation of lists. -->
  <xsl:attribute-set name="list.block.spacing">
    <xsl:attribute name="margin-left">1cm</xsl:attribute>
  </xsl:attribute-set>

  <!-- ==================================================================== -->
  <!-- Table of Contents                                                    -->
  <!-- ==================================================================== -->

  <!-- Have chapter titles in bold. (from autotoc.xsl)-->
  <xsl:template name="toc.line">
    <xsl:param name="toc-context" select="NOTANODE"/>
    
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    
    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:variable>
    
    <fo:block xsl:use-attribute-sets="toc.line.properties"
      end-indent="{$toc.indent.width}pt"
      last-line-end-indent="-{$toc.indent.width}pt">

      <!-- Vaadin customization: -->
      <xsl:choose>
        <xsl:when test="self::chapter or self::appendix">
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <xsl:attribute name="margin-top">2.5mm</xsl:attribute>
        </xsl:when>
      </xsl:choose>

      <xsl:if test="local-name($toc-context) = 'chapter'">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="margin-left">0cm</xsl:attribute>
        <xsl:attribute name="margin-right">2cm</xsl:attribute>
      </xsl:if>

      <fo:inline keep-with-next.within-line="always">
        <fo:basic-link internal-destination="{$id}">
          <xsl:if test="$label != ''">
            <xsl:copy-of select="$label"/>
            <xsl:value-of select="$autotoc.label.separator"/>
          </xsl:if>
          <xsl:apply-templates select="." mode="titleabbrev.markup"/>
        </fo:basic-link>
      </fo:inline>
      <fo:inline keep-together.within-line="always">
        <xsl:text> </xsl:text>
        <fo:leader leader-pattern="dots"
          leader-pattern-width="3pt"
          leader-alignment="reference-area"
          keep-with-next.within-line="always"/>
      <xsl:text> </xsl:text>
      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </fo:inline>
  </fo:block>
  </xsl:template>

  <!-- Only generate ToC of chapters/sections. -->
  <xsl:param name="generate.toc">
    appendix  nop
    article   toc,title
    book      toc,title
    chapter   toc
    part      nop
    preface   nop
    qandadiv  nop
    qandaset  nop
    reference toc,title
    section   nop
    set       toc
  </xsl:param>

  <!-- Only first level section titles in chapter ToC. From autotoc.xsl. -->  
  <xsl:template match="section" mode="toc">
    <xsl:param name="toc-context" select="."/>
    
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    
    <xsl:variable name="cid">
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$toc-context"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="depth" select="count(ancestor::section) + 1"/>
    <xsl:variable name="reldepth"
      select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

    <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

    <!-- xsl:message>
      <xsl:text>toc-context: </xsl:text>
      <xsl:value-of select="local-name($toc-context)"/>
    </xsl:message -->

    <xsl:variable name="toc.section.depth.vaadin">
      <xsl:choose>
        <xsl:when test="local-name($toc-context) = 'chapter'">1</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$toc.section.depth"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$toc.section.depth.vaadin &gt;= $depth">
      <xsl:call-template name="toc.line">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:call-template>
      
      <xsl:if test="$toc.section.depth > $depth and $toc.max.depth > $depth.from.context and section">
        <fo:block id="toc.{$cid}.{$id}">
          <xsl:attribute name="margin-left">
            <xsl:call-template name="set.toc.indent">
              <xsl:with-param name="reldepth" select="$reldepth"/>
            </xsl:call-template>
          </xsl:attribute>
          
          <xsl:apply-templates select="section" mode="toc">
            <xsl:with-param name="toc-context" select="$toc-context"/>
          </xsl:apply-templates>
        </fo:block>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Fonts.                                                               -->
  <!-- ==================================================================== -->

  <xsl:param name="body.font.family">
    <xsl:choose>
      <xsl:when test="$manual.fonts.custom">Helvetica</xsl:when>
      <xsl:otherwise>Times</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <!-- ==================================================================== -->
  <!-- Custom chapter title.                                                -->
  <!-- ==================================================================== -->

  <xsl:template match="title" mode="chapter.titlepage.recto.auto.mode">  
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" 
      xsl:use-attribute-sets="chapter.titlepage.recto.style" 
      margin-left="{$title.margin.left}" 
      font-size="32.0pt" 
      font-weight="bold" 
      font-family="{$title.font.family}">
      <xsl:call-template name="vaadinchapter.title">
        <xsl:with-param name="node" select="ancestor-or-self::chapter[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <!-- Use the same style for the appendices. -->
  <xsl:template match="title" mode="appendix.titlepage.recto.auto.mode">  
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" 
      xsl:use-attribute-sets="chapter.titlepage.recto.style" 
      margin-left="{$title.margin.left}" 
      font-size="32.0pt" 
      font-weight="bold" 
      font-family="{$title.font.family}">
      <xsl:call-template name="vaadinchapter.title">
        <xsl:with-param name="node" select="ancestor-or-self::appendix[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template name="vaadinchapter.title">
    <xsl:param name="node" select="."/>
    <xsl:variable name="id">
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$node"/>
      </xsl:call-template>
    </xsl:variable>
    
    <fo:block id="{$id}"
      xsl:use-attribute-sets="chap.label.properties">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">
          <xsl:choose>
            <xsl:when test="$node/self::chapter">chapter</xsl:when>
            <xsl:when test="$node/self::appendix">appendix</xsl:when>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$node" mode="label.markup"/>
    </fo:block>
    <fo:block xsl:use-attribute-sets="chap.title.properties">
      <xsl:apply-templates select="$node" mode="title.markup"/>
    </fo:block>
  </xsl:template>

  <!-- The formatting properties for the chapter label. -->
  <xsl:attribute-set name="chap.label.properties">
    <xsl:attribute name="font-size">36pt</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="space-before.minimum">4cm</xsl:attribute>
    <xsl:attribute name="space-before.optimum">6cm</xsl:attribute>
    <xsl:attribute name="space-before.maximum">8cm</xsl:attribute>
  </xsl:attribute-set>

  <!-- The formatting properties for the chapter title. -->
  <xsl:attribute-set name="chap.title.properties">
    <xsl:attribute name="font-size">48pt</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="space-before.minimum">2cm</xsl:attribute>
    <xsl:attribute name="space-before.optimum">4cm</xsl:attribute>
    <xsl:attribute name="space-before.maximum">6cm</xsl:attribute>
    <xsl:attribute name="space-after.minimum">2cm</xsl:attribute>
    <xsl:attribute name="space-after.optimum">3cm</xsl:attribute>
    <xsl:attribute name="space-after.maximum">4cm</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
  </xsl:attribute-set>

  <!-- ==================================================================== -->
  <!-- Admonitions (warnings, notes, etc.)                                  -->
  <!-- ==================================================================== -->

  <!-- Admonition graphics (warning and note boxes). -->
  <xsl:param name="admon.graphics">1</xsl:param>
  <xsl:param name="admon.graphics.path">manual/img/icons/</xsl:param>

  <!-- Admonition (warning/note) box. -->
  <xsl:attribute-set name="graphical.admonition.properties">
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">1pt</xsl:attribute>
    <xsl:attribute name="border-color">grey</xsl:attribute>
    <xsl:attribute name="padding">2pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- Admonition (warning/note) title. -->
  <xsl:attribute-set name="admonition.title.properties">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- ==================================================================== -->
  <!-- Custom headers.                                                      -->
  <!-- ==================================================================== -->

  <!-- Custom header data element. Not processed - skip. -->
  <xsl:template match="headerdata">
  </xsl:template>

  <!-- Custom header logo element. -->
  <xsl:template match="headerlogo">
    <xsl:apply-templates select="imagedata"/>
  </xsl:template>

  <xsl:template name="header.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>
    
    <fo:block>
      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>
        <xsl:when test="$sequence = 'blank'">
          <!-- nothing -->
        </xsl:when>
        
        <xsl:when test="$sequence='even' and $position='left'">
          <xsl:apply-templates select="/book/headerdata/headerlogo"/>
        </xsl:when>
        
        <xsl:when test="$sequence='odd' and $position='left'">
          <!-- nothing -->
        </xsl:when>
        
        <xsl:when test="($sequence='odd' or $sequence='even') and $position='center'">
          <xsl:if test="$pageclass != 'titlepage'">
            <xsl:choose>
              <xsl:when test="ancestor::book and ($double.sided != 0)">
                <fo:block>
                  <!-- Have an empty line above the section header because of the logo. -->
                  <xsl:apply-templates select="." mode="titleabbrev.markup"/>
                </fo:block>
                <fo:block>
                  <fo:retrieve-marker retrieve-class-name="section.head.marker"
                    retrieve-position="first-including-carryover"
                    retrieve-boundary="page-sequence"/>
                </fo:block>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="." mode="titleabbrev.markup"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:when>
        
        <xsl:when test="$position='center'">
          <!-- nothing for empty and blank sequences -->
        </xsl:when>
        
        <xsl:when test="$sequence='odd' and $position='right'">
          <xsl:apply-templates select="/book/headerdata/headerlogo"/>
        </xsl:when>
      
        <xsl:when test="$sequence='even' and $position='right'">
          <!-- nothing -->
        </xsl:when>
        
        <xsl:when test="$sequence = 'first'">
          <!-- nothing for first pages -->
        </xsl:when>
        
        <xsl:when test="$sequence = 'blank'">
          <!-- nothing for blank pages -->
        </xsl:when>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Custom footers.                                                      -->
  <!-- ==================================================================== -->
<xsl:template name="footer.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

  <fo:block>
    <!-- pageclass can be front, body, back -->
    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->
    <xsl:choose>
      <xsl:when test="$pageclass = 'titlepage'">
        <!-- nop; no footer on title pages -->
      </xsl:when>

      <xsl:when test="$double.sided != 0 and $sequence = 'even' and $position='left'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first') and $position='left'">
      </xsl:when>

      <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first') and $position='right'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$double.sided != 0 and ($sequence = 'even') and $position='right'">
      </xsl:when>

      <xsl:when test="$double.sided != 0 and $position='center'">
        <!-- Custom footer: -->
        <xsl:value-of select="/book/info/title"/>
        <!-- <xsl:text>Vaadin Reference Manual</xsl:text>  -->
      </xsl:when>

      <xsl:when test="$double.sided = 0 and $position='center'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$sequence='blank'">
        <xsl:choose>
          <xsl:when test="$double.sided != 0 and $position = 'left'">
            <fo:page-number/>
          </xsl:when>
          <xsl:when test="$double.sided = 0 and $position = 'center'">
            <fo:page-number/>
          </xsl:when>
          <xsl:otherwise>
            <!-- nop -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>


      <xsl:otherwise>
        <!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

    
  <!-- ==================================================================== -->
  <!-- Custom title page.                                                   -->
  <!-- ==================================================================== -->

  <xsl:include href="custom-fo-titlepage.xsl"/>

  <!-- Get the publication date from the command-line arguments. -->
  <xsl:param name="manual.pubdate">xxxx-xx-xx</xsl:param>
  <xsl:template match="pubdate" mode="titlepage.mode">
    <fo:block>
      <xsl:text>Published: </xsl:text> 
      <xsl:value-of select="$manual.pubdate"/>
    </fo:block>
  </xsl:template>

  <!-- Get the version number from the command-line arguments. -->
  <xsl:param name="manual.version">x.x.x</xsl:param>
  <xsl:template match="releasenumber">
    <xsl:value-of select="$manual.version"/>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Custom floating figure to replace broken informalfigure.             -->
  <!-- ==================================================================== -->

  <!-- This is copied as is from 'figure' template. -->
  <xsl:template match="informalfigure">
    <xsl:variable name="param.placement"
      select="substring-after(normalize-space($formal.title.placement),
              concat(local-name(.), ' '))"/>

    <xsl:variable name="placement">
      <xsl:choose>
        <xsl:when test="contains($param.placement, ' ')">
          <xsl:value-of select="substring-before($param.placement, ' ')"/>
        </xsl:when>
        <xsl:when test="$param.placement = ''">before</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$param.placement"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="figure">
      <xsl:choose>
        <xsl:when test="@pgwide = '1'">
          <fo:block xsl:use-attribute-sets="pgwide.properties">
            <xsl:call-template name="formal.object">
              <xsl:with-param name="placement" select="$placement"/>
            </xsl:call-template>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="formal.object">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="floatstyle">
      <xsl:call-template name="floatstyle"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$floatstyle != ''">
        <xsl:call-template name="floater">
          <xsl:with-param name="position" select="$floatstyle"/>
          <xsl:with-param name="content" select="$figure"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$figure"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Other.                                                               -->
  <!-- ==================================================================== -->

  <!-- Line spacing suitable for proofreading. -->
  <!-- xsl:param name="line-height" select="'2em'"/ -->

</xsl:stylesheet>
