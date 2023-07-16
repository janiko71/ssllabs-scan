<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>

<!-- format-date(function name) (inpvalue, 'MMM dd, yyyy')-->

  <!-- Global template -->

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
      <xsl:apply-templates select="LabsReport/*" />

    </body>

  </html>

  </xsl:template> 


  <!-- Detailed template --> 

  <xsl:template match="LabsReport/*">
    <xsl:for-each select="LabsReport/*[.]">
      <table class="full_table">
        <xsl:if test="not(./*)">
          <!-- Singleton -->
          <tr>
            <th>(b0)<xsl:value-of select="name()" /></th>
            <td>(b1)<xsl:value-of select="." /></td>
          </tr>
        </xsl:if>
      </table>
    </xsl:for-each>
  </xsl:template>  
