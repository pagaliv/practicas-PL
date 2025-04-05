<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Transformación XSLT 1.0 para generar un reporte HTML de futbolistas "horteras"
    Autor: [Tu nombre]
    Fecha: [Fecha]
    Entrada: XML de deportistas favoritos
    Salida: HTML con tabla de futbolistas hortera ordenados por goles
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:df="http://www.ejemplo.org/deportistasFavoritos"
    xmlns:dep="http://www.ejemplo.org/deportistas"
    exclude-result-prefixes="df dep">
    
    <!-- Configuración del output como HTML con indentación -->
    <xsl:output method="html" indent="yes"/>
    
    <!-- 
        Plantilla principal que genera la estructura HTML
        Se activa con el nodo raíz del documento XML
    -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Futbolistas "horteras" ordenados por goles</title>
                <style>
                    /* Estilos CSS para la tabla */
                    table { border-collapse: collapse; width: 80%; margin: 20px auto; }
                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                    th { background-color: #f2f2f2; }
                    tr:nth-child(even) { background-color: #f9f9f9; }
                </style>
            </head>
            <body>
                <!-- Título principal con el año dinámico -->
                <h1>Futbolistas "horteras" (temporada <xsl:value-of select="df:deportistasFavoritos/@agno"/>)</h1>
                
                <!-- Tabla de resultados -->
                <table>
                    <tr>
                        <th>Posición</th>
                        <th>Nombre</th>
                        <th>Equipo</th>
                        <th>Posición</th>
                        <th>Goles (temporada)</th>
                        <th>Goles (total)</th>
                    </tr>
                    <!-- 
                        Aplicamos plantillas a los futbolistas hortera 
                        Ordenados descendientemente por goles en temporada
                        Creamos variable de posición con xsl:number
                    -->
                    <xsl:for-each select="//dep:futbolista[@hortera='true']">
                        <xsl:sort select="dep:numGoles[@temporada]" data-type="number" order="descending"/>
                        <tr>
                            <td><xsl:number value="position()" format="1"/></td>
                            <td><xsl:value-of select="dep:nombre/@completo"/></td>
                            <td>
                                <xsl:value-of select="dep:equipo"/>
                                <xsl:if test="dep:equipo/@pais">
                                    (<xsl:value-of select="dep:equipo/@pais"/>)
                                </xsl:if>
                            </td>
                            <td><xsl:value-of select="dep:posicion"/></td>
                            <td><xsl:value-of select="dep:numGoles[@temporada]"/></td>
                            <td><xsl:value-of select="dep:numGoles[@tipo='total']"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
                
                
            </body>
        </html>
    </xsl:template>
    
    <!-- 
        Plantilla para manejar casos especiales o elementos no deseados
        En este caso la dejamos vacía para evitar output no deseado
    -->
    <xsl:template match="text()"/>
    
</xsl:stylesheet>