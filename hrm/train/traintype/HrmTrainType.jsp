<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6130,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainTypeAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/train/traintype/HrmTrainTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmTrainType:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+66+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="60%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6130,user.getLanguage())%></TH></TR>
    <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
  </TR>
 
<%
       rs.executeProc("HrmTrainType_Select","");
    int needchange = 0;
      while(rs.next()){
		String	name=rs.getString("name");
		String	description=rs.getString("description");
       try{
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}
  %>
    <TD><a href="HrmTrainTypeEdit.jsp?id=<%=rs.getString("id")%>"><%=name%></TD>
    <TD><%=description%></a></TD>
    
  </TR>
<%
      }catch(Exception e){
        System.out.println(e.toString());
      }
    }
%>  
 </TBODY>
 </TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>