<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
char flag = 2;
String ProcPara = "";
String ProjID = Util.null2String(request.getParameter("ProjID"));
String log = Util.null2String(request.getParameter("log"));
RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-2),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

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


<TABLE class=liststyle cellspacing=1 >
<TBODY>
        <TR class=Header>
          <th><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1335,user.getLanguage())%></th>
		</TR>
		<TR class=Line>
		<th class="Line1"></th>
		<th class="Line1"></th>
		<th class="Line1"></th>
		<th class="Line1"></th>
		<th class="Line1"></th>
		<th class="Line1"></th>
		</TR> 
		
<%
String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;
String sql="select distinct t1.requestid, t1.createdate, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t1.status from workflow_requestbase t1,workflow_currentoperator t2, Prj_Request t3 ";
String sqlwhere=" where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype + " and t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" ";
String orderby=" order by t1.createdate desc ";
sql=sql+sqlwhere+orderby;
RecordSet.executeSql(sql);
while(RecordSet.next())
{
	String requestid=RecordSet.getString("requestid");
	String createdate=RecordSet.getString("createdate");
	String creater=RecordSet.getString("creater");
	String creatertype=RecordSet.getString("creatertype");
	String creatername=ResourceComInfo.getResourcename(creater);
	String workflowid=RecordSet.getString("workflowid");
	String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
	String requestname=RecordSet.getString("requestname");
	String status=RecordSet.getString("status");
%>

    <tr class=datadark>
      <td><%=Util.toScreen(createdate,user.getLanguage())%></td>
      <td>
      <%if(creatertype.equals("0")){%>
      <%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=creater%>"><%}%><%=Util.toScreen(creatername,user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
      <%}else if(creatertype.equals("1")){%>
      <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=creater%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(creater),user.getLanguage())%></a>
      <%}else{%>
      <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
      <%}%>
      </td>
      <td><%=Util.toScreen(workflowname,user.getLanguage())%></td>
      <td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>"><%=Util.toScreen(requestname,user.getLanguage())%></a></td>
      <td><%=Util.toScreen(createdate,user.getLanguage())%></td>
      <td><%=Util.toScreen(status,user.getLanguage())%></td>
       </tr>

<%}%>
</TBODY>
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