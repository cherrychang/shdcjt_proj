<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<BODY>
<%
String scope = Util.null2String(request.getParameter("scope"));
String subcompanyid = Util.null2String(request.getParameter("subc"));
String scopetype = Util.null2String(request.getParameter("st"));
String scopevalue = Util.null2String(request.getParameter("sv"));

String supids=SubCompanyComInfo.getAllSupCompany(subcompanyid);
String sqlwhere = "";
String sqlwhere2 = "";
String sqlwhere1="";
if(scope.equals("0")){
  sqlwhere = " select * from HrmSalaryItem where applyscope=0";
  sqlwhere2 = " select * from hrmschedulediff where salaryable!=1 and workflowid=5 and diffscope=0";
}
else if(scope.equals("1")){
    if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
  sqlwhere = " select * from HrmSalaryItem where applyscope=0 or (applyscope>0 and subcompanyid="+subcompanyid+") or (applyscope=2 and subcompanyid in("+supids+"))";
   sqlwhere2 = " select * from hrmschedulediff where salaryable!=1 and workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subcompanyid+") or (diffscope=2 and subcompanyid in("+supids+")))";
    }else{
  sqlwhere = " select * from HrmSalaryItem where applyscope=0 or (applyscope>0 and subcompanyid="+subcompanyid+")";
  sqlwhere2 = " select * from hrmschedulediff where salaryable!=1 and workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subcompanyid+"))";
    }
}else if(scope.equals("2")){
    if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
  sqlwhere = " select * from HrmSalaryItem where applyscope=0 or (applyscope=2 and subcompanyid in("+supids+","+subcompanyid+"))";
  sqlwhere2 = " select * from hrmschedulediff where salaryable!=1 and workflowid=5 and (diffscope=0 or (diffscope=2 and subcompanyid in("+supids+","+subcompanyid+")))";
    }else{
  sqlwhere = " select * from HrmSalaryItem where applyscope=0 or (applyscope=2 and subcompanyid="+subcompanyid+")";
  sqlwhere2 = " select * from hrmschedulediff where salaryable!=1 and workflowid=5 and (diffscope=0 or (diffscope=2 and subcompanyid="+subcompanyid+"))";
    }
}
   // System.out.println(sqlwhere);
rs.execute(sqlwhere);

   //System.out.println(sqlwhere);
rs2.execute(sqlwhere2);

