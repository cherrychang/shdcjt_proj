<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(21590,user.getLanguage());
String needfav ="1";
String needhelp ="";
String operation="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<TABLE class=viewform>
  <colgroup>
  <col width="10">
  <col width="">
  <TR class=Title>
    <TH colspan="2"><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colspan="2"></TD></TR>
  <TR>
    <TD></TD>
        <TD><li><%if(user.getLanguage()==8){%>click left subcompany tree or department tree,set the subcompany's or department's annual leave 
    		<%}else if(user.getLanguage()==9){%>點擊左邊分部或者部門，對該分部或者部門的人員進行年假管理
    		<%}else{%>点击左边分部或者部门，对该分部或者部门的人员进行年假管理<%}%>
    </li></TD>
   </TR>
   </TR>
</TABLE>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>
