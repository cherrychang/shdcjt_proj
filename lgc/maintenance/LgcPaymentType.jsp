<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : " + SystemEnv.getHtmlLabelName(710,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


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
		<td valign="top"><FORM id=weaver name=frmmain method=post >
<div style="display:none">
<%
if(HrmUserVarify.checkUserRight("LgcPaymentTypeAdd:Add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:location='LgcPaymentTypeAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnNew accessKey=N onclick="location='LgcPaymentTypeAdd.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<%}
if(HrmUserVarify.checkUserRight("LgcPaymentType:Log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =48',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnLog accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =48'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<%}
%>
</div>
<br>
  <UL>
    <%
	RecordSet.executeProc("LgcPaymentType_Select","");
	while(RecordSet.next()){
		String id =RecordSet.getString(1);
		String typename=RecordSet.getString(2);
		%>
    <LI> <a href="LgcPaymentTypeEdit.jsp?id=<%=id%>"><%=typename%></a> </li>
    <%
}
%>
  </ul>
</form>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</body>
</html>