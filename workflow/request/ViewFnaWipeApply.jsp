<%@ page import="java.math.*" %>
<%@ page import="weaver.fna.budget.BudgetHandler"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<style id="balancestyle">
        td.balancehide {
            display:none;
        }
    </style>
<form name="frmmain" method="post" action="FnaWipeApplyOperation.jsp" enctype="multipart/form-data">
   
	   <jsp:include page="WorkflowViewRequestBodyAction.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="languageid" value="<%=languageidtemp%>" />
               
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="requestlevel" value="<%=requestlevel%>" />
                <jsp:param name="isbill" value="1" />
                <jsp:param name="billid" value="<%=billid%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="isprint" value="<%=isprint%>" />
                <jsp:param name="logintype" value="<%=logintype%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="nodetype" value="<%=nodetype%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="isrequest" value="<%=isrequest%>" />
                <jsp:param name="isurger" value="<%=isurger%>" />
                <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
            </jsp:include>
    <table class="viewform">

        <tr>
            <td>
            <%

			ArrayList fieldids=new ArrayList();             //字段队列
			ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
			ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
			ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
			ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
			ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
			ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
			ArrayList fieldvalues=new ArrayList();          //字段的值
			ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)

             String uid=""+creater;
             String uname=ResourceComInfo.getLastname(uid);
             String udept=ResourceComInfo.getDepartmentID(uid);
             String udeptname= DepartmentComInfo.getDepartmentname(udept);
             String usubcom=DepartmentComInfo.getSubcompanyid1(udept);
             weaver.hrm.company.SubCompanyComInfo scci=new weaver.hrm.company.SubCompanyComInfo();
             String usubcomname=scci.getSubCompanyname(usubcom);

            int colcount = 0 ;
            int colwidth = 0 ;
            fieldids.clear() ;
            fieldlabels.clear() ;
            fieldhtmltypes.clear() ;
            fieldtypes.clear() ;
            fieldnames.clear() ;
            fieldviewtypes.clear() ;
            String temporganizationidisview="0";
            String temprogtypeisview="0";

            RecordSet.executeProc("workflow_billfield_Select",formid+"");
            while(RecordSet.next()){
                String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
                if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示

                fieldids.add(Util.null2String(RecordSet.getString("id")));
                fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
                fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
                fieldtypes.add(Util.null2String(RecordSet.getString("type")));
                fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
                fieldviewtypes.add(theviewtype);
            }
			// 确定字段是否显示
			ArrayList isfieldids=new ArrayList();              //字段队列
			ArrayList isviews=new ArrayList();              //字段是否显示队列

            // 确定字段是否显示，是否可以编辑，是否必须输入
            isfieldids.clear() ;              //字段队列
            isviews.clear() ;              //字段是否显示队列

            RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
            while(RecordSet.next()){
                String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
                int thefieldidindex = fieldids.indexOf( thefieldid ) ;
                if( thefieldidindex == -1 ) continue ;
                String theisview = Util.null2String(RecordSet.getString("isview")) ;
                String thefieldname=(String)fieldnames.get(thefieldidindex);
                if(thefieldname.equals("organizationid")) temporganizationidisview=theisview;
                if(thefieldname.equals("organizationtype")) temprogtypeisview=theisview;
                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
            }
            if(temporganizationidisview.equals("1")&&temprogtypeisview.equals("0")) colcount++;
            if( colcount != 0 ) colwidth = 95/colcount ;


    %>
            <table class=liststyle cellspacing=1   id="oTable">
              <COLGROUP>
              <tr class="header">
              <td width="5%">&nbsp;</td>
   <%
            ArrayList viewfieldnames = new ArrayList() ;

            // 得到每个字段的信息并在页面显示

            for(int i=0;i<fieldids.size();i++){         // 循环开始

                String fieldid=(String)fieldids.get(i);  //字段id
                String isview="0" ;    //字段是否显示

                int isfieldidindex = isfieldids.indexOf(fieldid) ;
                if( isfieldidindex != -1 ) {
                    isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                }
                String fieldname = "" ;                         //字段数据库表中的字段名
                String fieldlable = "" ;                        //字段显示名
                int languageid = 0 ;

                fieldname=(String)fieldnames.get(i);
                if(! isview.equals("1") &&fieldname.equals("organizationtype")) isview=temporganizationidisview;
                if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环


                languageid = user.getLanguage() ;
                fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                viewfieldnames.add(fieldname) ;
%>
                <td width="<%=colwidth%>%" <%if (fieldname.equals("loanbalance")) {%> class=balancehide<%}%>><%=fieldlable%></td>
<%          }
%>
              </tr>
            <!-- 此处多出来两对 <td></td> 循环外边多一对 循环内多一对  -->
			<!-- 2012-8-2 — 修改 — ypc -->
              <tr class="line2">
			   <%for(int i=0;i<fieldids.size();i++){ %>
			   	<%}%>
			  </tr>
			  </tr>
