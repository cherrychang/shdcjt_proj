<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(575,user.getLanguage());
String needfav ="1";
String needhelp ="";

String optional="sectorinfo";

String sqlstr = "";
String parentid=Util.null2String(request.getParameter("parentid"));
int linecolor=0;
int totalcustomer=0;
float resultpercent=0;
ArrayList sectorids=new ArrayList();

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
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
<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="30%">
  <COL align=left width="40%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
    <TR class=Line><TD colSpan=4></TD></TR>
<%  
	if(parentid.equals(""))	parentid="0";
/*
	RecordSet.executeProc("CRM_SectorInfo_SelectAll",parentid);
	while(RecordSet.next()){
		sectorids.add(RecordSet.getString("id"));
	}
	String tempid="";
	for(int i=0;i<sectorids.size();i++){
		tempid=(String) sectorids.get(i);


	if(user.getLogintype().equals("1")){
		sqlstr="select count(t1.id) as resultcount from CRM_CustomerInfo as t1,CrmShareDetail as t2 where t1.sector in(select id from crm_sectorinfo where id="+tempid+" or sectors like '%,"+tempid+",%') and t1.id = t2.crmid and t2.usertype=1 and t2.userid="+user.getUID();
	}else{
		sqlstr="select count(t1.id) as resultcount from CRM_CustomerInfo as t1 where t1.sector in(select id from crm_sectorinfo where id="+tempid+" or sectors like '%,"+tempid+",%') and t1.agent="+user.getUID();
	}		
		
		RecordSet.executeSql(sqlstr);
		if(RecordSet.next())	totalcustomer+=RecordSet.getInt(1);
	}
*/
    if((RecordSet.getDBType()).equals("oracle")) {
        if(user.getLogintype().equals("1")){
            sqlstr="select t3.id,count(distinct t1.id) as resultcount from CRM_CustomerInfo  t1,"+leftjointable+"  t2,crm_sectorinfo  t3 where  t3.parentid="+parentid+" and t1.id = t2.relateditemid and ((t3.id=t1.sector) or ( t3.sectors like '%,'+To_CHAR(t3.id)+',%' and t3.id=t1.sector)) and t1.deleted = 0 group by t3.id order by resultcount";
        }else{
            sqlstr="select t3.id,count(distinct t1.id) as resultcount from CRM_CustomerInfo  t1,"+leftjointable+"  t2,crm_sectorinfo  t3 where  t3.parentid="+parentid+" and t1.agent="+user.getUID()+" and (( t3.id=t1.sector) or ( t3.sectors like '%,'+To_CHAR(t3.id)+',%' and t3.id=t1.sector)) and t1.deleted = 0 group by t3.id order by resultcount";
        }
     }else if((RecordSet.getDBType()).equals("db2")) {
        if(user.getLogintype().equals("1")){
            sqlstr="select t3.id,count(distinct t1.id) as resultcount from CRM_CustomerInfo  t1,"+leftjointable+"  t2,crm_sectorinfo  t3 where  t3.parentid="+parentid+" and t1.id = t2.relateditemid and ((t3.id=t1.sector) or ( t3.sectors like concat(concat('%,',VARCHAR(t3.id)),',%')  and t3.id=t1.sector)) and t1.deleted = 0 group by t3.id order by resultcount";
        }else{
            sqlstr="select t3.id,count(distinct t1.id) as resultcount from CRM_CustomerInfo  t1,"+leftjointable+"  t2,crm_sectorinfo  t3 where  t3.parentid="+parentid+" and t1.agent="+user.getUID()+" and (( t3.id=t1.sector) or ( t3.sectors like  concat(concat('%,',VARCHAR(t3.id)),',%')  and t3.id=t1.sector)) and t1.deleted = 0 group by t3.id order by resultcount";
        }
	}
    else {
        if(user.getLogintype().equals("1")){
            sqlstr="select t3.id,count(distinct t1.id) as resultcount from CRM_CustomerInfo  t1,"+leftjointable+"  t2,crm_sectorinfo  t3 where  t3.parentid="+parentid+" and t1.id = t2.relateditemid and ((t3.id=t1.sector) or ( t3.sectors like '%,'+convert(varchar,t3.id)+',%' and t3.id=t1.sector)) and t1.deleted = 0 group by t3.id order by resultcount";
        }else{
            sqlstr="select t3.id,count(distinct t1.id) as resultcount from CRM_CustomerInfo  t1,"+leftjointable+"  t2,crm_sectorinfo  t3 where  t3.parentid="+parentid+" and t1.agent="+user.getUID()+" and (( t3.id=t1.sector) or ( t3.sectors like '%,'+convert(varchar,t3.id)+',%' and t3.id=t1.sector)) and t1.deleted = 0 group by t3.id order by resultcount";
        }	
    }

    RecordSet.executeSql(sqlstr);
    
    while(RecordSet.next()){
        totalcustomer+=RecordSet.getInt("resultcount");
    }
		
	PieTeeChart pie=TeeChartFactory.createPieChart(SystemEnv.getHtmlLabelName(16583,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage()),650,300,PieTeeChart.SMS_LabelPercent);
//	pie.isDebug();

	int resultcount=0;
	String resultid="";
	if(RecordSet.first()){
		
	do{
		resultid =RecordSet.getString(1);
		resultcount = RecordSet.getInt(2);
		if(resultcount==0)	continue;
		resultpercent=(float)resultcount*100/(float)totalcustomer;
		resultpercent=(float)((int)(resultpercent*100))/(float)100;
		String labelName=resultid.equals("0")?SystemEnv.getHtmlLabelName(557,user.getLanguage()):Util.toScreen(SectorInfoComInfo.getSectorInfoname(resultid),user.getLanguage());
		pie.addSeries(labelName,resultcount);
	%>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD>
    <%if(resultid.equals("0")){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%>
    <a href="SectorInfoRpSum.jsp?parentid=<%=resultid%>">
    <%=Util.toScreen(SectorInfoComInfo.getSectorInfoname(resultid),user.getLanguage())%></a><%}%></TD>
    <TD>
      <TABLE height="100%" cellSpacing=0 width="100%">
        <TBODY>
        <TR>
          <TD class=redgraph <%if(resultpercent<1){%>width="1%"<%} else {%>
          width="<%=resultpercent%>%"<%}%>>&nbsp;</TD>
          <TD>&nbsp;</TD></TR></TBODY></TABLE></TD>
    <TD>
    <%if(resultcount!=0){%><a href="/CRM/search/SearchOperation.jsp?msg=report&settype=sectorinfo&id=<%=resultid%>"><%=resultcount%></a>
    <%} else {%><%=resultcount%><%}%></TD>
    <TD><%=resultpercent%>%</TD>
    </TR>
    <%	  if(linecolor==0) linecolor=1;
    		else	linecolor=0; 
    	  }while(RecordSet.next());
	} %>
  </TBODY></TABLE>
  <br>
  <div class="chart">
  <%
	if ("true".equals(isIE)){
		if(pie!=null)pie.print(out); 
	}else{   %>
	<p height="100%" width="100%" align="center" style="color:red;font-size:14px;">
				您当前使用的浏览器不支持【报表视图】，如需使用该功能，请使用IE浏览器！
	</p>
	<%} %>	
  </div>
<br>
 
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
  </BODY></HTML>