ArrayList targetid=new ArrayList();
ArrayList targetname=new ArrayList();
if(scopetype.equals("0")){//全部
   if(scope.equals("0"))
  sqlwhere1 = " select b.* from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=0";
else if(scope.equals("1")){
    if(supids.length()>0){
  sqlwhere1 = " select b.* from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and (b.areatype=0 or (b.areatype=3  and a.companyordeptid="+subcompanyid+") or (b.areatype=1  and b.subcompanyid="+subcompanyid+") or (b.areatype=2 and b.subcompanyid in("+supids+","+subcompanyid+")))";
    }else
  sqlwhere1 = " select b.* from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and (b.areatype=0 or (b.areatype=3 and a.companyordeptid="+subcompanyid+") or (b.areatype=1  and b.subcompanyid="+subcompanyid+") or (b.areatype=2  and b.subcompanyid="+subcompanyid+"))";
}else if(scope.equals("2")){
    if(supids.length()>0){
  sqlwhere1 = " select b.* from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and (b.areatype=0 or (b.areatype=2 and b.subcompanyid in("+supids+","+subcompanyid+")))";
    }else
  sqlwhere1 = " select b.* from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and (b.areatype=0 or (b.areatype=2 and b.subcompanyid="+subcompanyid+"))";
}
rs1.executeSql(sqlwhere1);
 while (rs1.next()) {
                targetid.add(rs1.getString("id"));
                targetname.add(rs1.getString("targetname"));
        }
}else if(scopetype.equals("2")) {//分部
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype<2";
    rs1.executeSql(sqlwhere1);
    if (scopevalue.indexOf(",") > 0) {

        while (rs1.next()) {
            if (rs1.getString("areatype").equals("0")) {
                targetid.add(rs1.getString("id"));
                targetname.add(rs1.getString("targetname"));
            }
        }
    } else {
        while (rs1.next()) {
            if (rs1.getString("areatype").equals("0") || rs1.getString("subcompanyid").equals(scopevalue)) {
                targetid.add(rs1.getString("id"));
                targetname.add(rs1.getString("targetname"));
            }
        }
    }
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=2";
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        String subid = rs1.getString("subcompanyid");
        ArrayList allsubcoms = new ArrayList();
        allsubcoms.add(subid);
        SubCompanyComInfo.getSubCompanyLists(subid, allsubcoms);
        if (allsubcoms.containsAll(Util.TokenizerString(scopevalue, ","))) {
            targetid.add(rs1.getString("id"));
            targetname.add(rs1.getString("targetname"));
        }

    }
    sqlwhere1 = "select b.id,b.targetname from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=3 and a.companyordeptid in (" + scopevalue + ") group by b.id,b.targetname having count(a.companyordeptid)=" + Util.TokenizerString(scopevalue, ",").size();
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
                targetid.add(rs1.getString("id"));
                targetname.add(rs1.getString("targetname"));
        }
}else if(scopetype.equals("3")) {//部门
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=0";
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=1";
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        String subid = rs1.getString("subcompanyid");
        ArrayList depts = new ArrayList();
        while (DepartmentComInfo.next()) {
            if (DepartmentComInfo.getSubcompanyid1().equals(subid))
                depts.add(DepartmentComInfo.getDepartmentid());
        }
        if (depts.containsAll(Util.TokenizerString(scopevalue, ","))) {
            targetid.add(rs1.getString("id"));
            targetname.add(rs1.getString("targetname"));
        }
    }
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=2";
    rs1.executeSql(sqlwhere1);
    ArrayList arr_subids = new ArrayList();
    ArrayList arr_scopevalue = Util.TokenizerString(scopevalue, ",");
    for (Iterator iter = arr_scopevalue.iterator(); iter.hasNext();) {
        String thesubcomid = DepartmentComInfo.getSubcompanyid1((String) iter.next());
        if (!arr_subids.contains(thesubcomid))
            arr_subids.add(thesubcomid);
    }
    String subids = "";
    for (Iterator iter = arr_subids.iterator(); iter.hasNext();) {
        if (subids.equals(""))
            subids = subids + (String) iter.next();
        else
            subids = subids + "," + (String) iter.next();
    }

    while (rs1.next()) {
        String subid = rs1.getString("subcompanyid");
        ArrayList allsubcoms = new ArrayList();
        allsubcoms.add(subid);
        SubCompanyComInfo.getSubCompanyLists(subid, allsubcoms);
        if (allsubcoms.containsAll(Util.TokenizerString(subids, ","))) {
            targetid.add(rs1.getString("id"));
            targetname.add(rs1.getString("targetname"));
        }

    }
    sqlwhere1 = "select b.id,b.targetname from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=3 and a.companyordeptid in (" + subids + ") group by b.id,b.targetname having count(a.companyordeptid)=" + Util.TokenizerString(subids, ",").size();
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }
    sqlwhere1 = "select b.id,b.targetname from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=4 and a.companyordeptid in (" + scopevalue + ") group by b.id,b.targetname having count(a.companyordeptid)=" + Util.TokenizerString(scopevalue, ",").size();
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }
}else if(scopetype.equals("4")){//人力资源

    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=0";
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=1";
    rs1.executeSql(sqlwhere1);
    ArrayList arr_deptids=new ArrayList();
    ArrayList arr_scopevalue = Util.TokenizerString(scopevalue, ",");
    for (Iterator iter = arr_scopevalue.iterator(); iter.hasNext();) {
        String thedeptid = ResourceComInfo.getDepartmentID((String)iter.next());
        if (!arr_deptids.contains(thedeptid))
            arr_deptids.add(thedeptid);
    }
    String deptids = "";
    for (Iterator iter = arr_deptids.iterator(); iter.hasNext();) {
        if (deptids.equals(""))
            deptids = deptids + (String) iter.next();
        else
            deptids = deptids + "," + (String) iter.next();
    }
    while (rs1.next()) {
        String subid = rs1.getString("subcompanyid");
        ArrayList depts = new ArrayList();
        while (DepartmentComInfo.next()) {
            if (DepartmentComInfo.getSubcompanyid1().equals(subid))
                depts.add(DepartmentComInfo.getDepartmentid());
        }
        if (depts.containsAll(Util.TokenizerString(deptids, ","))) {
            targetid.add(rs1.getString("id"));
            targetname.add(rs1.getString("targetname"));
        }
    }
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=2";
    rs1.executeSql(sqlwhere1);
    ArrayList arr_subids = new ArrayList();
    for (Iterator iter = arr_deptids.iterator(); iter.hasNext();) {
        String thesubcomid = DepartmentComInfo.getSubcompanyid1((String) iter.next());
        if (!arr_subids.contains(thesubcomid))
            arr_subids.add(thesubcomid);
    }
    String subids = "";
    for (Iterator iter = arr_subids.iterator(); iter.hasNext();) {
        if (subids.equals(""))
            subids = subids + (String) iter.next();
        else
            subids = subids + "," + (String) iter.next();
    }

    while (rs1.next()) {
        String subid = rs1.getString("subcompanyid");
        ArrayList allsubcoms = new ArrayList();
        allsubcoms.add(subid);
        SubCompanyComInfo.getSubCompanyLists(subid, allsubcoms);
        if (allsubcoms.containsAll(Util.TokenizerString(subids, ","))) {
            targetid.add(rs1.getString("id"));
            targetname.add(rs1.getString("targetname"));
        }

    }
    sqlwhere1 = "select b.id,b.targetname from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=3 and a.companyordeptid in (" + subids + ") group by b.id,b.targetname having count(a.companyordeptid)=" + Util.TokenizerString(subids, ",").size();
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }
    sqlwhere1 = "select b.id,b.targetname from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=4 and a.companyordeptid in (" + deptids + ") group by b.id,b.targetname having count(a.companyordeptid)=" + Util.TokenizerString(scopevalue, ",").size();
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }

}
%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%      RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btok(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btclear(),_self} " ;
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
<td></td>
<td valign="top">
<form name="weaver">
<TABLE class=Shadow>
<COLGROUP> <COL width="30%"> <COL width="30%"> <COL width="40%"><TBODY> 
<tr>
<td valign="top" >
<table>
<b>个人设置</b>
<hr>
 <tr><td><%=SystemEnv.getHtmlLabelName(15815,user.getLanguage())%></td></tr>
    <tr><td>