<%
            BigDecimal amountsum = new BigDecimal("0") ;
            BigDecimal applyamountsum = new BigDecimal("0") ;
            int attachcountsum = 0 ;
            boolean isttLight = false;
            sql="select *  from Bill_FnaWipeApplyDetail where id="+billid+" order by dsporder";
            RecordSet.executeSql(sql);
            while(RecordSet.next()) {
                    int organizationtype = RecordSet.getInt("organizationtype");
                    int organizationid = RecordSet.getInt("organizationid");
                    String budgetperiod = RecordSet.getString("budgetperiod");
                    int subject = RecordSet.getInt("subject");
                    BudgetHandler bp = new BudgetHandler();

                    double loanamount=bp.getLoanAmount(organizationtype,organizationid);
                    String kpi = bp.getBudgetKPI(budgetperiod, organizationtype, organizationid, subject);
                    String kpi1 = kpi.substring(0, kpi.indexOf("|"));
                    String kpi11 = kpi1.substring(0, kpi1.indexOf(","));
                    String kpi12 = kpi1.substring(kpi1.indexOf(",") + 1, kpi1.lastIndexOf(","));
                    String kpi13 = kpi1.substring(kpi1.lastIndexOf(",") + 1);
                    String span1 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + Util.round(kpi11,2) + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + Util.round(kpi12,2) + "</span><br><span style='white-space :nowrap;color:green'> " + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + Util.round(kpi13,2) + "</span></span>";

                    String kpi2 = kpi.substring(kpi.indexOf("|") + 1, kpi.lastIndexOf("|"));
                    String kpi21 = kpi2.substring(0, kpi2.indexOf(","));
                    String kpi22 = kpi2.substring(kpi2.indexOf(",") + 1, kpi2.lastIndexOf(","));
                    String kpi23 = kpi2.substring(kpi2.lastIndexOf(",") + 1);
                    String span2 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + Util.round(kpi21,2) + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + Util.round(kpi22,2) + "</span><br><span style='white-space :nowrap;color:green'>" + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + Util.round(kpi23,2) + "</span></span>";

                    String kpi3 = kpi.substring(kpi.lastIndexOf("|") + 1);
                    String kpi31 = kpi3.substring(0, kpi3.indexOf(","));
                    String kpi32 = kpi3.substring(kpi3.indexOf(",") + 1, kpi3.lastIndexOf(","));
                    String kpi33 = kpi3.substring(kpi3.lastIndexOf(",") + 1);
                    String span3 = "<span><span style='white-space :nowrap'>" + SystemEnv.getHtmlLabelName(18768, user.getLanguage()) + ":" + Util.round(kpi31,2) + "</span><br><span style='white-space :nowrap;color:red'>" + SystemEnv.getHtmlLabelName(18503, user.getLanguage()) + ":" + Util.round(kpi32,2) + "</span><br><span style='white-space :nowrap;color:green'>" + SystemEnv.getHtmlLabelName(18769, user.getLanguage()) + ":" + Util.round(kpi33,2) + "</span></span>";

                isttLight = !isttLight ;
%>
              <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
                <td width="5%">&nbsp;</td>
<%
                for(int i=0;i<fieldids.size();i++){         // 循环开始

                    String fieldid=(String)fieldids.get(i);  //字段id
                    String isview="0" ;    //字段是否显示

                    int isfieldidindex = isfieldids.indexOf(fieldid) ;
                    if( isfieldidindex != -1 ) {
                        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                    }


                    String fieldname = (String)fieldnames.get(i);   //字段数据库表中的字段名
                    if(! isview.equals("1") &&fieldname.equals("organizationtype")) isview=temporganizationidisview;
                    if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环
                    String fieldvalue =  Util.null2String(RecordSet.getString(fieldname)) ;

                    if( fieldname.equals("organizationtype")){
                        String orgtype=Util.null2String(RecordSet.getString("organizationtype"));
                        if(orgtype.equals("3")){
                        fieldvalue=SystemEnv.getHtmlLabelName(6087,user.getLanguage());
                        }else if(orgtype.equals("2")){
                        fieldvalue=SystemEnv.getHtmlLabelName(124,user.getLanguage());
                        }else if(orgtype.equals("1")){
                        fieldvalue=SystemEnv.getHtmlLabelName(141,user.getLanguage());
                        }

                    }else if( fieldname.equals("organizationid")){
                        String orgtype=Util.null2String(RecordSet.getString("organizationtype"));
                        String orgid=Util.null2String(RecordSet.getString("organizationid"));
                        if(orgtype.equals("3")){
                        fieldvalue="<A href='javaScript:openhrm("+fieldvalue+");' onclick='pointerXY(event);'>"+Util.toScreen(ResourceComInfo.getLastname(fieldvalue),user.getLanguage()) +"</A>";
                        if(!orgid.equals(uid)) fieldvalue="<div style='background:#ff9999'>"+fieldvalue+"</div>";
                        }else if(orgtype.equals("2")){
                        fieldvalue="<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+fieldvalue+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(fieldvalue),user.getLanguage()) +"</A>";
                        if(!orgid.equals(udept)) fieldvalue="<div style='background:#ff9999'>"+fieldvalue+"</div>";
                        }else if(orgtype.equals("1")){
                        fieldvalue="<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+fieldvalue+"'>"+Util.toScreen(SubCompanyComInfo.getSubCompanyname(fieldvalue),user.getLanguage())+"</A>";
                        if(!orgid.equals(usubcom)) fieldvalue="<div style='background:#ff9999'>"+fieldvalue+"</div>";
                        }

                        }else if( fieldname.equals("relatedprj"))
                        fieldvalue = "<A href='/proj/data/ViewProject.jsp?isrequest=1&ProjID="+fieldvalue+"'>"+Util.toScreen(ProjectInfoComInfo.getProjectInfoname(fieldvalue),user.getLanguage()) +"</A>";
                    else if( fieldname.equals("relatedcrm"))
                        fieldvalue = "<A href='/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID="+fieldvalue+"'>"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(fieldvalue),user.getLanguage()) +"</A>";
                    else if( fieldname.equals("subject"))
                        fieldvalue = Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(fieldvalue),user.getLanguage()) ;
                    else if( fieldname.equals("hrmremain"))
                        fieldvalue = span1 ;
                    else if( fieldname.equals("deptremain"))
                        fieldvalue = span2 ;
                    else if( fieldname.equals("subcomremain"))
                        fieldvalue = span3 ;
                    else if( fieldname.equals("subcomremain"))
                        fieldvalue = ""+loanamount ;
                    else if( fieldname.equals("amount")) {
                        if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                        else
                            amountsum = amountsum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
                    }else if( fieldname.equals("applyamount")) {
                        if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                        else
                            applyamountsum = applyamountsum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
                    }else if( fieldname.equals("attachcount")) {
                        if( Util.getIntValue(fieldvalue,0) == 0 ) fieldvalue="0" ;
                        else
                            attachcountsum = attachcountsum+Util.getIntValue(fieldvalue,0) ;
                    }



