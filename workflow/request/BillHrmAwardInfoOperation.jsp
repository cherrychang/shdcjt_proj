<%@ page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.file.FileUpload" %>


<%
FileUpload fu = new FileUpload(request);
String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));

if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}



RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(fu) ;
RequestManager.setUser(user) ;
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {

        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }

        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;

if( iscreate.equals("1") ) {
	String createdate = RequestManager.getCreatedate() ;
	billid = RequestManager.getBillid() ;
	rs.executeSql(" update Bill_HrmAwardInfo set rpdate = '" + createdate +"' where id = " + billid ) ;
}

if( RequestManager.getNextNodetype().equals("3") ) {
	rs.executeSql(" select * from Bill_HrmAwardInfo where id = " + billid ) ;
	if( rs.next() ) {
		String rptitle = Util.null2String(rs.getString("rptitle"));/*奖惩标题*/
		String resourceid =    Util.null2String(rs.getString("resource_n"));/*员工id*/
		String rptypeid = Util.null2String(rs.getString("rptypeid"));/*
		  奖惩种类*/
		String rpdate = Util.null2String(rs.getString("rpdate")) ;       /*奖惩日期*/	
		String rpexplain = Util.null2String(rs.getString("rpexplain")) ;	/*说明*/
		String rptransact = Util.null2String(rs.getString("rptransact")) ;	/*相关处理*/
		char separator = Util.getSeparator() ;  
		String para = rptitle + separator + resourceid + separator + rptypeid + separator + rpdate + separator + rpexplain + separator + rptransact;
        
        rs.executeProc("HrmAwardInfo_Insert",para);
	}
}

//response.sendRedirect("/workflow/request/RequestView.jsp");
out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
%>