<select  name="checks0" onchange="getText0()">
<option></option>
<%while(rs.next()){
if(!rs.getString("itemtype").equals("9")){%>
<option value='<%=rs.getString("id")%>' alias='<%=rs.getString("itemcode")%>'><%=rs.getString("itemname")%></option>
<%}else{%>
<option value='<%=rs.getString("id")+"_1"%>' alias='<%=rs.getString("itemcode")+"_1"%>'><%=rs.getString("itemname")+"("+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+")"%></option>
<option value='<%=rs.getString("id")+"_2"%>' alias='<%=rs.getString("itemcode")+"_2"%>'><%=rs.getString("itemname")+"("+SystemEnv.getHtmlLabelName(1851,user.getLanguage())+")"%></option>
<%}%>
<%}%>
</select>
</td>
<td class=Field>
</td>
<td class=Field></td>
</tr>
</table>
<table>
 <tr><td><%=SystemEnv.getHtmlLabelName(19397,user.getLanguage())%></td></tr>
    <tr><td>
<select  name="checks" onchange="getText()">
<option></option>
<%while(rs2.next()){%>
<option value='<%=rs2.getString("id")%>'><%=rs2.getString("diffname")%></option>
<%}%>
</select>
</td>
<td class=Field>
</td>
<td class=Field></td>
</tr>
</table>
<table>
 <tr><td id=countsalary onclick="getText2()" style="cursor:pointer;"><%=SystemEnv.getHtmlLabelName(19378,user.getLanguage())%></td></tr>
    <tr><td>
