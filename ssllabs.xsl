<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" indent="yes"/>



  <!-- Date conversion template -->
  <xsl:template name="convertSecondsToDate">
    <xsl:param name="milliSeconds" select="0"/>
    <xsl:variable name="secondsInt" select="floor($milliSeconds div 1000)"/>
    
    <xsl:variable name="secondsPerDay" select="86400"/>
    <xsl:variable name="secondsPerHour" select="3600"/>
    <xsl:variable name="secondsPerMinute" select="60"/>
    
    <xsl:variable name="days" select="floor($secondsInt div $secondsPerDay)"/>
    <xsl:variable name="remainingSeconds1" select="$secondsInt mod $secondsPerDay"/>
    
    <xsl:variable name="hours" select="floor($remainingSeconds1 div $secondsPerHour)"/>
    <xsl:variable name="remainingSeconds2" select="$remainingSeconds1 mod $secondsPerHour"/>
    
    <xsl:variable name="minutes" select="floor($remainingSeconds2 div $secondsPerMinute)"/>
    <xsl:variable name="seconds" select="$remainingSeconds2 mod $secondsPerMinute"/>
    
    <!-- Replace '1970-01-01T00:00:00' with the specific date corresponding to your integer -->
    <xsl:call-template name="convertDaysToDate">
      <xsl:with-param name="days" select="$days"/>
    </xsl:call-template> / 
    <xsl:value-of select="concat(format-number($hours, '00'), ':', format-number($minutes, '00'), ':', format-number($seconds, '00'))"/>
  </xsl:template>    

  <!-- Date conversion template -->
  <xsl:template name="convertDaysToDate">
    <xsl:param name="days" select="0"/>
    <!-- Replace '1970-01-01' with your reference date -->
    <xsl:variable name="referenceDate" select="'1970-01-01'"/>
    <!-- Calculate the target date -->
    <xsl:variable name="targetYear" select="substring($referenceDate, 1, 4) + floor($days div 365)"/>
    <xsl:variable name="leapYears" select="floor($targetYear div 4) - floor($targetYear div 100) + floor($targetYear div 400)"/>
    <xsl:variable name="daysSinceReference" select="$days - ($targetYear - substring($referenceDate, 1, 4)) * 365 - $leapYears"/>
    <xsl:variable name="monthDays" select="30 + ($targetYear mod 4 = 0 and ($targetYear mod 100 != 0 or $targetYear mod 400 = 0))"/>
    <xsl:variable name="targetMonth" select="1 + floor(($daysSinceReference - 1) div $monthDays)"/>
    <xsl:variable name="targetDay" select="$daysSinceReference - floor(($daysSinceReference - 1) div $monthDays) * $monthDays"/>
    <!-- Format the target date -->
    <xsl:value-of select="concat($targetYear, '-', format-number($targetMonth, '00'), '-', format-number($targetDay, '00'))"/>
  </xsl:template>
  
  
    <!-- Template principal -->
    <xsl:template match="/">
    
        <html>
        
            <head>
                <title>Rapport SSL</title>
                <link href="ssllabs.css" rel="stylesheet" type="text/css" />
            </head>
            
            <body>
            
                <h1>Rapport SSL*</h1>
                
                
                <table class="full_table">
                
                    <!--h2>Informations</h2-->
                    <tr>
                        <th class="table_header" colspan="2">General information</th>
                    </tr>
                    
                    <xsl:for-each select="LabsReport/*[.]">
                        <!-- format-date(function name) (inpvalue, 'MMM dd, yyyy') -->
                        <xsl:choose>
                            <xsl:when test="name()='StartTime'">
                                <!-- Singleton -->
                                <tr>
                                    <th><xsl:value-of select="name()" /></th>
                                    <td colspan="2">
                                        <xsl:call-template name="convertSecondsToDate">
                                          <xsl:with-param name="milliSeconds" select="."/>
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
                        <th class="table_header" colspan="2">Endpoints information</th><td></td>
                    </tr>
                    
                    <!-- Endpoints Information -->
                    <xsl:for-each select="LabsReport/Endpoints/*[.]">
                        <xsl:choose>
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
                                        <div class="accepted_suites">
                                            <xsl:for-each select="./List[*]">
                                                <span class="accepted_suites_name"><xsl:value-of select="Name" /></span>
                                                &#160;<span class="content_name">CipherStrength : </span><span class="content_value"><xsl:value-of select="CipherStrength" /></span>
                                                &#160;<span class="content_name">KxType : </span><span class="content_value"><xsl:value-of select="KxType" /></span>
                                                &#160;<span class="content_name">KxStrength : </span><span class="content_value"><xsl:value-of select="KxStrength" /></span>
                                                &#160;<span class="content_name">NamedGroupBits : </span><span class="content_value"><xsl:value-of select="NamedGroupBits" /></span>
                                                <br/>
                                            </xsl:for-each>
                                        </div>                                    
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
                                    <xsl:choose>
                                        <xsl:when test="ErrorCode=0">
                                            <xsl:value-of select="SuiteName" />&#160;KxType<xsl:value-of select="KxType" />
                                            &#160;<span class="content_name">KxStrength : </span><span class="content_value"><xsl:value-of select="KxStrength" /></span>
                                            &#160;<span class="content_name">NamedGroupBits : </span><span class="content_value"><xsl:value-of select="NamedGroupBits" /></span>
                                            &#160;<span class="content_name">NamedGroupName : </span><span class="content_value"><xsl:value-of select="NamedGroupName" /></span>
                                            &#160;<span class="content_name">KeyAlg : </span><span class="content_value"><xsl:value-of select="KeyAlg" /></span>
                                            &#160;<span class="content_name">KeySize : </span><span class="content_value"><xsl:value-of select="KeySize" /></span>
                                            &#160;<span class="content_name">SigAlg : </span><span class="content_value"><xsl:value-of select="SigAlg" /></span>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="ErrorMessage" />
                                        </xsl:otherwise>
                                    </xsl:choose>
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
                                    <tr>
                                        <th><xsl:value-of select="name()" /></th>
                                        <td colspan="2"><xsl:value-of select="." /></td>
                                    </tr>
                                </xsl:when>
                                <xsl:otherwise>
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
