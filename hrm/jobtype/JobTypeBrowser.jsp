<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where description like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and description like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}
%>
<BODY>
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
<td valign="top" style="height:1px;">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="JobTypeBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=Viewform>
<TR class=Sapcing style="height:1px;"><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=name value="<%=name%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=description value="<%=description%>"></TD>
</TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=70%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
</tr><TR class=Line ><TH colspan="4" style="padding:0;"></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmJobType "+sqlwhere;
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD style="display:none"><%=RecordSet.getString(1)%></TD>
	<TD><%=RecordSet.getString("name")%></TD>
	<TD><%=RecordSet.getString("description")%></TD>
	
</TR>
<%}%>
</TABLE></FORM>
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
 </BODY></HTML>

<script	language="javascript">
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","��");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
		window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
});
</script>