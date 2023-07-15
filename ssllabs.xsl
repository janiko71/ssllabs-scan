<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>

<!-- format-date(function name) (inpvalue, 'MMM dd, yyyy')-->

  <!-- Template principal -->
  <xsl:template match="/">
    <html>
      <head>
        <title>Rapport SSL</title>
        <link href="./ssllabs.css" rel="stylesheet" type="text/css" />
        <!-- If you want your own Google Font...-->
        <link href='http://fonts.googleapis.com/css?family=PT+Sans:400,400italic,700,700italic' rel='stylesheet' type='text/css' />
      </head>
      <body>
        <h1>Rapport SSL</h1>
        <table class="full_table">
          <xsl:apply-templates select="LabsReport/*" />
        </table>
      </body>
    </html>
  </xsl:template>
  
  <!---
              ENDPOINTS
  -->  

  <!-- Template pour les Endpoints -->
  <xsl:template match="Endpoints">
    <table>
      <xsl:apply-templates />
    </table>
  </xsl:template>

  <!--Template pour les Endpoints (détails) -->
  <xsl:template match="Endpoints/Details/Suites/List/*">
    <tr>
      <th></th>
      <td></td>
      <td></td>
      <td></td>
      <td class="endpoint_header_level5">(b6s)<xsl:value-of select="name()" /></td>
      <td class="endpoint_content_level5" colspan="2">(b7s)<xsl:apply-templates /></td>
    </tr>
  </xsl:template> 

  <!--Template pour les Endpoints (détails) -->
  <xsl:template match="Endpoints/Details/Suites/*|Endpoints/Details/NamedGroups/*|Endpoints/Details/Protocols/*|Endpoints/Details/CertChains/*|Endpoints/Details/NoSniSuites/*|Endpoints/Details/Sims/*">
    <tr>
      <th></th>
      <td></td>
      <td>(b8n)</td>
      <td class="endpoint_header_level4">(b8s)<xsl:value-of select="name()" /></td>
      <td class="endpoint_content_level4" colspan="3">(b9s)<xsl:apply-templates /></td>
    </tr>
  </xsl:template> 

  <!--Template pour les Endpoints (détails) -->
  <xsl:template match="Endpoints/Details/HstsPolicy/*|Endpoints/Details/HstsPreloads/*|Endpoints/Details/HpkpPolicy/*|Endpoints/Details/HpkpRoPolicy/*|Endpoints/Details/HttpTransactions/*">
    <tr>
      <th></th>
      <td></td>
      <td>(b8n)</td>
      <td class="endpoint_header_level4">(b8s)<xsl:value-of select="name()" /></td>
      <td class="endpoint_content_level4" colspan="3">(b9s)<xsl:apply-templates /></td>
    </tr>
  </xsl:template> 

  <!--Template pour les Endpoints (détails) -->
  <xsl:template match="Endpoints/Details/*">
    <tr>
      <th></th>
      <td></td>
      <td class="endpoint_header_level3">(b6)<xsl:value-of select="name()" /></td>
      <td class="endpoint_content_level3" colspan="4">(b7)<xsl:apply-templates /></td>
    </tr>
  </xsl:template>  

  <!--Template pour les Endpoints (détails) -->
  <xsl:template match="Endpoints/*">
    <tr>
      <th></th>
      <td class="endpoint_header_level2">(b4)<xsl:value-of select="name()" /></td>
      <td class="endpoint_content_level2" colspan="4">(b5)<xsl:apply-templates /></td>
    </tr>
  </xsl:template>  
 

  <!---
              CERTS
  -->  

  <!-- Template pour les Certs -->
  <xsl:template match="Certs">
    <table>
      <xsl:apply-templates />
    </table>
  </xsl:template>

  <!--Template pour les Certs (détails) -->
  <xsl:template match="Certs/*">
    <tr>
      <th></th>
      <td class="endpoint_header_level2">(b10)<xsl:value-of select="name()" /></td>
      <td class="endpoint_content_level2" colspan="4">(b11)<xsl:value-of select="." /></td>
    </tr>
  </xsl:template>



  <!-- Template pour les champs -->
  <xsl:template match="LabsReport/*">
    <xsl:choose>
      <xsl:when test="not(normalize-space(.))">
        <!-- Empty value, not displayed -->
        <tr>
          <th>(b1)<xsl:value-of select="name()" /></th>
          <td><i>vide</i></td>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <th>(b2)<xsl:value-of select="name()" /></th>
          <td class="level1" colspan="5">(b3)<xsl:apply-templates /></td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