</table>
<table>
<tr><td nowrap><%=SystemEnv.getHtmlLabelName(19454,user.getLanguage())+SystemEnv.getHtmlLabelName(19482,user.getLanguage())%></td></tr>
    <tr><td>
        <select  name = 'timescope'>
        <option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
        <option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
        <option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
        <option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
        </select>
</td>
<td class=Field>
</td>
<td class=Field></td>
</tr>
</table>
<table>
<tr><td><%=SystemEnv.getHtmlLabelName(19454,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage())%></td></tr>
    <tr><td>
<select  name = 'checks1' onchange="getText1()" >
        <option></option>
        <%for(Iterator iter=targetid.iterator();iter.hasNext();){
            String value=(String)iter.next();
            String label=(String)targetname.get(targetid.indexOf(value));
        %>
         <option value=<%=value%>><%=label%></option>
        <%}%>
        </select>
</td>
<td class=Field>
</td>
<td class=Field></td>
</tr>
</table>
</td>
<td valign="top" >
<table bgcolor="#C0C0C0" class=viewform width="100%" id="formulaTable">
<COLGROUP> <COL width="33%"> <COL width="33%"> <COL width="33%"><TBODY>
	<tr >
		<td ><font color="#FF0000"> </font></td>
		<td ><font color="#FF0000"> </font></td>
		<td><font color="#FF0000"><a href="#">←</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">+</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">-</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">*</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">/</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">(</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">)</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">9</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">8</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">7</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">6</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">5</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">4</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">3</a></font></td>
		<td align="center" ><font color="#FF0000"><a href="#">2</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">1</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">0</font></a></td>
		<td align="center"><font color="#FF0000"><a href="#">.</font></a></td>
		<td align="center">　</td>
	</tr>
	</table>

</td>
<td valign="top">
<table class="viweform"><tr><td>
<textarea class=inputstyle readonly="true" rows="8" cols="30" name=formula style="color: #FF0000;font-size: 10pt"></textarea>
<input type="hidden" name="formulaid" id="formulaid">
</td>
</tr>
</table>
</td>
</tr>
</TBODY>
</TABLE>
</form>
</td>
<td></td>
</tr>
<%rs.beforFirst();rs2.beforFirst();%>
<tr>
<td></td>
<td valign="top">
<form name="weaver1">
<TABLE class=Shadow>
<COLGROUP> <COL width="30%"> <COL width="30%"> <COL width="40%"><TBODY>
<tr>
<td valign="top" >
<table>
<b>公司设置</b>
<hr>
 <tr><td><%=SystemEnv.getHtmlLabelName(15815,user.getLanguage())%></td></tr>
    <tr><td>
<select  name="checks0_1" onchange="getText0_1()">
<option></option>
<%while(rs.next()){
if(!rs.getString("itemtype").equals("9")){%>
<option value='<%=rs.getString("id")%>' alias='<%=rs.getString("itemcode")%>'><%=rs.getString("itemname")%></option>
<%}else{%>
<option value='<%=rs.getString("id")+"_1"%>' alias='<%=rs.getString("itemcode")+"_1"%>'><%=rs.getString("itemname")+"("+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+")"%></option>
<option value='<%=rs.getString("id")+"_2"%>' alias='<%=rs.getString("itemcode")+"_2"%>'><%=rs.getString("itemname")+"("+SystemEnv.getHtmlLabelName(1851,user.getLanguage())+")"%></option>
<%}%>
<%}%>
</select>
</td>
<td class=Field>
</td>
<td class=Field></td>
</tr>
</table>
<table>
 <tr><td><%=SystemEnv.getHtmlLabelName(19397,user.getLanguage())%></td></tr>
    <tr><td>
