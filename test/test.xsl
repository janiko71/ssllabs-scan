<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>

  <!-- Déclaration des traductions -->
  <xsl:param name="lang" select="'fr'" /> 
  <!-- Langue par défaut -->
  <xsl:param name="labels">
    <translations>
      <translation lang="fr" field="Host">Hôte</translation>
      <translation lang="fr" field="Port">Port</translation>
      <translation lang="fr" field="Protocol">Protocole</translation>
      <translation lang="fr" field="IsPublic">Public</translation>
      <!-- Ajoutez d'autres traductions ici -->
    </translations>
  </xsl:param>

  <!-- Template principal -->
  <xsl:template match="/">
    <html>
      <head>
        <title>Rapport de laboratoire</title>
        <link href="./ssllabs.css" rel="stylesheet" type="text/css" />
        <!-- If you want your own Google Font...-->
        <link href='http://fonts.googleapis.com/css?family=PT+Sans:400,400italic,700,700italic' rel='stylesheet' type='text/css' />
      </head>
      <body>
        <h1>Rapport de laboratoire</h1>
        <xsl:apply-templates select="LabsReport/*" />
      </body>
    </html>
  </xsl:template>
  
  <!---
              DETAILS
  -->

  <!-- Template pour Details -->
  <xsl:template match="Details">
    <h3>Details</h3>    
    <xsl:apply-templates />
  </xsl:template>  

  <!--Template pour les Details (détails) -->
  <xsl:template match="Details/@*">
    <tr>
      <th><xsl:value-of select="name()" /></th>
      <td><xsl:value-of select="." /></td>
    </tr>
  </xsl:template>

  <xsl:template match="Details[*]"/>  
  
  <!---
              ENDPOINTS
  -->  

  <!-- Template pour les Endpoints -->
  <xsl:template match="Endpoints">
    <h2>Endpoints</h2>    
    <xsl:apply-templates />
  </xsl:template>

  <!--Template pour les Endpoints (détails) -->
  <xsl:template match="Endpoints/@*">
    <tr>
      <th><xsl:value-of select="name()" /></th>
      <td><xsl:value-of select="." /></td>
    </tr>
  </xsl:template>
  
  <!-- Template pour Suites/List -->
  <xsl:template match="Sims/Results/Client">
    <p>Sims/Results/Client <xsl:value-of select="." /></p>    
    <xsl:apply-templates />
  </xsl:template>

  <!-- Template pour les listes Suites/Sims -->
  <xsl:template match="Suites/List|Sims/Results">
    <h5><xsl:value-of select="name()" /></h5>    
    <table>
      <xsl:apply-templates />
    </table>
  </xsl:template>      

  <!-- Template pour les listes Suites/Sims (détails) -->
  <xsl:template match="Suites/List/*|Sims/Results/*">
    <tr>
      <th><xsl:value-of select="name()" /></th>
      <td><xsl:value-of select="." /></td>
    </tr>
  </xsl:template>

  <!-- Template pour Suites -->
  <xsl:template match="Suites|Protocols|NamedGroups|CertChains|NoSniSuites|Sims|HstsPolicy|HstsPreloads|HpkpPolicy|HpkpRoPolicy|HttpTransactions">
    <h4><xsl:value-of select="name()" /></h4>    
    <table>
      <xsl:apply-templates />
    </table>  
  </xsl:template> 

  <!-- Template pour les Suites (détails) -->
  <xsl:template match="Suites/*|Protocols/*|NamedGroups/*|CertChains/*|NoSniSuites/*|HstsPolicy/*|HstsPreloads/*|HpkpPolicy/*|HpkpRoPolicy/*|HttpTransactions/*">
    <tr>
      <th><xsl:value-of select="name()" /></th>
      <td><xsl:value-of select="." /></td>
    </tr>
  </xsl:template>

  <!---
              CERTS
  -->

  <!-- Template pour les Certs -->
  <xsl:template match="Certs">
    <h2>Certs</h2>    
    <table>
      <xsl:apply-templates />
    </table>
  </xsl:template>

  <!-- Template pour les Certs (détails) -->
  <xsl:template match="Certs/*">
    <tr>
      <th><xsl:value-of select="name()" /></th>
      <td><xsl:value-of select="." /></td>
    </tr>
    <!--xsl:apply-templates /-->
  </xsl:template>

  <!---
              OTHER
  -->

  <!-- Template pour les champs -->
  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="not(normalize-space(.))">
        <!-- Empty value, not displayed -->
        <p><b><xsl:value-of select="name()" /></b><xsl:text> : </xsl:text><i>vide</i></p>
      </xsl:when>
      <xsl:otherwise>
        <p><b><xsl:value-of select="name()" /></b><xsl:text> : </xsl:text><xsl:value-of select="." /></p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>















  <!---
              ENDPOINTS
  -->  

  <!-- Template pour les Endpoints -->
  <xsl:template match="Endpoints">
    <table>
      <xsl:apply-templates select="Endpoints/*" />
    </table>
  </xsl:template>

  <!--Template pour les Endpoints (détails) -->
  <xsl:template match="Endpoints/*">
    <tr>
      <th><xsl:value-of select="name()" /></th>
      <td></td>
    </tr>
  </xsl:template>
  

  <!---
              DETAILS
  -->

  <!-- Template pour Details -->
  <xsl:template match="Details">
    <h3>Details</h3>    
    <table>
      <xsl:apply-templates />
    </table>
  </xsl:template>  

  <!--Template pour les Details (détails) -->
  <xsl:template match="Details/*">
    <tr>
      <th><xsl:value-of select="name()" /></th>
      <td><xsl:value-of select="." /></td>
    </tr>
  </xsl:template>
