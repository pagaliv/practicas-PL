<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <!-- Plantilla para el elemento raíz 'alumnos' -->
    <xsl:template match="/alumnos">
        <html>
            <head>
                <title>Alumnos y Asignaturas Superadas</title>
            </head>
            <body>
                <h1>Alumnos y Asignaturas Superadas</h1>
                <ul>
                    <xsl:for-each select="alumno">
                        <li>
                            <strong>
                                <xsl:value-of select="datosPersonales/nombre"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="datosPersonales/apellido"/>
                            </strong>
                            <ul>
                                <xsl:for-each select="asignaturas/asignatura[calificacion >= 5]">
                                    <li>
                                        <xsl:value-of select="nombreAsignatura"/>
                                        <xsl:text> (Calificación: </xsl:text>
                                        <xsl:value-of select="calificacion"/>
                                        <xsl:text>)</xsl:text>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </li>
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>