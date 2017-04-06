<%--
  ~ Copyright (c) 2006, Weaver software. All Rights Reserved.
  --%>

<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.workflow.layout.*" %>
<%@ page import="weaver.workflow.workflow.WorkflowComInfo" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
    if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    
	if("false".equals(isIE)){
		response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=16459");
		return;
	}

    String currWf = Util.null2String(request.getParameter("wfid"));
  
%>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(16352,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<body>
<form name="form1" method="post"  >
	<%if("true".equals(isIE)){ %>
     <iframe id ="wfdesign" src="/workflow/design/wfdesign.jsp?wfId=<%=currWf%>&type=view"  style="width:100%;height:100%;"></iframe>
     <%}else{ 
    	  	Workflow wf;
    	    
    	    if (currWf != null && !currWf.equals("")) {
    		    wf = DownloadWFLayoutServlet.readWFLayout(Util.getIntValue(currWf,0), user.getLanguage(), false);
    		    wf.checkAndAutosetLayout(10, 10, 20, 50);
    		} else {
    		    wf = new Workflow();
    		}

    	    String wfnameq = Util.null2String(request.getParameter("wfnameq"));
    	   
    	    String serverstr=request.getScheme()+"://"+request.getHeader("Host");

     	  	String sql = "select * from workflow_base where isvalid='1' and workflowname like '%"+wfnameq+"%' order by workflowname"; //xwj td1800 on 2005-04-27
		    //System.out.println("sql = " + sql);
		    rs.executeSql(sql);
		    //WorkflowComInfo wfci = new WorkflowComInfo();
		    //wfci.setTofirstRow();
		    //int wfnum = wfci.getWorkflowNum();
		    int top = 0;
		    int left = 0;
		    int listwidth = 150;
		    int appletwidth = wf.getMaxPos().x+10>800?wf.getMaxPos().x+10:800;
		    int appletheight = wf.getMaxPos().y+10>592?wf.getMaxPos().y+10:592;
		
		    String viewName = "";
		    while (rs.next()) {
		        viewName = DownloadWFLayoutServlet.ch2China(rs.getString("workflowname"), user.getLanguage(), true);
		        if(viewName != null){
		            //System.out.println("viewName = "+viewName+" \tviewNameLength = " + viewName.getBytes().length);
		            if(viewName.getBytes().length*420/60>listwidth){
		                listwidth = viewName.getBytes().length*420/60;
		            }
		
		        }
		    }
    //System.out.println("listwidth = " + listwidth);
		    rs.beforFirst();
		    listwidth +=30;
%>

    <div style="position:absolute;width:<%=appletwidth%>;height:<%=appletheight%>">
    <!--  
      <object classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" width=<%=appletwidth%> height=<%=appletheight%> codebase="<%=serverstr%>/resource/j2re-1_3_1_04-windows-i586.exe">
        <param name = code value = weaver.workflow.layout.WorkflowEditor.class >
        <param name = codebase value = /classbean >
        <param name="type" value="application/x-java-applet;jpi-version=1.3.1">
        <param name="scriptable" value="false">
    	<param name="MAYSCRIPT" value="true">
        <param name = "downloadUrl" value="<%=serverstr%>/weaver/weaver.workflow.layout.DownloadWFLayoutServlet"/>
        <param name = "uploadUrl" value ="<%=serverstr%>/weaver/weaver.workflow.layout.DownloadWFLayoutServlet"/>
        <param name = "id" value="<%=(currWf==null?"":currWf)%>">
        <param name = actionRedirectToLogin value = "redirect"/>
      </object>
      -->
      <object type="application/x-java-applet;version=1.5" 
        width=<%=appletwidth%> height=<%=appletheight%> name="myApplet" 
        codebase="<%=serverstr%>/resource/j2re-1_3_1_04-windows-i586.exe">
    <param name="type" value="application/x-java-applet;jpi-version=1.3.1">
    <param name="code" value="weaver.workflow.layout.WorkflowEditor.class">
    <param name="codebase" value="/classbean/">
    <param name="archive" value="myapplet.jar">
    <param name="scriptable" value="false">
    <param name="MAYSCRIPT" value="true">
   
   <param name = "downloadUrl" value="<%=serverstr%>/weaver/weaver.workflow.layout.DownloadWFLayoutServlet"/>
   <param name = "uploadUrl" value ="<%=serverstr%>/weaver/weaver.workflow.layout.DownloadWFLayoutServlet"/>
   <param name = "id" value="<%=(currWf==null?"":currWf)%>">
   <param name = actionRedirectToLogin value = "redirect"/>
</object>
    </div>
    
     <%} %>
</form>
<%
String loginfile = Util.getCookie(request , "loginfileweaver");
%>
<form name="redirect" method="post" action="/Refresh.jsp?loginfile=<%=loginfile%>&message=19">
</form>
</body>
</html>

