<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
//是否为流程模板
//判断是否分权设置
String rightSha=Util.null2String(request.getParameter("rightSha"));
String url="";

%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	function getParentHeight() {
		if(parent.parent.window.document.getElementById('leftFrame') == null) {
		  	return "100%";
		}else {
			return parent.parent.window.document.getElementById('leftFrame').scrollHeight;
		}
	}
	if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#leftcontentframe,#middleframe,#wfmainFrame").height(jQuery("#leftcontentframe").parent().height());
			window.onresize = function () {
				jQuery("#leftcontentframe,#middleframe,#wfmainFrame").height(jQuery("#leftcontentframe").parent().height());
			};
		});
	}
</script>
</head>

<body>
<%
if(!rightSha.equals("") && rightSha.equalsIgnoreCase("share") && rightSha!=null){  //分权设置
%>
<TABLE class=viewform width=100% id=oTable1 height=100%>
<%}else{%>
<TABLE class=viewform width=100% id=oTable1 style="height: 100%">
<%}%>

  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="220px">
<IFRAME name=leftcontentframe id=leftcontentframe src="/workflow/workflow/CustomQueryType_left.jsp" width="100%" height="100%" frameborder=no scrolling=no >
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width="10px">
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 >
<IFRAME name=wfmainFrame id=wfmainFrame src="/workflow/workflow/CustomQuerySet.jsp" width="100%" height="100%" frameborder=no scrolling=auto>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
</body>
</html>