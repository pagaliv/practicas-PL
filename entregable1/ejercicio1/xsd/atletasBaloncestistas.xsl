<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Transformación XSLT 1.0 para generar un reporte HTML combinado
    Autor: Pablo Galilea
    Fecha: 05-04-2025
    Entrada: XML de deportistas favoritos
    Salida: HTML con:
      - Atletas con más de X medallas (parámetro)
      - Todos los baloncestistas
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:df="http://www.ejemplo.org/deportistasFavoritos"
    xmlns:dep="http://www.ejemplo.org/deportistas"
    exclude-result-prefixes="df dep">
    
    <!-- Configuración del output como HTML con indentación -->
    <xsl:output method="html" indent="yes"/>
    
    <!-- 
        Parámetro para el número mínimo de medallas
        Valor por defecto: 5 (puede ser sobrescrito al invocar la transformación)
    -->
    <xsl:param name="minMedallas" select="5"/>
    
    <!-- Plantilla principal -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Reporte de Atletas y Baloncestistas</title>
                <style>
                    /* Estilos CSS para las tablas */
                    table { 
                    border-collapse: collapse; 
                    width: 80%; 
                    margin: 20px auto; 
                    box-shadow: 0 2px 3px rgba(0,0,0,0.1);
                    }
                    th { 
                    background-color: #4CAF50; 
                    color: white; 
                    padding: 10px;
                    text-align: left;
                    }
                    td { 
                    padding: 8px; 
                    border-bottom: 1px solid #ddd;
                    }
                    tr:hover { background-color: #f5f5f5; }
                    .section-title { 
                    color: #2E7D32; 
                    margin: 30px 0 10px 10%;
                    }
                    .param-info {
                    margin: 10px auto;
                    width: 80%;
                    padding: 10px;
                    background-color: #E8F5E9;
                    border-left: 4px solid #2E7D32;
                    }
                </style>
            </head>
            <body>
                <h1 style="text-align: center; color: #2E7D32;">
                    Reporte de Deportistas (<xsl:value-of select="df:deportistasFavoritos/@agno"/>)
                </h1>
                
                <!-- Información sobre el parámetro usado -->
                <div class="param-info">
                    <strong>Parámetro aplicado:</strong> Mostrando atletas con más de 
                    <xsl:value-of select="$minMedallas"/> medallas.
                </div>
                
                <!-- Sección de Atletas -->
                <h2 class="section-title">Atletas con más de <xsl:value-of select="$minMedallas"/> medallas</h2>
                <table>
                    <tr>
                        <th>Nombre</th>
                        <th>Disciplina</th>
                        <th>Medallas (total)</th>
                        <th>Medallas (oro)</th>
                        <th>Activo</th>
                    </tr>
                    <xsl:apply-templates select="//dep:atleta[dep:medallas[@tipo='total'] > $minMedallas]">
                        <xsl:sort select="dep:medallas[@tipo='total']" data-type="number" order="descending"/>
                    </xsl:apply-templates>
                </table>
                
                <!-- Sección de Baloncestistas -->
                <h2 class="section-title">Todos los baloncestistas</h2>
                <table>
                    <tr>
                        <th>Nombre</th>
                        <th>Equipo</th>
                        <th>Posición</th>
                        <th>Puntos (total)</th>
                        <th>Estado</th>
                    </tr>
                    <xsl:apply-templates select="//dep:baloncestista">
                        <xsl:sort select="dep:nombre/@completo"/>
                    </xsl:apply-templates>
                </table>
                
                <!-- Resumen estadístico -->
                <div style="width: 80%; margin: 30px auto; padding: 15px; background-color: #E3F2FD; border-left: 4px solid #1565C0;">
                    <h3 style="margin-top: 0; color: #0D47A1;">Resumen estadístico</h3>
                    <p>Total atletas con muchas medallas: <xsl:value-of select="count(//dep:atleta[dep:medallas[@tipo='total'] > $minMedallas])"/></p>
                    <p>Total baloncestistas: <xsl:value-of select="count(//dep:baloncestista)"/></p>
                    <p>Total deportistas en el sistema: <xsl:value-of select="count(//df:deportista)"/></p>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- Plantilla para atletas -->
    <xsl:template match="dep:atleta">
        <tr>
            <td>
                <xsl:value-of select="dep:nombre/@completo"/>
                <xsl:if test="dep:fechaNacimiento">
                    <br/>
                    <small>Nacimiento: <xsl:value-of select="format-date(dep:fechaNacimiento, '[D]/[M]/[Y]')"/></small>
                </xsl:if>
            </td>
            <td><xsl:value-of select="dep:disciplina"/></td>
            <td style="text-align: center;"><xsl:value-of select="dep:medallas[@tipo='total']"/></td>
            <td style="text-align: center;"><xsl:value-of select="dep:medallas[@tipo='oro']"/></td>
            <td style="text-align: center;">
                <xsl:choose>
                    <xsl:when test="@activo='true'">✅ Activo</xsl:when>
                    <xsl:otherwise>⏹ Retirado</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    
    <!-- Plantilla para baloncestistas -->
    <xsl:template match="dep:baloncestista">
        <tr>
            <td>
                <xsl:value-of select="dep:nombre/@completo"/>
                <xsl:if test="dep:fechaNacimiento">
                    <br/>
                    <small>Nacimiento: <xsl:value-of select="format-date(dep:fechaNacimiento, '[D]/[M]/[Y]')"/></small>
                </xsl:if>
            </td>
            <td>
                <xsl:value-of select="dep:equipo"/>
                <xsl:if test="dep:equipo/@pais">
                    (<xsl:value-of select="dep:equipo/@pais"/>)
                </xsl:if>
            </td>
            <td><xsl:value-of select="dep:posicion"/></td>
            <td style="text-align: center;">
                <xsl:value-of select="format-number(dep:puntos[@tipo='total'], '#,###')"/>
            </td>
            <td style="text-align: center;">
                <xsl:choose>
                    <xsl:when test="@retirado='true'">⏹ Retirado</xsl:when>
                    <xsl:otherwise>✅ Activo</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    
    <!-- Plantilla para ignorar texto no deseado -->
    <xsl:template match="text()"/>
    
</xsl:stylesheet>