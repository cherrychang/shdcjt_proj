<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(6146,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15114,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(800,user.getLanguage())+"-"+ "<a href='/CRM/sellchance/SellAreaCityRpSum.jsp' >"+SystemEnv.getHtmlLabelName(493,user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";

int linecolor=0;
int total=0;

 
int resource=Util.getIntValue(request.getParameter("viewer"),0);
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String sqlwhere="";
String sqlwhere_0="";

if(resource!=0){
	sqlwhere =" and t1.manager="+resource;
    sqlwhere_0 +=" and t1.manager="+resource;
}
if(!fromdate.equals("")){	
    sqlwhere_0 +=" and t3.startDate>='"+fromdate+"'";
}
if(!enddate.equals("")){
    sqlwhere_0 +=" and t3.startDate<='"+enddate+"'";
}

 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

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

<form name=frmmain id=weaver method=post action="SellAreaProRpSum.jsp">

<table class=ViewForm>
<tbody>
<TR class=Spacing><TD colspan=6 class=sep2></TD></TR>
<tr>
    <%if(!user.getLogintype().equals("2")){%>
    <td width=10%><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
    <td class=field ><input  class=wuiBrowser type=hidden name=viewer value="<%=resource%>"
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
    _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name} </a>"
    _displayText="<%=resourcename%>"
    >
    </td>
    <%}%>

    <td width=15%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td >
</TR><tr style="height:2px"><td class=Line colspan=6></td></tr>
</tbody>
</table>

<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="30%">
  <COL align=left width="30%">
  <COL align=left width="10%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=header>
    <TH  colspan=5><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(15248,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>)</TH>
    <TH><%=SystemEnv.getHtmlLabelName(15247,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
    <TR class=Line><TD colSpan=5></TD></TR>
<%
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
    String sql_id ="";
    if(sqlwhere.equals("")){
        sql_id ="select  distinct t2.id conids from CRM_CustomerInfo t1,CRM_Contract t2  ,"+leftjointable+" t3  where  t2.crmId = t3.relateditemid and t2.crmId = t1.id and t1.province <> 0   and t2.status >=2" ;
    }else{
        sql_id ="select  distinct t2.id conids from CRM_CustomerInfo t1,CRM_Contract t2  ,"+leftjointable+" t3  where  t2.crmId = t3.relateditemid and t2.crmId = t1.id and t1.province <> 0   and t2.status >=2" +sqlwhere;
    }
    String C_ids="";
    RecordSet.executeSql(sql_id);
   
    while(RecordSet.next()){
        C_ids += "," + RecordSet.getString("conids");
     
    }
 
    if(!C_ids.equals("")) C_ids = C_ids.substring(1);  
   
    String sql_totel="select sum(price) total  from CRM_Contract where  id in ("+C_ids+") ";
    RecordSet.executeSql(sql_totel);
    RecordSet.next();
    float totel= Util.getFloatValue(RecordSet.getString("total"),0);//计算总业绩

if(totel!=0){
    String sqlstr = "";
    if(sqlwhere_0.equals("")){
	    sqlstr = "select t1.province AS provinceid,COUNT(DISTINCT t1.id) AS crmids ,sum(t3.price) everysum from CRM_customerinfo  t1,HrmProvince  t2 ,CRM_Contract t3 ,"+leftjointable+" t4  where   t3.crmId = t4.relateditemid and t3.crmId = t1.id and  t1.province =t2.id  and t3.status>=2 group by t1.province order by crmids";
    }else{
        sqlstr = "select t1.province AS provinceid,COUNT(DISTINCT t1.id) AS crmids ,sum(t3.price) everysum from CRM_customerinfo  t1,HrmProvince  t2 ,CRM_Contract t3 ,"+leftjointable+" t4  where   t3.crmId = t4.relateditemid and t3.crmId = t1.id and t1.province =t2.id  and t3.status>=2 "+sqlwhere_0+" group by t1.province order by crmids";
    }

	RecordSet.executeSql(sqlstr);
    RecordSet.first();
	do{ 
        String provinceid = RecordSet.getString("provinceid");//某个省份
        int crmsum = Util.getIntValue(RecordSet.getString("crmids"), 0); //客户的个数
        String Display_sum = RecordSet.getString("everysum");
        float sum_every = Util.getFloatValue(RecordSet.getString("everysum"),0);//某个省份的客户的合同的金额的总和       
        float per=sum_every/totel*100;
        per=(float)((int)(per*100))/(float)100;
						float resultpercentOfwidth=0;
						resultpercentOfwidth = per;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;

%>
  <%if(per!=0){%>
    <tr <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%> >
        <td><%=Util.toScreen(ProvinceComInfo.getProvincename(provinceid),user.getLanguage())%></td>
        <td height=100%>
      
            <TABLE height="100%" cellSpacing=0 
                <%if(per==100){%>
                class=redgraph 
                <%}else{%>
                class=greengraph 
                <%}%>
                width="<%=resultpercentOfwidth%>%">                       
            <TBODY>
            <TR>
              <TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>
             </TR>
             </TBODY>
             </TABLE>
              
        </td>
        <td><%if(crmsum != 0){%>
    <a href="/CRM/sellchance/SellAreaResult.jsp?province=<%=provinceid%>&sqlterm=<%=sqlwhere_0%>"><%=crmsum%></a>
    <%} else {%><%=crmsum%><%}%></td>
        <td><%=Display_sum%></td>
        <td><%=per%>%</td>
    </tr>
      <%}%> 
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		}while(RecordSet.next());
	} %>


  </TBODY></TABLE>  </form>
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
  </BODY>
   <SCRIPT language="javascript" src="/js/datetime.js"></script>
   <SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
  <script type="text/javascript">
    function doSearch(){
       jQuery("#weaver").submit();
    }
  </script> 
  <script language=vbs>  
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	viewerspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.viewer.value=id(0)
	else 
	viewerspan.innerHtml = ""
	frmmain.viewer.value=""
	end if
	end if
end sub

</script>
  </HTML>
