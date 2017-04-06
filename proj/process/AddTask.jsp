<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%

int sign = Util.getIntValue(request.getParameter("sign"),-1);
if(sign!=-1){//如果从计算天数的页面返回的话
String taskrecordid = request.getParameter("taskrecordid");
String ProjID=Util.null2String(request.getParameter("ProjID"));
String parentid=Util.null2String(request.getParameter("parentid"));
String parentids=Util.null2String(request.getParameter("parentids"));
String parenthrmids=Util.null2String(request.getParameter("parenthrmids"));
String hrmid=Util.null2String(request.getParameter("hrmid"));
String oldhrmid=Util.null2String(request.getParameter("oldhrmid"));
String finish=Util.null2String(request.getParameter("finish"));
String level=Util.null2String(request.getParameter("level"));
String subject=Util.null2String(request.getParameter("subject"));
String begindate=Util.null2String(request.getParameter("begindate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String workday=Util.null2String(request.getParameter("workday"));
String fixedcost=Util.null2String(request.getParameter("fixedcost"));
String islandmark=Util.null2String(request.getParameter("islandmark"));
String pretaskid=Util.null2String(request.getParameter("taskids02"));
String content=Util.null2String(request.getParameter("content"));

// added by lupeng 2004-07-21
String realManDays = Util.null2String(request.getParameter("realmandays"));
// end

String logintype = ""+user.getLogintype();

/*项目状态*/
String isCurrentActived="";
RecordSet rs = new RecordSet();
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID+" order by id";
rs.executeSql(sql_tatus);
if(rs.next())
 isCurrentActived=rs.getString("isactived");
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划
String status_prj="" ;
String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
rs.executeSql(sql_prjstatus);
if(rs.next())
 status_prj=rs.getString("status");

if(isCurrentActived.equals("2")&&(status_prj.equals("3")||status_prj.equals("4"))){//项目冻结或者项目完成
	response.sendRedirect("ViewProcess.jsp?ProjID="+ProjID);
}

//String pretaskid=RecordSet.getString("prefinish");
String taskname="";
if(!pretaskid.equals("0")){
    ArrayList pretaskids = Util.TokenizerString(pretaskid,",");
    int taskidnum = pretaskids.size();
    for(int j=0;j<taskidnum;j++){
    String sql_1="select subject from Prj_TaskProcess where id = "+pretaskids.get(j);
    RecordSet3.executeSql(sql_1);
    RecordSet3.next();
    taskname +="<a href=/proj/process/ViewTask.jsp?taskrecordid="+pretaskids.get(j)+">"+ RecordSet3.getString("subject")+ "</a>" +" ";

    }
}

/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

String ViewSql="select * from PrjShareDetail where prjid="+ProjID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

RecordSetV.executeSql(ViewSql);

if(RecordSetV.next())
{
	 canview=true;
	 if(RecordSetV.getString("usertype").equals("2")){
	 	iscustomer=RecordSetV.getString("sharelevel");
	 }else{
		 if(RecordSetV.getString("sharelevel").equals("2")){
			canedit=true;
			ismanager=true;
		 }else if (RecordSetV.getString("sharelevel").equals("3")){
			canedit=true;
			ismanagers=true;
		 }else if (RecordSetV.getString("sharelevel").equals("4")){
			canedit=true;
			isrole=true;
		 }else if (RecordSetV.getString("sharelevel").equals("5")){
			ismember=true;
		 }else if (RecordSetV.getString("sharelevel").equals("1")){
			isshare=true;
		 }
	 }
}




/*权限－end*/
/*
	boolean isResponser=false;
int level=0;
if(parentid.equals("")) {
	parentid="0";
} else {
	RecordSet.executeProc("Prj_TaskProcess_SelectByID",parentid);
	if(RecordSet.next()){
		begindate = RecordSet.getString("begindate");
		enddate = RecordSet.getString("enddate");
		workday = RecordSet.getString("workday");
		parentids = RecordSet.getString("parentids");
		parenthrmids = RecordSet.getString("parenthrmids");
		hrmid = RecordSet.getString("hrmid");
		level = RecordSet.getInt("level_n");

		if( RecordSet.getString("parenthrmids").indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
		  isResponser=true;
		}
	}
}
if(level==0){
	level=1;
}
else {
	level += 1;
}


if(!canedit ){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}*/
%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",/proj/process/ViewProcess.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=weaver action="/proj/process/TaskOperation.jsp" method=post>
  <input type="hidden" name="method" value="add">
    <input type="hidden" name="type" value="process">
  <input type="hidden" name="ProjID" value="<%=ProjID%>">
  <input type="hidden" name="parentid" value="<%=parentid%>">
  <input type="hidden" name="parentids" value="<%=parentids%>">
  <input type="hidden" name="parenthrmids" value="<%=parenthrmids%>">
  <input type="hidden" name="level" value="<%=level%>">
    <input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">




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
  <COLGROUP>
  <COL width="49%">
  <COL width="10">
  <COL width="49%">
  <TBODY>
  <TR class=spacing>
    <TD class=line1 colSpan=3></TD>
  </TR>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="30%">
  	  <COL width="70%">
        <TBODY>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=80 size=34 name="subject" onChange="checkinput('subject','subjectspan')"  value="<%=subject%>"> <span
            id=subjectspan>
              <%if(subject.equals("")){%>
              <IMG src='/images/BacoError.gif' align=absMiddle>
              <%}%>
              </span> </TD>
         </TR> <TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=SelectHrmid onClick="onShowHrmid()"></BUTTON> <span
            id=Hrmidspan>
			<%if(!hrmid.equals("")){%>
				<%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=hrmid%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(hrmid),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
			<%}else{%>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			<%}%>
			</span>
              <INPUT class=inputstyle type=hidden name="hrmid" value="<%=hrmid%>">
             </TD>
        </TR><TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getProjBDate()"></BUTTON>
              <SPAN id=begindatespan >
				  <%if(!begindate.equals("x")){%>
						<%=begindate%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="begindate" id="begindate" value="<%=begindate%>">

          </TD>
        </TR><TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getProjEDate()"></BUTTON>
              <SPAN id=enddatespan >
				  <%if(!enddate.equals("-")){%>
						<%=enddate%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="enddate" id="enddate" value="<%=enddate%>"></TD>
         </TR><TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="workday" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("workday");onWorkDayChange("workday","begindate","begindatespan","enddate","enddatespan")' value="<%=workday%>"><SPAN id=workdayimage></SPAN></TD>
         </TR><TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>

  <!--added by lupeng 2004-07-21-->
  <TR>
         <TD><%=SystemEnv.getHtmlLabelName(17501,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="realmandays" value="<%=realManDays%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("realmandays")'>
                            </TD>
         </TR>  <TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
  <!--end-->

         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=18 size=18 name="fixedcost" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fixedcost")' value="<%=fixedcost%>">元<SPAN id=workdayimage></SPAN></TD>
         </TR><TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TD>
          <TD class=Field>
          	<button class=Browser onclick="onShowMTask('taskids02span','taskids02','ProjID','taskrecordid')"></button>
			<input type=hidden name="taskids02" value="<%=pretaskid%>">
			<span id="taskids02span">
              <%=taskname%>
            </span>
		  </TD>
        </TR><TR class=spacing>
    <TD class=line1 colSpan=2></TD>
  </TR>
	  </TABLE>
	</TD>
	<TD></TD>
	<TD vAlign=top>
	 <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="100%">
         <TR>
           <TD ><%=SystemEnv.getHtmlLabelName(2240,user.getLanguage())%></TD>
		 </TR>
		 <TR>
           <TD class=Field><TEXTAREA class=inputstyle name="content" ROWS=8 STYLE="width:100%" value="<%=content%>"><%=content%></TEXTAREA>
         </TR>
     </TABLE>
	</TD>
   </TR>
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

</FORM>
<script language=vbs>
sub onShowHrmid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/ResourceBrowser_proj.jsp?ProjID=<%=ProjID%>")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Hrmidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.hrmid.value=id(0)
	else
	Hrmidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	weaver.hrmid.value=""
	end if
	end if
end sub


sub onShowMTask(spanname,inputename,prj,task)
        ProjID = document.all(prj).value
        taskrecordid = document.all(task).value
		taskids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/SingleTaskBrowser.jsp?taskids="&taskids&"&ProjID="&ProjID&"&taskrecordid="&taskrecordid)
        if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					task_ids = id1(0)
					taskname = id1(1)
					sHtml = ""
					task_ids = Mid(task_ids,2,len(task_ids))
					document.all(inputename).value= task_ids
					taskname = Mid(taskname,2,len(taskname))
					while InStr(task_ids,",") <> 0
						curid = Mid(task_ids,1,InStr(task_ids,",")-1)
						curname = Mid(taskname,1,InStr(taskname,",")-1)
						task_ids = Mid(task_ids,InStr(task_ids,",")+1,Len(task_ids))
						taskname = Mid(taskname,InStr(taskname,",")+1,Len(taskname))
						sHtml = sHtml&"<a href=/proj/process/ViewTask.jsp?taskrecordid="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/proj/process/ViewTask.jsp?taskrecordid="&task_ids&">"&taskname&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
         end if
end sub
</script>

 <script language="javascript">
oldbegindate="";
oldenddate="";
setTimeout("CaculateWorkDay();",50);
function CaculateWorkDay(){
	begindate = document.all("begindate").value;
	enddate = document.all("enddate").value;
	if((begindate!=oldbegindate||enddate!=oldenddate)&&begindate!=""&&enddate!="" && begindate != null && enddate != null){
		oldbegindate = begindate;
		oldenddate = enddate;
		begindateY = begindate.substring(0,begindate.indexOf("-"));
		begindateM = begindate.substring(begindate.indexOf("-")+1,begindate.lastIndexOf("-"))-1;
		begindateD = begindate.substring(begindate.lastIndexOf("-")+1);
		enddateY = enddate.substring(0,enddate.indexOf("-"));
		enddateM = enddate.substring(enddate.indexOf("-")+1,enddate.lastIndexOf("-"))-1;
		enddateD = enddate.substring(enddate.lastIndexOf("-")+1);
		bd = new Date(begindateY,begindateM,begindateD);
		ed = new Date(enddateY,enddateM,enddateD);
		diffdays = Math.floor((ed.valueOf()-ed.getTimezoneOffset()*60000)/(3600*24000))-Math.floor((bd.valueOf()-bd.getTimezoneOffset()*60000)/(3600*24000))+1;
		document.all("workday").value = diffdays;
	}
	setTimeout("CaculateWorkDay();",50);
} 
function onWorkDayChange(workLongObj,beginDateObj,spanBeginDateObj,endDateObj,spanEndDateObj){
	workLong = document.all(workLongObj).value
	beginDate = document.all(beginDateObj).value
	endDate = document.all(endDateObj).value
	
	if(workLong!=""&&beginDate!=""){
		newDate = getAddNewDateStr(beginDate,workLong);
		document.all(spanEndDateObj).innerHTML=newDate;
		document.all(endDateObj).value=newDate;
		return;
	}

	if (workLong!=""&&endDate!=""){
		newDate = getSubtrNewDateStr(endDate,workLong);
		document.all(spanBeginDateObj).innerHTML=newDate;
		document.all(beginDateObj).value=newDate;
		return;
	}
}
function submitData()
{if (check_form(weaver,'subject,hrmid')&&checkDateRange(weaver.begindate,weaver.enddate,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")) {
		document.body.onbeforeunload = null;//by cyril on 2008-06-24 for TD:8828
		weaver.submit();
	}
}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript"  type='text/vbScript' src="/js/projTask/ProjTask.vbs"></SCRIPT> 
</HTML>





<%}else{//其它地方来的
String ProjID = Util.null2String(request.getParameter("ProjID"));
String taskrecordid="";

/*项目状态*/
RecordSet rs2 = new RecordSet();
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID+"order by id";
rs2.executeSql(sql_tatus);
rs2.next();
String isCurrentActived=rs2.getString("isactived");
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划

String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
rs2.executeSql(sql_prjstatus);
rs2.next();
String status_prj=rs2.getString("status");
System.out.println("isactived:"+isCurrentActived);
System.out.println("status_prj:"+status_prj);
if(isCurrentActived.equals("2")&&(status_prj.equals("3")||status_prj.equals("4"))){//项目冻结或者项目完成
	response.sendRedirect("ViewProcess.jsp?ProjID="+ProjID);
}

String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

String ViewSql="select * from PrjShareDetail where prjid="+ProjID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

RecordSetV.executeSql(ViewSql);

if(RecordSetV.next())
{
	 canview=true;
	 if(RecordSetV.getString("usertype").equals("2")){
	 	iscustomer=RecordSetV.getString("sharelevel");
	 }else{
		 if(RecordSetV.getString("sharelevel").equals("2")){
			canedit=true;
			ismanager=true;
		 }else if (RecordSetV.getString("sharelevel").equals("3")){
			canedit=true;
			ismanagers=true;
		 }else if (RecordSetV.getString("sharelevel").equals("4")){
			canedit=true;
			isrole=true;
		 }else if (RecordSetV.getString("sharelevel").equals("5")){
			ismember=true;
		 }else if (RecordSetV.getString("sharelevel").equals("1")){
			isshare=true;
		 }
	 }
}




/*权限－end*/
	boolean isResponser=false;
String parentid = Util.null2String(request.getParameter("parentid"));

String begindate = "";
String enddate = "";
String workday = "";
String parentids = "";
String parenthrmids = "";
String fixedcost = "";
String hrmid = "";
String pretask="";

String realManDays = "";

int level = 0;
if(parentid.equals("")) {
	parentid="0";
} else {
	RecordSet.executeProc("Prj_TaskProcess_SelectByID",parentid);
	if(RecordSet.next()){
		begindate = RecordSet.getString("begindate");
		enddate = RecordSet.getString("enddate");
		workday = RecordSet.getString("workday");
		parentids = RecordSet.getString("parentids");
		parenthrmids = RecordSet.getString("parenthrmids");
		hrmid = RecordSet.getString("hrmid");
		level = RecordSet.getInt("level_n");
        realManDays = RecordSet.getString("realManDays");

		if( RecordSet.getString("parenthrmids").indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
		  isResponser=true;
		}
	}

    //  新建子任务的时候计算workday
    try {
        int i;
        int frombackyear = Util.getIntValue(begindate.substring(0,4)) ; //开始的年份
        int frombackmonth = Util.getIntValue(begindate.substring(5,7)) ; //开始的月份
        int frombackday = Util.getIntValue(begindate.substring(8,10)); //开始的天数

        if(enddate.compareTo(begindate)==0){
            i=1;
        }else{

            Calendar thedate1 = Calendar.getInstance ();
            thedate1.set(frombackyear,frombackmonth-1,frombackday) ;
            for(i=1;;i++){
                thedate1.add(Calendar.DATE, 1) ; //增加天数
                String forecastStartDate = Util.add0(thedate1.get(Calendar.YEAR), 4) +"-"+
                           Util.add0(thedate1.get(Calendar.MONTH) + 1, 2) +"-"+
                           Util.add0(thedate1.get(Calendar.DAY_OF_MONTH), 2) ;
                if(enddate.compareTo(forecastStartDate) <=0)
                    break;
            }
            i=i+1;
        }
        workday= "" + i;
    } catch (Exception e) {
        //do nothing
    }
}
if(level==0){
	level=1;
}
else {
	level += 1;
}


if(!canedit && !isResponser){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",ViewProcess.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=weaver action="/proj/process/TaskOperation.jsp" method=post>

  <input type="hidden" name="method" value="add">
    <input type="hidden" name="type" value="process">
  <input type="hidden" name="ProjID" value="<%=ProjID%>">
  <input type="hidden" name="parentid" value="<%=parentid%>">
  <input type="hidden" name="parentids" value="<%=parentids%>">
  <input type="hidden" name="parenthrmids" value="<%=parenthrmids%>">
  <input type="hidden" name="level" value="<%=level%>">
    <input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
    <input type="hidden" name="isResponser" value="<%=isResponser%>">
<TABLE class=viewform>
  <COLGROUP>
  <COL width="49%">
  <COL width="10">
  <COL width="49%">
  <TBODY>

  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="30%">
  	  <COL width="70%">
        <TBODY>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=80 size=34 name="subject" onChange="checkinput('subject','subjectspan')"> <span
            id=subjectspan>
              <IMG src='/images/BacoError.gif' align=absMiddle>
              </span> </TD>
         </TR> <TR><TD class=Line colSpan=2></TD></TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=SelectHrmid onClick="onShowHrmid()"></BUTTON> <span
            id=Hrmidspan>
			<%if(!hrmid.equals("")){%>
				<%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(hrmid),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
			<%}else{%>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			<%}%>
			</span>
              <INPUT class=inputstyle type=hidden name="hrmid" value="<%=hrmid%>">
             </TD>
        </TR>
		<TR><TD class=Line colSpan=2></TD></TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getProjBDate()"></BUTTON>
              <SPAN id=begindatespan >
				  <%if(!begindate.equals("x")){%>
						<%=begindate%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="begindate" id="begindate" value="<%=begindate%>">

          </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getProjEDate()"></BUTTON>
              <SPAN id=enddatespan >
				  <%if(!enddate.equals("-")){%>
						<%=enddate%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="enddate" id="enddate" value="<%=enddate%>">

          </TD>
         </TR><TR><TD class=Line colSpan=2></TD></TR>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="workday" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("workday");onWorkDayChange("workday","begindate","begindatespan","enddate","enddatespan")' value="<%=workday%>"><SPAN id=workdayimage></SPAN></TD>
         </TR><TR><TD class=Line colSpan=2></TD></TR>
         <!--added by lupeng 2004-07-21-->
  <TR>
         <TD><%=SystemEnv.getHtmlLabelName(17501,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="realmandays" value="<%=realManDays%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("realmandays")'>
                            </TD>
         </TR>  <TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
  <!--end-->
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=18 size=18 name="fixedcost" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fixedcost")' value="<%=fixedcost%>">元<SPAN id=workdayimage></SPAN></TD>
         </TR><TR><TD class=Line colSpan=2></TD></TR>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TD>
          <TD class=Field>
          	<button class=Browser onclick="onShowMTask('taskids02span','taskids02','ProjID','taskrecordid')"></button>
			<input type=hidden name="taskids02" value="">
			<span id="taskids02span">
            </span>
		  </TD>
        </TR><TR><TD class=Line colSpan=2></TD></TR>
	  </TABLE>
	</TD>
	<TD></TD>
	<TD vAlign=top>
	 <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="100%">
         <TR>
           <TD ><%=SystemEnv.getHtmlLabelName(2240,user.getLanguage())%></TD>
		 </TR>
		 <TR>
           <TD class=Field><TEXTAREA class=inputstyle name="content" ROWS=8 STYLE="width:100%" ></TEXTAREA>
         </TR>
     </TABLE>
	</TD>
   </TR>
   </TBODY>
</TABLE>


</FORM>
<script type="text/javascript">

function onShowHrmid(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/ResourceBrowser_proj.jsp?ProjID=<%=ProjID%>");
	if (data){
		if (data.id){
			$("#Hrmidspan").html( "<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>");
			$("input[name=hrmid]").val(data.id);
		}else{
			$("#Hrmidspan").html("");
			$("input[name=hrmid]").val("");
		}
	}
}



function onShowMTask(spanname,inputename,prj,task){
        ProjID = $("input[name="+prj+"]").val();
        taskrecordid = $("input[name="+task+"]").val();
		taskids = $("input[name="+inputename+"]").val();
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/SingleTaskBrowser.jsp?taskids="+taskids+"&ProjID="+ProjID+"&taskrecordid="+taskrecordid);
        if (data){
				if(data.id){
					task_ids = data.id.split(",");
					taskname = data.name.split(",");
					sHtml="";
					for(var i=0;i<task_ids.length;i++){
						if(task_ids[i]){
							sHtml = sHtml+"<a href=/proj/process/ViewTask.jsp?taskrecordid="+task_ids[i]+">"+taskname[i]+"</a>&nbsp";
						}
					}
					$("#"+spanname).html( sHtml);
					$("input[name="+inputename+"]").val(data.id);
				}else{
					$("#"+spanname).html( "");
					$("input[name="+inputename+"]").val("");
				}
	}
}


</script>
 <script language="javascript">
oldbegindate="";
oldenddate="";
setTimeout("CaculateWorkDay();",50);
function CaculateWorkDay(){
	begindate = document.all("begindate").value;
	enddate = document.all("enddate").value;
	if((begindate!=oldbegindate||enddate!=oldenddate)&&begindate!=""&&enddate!="" && begindate != null && enddate != null){
		oldbegindate = begindate;
		oldenddate = enddate;
		begindateY = begindate.substring(0,begindate.indexOf("-"));
		begindateM = begindate.substring(begindate.indexOf("-")+1,begindate.lastIndexOf("-"))-1;
		begindateD = begindate.substring(begindate.lastIndexOf("-")+1);
		enddateY = enddate.substring(0,enddate.indexOf("-"));
		enddateM = enddate.substring(enddate.indexOf("-")+1,enddate.lastIndexOf("-"))-1;
		enddateD = enddate.substring(enddate.lastIndexOf("-")+1);
		bd = new Date(begindateY,begindateM,begindateD);
		ed = new Date(enddateY,enddateM,enddateD);
		diffdays = Math.floor((ed.valueOf()-ed.getTimezoneOffset()*60000)/(3600*24000))-Math.floor((bd.valueOf()-bd.getTimezoneOffset()*60000)/(3600*24000))+1;
		document.all("workday").value = diffdays;
	}
	setTimeout("CaculateWorkDay();",50);
} 
function onWorkDayChange(workLongObj,beginDateObj,spanBeginDateObj,endDateObj,spanEndDateObj){
	workLong = document.all(workLongObj).value
	beginDate = document.all(beginDateObj).value
	endDate = document.all(endDateObj).value
	
	if(workLong!=""&&beginDate!=""){
		newDate = getAddNewDateStr(beginDate,workLong);
		document.all(spanEndDateObj).innerHTML=newDate;
		document.all(endDateObj).value=newDate;
		return;
	}

	if (workLong!=""&&endDate!=""){
		newDate = getSubtrNewDateStr(endDate,workLong);
		document.all(spanBeginDateObj).innerHTML=newDate;
		document.all(beginDateObj).value=newDate;
		return;
	}
}
function submitData()
{if (check_form(weaver,'subject,hrmid')&&checkDateRange(weaver.begindate,weaver.enddate,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")) {
		document.body.onbeforeunload = null;//by cyril on 2008-06-24 for TD:8828
		weaver.submit();
	}
}
</script>

</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript"  type='text/vbScript' src="/js/projTask/ProjTask.vbs"></SCRIPT> 
</HTML>
<%}%>
<%@include file="/hrm/include.jsp"%>
<!-- added by cyril on 2008-06-13 for TD:8828 -->
<script>
function protectTask() {
	if(!checkDataChange())
  	event.returnValue="<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
}
document.body.onbeforeunload=function () {protectTask();}
</script>
<script language=javascript src="/js/checkData.js"></script>
<!-- end by cyril on 2008-06-13 for TD:8828 -->