<select  name="checks_1" onchange="getText_1()">
<option></option>
<%while(rs2.next()){%>
<option value='<%=rs2.getString("id")%>'><%=rs2.getString("diffname")%></option>
<%}%>
</select>
</td>
<td class=Field>
</td>
<td class=Field></td>
</tr>
</table>
<table>
 <tr><td id=countsalary1 onclick="getText2_1()" style="cursor:pointer;"><%=SystemEnv.getHtmlLabelName(19378,user.getLanguage())%></td></tr>
    <tr><td>
</table>
<table>
<tr><td nowrap><%=SystemEnv.getHtmlLabelName(19454,user.getLanguage())+SystemEnv.getHtmlLabelName(19482,user.getLanguage())%></td></tr>
    <tr><td>
        <select  name = 'timescope1'>
        <option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
        <option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
        <option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
        <option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
        </select>
</td>
<td class=Field>
</td>
<td class=Field></td>
</tr>
</table>
<table>
<tr><td><%=SystemEnv.getHtmlLabelName(19454,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage())%></td></tr>
    <tr><td>
<select  name = 'checks1_1' onchange="getText1_1()" >
        <option></option>
        <%for(Iterator iter=targetid.iterator();iter.hasNext();){
            String value=(String)iter.next();
            String label=(String)targetname.get(targetid.indexOf(value));
        %>
         <option value=<%=value%>><%=label%></option>
        <%}%>
        </select>
</td>
<td class=Field>
</td>
<td class=Field></td>
</tr>
</table>
</td>
<td valign="top" >
<table bgcolor="#C0C0C0" class=viewform width="100%" id="formulaTable1">
<COLGROUP> <COL width="33%"> <COL width="33%"> <COL width="33%"><TBODY>
	<tr >
		<td ><font color="#FF0000"> </font></td>
		<td ><font color="#FF0000"> </font></td>
		<td><font color="#FF0000"><a href="#">←</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">+</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">-</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">*</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">/</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">(</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">)</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">9</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">8</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">7</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">6</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">5</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">4</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">3</a></font></td>
		<td align="center" ><font color="#FF0000"><a href="#">2</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">1</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">0</font></a></td>
		<td align="center"><font color="#FF0000"><a href="#">.</font></a></td>
		<td align="center">　</td>
	</tr>
	</table>

