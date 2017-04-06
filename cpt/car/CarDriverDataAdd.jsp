<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<% 
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17631,user.getLanguage());

String needfav ="1";
String needhelp ="";

String useperson = "";
String usedepartment ="";
int driverid=0;
String driverName=ResourceComInfo.getResourcename(driverid+"");
String resourceId = Util.null2String(request.getParameter("resourceid"));
String startDate = Util.null2String(request.getParameter("startDate"));
String startTime = Util.null2String(request.getParameter("startTime"));
String backTime = Util.null2String(request.getParameter("backTime"));

Calendar today = Calendar.getInstance();
int thisyear = today.get(Calendar.YEAR);
String sql="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<form name=frmmain action="CarDriverDataOperation.jsp">
<input type="hidden" name=operation value=add>

<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%"><COL width="30%"><COL width="20%"><COL width="30%">
  <TBODY>
  <TR class=title>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(17631,user.getLanguage())%></TH></TR>
      <TR class=spacing>
        <TD class=line1 colSpan=4></TD></TR>
      <TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%></TD>

    <TD  class=field>
    <button class=Browser onClick="onShowResource()"></button>
	<span id=driveridspan>
    <a href="/hrm/resource/HrmResource.jsp?id=<%=driverid%>"></a><%if(driverid<=0){%><IMG src="/images/BacoError.gif" align="absMiddle"><%}else {%>
    <%=Util.toScreen(driverName,user.getLanguage())%><%}%>
	</span>
	<input type=hidden name="driverid" value="<%=driverid%>">
    <input type=hidden name="driverName" value="<%=driverName%>">
	</TD>

    <td><%=SystemEnv.getHtmlLabelName(17651,user.getLanguage())%></td>
    <td class=field>
        <select name="cartypeid" size=1 style="width:80%">
<%
     sql="select * from cartype";
     RecordSet.executeSql(sql);
     while(RecordSet.next()){
        String cartypeid=RecordSet.getString("id");
        String cartypename=RecordSet.getString("name");
%>      <option value="<%=cartypeid%>"><%=cartypename%></option>
<%
     }
%>
        </select>
    </td>
  </tr>
  <TR><TD class=Line colspan=4></TD></TR> 
  <tr>  
    <td><%=SystemEnv.getHtmlLabelName(17666,user.getLanguage())%></td>
    <td class=field>
        <input type=radio name="isholiday" value="0" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio name="isholiday" value="2"><%=SystemEnv.getHtmlLabelName(17667,user.getLanguage())%>
        <input type=radio name="isholiday" value="1"><%=SystemEnv.getHtmlLabelName(516,user.getLanguage())%>
    </td>
  </TR>
  <TR><TD class=Line colspan=4></TD></TR> 
  <TR>
    <!--TD>�س�����</TD>
    <TD class=Field><BUTTON class=Calendar onclick="getBackdate()"></BUTTON>
    <input type=hidden name="backdate" value="">
    <SPAN id=backdatespan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD !-->
    <TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(17657,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type='button' class="Calendar" id="SelectStartDate" onclick="onShowDate(startdatespan,startdate)"></BUTTON> 
		  <SPAN id="startdatespan"><%if (startDate.equals("")) {%><IMG src="/images/BacoError.gif" align="absMiddle">
		  <%} else {%><%=startDate%><%}%></SPAN> 
		  <INPUT type="hidden" name="startdate">  
		  &nbsp;&nbsp;&nbsp;
		  <BUTTON type='button' class="Clock" id="SelectStartTime" onclick="onWorkFlowShowTime(starttimespan,starttime,1)"></BUTTON>
		  <SPAN id="starttimespan"><%if (startTime.equals("")) {%><IMG src="/images/BacoError.gif" align="absMiddle">
		  <%} else{%><%=startTime%><%}%></SPAN>
		  <INPUT type="hidden" name="starttime"></TD>

    <TD><%=SystemEnv.getHtmlLabelName(17658,user.getLanguage())%></TD>
	  <TD class="Field">
		  <BUTTON type='button' class="Clock" id="SelectBackTime" onclick="onWorkFlowShowTime(backtimespan,backtime,1)"></BUTTON>
		  <SPAN id="backtimespan"><%if (backTime.equals("")) {%><IMG src="/images/BacoError.gif" align="absMiddle"><%}else {%><%=backTime%><%}%></SPAN>
		  <INPUT type="hidden" name="backtime"></TD>
  </TR>
  <TR><TD class=Line colspan=4></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17668,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=10 name="startkm" onKeyPress="ItemNum_KeyPress()" 
    onBlur="checknumber1(this);checkinput('startkm','startkmspan')"> km
    <SPAN id=startkmspan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17669,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=10 name="backkm" onKeyPress="ItemNum_KeyPress()" 
    onBlur="checknumber1(this);checkinput('backkm','backkmspan')"> km
    <SPAN id=backkmspan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
  </TR>
  <TR><TD class=Line colspan=4></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17670,user.getLanguage())%></TD>
    <TD class=Field>	  <BUTTON type='button' class="Browser" id="SelectMember" onclick="onShowMultiHrmResourceNeeded('useperson','usepersonspan')"></BUTTON> 
		  <SPAN id="usepersonspan">
		  <A href="/hrm/resource/HrmResource.jsp?id=<%=resourceId%>">
		  <%=Util.toScreen(ResourceComInfo.getResourcename(resourceId),user.getLanguage())%></A></SPAN> 
          <INPUT type="hidden" name="useperson"  id ="useperson" value=<%=useperson%>>
