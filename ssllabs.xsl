<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!--
        Documentation: https://github.com/ssllabs/ssllabs-scan/blob/master/ssllabs-api-docs-v3.md
    -->

    <xsl:variable name="grades" select="document('ssllabs_globals.xml')"/>

    <xsl:output method="html" indent="yes"/>



  <!-- Date conversion template -->
    <xsl:template name="UnixTime-to-dateTime">
    	<xsl:param name="unixTime"/>
    	
    	<xsl:variable name="UnixTimeSec" select="floor($unixTime div 1000)" />
    	<xsl:variable name="JDN" select="floor($UnixTimeSec div 86400) + 2440588" />
    	<xsl:variable name="secs" select="$UnixTimeSec mod 86400" />	
    	
    	<xsl:variable name="f" select="$JDN + 1401 + floor((floor((4 * $JDN + 274277) div 146097) * 3) div 4) - 38"/>
    	<xsl:variable name="e" select="4*$f + 3"/>
    	<xsl:variable name="g" select="floor(($e mod 1461) div 4)"/>
    	<xsl:variable name="h" select="5*$g + 2"/>
    
    	<xsl:variable name="d" select="floor(($h mod 153) div 5 ) + 1"/>
    	<xsl:variable name="m" select="(floor($h div 153) + 2) mod 12 + 1"/>
    	<xsl:variable name="y" select="floor($e div 1461) - 4716 + floor((14 - $m) div 12)"/>
    
    	<xsl:variable name="H" select="floor($secs div 3600)"/>
    	<xsl:variable name="M" select="floor($secs mod 3600 div 60)"/>
    	<xsl:variable name="S" select="$secs mod 60"/>
    
    	<xsl:value-of select="$y"/>
    	<xsl:text>-</xsl:text>
    	<xsl:value-of select="format-number($m, '00')"/>
    	<xsl:text>-</xsl:text>
    	<xsl:value-of select="format-number($d, '00')"/>
    	<xsl:text>T</xsl:text>
    	<xsl:value-of select="format-number($H, '00')"/>
    	<xsl:text>:</xsl:text>
    	<xsl:value-of select="format-number($M, '00')"/>
    	<xsl:text>:</xsl:text>
    	<xsl:value-of select="format-number($S, '00')"/>
    </xsl:template>
  
  
    <!-- Template principal -->
    <xsl:template match="/">
    
        <html>
        
            <head>
                <title>Rapport SSL - <xsl:value-of select="LabsReport/Host" /></title>
                <link href="ssllabs.css" rel="stylesheet" type="text/css" />
            </head>
            
            <body>
            
                <h1>Rapport SSL - <xsl:value-of select="LabsReport/Host" /></h1>
                
                
                <table class="full_table">
                
                    <!--h2>Informations</h2-->
                    <tr>
                        <th class="table_header" colspan="2">General information</th>
                    </tr>
                    
                    <xsl:for-each select="LabsReport/*[.]">
                        <xsl:choose>
                            <xsl:when test="(name()='StartTime') or (name()='TestTime')">
                                <!-- Singleton -->
                                <tr>
                                    <th><xsl:value-of select="name()" /></th>
                                    <td colspan="2">
                                        <xsl:call-template name="UnixTime-to-dateTime">
                                          <xsl:with-param name="unixTime" select="."/>
                                        </xsl:call-template>                                    
                                    </td>
                                </tr>
                            </xsl:when>
                            <xsl:when test="not(./*)">
                                <!-- Singleton -->
                                <tr>
                                    <th><xsl:value-of select="name()" /></th>
                                    <td colspan="2"><xsl:value-of select="." /></td>
                                </tr>
                            </xsl:when>
                            <xsl:otherwise>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>

                    <!--h2>Endpoints</h2-->
                    
                    <tr>
                        <th class="table_header" colspan="2">Endpoints information*</th><td></td>
                    </tr>
                    
                    <!-- Endpoints Information -->
                    <xsl:for-each select="LabsReport/Endpoints/*[.]">
                        <xsl:choose>
                            <xsl:when test="name()='Grade'">
                                <!-- Grade!! -->
                                <xsl:variable name="current_grade" select="." />
                                <tr>
                                    <th><xsl:value-of select="name()" /></th>
                                    <td>
                                        <table class="table_grade">
                                            <tr class="tr_grade">
                                            <xsl:for-each select="$grades/ListGrades/*">
                                                <xsl:if test='$current_grade=letter'>
                                                    <td style='background:{background};' class="current_grade"><xsl:value-of select="letter" /></td>
                                                </xsl:if>
                                                <xsl:if test='$current_grade!=letter'>
                                                    <td style='background:{background};' class="hidden_grade"><xsl:value-of select="letter" /></td>
                                                </xsl:if>
                                            </xsl:for-each>
                                            </tr >
                                        </table>
                                    </td>
                                </tr>
                            </xsl:when>
                            <xsl:when test="name()='GradeTrustIgnored'">
                                <xsl:variable name="untrusted_grade" select="." />
                                <!-- Grade!! -->
                                <tr>
                                    <th><xsl:value-of select="name()" /></th>
                                    <td>
                                        <table class="table_grade">
                                            <tr class="tr_grade">
                                            <xsl:for-each select="$grades/ListGrades/*">
                                                <xsl:if test='$untrusted_grade=letter'>
                                                    <td style='background:{background};' class="current_grade"><xsl:value-of select="letter" /></td>
                                                </xsl:if>
                                                <xsl:if test='$untrusted_grade!=letter'>
                                                    <td style='background:{background};' class="hidden_grade"><xsl:value-of select="letter" /></td>
                                                </xsl:if>
                                            </xsl:for-each>
                                            </tr >
                                        </table>
                                    </td>
                                </tr>
                            </xsl:when>
                            <xsl:when test="name()='FutureGrade'">
                                <xsl:variable name="future_grade" select="." />
                                <!-- Grade!! -->
                                <tr>
                                    <th><xsl:value-of select="name()" /></th>
                                    <td>
                                        <table class="table_grade">
                                            <tr class="tr_grade">
                                            <xsl:for-each select="$grades/ListGrades/*">
                                                <xsl:if test='$future_grade=letter'>
                                                    <td style='background:{background};' class="current_grade"><xsl:value-of select="letter" /></td>
                                                </xsl:if>
                                                <xsl:if test='$future_grade!=letter'>
                                                    <td style='background:{background};' class="hidden_grade"><xsl:value-of select="letter" /></td>
                                                </xsl:if>
                                            </xsl:for-each>
                                            </tr >
                                        </table>
                                    </td>
                                </tr>
                            </xsl:when>
                            <xsl:when test="not(./*)">
                                <!-- Singleton -->
                                <tr>
                                    <th><xsl:value-of select="name()" /></th>
                                    <td colspan="2"><xsl:value-of select="." /></td>
                                </tr>
                            </xsl:when>
                            <xsl:otherwise>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    
                    <!-- Endpoints Accepted Protocols -->

                    <tr>
                        <th class="protocols_header" colspan="2">Endpoint Accepted Protocols</th><td></td>
                    </tr>
                    <xsl:for-each select="LabsReport/Endpoints/Details/Protocols[*]">
                        <xsl:choose>
                            <xsl:when test="not(./*)">
                                <!-- Singleton -->
                                <!-- N/A -->
                            </xsl:when>
                            <xsl:otherwise>
                                <tr>
                                    <th>Endpoints Accepted Protocols</th>
                                    <td colspan="2">Protocol Id : <xsl:value-of select="Id" />&#160;<xsl:value-of select="Name" />&#160;<xsl:value-of select="Version" />&#160;V2disabled : <xsl:value-of select="V2SuitesDisabled" />&#160;Q : <xsl:value-of select="Q" /></td>
                                </tr>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
    
                    <!-- Endpoints Accepted Suites -->
                    <xsl:variable name="eap_protocols" select="LabsReport/Endpoints/Details/Protocols"/>
                    <xsl:for-each select="LabsReport/Endpoints/Details/Suites[*]">
                        <xsl:choose>
                            <xsl:when test="not(./*)">
                                <!-- Singleton -->
                                <!-- N/A -->
                            </xsl:when>
                            <xsl:otherwise>
                                <tr>
                                    <th>Endpoints Accepted Suites</th>
                                    <xsl:variable name="protocol_id" select="Protocol"/>
                                    <td colspan="2"><xsl:value-of select="$eap_protocols[Id=$protocol_id]/Name" />&#160;<xsl:value-of select="$eap_protocols[Id=$protocol_id]/Version" /> (<xsl:value-of select="Protocol" />)&#160;HasPreference : <xsl:value-of select="Preference" /></td>
                                </tr>
                                <tr>
                                    <th></th>
                                    <td colspan="2">
                                        <table class="accepted_suites">
                                            <xsl:for-each select="./List[*]">
                                            <tr>
                                                <td class="accepted_suites_name"><span ><xsl:value-of select="Name" /></span></td>
                                                <td class="accepted_suites_value"><span class="content_name">CipherStrength </span><span class="content_value"><xsl:value-of select="CipherStrength" /></span></td>
                                                <td class="accepted_suites_value"><span class="content_name">KxType </span><span class="content_value"><xsl:value-of select="KxType" /></span></td>
                                                <td class="accepted_suites_value"><span class="content_name">KxStrength </span><span class="content_value"><xsl:value-of select="KxStrength" /></span></td>
                                                <td class="accepted_suites_value"><span class="content_name">NamedGroupBits </span><span class="content_value"><xsl:value-of select="NamedGroupBits" /></span></td>
                                                <td class="accepted_suites_value"></td>
                                            </tr>
                                            </xsl:for-each>
                                        </table>                                    
                                    </td>
                                </tr>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
    
                    <!-- NoSniSuites -->
                    <xsl:for-each select="LabsReport/Endpoints/Details/NoSniSuites[*]">
                        <xsl:choose>
                            <xsl:when test="not(./*)">
                                <!-- Singleton -->
                                <!-- N/A -->
                            </xsl:when>
                            <xsl:otherwise>
                                <tr>
                                    <th>NoSniSuites</th>
                                    <td colspan="2">Protocol : <xsl:value-of select="Protocol" /> Preference : <xsl:value-of select="Preference" /></td>
                                </tr>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    
                    <!-- NamedGroups -->
                    <tr>
                        <th>NamedGroups</th>
                        <td colspan="2">
                            <xsl:for-each select="LabsReport/Endpoints/Details/NamedGroups/*[*]">
                                <xsl:choose>
                                    <xsl:when test="not(./*)">
                                        <!-- Singleton -->
                                        <!-- N/A -->
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="named_group"><xsl:value-of select="Name" /></span>&#160;<xsl:value-of select="Bits" />&#160;bits&#160;(Id : <xsl:value-of select="Id" />)<br/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </td>
                    </tr>

                    <!-- CertChains -->
                    <tr>
                        <th>CertChains</th>
                        <td colspan="2">
                            <xsl:for-each select="LabsReport/Endpoints/Details/CertChains/*">
                                <xsl:value-of select="name()" /> : <xsl:value-of select="." /><br/>
                            </xsl:for-each>
                        </td>
                    </tr>
                    
                    <!-- Simulations -->
                    <tr>
                        <th class="simulation_header" colspan="2">Simulation of negociation by OS</th><td></td>
                    </tr>
                    <xsl:for-each select="LabsReport/Endpoints/Details/Sims/*[*]">
                        <tr>
                            <xsl:choose>
                                <xsl:when test="not(./*)">
                                    <!-- Singleton -->
                                    <!-- N/A -->
                                </xsl:when>
                                <xsl:otherwise>
                                    <th class="simulation_OS"><xsl:value-of select="Client/Name" />&#160;<xsl:value-of select="Client/Platform" />&#160;<xsl:value-of select="Client/Version" />&#160;</th>
                                    <td>
                                        <table class="accepted_suites">
                                            <tr>
                                                <xsl:choose>
                                                    <xsl:when test="ErrorCode=0">
                                                        <td class="sim_os_suites_name"><xsl:value-of select="SuiteName" /></td>
                                                        <td class="sim_os_suites_value"><span class="content_name">Key Type </span><span class="content_value"><xsl:value-of select="KxType" /> (<xsl:value-of select="KxStrength" /> bits)</span></td>
                                                        <td class="sim_os_suites_value"><span class="content_name">NamedGroupBits </span><span class="content_value"><xsl:value-of select="NamedGroupBits" /></span></td>
                                                        <td class="sim_os_suites_value"><span class="content_name">NamedGroup </span><span class="content_value"><xsl:value-of select="NamedGroupName" /></span></td>
                                                        <td class="sim_os_suites_value"><span class="content_name">KeyAlg </span><span class="content_value"><xsl:value-of select="KeyAlg" /> (<xsl:value-of select="KeySize" /> bits)</span></td>
                                                        <td class="accepted_suites_value"><span class="content_name">SigAlg </span><span class="content_value"><xsl:value-of select="SigAlg" /></span></td>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <td><span class="content_light_error"><xsl:value-of select="ErrorMessage" /></span></td>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </tr>
                                        </table>
                                    </td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr>
                    </xsl:for-each>

                    <!-- Endpoint Details -->
                    <tr>
                        <th class="endpoint_detail_header" colspan="2">Endpoint details</th><td></td>
                    </tr>
                    <xsl:for-each select="LabsReport/Endpoints/Details/*[.]">
                        <xsl:choose>
                            <xsl:when test="(name()='HostStartTime')">
                                    <th>Details/<xsl:value-of select="name()" /></th>
                                    <td>
                                        <xsl:call-template name="UnixTime-to-dateTime">
                                          <xsl:with-param name="unixTime" select="."/>
                                        </xsl:call-template>
                                    </td>
                            </xsl:when>
                            <xsl:when test="not(./*)">
                                <!-- Singleton -->
                                <tr>
                                    <th>Details/<xsl:value-of select="name()" /></th>
                                    <td><xsl:value-of select="." /></td>
                                </tr>
                            </xsl:when>
                            <xsl:otherwise>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
    
                    <!--h2>Certificates</h2-->
                    <tr>
                        <th class="table_header" colspan="2">Certificates</th>
                    </tr>                    
                    <!-- Certificates Information -->
                    <xsl:for-each select="LabsReport/Certs[*]">
                        <tr>
                            <th colspan="2"><span class="certificate_header_CN">CN=<xsl:value-of select="CommonNames" /> (<xsl:value-of select="IssuerSubject" />)</span></th>
                        </tr>
                        <xsl:for-each select="./*">
                            <xsl:choose>
                                <xsl:when test="not(./*)">
                                    <!-- Singleton -->
                                    <xsl:choose>
                                        <xsl:when test="(name()='NotBefore') or (name()='NotAfter')">
                                            <tr>
                                                <th><xsl:value-of select="name()" /></th>
                                                <td colspan="2">
                                                    <xsl:call-template name="UnixTime-to-dateTime">
                                                      <xsl:with-param name="unixTime" select="."/>
                                                    </xsl:call-template>                                    
                                                </td>
                                            </tr>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <tr>
                                                <th><xsl:value-of select="name()" /></th>
                                                <td colspan="2"><xsl:value-of select="." /></td>
                                            </tr>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <tr>
                                        <th><xsl:value-of select="name()" /></th>
                                        <td colspan="2"><xsl:value-of select="." /></td>
                                    </tr>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:for-each>
                
                    <!-- Certificates Information -->

                    
                </table>
                    
            </body>
            
        </html>
        
    </xsl:template>

</xsl:stylesheet>
