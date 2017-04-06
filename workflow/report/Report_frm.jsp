<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>

<%
String imagefilename = "/images/hdHRM.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
//是否为流程模板
String isTemplate=Util.null2String(request.getParameter("isTemplate"));
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}
if(detachable==0){
    response.sendRedirect("/workflow/report/ReportType_frm.jsp");
    return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

<script language="JavaScript">
function getParentHeight() {
	if(parent.parent.window.document.getElementById('leftFrame') == null) {
	  	return "100%";
	}else {
		return parent.parent.window.document.getElementById('leftFrame').scrollHeight;
	}
}
if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}
</script>
</HEAD>
<body>
<TABLE class=viewform width=100% id=oTable1 style="height: 100%;" height="100%">
  <TBODY>
<tr>
	<td  height=100% id=oTd1 name=oTd1 width="220px" >
	<IFRAME name=leftframe id=leftframe src="Report_left.jsp?rightStr=WorkflowReportManage:All" width="100%" height="100%" frameborder=no scrolling=no >
	浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
	</td>
	<td height=100% id=oTd0 name=oTd0 width="10px;" >
	<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%"  height="100%" frameborder=no scrolling=no >
	浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
	</td>
	<td height=100% id=oTd2 name=oTd2 width="*" >
	<IFRAME name=contentframe id=contentframe src="/workflow/report/ReportType_frm.jsp"  height="100%" width="100%" frameborder=no scrolling=no>
	浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
	</td>
</tr>
  </TBODY>
</TABLE>
 </body>
</html>