</td>
<td valign="top">
<table class="viweform"><tr><td>
<textarea class=inputstyle readonly="true" rows="8" cols="30" name=formula1 style="color: #FF0000;font-size: 10pt"></textarea>
<input type="hidden" name="formulaid1" id="formulaid1">
</td>
</tr>
</table>
</td>
</tr>
</TBODY>
</TABLE>
</form>
</td>
<td></td>
</tr>
</table>
<script language="javascript" for="formulaTable1" event="onclick">
	var e =  window.event.srcElement ;
	var v=document.all("formula1").value;
	var reg=/[+\-*/]/;
	if(e.tagName == "A"){
		var newEntry = e.parentElement.parentElement.innerText
		if (newEntry=="←")
		{
		document.all("formula1").value="";
		document.all("formulaid1").value="";
		return;
		}
		if ((reg.test(newEntry)&&reg.test(v.substring(v.length-1,v.length))))
		{
		alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
		document.all("formula1").value=document.all("formula1").value+newEntry;
		document.all("formulaid1").value=document.all("formulaid1").value+newEntry;
		}
</script>
<script language="javascript" for="formulaTable" event="onclick">
	var e =  window.event.srcElement ;
	var v=document.all("formula").value;
	var reg=/[+\-*/]/;
	if(e.tagName == "A"){
		var newEntry = e.parentElement.parentElement.innerText
		if (newEntry=="←")
		{
		document.all("formula").value="";
		document.all("formulaid").value="";
		return;
		}
		if ((reg.test(newEntry)&&reg.test(v.substring(v.length-1,v.length))))
		{
		alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
		document.all("formula").value=document.all("formula").value+newEntry;
		document.all("formulaid").value=document.all("formulaid").value+newEntry;
		}
</script>
<script>

function getText()
{
       var reg=/[+\-*/\(\)]/;
       var v=document.all("formula").value;
        if (document.all("checks").value=="")
       {
       alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       document.all("formula").value=document.all("formula").value + document.weaver.checks.options[document.weaver.checks.selectedIndex].text;
       var temp;
       temp="@"+document.all("checks").value+"@";
       document.all("formulaid").value=document.all("formulaid").value+temp;
}
function getText0()
{
       var reg=/[+\-*/\(\)]/;
       var v=document.all("formula").value;
        if (document.all("checks0").value=="")
       {
       alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       document.all("formula").value=document.all("formula").value + document.weaver.checks0.options[document.weaver.checks0.selectedIndex].text;
       var temp;
       temp="#"+document.all("checks0").value+"#";
       document.all("formulaid").value=document.all("formulaid").value+temp;
}
function getText1()
{
       var reg=/[+\-*/\(\)]/;
       var v=document.all("formula").value;
       if (document.all("checks1").value=="")
       {
       alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       document.all("formula").value=document.all("formula").value + document.weaver.checks1.options[document.weaver.checks1.selectedIndex].text+ "("+document.weaver.timescope.options[document.weaver.timescope.selectedIndex].text+")";
       var temp;
       temp="$"+document.all("checks1").value+"("+document.weaver.timescope.value+")"+"$";
       document.all("formulaid").value=document.all("formulaid").value+temp;
}
function getText2()
{
       var reg=/[+\-*/\(\)]/;
       var v=document.all("formula").value;
        if (document.all("countsalary").value=="")
       {
       alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       document.all("formula").value=document.all("formula").value + document.all("countsalary").innerHTML;
       var temp;
       temp="^";
       document.all("formulaid").value=document.all("formulaid").value+temp;
}

function getText_1()
{
       var reg=/[+\-*/\(\)]/;
       var v=document.all("formula1").value;
        if (document.all("checks_1").value=="")
       {
       alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       document.all("formula1").value=document.all("formula1").value + document.weaver1.checks_1.options[document.weaver1.checks_1.selectedIndex].text;
       var temp;
       temp="@"+document.all("checks_1").value+"@";
       document.all("formulaid1").value=document.all("formulaid1").value+temp;
}
function getText0_1()
{
       var reg=/[+\-*/\(\)]/;
       var v=document.all("formula1").value;
        if (document.all("checks0_1").value=="")
       {
       alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       document.all("formula1").value=document.all("formula1").value + document.weaver1.checks0_1.options[document.weaver1.checks0_1.selectedIndex].text;

       var temp;
       temp="#"+document.all("checks0_1").value+"#";
       document.all("formulaid1").value=document.all("formulaid1").value+temp;
}
function getText1_1()
{
       var reg=/[+\-*/\(\)]/;
       var v=document.all("formula1").value;
       if (document.all("checks1_1").value=="")
       {
       alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       document.all("formula1").value=document.all("formula1").value + document.weaver1.checks1_1.options[document.weaver1.checks1_1.selectedIndex].text+ "("+document.weaver1.timescope1.options[document.weaver1.timescope1.selectedIndex].text+")";
       var temp;
       temp="$"+document.all("checks1_1").value+"("+document.weaver1.timescope1.value+")"+"$";
       document.all("formulaid1").value=document.all("formulaid1").value+temp;
}
function getText2_1()
{
       var reg=/[+\-*/\(\)]/;
       var v=document.all("formula1").value;
        if (document.all("countsalary1").value=="")
       {
       alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       document.all("formula1").value=document.all("formula1").value + document.all("countsalary1").innerHTML;
       var temp;
       temp="^";
       document.all("formulaid1").value=document.all("formulaid1").value+temp;
}
function btclear(){
	window.parent.returnValue ={id:"",name:""};
	window.parent.close();
}

function  btok(){
	var id,name;
	id=document.all("formulaid").value+";"+document.all("formulaid1").value;
	name=document.all("formula").value+";"+document.all("formula1").value;
	window.parent.returnValue = {id:id,name:name};
	window.parent.close();
}
</script>
</BODY>
</HTML>