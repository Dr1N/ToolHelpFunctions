<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html>
      <head>
        <title>Toolhelp32 functions</title>
        <style>
          a {
            text-decoration: none;
          }
          a:hover {
            background-color: #ddd;
          }
          td, th {
            border: 1px solid #000;
            padding: 10px
          }
          th {
            background-color: #eee;
          }
        </style>
      </head>
      <body>
        <h1 align="center">Tool Help Functions</h1>
        <!--меню-->
        <div id="menu" style="background-color: #eee;
                              width: 250px;
                              float: left;
                              margin-right: 20px;">
          <p style="font-size: 20px; text-align: center; padding-bottom: 5px; margin: 5px">Functions:</p>
          <xsl:apply-templates select="//function" mode="menu" />
        </div>
        <!--контент-->
        <div id="content" style="float: left;
                                 width:70%;">
          <xsl:apply-templates select="//function" mode="content" />
        </div>
     </body>
    </html>
  </xsl:template>
  
  <!--меню-->
  <xsl:template match="function" mode="menu">
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="concat('#',functionName)" />
      </xsl:attribute>
      <xsl:attribute name="style">
        display: block; width: 100%; padding: 5px 0;
      </xsl:attribute>
      <xsl:value-of select="functionName" />
    </xsl:element>
  </xsl:template>
  
  <!--контент-->
  <xsl:template match="function" mode="content">
    
    <!--имя функции-->
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="@source" />
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:text>to MSDN</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="target">
        <xsl:text>_blank</xsl:text>
      </xsl:attribute>
      <xsl:element name="h2">
        <xsl:attribute name="id">
          <xsl:value-of select="functionName"/>
        </xsl:attribute>
        <xsl:value-of select="functionName"/>
      </xsl:element>
    </xsl:element>
    
    <!--описание-->
    <xsl:element name="p">
      <xsl:value-of select="functionDescription" />
    </xsl:element>
    
    <!--синтаксис-->
    <h3>Syntax</h3>
    <xsl:element name="div">
      <xsl:attribute name="style">
        border: 1px solid #ccc; padding: 10px; margin: 0 10px; background-color: #eee
      </xsl:attribute>
      <xsl:call-template name="syntax">
        <xsl:with-param name="func" select="." />
      </xsl:call-template>
    </xsl:element>
    
    <!--параметры-->
    <h3>Parameters</h3>
    <xsl:element name="div">
      <xsl:apply-templates select="parameters/parametr" />
    </xsl:element>
    
    <!--возвращаемое значение-->
    <h3>Return value</h3>
    <xsl:value-of select="returnValue" />
    
    <!--замечания-->
    <xsl:if test="remarks">
      <h3>Remarks</h3>
      <xsl:value-of select="remarks" />
    </xsl:if>
    
    <!--пример-->
    <xsl:if test="examples">
      <h3>Examples</h3>
      <xsl:element name="div">
        <xsl:attribute name="style">
          border: 1px solid #ccc; margin: 10px; background-color: #eee
        </xsl:attribute>
        <pre>
          <xsl:value-of select="examples" />
        </pre>
      </xsl:element>
    </xsl:if>

    <!--требованя-->
    <h3>Requirements</h3>
    <xsl:element name="table">
      <xsl:attribute name="id">
        requirements
      </xsl:attribute>
      <xsl:attribute name="style">
        border-collapse: collapse;  width: 90%; margin: 10px
      </xsl:attribute>
      <xsl:call-template name="printRequirements">
        <xsl:with-param name="requirements" select="@requirement" />
        <xsl:with-param name="list" select="../requirements/requirement" />
        <xsl:with-param name="ansi" select="@ansi-unicode" />
      </xsl:call-template>
    </xsl:element>
    <p style="font-size: smaller; text-align: center">Прохоренко Андрей. СП-2111<br />2014</p>
   </xsl:template>
    
  <!--==================================================-->
  <!--вспомогательные шаблоны-->
  <!--==================================================-->
  <!--построение синтаксиса функции-->
  <xsl:template name="syntax">
    <xsl:param name="func" />
    <!--поиск типа возвращаемого значения-->
    <xsl:call-template name="getValue">
      <xsl:with-param name="value" select="$func/returnValue/@type" />
      <xsl:with-param name="list" select="../dataType/type" />
    </xsl:call-template>
    <xsl:text> WINAPI </xsl:text>
    <xsl:value-of select="$func/functionName" />
    <xsl:text>(</xsl:text>
    <br />
    <xsl:call-template name="printParameters" >
      <xsl:with-param name="parameters" select="parameters" />
    </xsl:call-template>
    <xsl:text>);</xsl:text>
  </xsl:template>
  
  <!--вывод параметров для синтаксиса функции-->
  <xsl:template name="printParameters">
    <xsl:param name="parameters" />
    <xsl:for-each select="$parameters/parametr">
      <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
      <xsl:value-of select="@way" />
      <xsl:text> </xsl:text>
      <xsl:call-template name="getValue">
        <xsl:with-param name="value" select="@type" />
        <xsl:with-param name="list" select="../../../dataType/type" />
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:value-of select="parametrName" />
      <br />
    </xsl:for-each>
  </xsl:template>
  
  <!--вывод описания параметров-->
  <xsl:template match="parametr">
    <strong><em>
      <xsl:value-of select="parametrName" />
    </em></strong>
    <br />
    <xsl:value-of select="parametrDescription" />
    <br />
    <xsl:if test="count(values/value)">
      <xsl:element name="table">
        <xsl:attribute name="style">
          border-collapse: collapse;  width: 90%; margin: 10px
        </xsl:attribute>
        <xsl:element name="tr">
          <th>Value</th>
          <th>Meaning</th>
        </xsl:element>
        <xsl:apply-templates select="values/value" />
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <!--вывод возможных значений параметра-->
  <xsl:template match="value">
    <tr>
      <td>
        <xsl:value-of select="valueName"/>
      </td>
      <td>
        <xsl:value-of select="valueMeaning"/>
      </td>
    </tr>
  </xsl:template>
  
  <!--получение значений по ид-->
  <xsl:template name="getValue">
    <xsl:param name="value" />
    <xsl:param name="list" />
    <xsl:for-each select="$list">
      <xsl:if test="$value = @id">
        <xsl:value-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!--вывод требований-->
  <xsl:template name="printRequirements">
    <xsl:param name="requirements" />
    <xsl:param name="list" />
    <xsl:param name="ansi" />
    
    <xsl:for-each select="$list">
      <xsl:if test="contains($requirements, @id)">
        <tr>
          <td style="background-color: #eee">
            <xsl:value-of select="name" />
          </td>
          <td>
            <xsl:value-of select="value" />
          </td>
        </tr>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="$ansi='yes'">
      <tr>
        <td>Unicode and ANSI names</td>
        <td>
          <xsl:value-of select="concat(functionName,'W (Unicode) and ', functionName, ( ANSI))"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>