%>
                <td <%if (fieldname.equals("loanbalance")) {%> class=balancehide<%}%>><%=fieldvalue%></td>
<%              }   %>
              </tr>
<%          }   %>
              <tr class=TOTAL style="FONT-WEIGHT: bold; COLOR: red">
                <td><%=SystemEnv.getHtmlLabelName(358, user.getLanguage())%></td>
<%          for(int i=0;i<viewfieldnames.size();i++){
                String thefieldname = (String)viewfieldnames.get(i) ;

%>
                <td <%if(thefieldname.equals("loanbalance")) {%> class=balancehide<% } %>>
                    <%  if(thefieldname.equals("amount")) {
                        amountsum = amountsum.divide ( new BigDecimal ( 1 ), 3, BigDecimal.ROUND_HALF_UP ) ;
                        String amountsumstr = "&nbsp;" ;
                        if( amountsum.doubleValue() != 0 ) amountsumstr = amountsum.toPlainString() ;
                    %><%=amountsum%>
                    <% } else if(thefieldname.equals("applyamount")) {
                        applyamountsum = applyamountsum.divide ( new BigDecimal ( 1 ), 3, BigDecimal.ROUND_HALF_UP ) ;
                        String applyamountsumstr = "&nbsp;" ;
                        if( applyamountsum.doubleValue() != 0 ) applyamountsumstr = applyamountsum.toPlainString() ;
                    %><%=applyamountsum%>
                     <% } else if(thefieldname.equals("attachcount")) {
                        String attachcountsumstr = "&nbsp;" ;
                        if( attachcountsum != 0 ) attachcountsumstr = ""+attachcountsum ;
                    %><%=attachcountsumstr%>
                     <% }  else { %>&nbsp;<%}%>
                </td>
<%          }
%>
              </tr>
            </table>
            </td>
        </tr>
    </table>

    <br>
    <%
   String totallabel="";
   String wipetypelabel="";
   RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        if(Util.null2String(RecordSet.getString("fieldname")).equals("total"))
          totallabel=Util.null2String(RecordSet.getString("id"));
        if(Util.null2String(RecordSet.getString("fieldname")).equals("wipetype"))
        wipetypelabel=Util.null2String(RecordSet.getString("id"));
    }

 %>
    <script>
        if (document.all("field<%=wipetypelabel%>") != null) {
            if (document.all("field<%=wipetypelabel%>").value == "4") {
                document.getElementById("balancestyle").disabled = true;
            } else {
                document.getElementById("balancestyle").disabled = false;
            }
        }
    </script>
    <br>
    <!--jsp过大，不能静态包含 2007.11.21 myq修改 开始-->
        <jsp:include page="/workflow/request/FnaWipeExpenseDetailView.jsp" >
        <jsp:param name="billid" value="<%=billid%>" />
        <jsp:param name="requestid" value="<%=requestid%>" />
        <jsp:param name="creater" value="<%=creater%>" />
        </jsp:include>
     <!--jsp过大，不能静态包含 2007.11.21 myq修改 结束-->
    <br>
    <%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>

