<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>

  <!-- Import du fichier de traductions -->
  <xsl:import href="translations.xml"/>

  <!-- Langue par défaut -->
  <xsl:param name="lang" select="'fr'" />

  <!-- Template principal -->
  <xsl:template match="/">
    <html>
      <head>
        <title>Rapport de laboratoire</title>
      </head>
      <body>
        <h1>Rapport de laboratoire</h1>
        <table>
          <xsl:apply-templates select="LabsReport//*" />
        </table>
      </body>
    </html>
  </xsl:template>

  <!-- Template pour les champs -->
  <xsl:template match="*">
    <xsl:variable name="fieldName" select="name()"/>
    <tr>
      <th><xsl:value-of select="document('translations.xml')/translations/translation[@lang=$lang and @field=$fieldName]" /></th>
      <td><xsl:value-of select="." /></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
