<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://www.ejemplo.org/matexpr"
    exclude-result-prefixes="m">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="contexto" select="//m:contexto/m:asignacion"/>
    
    <xsl:template match="/">
        <resultado>
            <expresion>
                <xsl:value-of select="normalize-space(//m:expresion/m:nodo[1])"/>
            </expresion>
            <evaluacion>
                <xsl:apply-templates select="//m:expresion/m:nodo[1]"/>
            </evaluacion>
            <contexto>
                <xsl:for-each select="$contexto">
                    <variable nombre="{@var}" valor="{.}"/>
                </xsl:for-each>
            </contexto>
        </resultado>
    </xsl:template>
    
    <xsl:template match="m:valor">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="m:variable">
        <xsl:variable name="nombreVar" select="."/>
        <xsl:value-of select="$contexto[@var=$nombreVar]"/>
    </xsl:template>
    
    <xsl:template match="m:suma">
        <xsl:variable name="op1">
            <xsl:apply-templates select="m:nodo[1]"/>
        </xsl:variable>
        <xsl:variable name="op2">
            <xsl:apply-templates select="m:nodo[2]"/>
        </xsl:variable>
        <xsl:value-of select="$op1 + $op2"/>
    </xsl:template>
    
    <xsl:template match="m:resta">
        <xsl:variable name="op1">
            <xsl:apply-templates select="m:nodo[1]"/>
        </xsl:variable>
        <xsl:variable name="op2">
            <xsl:apply-templates select="m:nodo[2]"/>
        </xsl:variable>
        <xsl:value-of select="$op1 - $op2"/>
    </xsl:template>
    
    <xsl:template match="m:multiplicacion">
        <xsl:variable name="op1">
            <xsl:apply-templates select="m:nodo[1]"/>
        </xsl:variable>
        <xsl:variable name="op2">
            <xsl:apply-templates select="m:nodo[2]"/>
        </xsl:variable>
        <xsl:value-of select="$op1 * $op2"/>
    </xsl:template>
</xsl:stylesheet>