</TD>
    <td><%=SystemEnv.getHtmlLabelName(17671,user.getLanguage())%></td>
               <TD class=Field>
                 <button type='button' class=Browser onClick="onShowDepartment()"></button>
                 <span class=inputstyle id=usedepartmentspan><%if(usedepartment.equals("")){%><IMG src="/images/BacoError.gif" align="absMiddle"><%}else {%><%=Util.toScreen(DepartmentComInfo.getDepartmentname(usedepartment),user.getLanguage())%><%}%></span>
                 <input class=inputstyle id=department type=hidden name=usedepartment value="<%=usedepartment%>">
               </TD>

    

  </TR>
  <TR><TD class=Line colspan=4></TD></TR> 
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(17672,user.getLanguage())%></td>
    <td class=field>
        <input type=checkbox name="iscarout" value="1" checked >
    </td>
    <td><%=SystemEnv.getHtmlLabelName(17673,user.getLanguage())%></td>
    <td class=field>
        <input type=checkbox name="isreception" value="1">
    </td>
  </tr>
  <TR><TD class=Line colspan=2></TD></TR> 
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(17633,user.getLanguage())%></td>
    <td class=field colspan=3>
<%
    sql="select * from carparameter";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        String paraid=RecordSet.getString("id");
        String paraname=RecordSet.getString("name");
%>      <input type=checkbox name="check_para" value="<%=paraid%>"><%=paraname%>&nbsp;
<%
    }
%>    
    </td>
  </tr>
  <TR><TD class=Line colspan=4></TD></TR> 
  <tr>
    <td valign=top><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
    <td class=field colspan=3>
    <textarea class=inputstyle cols=50 rows=5 name="remark" style="width:80%"></textarea>
    </td>
  </tr>
  <TR><TD class=Line colspan=4></TD></TR> 
</form>
</TBODY></TABLE>
			
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





<script language=vbs>
sub onShowDepartment(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/car/UseDepartmentBrowser.jsp?departmentids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					departmentids = id1(0)
					departmentnames = id1(1)
					sHtml = ""
					departmentids = Mid(departmentids,2,len(departmentids))
					document.all(inputename).value= departmentids
					departmentnames = Mid(departmentnames,2,len(departmentnames))
					while InStr(departmentids,",") <> 0
						curid = Mid(departmentids,1,InStr(departmentids,",")-1)
						curname = Mid(departmentnames,1,InStr(departmentnames,",")-1)
						departmentids = Mid(departmentids,InStr(departmentids,",")+1,Len(departmentids))
						departmentnames = Mid(departmentnames,InStr(departmentnames,",")+1,Len(departmentnames))
						sHtml = sHtml&curname&",&nbsp"
					wend
					sHtml = sHtml&departmentnames&"&nbsp"
					document.all(spanname).innerHtml = sHtml
				else
					document.all(spanname).innerHtml ="<IMG src='/images/BacoError.gif' align=absMiddle>"
					document.all(inputename).value=""
				end if
			end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.frmmain.usedepartment.value)
	if Not isempty(id) then
	if id(0)<> 0 then
	usedepartmentspan.innerHtml = id(1)
	document.frmmain.usedepartment.value=id(0)
	else
	usedepartmentspan.innerHtml = ""
	document.frmmain.usedepartment.value=""
	end if
	end if
end sub

sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		driveridspan.innerHtml = "<a href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		document.frmmain.driverid.value=id(0)
        document.frmmain.driverName.value=id(1)
		else
		driveridspan.innerHtml = " <IMG src='/images/BacoError.gif' align=absMiddle>"
		document.frmmain.driverid.value=""
		end if
	end if
end sub
sub onShowMultiHrmResourceNeeded(inputename,spanname)
    tmpids = document.all(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
        if (Not IsEmpty(id1)) then
        if id1(0)<> "" then
          resourceids = id1(0)
          resourcename = id1(1)
          sHtml = ""
          resourceids = Mid(resourceids,2,len(resourceids))
          document.all(inputename).value= resourceids
          resourcename = Mid(resourcename,2,len(resourcename))
          while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
          document.all(spanname).innerHtml = sHtml
          
        else
          document.all(spanname).innerHtml ="<IMG src='/images/BacoError.gif' align=absMiddle>"
          document.all(inputename).value=""
        end if
         end if
end sub

</script>

<script language="javascript">
function onSubmit()
{
    if(check_form(document.frmmain,'startdate,starttime,backtime,startkm,backkm,usedepartment')){
	    document.frmmain.submit();
    }
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime.js"></script>
</HTML>
