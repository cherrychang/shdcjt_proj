<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,weaver.conn.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.worktask.worktask.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet5" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td3665 on 20060227--%>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/><!--xwj for td3450 20060112-->
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" /><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" /><!--xwj for td3665 20060224-->
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="SysWFLMonitor" class="weaver.system.SysWFLMonitor" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />
<jsp:useBean id="WFCoadjutantManager" class="weaver.workflow.request.WFCoadjutantManager" scope="page" />
<%
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
boolean isUseOldWfMode = sysInfo.isUseOldWfMode();
String isworkflowhtmldoc=Util.null2String(request.getParameter("isworkflowhtmldoc"));
%>
<%----xwj for td3665 20060301 begin---%>
<%
String info = (String)request.getParameter("infoKey");
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
int isonlyview = Util.getIntValue(request.getParameter("isonlyview"), 0);
String isworkflowdoc = "0";//是否为公文
int seeflowdoc = Util.getIntValue(request.getParameter("seeflowdoc"),0);
boolean isnotprintmode =Util.null2String(request.getParameter("isnotprintmode")).equals("1")?true:false;
String reEdit=""+Util.getIntValue(request.getParameter("reEdit"),1);//是否为编辑
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String wfdoc = Util.null2String((String)session.getAttribute(requestid+"_wfdoc"));
String isrequest = Util.null2String(request.getParameter("isrequest")); //
String nodetypedoc=Util.null2String(request.getParameter("nodetypedoc"));
int desrequestid=0;
int wflinkno=Util.getIntValue(request.getParameter("wflinkno"));
boolean isprint = Util.null2String(request.getParameter("isprint")).equals("1")?true:false;
String fromoperation=Util.null2String(request.getParameter("fromoperation"));

String fromPDA = Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录
//TD4262 增加提示信息  开始
String src=Util.null2String(request.getParameter("src"));//进入该界面前的操作，"submit"：提交，"reject"：退回。
String isShowPrompt=Util.null2String(request.getParameter("isShowPrompt"));//是否显示提示  取值"true"或者"false"
//TD4262 增加提示信息  结束

String requestname="";      //请求名称
String requestlevel="";     //请求重要级别 0:正常 1:重要 2:紧急
String requestmark = "" ;   //请求编号
String isbill="0";          //是否单据 0:否 1:是
int creater=0;              //请求的创建人
int creatertype = 0;        //创建人类型 0: 内部用户 1: 外部用户
int deleted=0;              //请求是否删除  1:是 0或者其它 否
int billid=0 ;              //如果是单据,对应的单据表的id
String isModifyLog = "";		//是否记录表单日志 by cyril on 2008-07-09 for TD:8835
int workflowid=0;           //工作流id
String workflowtype = "" ;  //工作流种类
int formid=0;               //表单或者单据的id
int helpdocid = 0;          //帮助文档 id
String workflowname = "" ;         //工作流名称
String status = ""; //当前的操作类型
String docCategory="";//工作流目录
int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;
int nodeid=WFLinkInfo.getCurrentNodeid(requestid,userid,Util.getIntValue(logintype,1));               //节点id
String nodetype=WFLinkInfo.getNodeType(nodeid);         //节点类型  0:创建 1:审批 2:实现 3:归档
int currentstatus = -1;//当前流程状态(对应流程暂停、撤销而言)

//当前流程所处节点id和类型，用于判断是否有强制归档权限TD9023
String currentnodetype = "";
int currentnodeid = 0;

int lastOperator=0;
String lastOperateDate="";
String lastOperateTime="";

boolean canview = false ;               // 是否可以查看
boolean canactive = false ;             // 是否可以对删除的工作流激活
boolean isurger=false;                  //督办人可查看
boolean wfmonitor=false;                //流程监控人
boolean haveBackright=false;            //强制收回权限
boolean haveStopright = false;			//暂停权限
boolean haveCancelright = false;		//撤销权限
boolean haveRestartright = false;		//启用权限
//boolean haveOverright=false;            //强制归档权限

boolean currentusercanview = "true".equals(session.getAttribute(userid+"_"+requestid+"currentusercanview"))?true:false;
canview = "true".equals(session.getAttribute(userid+"_"+requestid+"canview"))?true:false;
canactive = "true".equals(session.getAttribute(userid+"_"+requestid+"canactive"))?true:false;
isurger = "true".equals(session.getAttribute(userid+"_"+requestid+"isurger"))?true:false;
wfmonitor = "true".equals(session.getAttribute(userid+"_"+requestid+"wfmonitor"))?true:false;
haveBackright = "true".equals(session.getAttribute(userid+"_"+requestid+"haveBackright"))?true:false;
isrequest = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isrequest"));

int wfcurrrid=0;

String sql = "" ;
char flag = Util.getSeparator() ;
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
String isSignMustInputOfThisJsp="0";
String isFormSignatureOfThisJsp="0";

if(isrequest.equals("1")){      // 从相关工作流过来,有查看权限
    requestid=Util.getIntValue(String.valueOf(session.getAttribute("resrequestid"+wflinkno)),0);
    desrequestid=Util.getIntValue(String.valueOf(session.getAttribute("desrequestid")),0);//父级流程ID
    String realateRequest=Util.null2String(String.valueOf(session.getAttribute("relaterequest")));
	if (requestid==0)  requestid=Util.getIntValue(request.getParameter("requestid"),0);
    session.setAttribute(requestid+"wflinkno",wflinkno+"");//解决相关流程，不是流程操作人无权限打印的问题    
}
// 查询请求的相关工作流基本信息
status = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"status"));
requestname= Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestname"));
requestlevel=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestlevel"));
requestmark= Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestmark"));
creater= Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"creater"),0);
creatertype=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"creatertype"),0);
deleted=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"deleted"),0);
workflowid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"workflowid"),0);
nodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"nodeid"),0);
nodetype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"nodetype"));
workflowname=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"workflowname"));
workflowtype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"workflowtype"));
lastOperator=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"formid"),0);
lastOperateDate=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateDate"));
lastOperateTime=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateTime"));
formid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"formid"),0);
billid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"billid"),0);
isbill=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isbill"));
helpdocid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"helpdocid"),0);
currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"currentnodeid"),0);
currentnodetype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"currentnodetype"));
currentstatus=Util.getIntValue(Util.null2String((String)session.getAttribute(userid+"_"+requestid+"currentstatus")),-1);

// 检查用户查看权限
// 检查用户是否可以查看和激活该工作流 (激活即是对删除的工作流,将删除状态改为删除前的状态)
// canview = HrmUserVarify.checkUserRight("ViewRequest:View", user);   //有ViewRequest:View权限的人可以查看全部工作流
// canactive = HrmUserVarify.checkUserRight("ViewRequest:Active", user);   //有ViewRequest:Active权限的人可以查看全部工作流
   

// 当前用户表中该请求对应的信息 isremark为0为当前操作者, isremark为1为当前被转发者,isremark为2为可跟踪查看者,isremark=5为干预人
//RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flag+usertype+flag+requestid+"");
int preisremark=-1;//如果是流程参与人，该值会被赋予正确的值，在初始化时先设为错误值，以解决主流程参与人查看子流程时权限判断问题。TD10126
String isremarkForRM = "";
int groupdetailid=0;
int intervenorright=0;

isremarkForRM=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isremarkForRM"));
wfcurrrid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"wfcurrrid"),0);
preisremark=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"preisremark"),-1);
groupdetailid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"groupdetailid"),0);
isModifyLog=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isModifyLog"));
helpdocid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"helpdocid"),0);
isSignMustInputOfThisJsp=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isSignMustInputOfThisJsp"));
intervenorright=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"intervenorright"),0);

//add by mackjoe at 2006-04-24 td3994
int urger=Util.getIntValue(request.getParameter("urger"),0);
int ismonitor=Util.getIntValue(request.getParameter("ismonitor"),0);
if(currentusercanview) {
	response.sendRedirect("/notice/noright.jsp?isovertime="+isovertime);
	return ;
}
if(urger==1 && isurger==true){//流程督办的入口，并且具有督办查看流程表单的权限
	nodeid = currentnodeid;
	nodetype = currentnodetype;
}
String isaffirmance=WorkflowComInfo.getNeedaffirmance(""+workflowid);//是否需要提交确认
//TD8715 获取工作流信息，是否显示流程图
WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String isShowChart = Util.null2String(WFManager.getIsShowChart());
//System.out.println("isShowChart = " + isShowChart);


//判断是否有流程创建文档，并且在该节点是有正文字段
boolean docFlag=flowDoc.haveDocFiled(""+workflowid,""+nodeid);
String  docFlagss=docFlag?"1":"0";
//如果是流程存文档过来，则没有TAB页
if("1".equals(isworkflowhtmldoc)) docFlagss="0";
session.setAttribute("requestAdd"+requestid,docFlagss);
if (!fromFlowDoc.equals("1"))
{
if (docFlag)
{ if (fromoperation.equals("1"))
	{

	if (!nodetypedoc.equals("0")) {
	%>
	<script>
		<%if("1".equals(isShowChart)){%>
	 //setTimeout("window.close()",1);
     //window.opener._table.reLoad();
try{	
	window.opener.btnWfCenterReload.onclick();
}catch(e){}

try{
	<%if(isUseOldWfMode){%>
	window.opener._table.reLoad();
	<%}else{%>
	window.opener.reLoad();
	<%}%>
}catch(e){}
     window.parent.location.href="/workflow/request/WorkflowDirection.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
	 <%}else{%>
	 setTimeout("window.close()",1);
     //window.opener._table.reLoad();
try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}

try{
	<%if(isUseOldWfMode){%>
	window.opener._table.reLoad();
	<%}else{%>
	window.opener.reLoad();
	<%}%>
}catch(e){}

		 <%}%>
    </script>
    <%return;}
	else
	{%>
			<script>
		try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}

try{
	<%if(isUseOldWfMode){%>
	window.opener._table.reLoad();
	<%}else{%>
	window.opener.reLoad();
	<%}%>
}catch(e){}
</script>
<%
		if("1".equals(isShowChart)){
			response.sendRedirect("/workflow/request/WorkflowDirection.jsp?requestid="+requestid+"&workflowid="+workflowid+"&isbill="+isbill+"&formid="+formid+"&isfromtab="+isfromtab);
		}else{
		 response.sendRedirect("RequestView.jsp");
		}
     return;
	}
    }
//response.sendRedirect("ViewRequestDoc.jsp?requestid="+requestid+"&isrequest="+isrequest+"&isovertime="+isovertime+"&isaffirmance="+isaffirmance+"&reEdit="+reEdit+"&wflinkno="+wflinkno);
//return;
isworkflowdoc = "1";
//fromFlowDoc = "1";
}
}
if(fromoperation.equals("1")&&(src.equals("submit")||src.equals("reject"))){//fromoperation=1表示对流程做过操作,当做提交，退回操作时返回到流程图页面。
%>
<script>
try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}
try{
	<%if(isUseOldWfMode){%>
	window.opener._table.reLoad();
	<%}else{%>
	window.opener.reLoad();
	<%}%>
}catch(e){}
<%if("1".equals(isShowChart)){%>
	window.parent.location.href="/workflow/request/WorkflowDirection.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
</script>
<%  return;
	}else{%>
</script>
    <%}

}
WFForwardManager.init();
WFForwardManager.setWorkflowid(workflowid);
WFForwardManager.setNodeid(nodeid);
WFForwardManager.setIsremark(Util.getIntValue(isremarkForRM,0)+"");
WFForwardManager.setRequestid(requestid);
WFForwardManager.setBeForwardid(wfcurrrid);
WFForwardManager.getWFNodeInfo();
String IsPendingForward=WFForwardManager.getIsPendingForward();
String IsBeForward=WFForwardManager.getIsBeForward();
String IsSubmitedOpinion=WFForwardManager.getIsSubmitedOpinion();
String IsSubmitForward=WFForwardManager.getIsSubmitForward();
String IsWaitForwardOpinion=WFForwardManager.getIsWaitForwardOpinion();
String IsBeForwardSubmit=WFForwardManager.getIsBeForwardSubmit();
String IsBeForwardModify=WFForwardManager.getIsBeForwardModify();
String IsBeForwardPending=WFForwardManager.getIsBeForwardPending();
boolean IsFreeWorkflow=WFForwardManager.getIsFreeWorkflow(requestid,nodeid,Util.getIntValue(isremarkForRM));
String IsFreeNode=WFForwardManager.getIsFreeNode(nodeid);
session.setAttribute(userid+"_"+requestid+"wfcurrrid",""+wfcurrrid);
boolean IsCanSubmit=WFForwardManager.getCanSubmit();
boolean IsBeForwardCanSubmitOpinion=WFForwardManager.getBeForwardCanSubmitOpinion();
boolean IsCanModify=WFForwardManager.getCanModify();
WFCoadjutantManager.getCoadjutantRights(groupdetailid);
String coadsigntype=WFCoadjutantManager.getSigntype();
String coadissubmitdesc=WFCoadjutantManager.getIssubmitdesc();
String coadisforward=WFCoadjutantManager.getIsforward();
String message = Util.null2String(request.getParameter("message"));       // 返回的错误信息

//add by xhheng @20041217 for TD 1438 end

// 记录查看日志
String clientip = request.getRemoteAddr();
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;

// modify by xhheng @20050304 for TD 1691

/*--  xwj for td2104 on 20050802 begin  --*/
boolean isOldWf = false;
if(isprint==false){
RecordSet4.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSet4.next()){
	if(RecordSet4.getString("nodeid") == null || "".equals(RecordSet4.getString("nodeid")) || "-1".equals(RecordSet4.getString("nodeid"))){
			isOldWf = true;
	}
}



//将本人的流程查看状态置为已查看2
	//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh begin
//RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,orderdate=receivedate,ordertime=receivetime where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
RecordSet.executeSql("update workflow_currentoperator set viewtype=-2 where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
    //TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh end
//记录第一次查看时间
RecordSet.executeProc("workflow_CurOpe_UpdatebyView",""+requestid+ flag + userid + flag + usertype);

if(! currentnodetype.equals("3") )
    RecordSet.executeProc("SysRemindInfo_DeleteHasnewwf",""+userid+flag+usertype+flag+requestid);
else
    RecordSet.executeProc("SysRemindInfo_DeleteHasendwf",""+userid+flag+usertype+flag+requestid);
}

String imagefilename = "/images/hdReport.gif";
String titlename =  SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage()) + " - " +  status + " "+requestmark ;//Modify by 杨国生 2004-10-26 For TD1231
//if(helpdocid !=0 ) {titlename=titlename + "<img src=/images/help.gif style=\"CURSOR:hand\" width=12 onclick=\"location.href='/docs/docs/DocDsp.jsp?id="+helpdocid+"'\">";}
String needfav ="1";
String needhelp ="";
//add by mackjoe at 2005-12-20 增加模板应用
String ismode="";
int modeid=0;
int isform=0;
int showdes=0;
int printdes=0;
int toexcel=0;
RecordSet.executeSql("select ismode,showdes,printdes,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
    showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
    printdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
    toexcel=Util.getIntValue(Util.null2String(RecordSet.getString("toexcel")),0);
}

if(ismode.equals("1") && showdes!=1){
    RecordSet.executeSql("select id from workflow_nodemode where isprint='0' and workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        modeid=RecordSet.getInt("id");
    }else{
        RecordSet.executeSql("select id from workflow_formmode where isprint='0' and formid="+formid+" and isbill='"+isbill+"'");
        if(RecordSet.next()){
            modeid=RecordSet.getInt("id");
            isform=1;
        }
    }
}else if("2".equals(ismode)){
	RecordSet.executeSql("select id from workflow_nodehtmllayout where type=0 and workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        modeid=RecordSet.getInt("id");
    }
}

//---------------------------------------------------------------------------------
//跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 START
//---------------------------------------------------------------------------------
//模板模式-如果用户使用的是非IE则自动使用一般模式来显示流程 START 2011-11-23 CC
//if (!isIE.equalsIgnoreCase("true") && ismode.equals("1")) {
if (!isIE.equalsIgnoreCase("true") && ismode.equals("1") && modeid != 0) {
	String messageLableId = "";
	if (ismode.equals("1")) {
		messageLableId = "18017";
	} else {
		messageLableId = "23682";
	}
	ismode = "0";	
	//response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=" + messageLableId);
	%>

	<script type="text/javascript">
	
	window.parent.location.href = "/wui/common/page/sysRemind.jsp?labelid=<%=messageLableId %>";
	
	</script>

<%
	return;
}
//模板模式-如果用户使用的是非IE则自动使用一般模式来显示流程 END
//---------------------------------------------------------------------------------
//跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 END
//---------------------------------------------------------------------------------


if(fromPDA.equals("1") && ismode.equals("1")){
	modeid=0;
}
if(ismode.equals("1") && !isnotprintmode && isprint && printdes!=1&&!fromPDA.equals("1")){
    response.sendRedirect("PrintMode.jsp?requestid="+requestid+"&isbill="+isbill+"&workflowid="+workflowid+"&formid="+formid+"&nodeid="+nodeid+"&billid="+billid+"&isfromtab="+isfromtab);
    return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script>     
<script type="text/javascript" language="javascript" src="/js/jquery/jquery.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">
<link href="/js/swfupload/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf.js"></script> 
<style>
.wordSpan{font-family:MS Shell Dlg,Arial;CURSOR: hand;font-weight:bold;FONT-SIZE: 10pt}
</style>
<title><%=requestname%></title>
</head>
<script language=javascript>

function hiddenPop(){
 try{
    <%
	if(modeid>0 && "1".equals(ismode)){
%>
    oPopup.hide();
<%
    }else{
%>
    showTableDiv.style.display='none';
    oIframe.style.display='none';
<%
    }
%>
}catch(e){}
}
var fromoperation="<%=fromoperation%>";
var overtime="<%=isovertime%>";
function windowOnload()
{
    <%if(modeid>0 && "1".equals(ismode)){%>
        init();
    <%}else{%>
    setwtableheight();
    <%}
%>
    if (fromoperation=="1") {
<%
         //TD4262 增加提示信息  开始
		 if(isShowPrompt.equals("true"))
		{
			 if(src.equals("submit")){
				 if(modeid>0 && "1".equals(ismode)){
%>
	                 contentBox = document.getElementById("divFavContent18982");
                     showObjectPopup(contentBox);
<%
				 }else{
%>
		             var content="<%=SystemEnv.getHtmlLabelName(18982,user.getLanguage())%>";
		             showPrompt(content);
<%
				 }
			 }else if(src.equals("reject")){
				 if(modeid>0 && "1".equals(ismode)){
%>
	                 contentBox = document.getElementById("divFavContent18983");
                     showObjectPopup(contentBox);
<%
				 }else {
%>
		             var content="<%=SystemEnv.getHtmlLabelName(18983,user.getLanguage())%>";
		             showPrompt(content);
<%
				 }
			}
		}
%>

         //TD4262 增加提示信息  结束
		<%if("1".equals(isShowChart)){%>
        //setTimeout("window.close()",1);
       			try{
				window.opener._table.reLoad();
			}catch(e){}
			window.parent.location.href="/workflow/request/WorkflowDirection.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
		<%}else{%>
			setTimeout("window.close()",1);
			try{
			<%if(isUseOldWfMode){%>
			window.opener._table.reLoad();
			<%}else{%>
			window.opener.reLoad();
			<%}%>

			}catch(e){}
		<%}%>
        //window.opener.document.frmmain.submit();
        //将提交父窗口改为调用分页控件的刷新函数
        if( overtime!="1")
        {
        	try
        	{
        		window.opener.btnWfCenterReload.onclick();
        			<%if(isUseOldWfMode){%>
					window.opener._table.reLoad();
					<%}else{%>
					window.opener.reLoad();
					<%}%>

        	}
        	catch(e)
        	{
        	<%if("1".equals(isShowChart)){%>
        		window.parent.location.href="/workflow/request/WorkflowDirection.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
				<%}else{%>
					window.parent.location.href = "RequestView.jsp";
				<%}%>
        	}
        }

    }
    displayAllmenu();
}
<%if(modeid<1 || ismode.equals("2")){%>
function setwtableheight(){
    /*
    var totalheight=5;
    var bodyheight=document.body.clientHeight;
    if(document.getElementById("divTopTitle")!=null){
        totalheight+=document.getElementById("divTopTitle").clientHeight;
    }
    <%if (fromFlowDoc.equals("1")){%>
        totalheight+=100;
        bodyheight=parent.document.body.clientHeight;
    <%}%>
    document.getElementById("w_table").height=bodyheight-totalheight;
    */
}
window.onresize = function (){
    setwtableheight(); 
}
<%}%>
</script>

<script language="javascript">
var isfirst = 0 ;
function displaydiv()
{
    if(oDivAll.style.display == ""){
		oDivAll.style.display = "none";
		oDivInner.style.display = "none";
        oDiv.style.display = "none";
        <%if(modeid>0 && "1".equals(ismode)){%> oDivSign.style.display = "none";<%}%>
        spanimage.innerHTML = "<img src='/images/ArrowDownRed.gif' border=0>" ;
    }
    else{
        if(isfirst == 0) {
			document.getElementById("picInnerFrame").src="/workflow/request/WorkflowRequestPictureInner.jsp?isview=1&fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>";				
			document.getElementById("picframe").src="/workflow/request/WorkflowRequestPicture.jsp?requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&isurger=<%=isurger%>";
            <%if(modeid>0 && "1".equals(ismode)){%> document.getElementById("picSignFrame").src="/workflow/request/WorkflowViewSignMode.jsp?isprint=true&languageid=<%=user.getLanguage()%>&userid=<%=userid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isOldWf=<%=isOldWf%>&desrequestid=<%=desrequestid%>&ismonitor=<%=ismonitor%>&logintype=<%=logintype%>";<%}%>
            isfirst ++ ;
        }

        spanimage.innerHTML = "<img src='/images/ArrowUpGreen.gif' border=0>" ;
		oDivAll.style.display = "";
		oDivInner.style.display = "";
        oDiv.style.display = "";
        workflowStatusLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19678,user.getLanguage())%></font>";
        workflowChartLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
        <%if(modeid>0 && "1".equals(ismode)){%>
        oDivSign.style.display = "";
        workflowSignLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(21200,user.getLanguage())%></font>";
        <%}%>
    }
}


function displaydivOuter()
{
    if(oDiv.style.display == ""){
        oDiv.style.display = "none";
        workflowStatusLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(19677,user.getLanguage())%></font>";
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none"<%if(modeid>0 && "1".equals(ismode)){%> &&oDivSign.style.display == "none"<%}%>){
		    oDivAll.style.display = "none";
            spanimage.innerHTML = "<img src='/images/ArrowDownRed.gif' border=0>" ;
		}
    }
    else{
        oDiv.style.display = "";
        workflowStatusLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19678,user.getLanguage())%></font>";
    }
}

function displaydivInner()
{
    if(oDivInner.style.display == ""){
        oDivInner.style.display = "none";
        workflowChartLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(19675,user.getLanguage())%></font>";
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none"<%if(modeid>0 && "1".equals(ismode)){%> &&oDivSign.style.display == "none"<%}%>){
		    oDivAll.style.display = "none";
            spanimage.innerHTML = "<img src='/images/ArrowDownRed.gif' border=0>" ;
		}
    }
    else{
        oDivInner.style.display = "";
        workflowChartLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
    }
}


</SCRIPT>
<body>

<%if (!fromFlowDoc.equals("1")) {%>
<%@ include file="RequestTopTitle.jsp" %>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
Prop prop = Prop.getInstance();
String ifchangstatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
String sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+nodeid;
if(!"0".equals(isremarkForRM)){
	RecordSet.executeSql("select nodeid from workflow_currentoperator c where c.requestid="+requestid+" and c.userid="+userid+" and c.usertype="+usertype+" and c.isremark='"+isremarkForRM+"' ");
	int tmpnodeid = 0;
	if(RecordSet.next()){
		tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"), 0);
	}
	sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+tmpnodeid;
}

RecordSet.executeSql(sqlselectName);
String forwardName = "";
String newWFName = "";//新建流程按钮
String newSMSName = "";//新建短信按钮
String ccsubnobackName = "";//抄送批注不需反馈
String haswfrm = "";//是否使用新建流程按钮
String hassmsrm = "";//是否使用新建短信按钮
String hasccnoback = "";//使用抄送批注不需反馈按钮
int t_workflowid = 0;//新建流程的ID
if(RecordSet.next()){
	if(user.getLanguage() == 7){
		forwardName = Util.null2String(RecordSet.getString("forwardName7"));
		newWFName = Util.null2String(RecordSet.getString("newWFName7"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName7"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName7"));
	}
	else if(user.getLanguage() == 9){
		forwardName = Util.null2String(RecordSet.getString("forwardName9"));
		newWFName = Util.null2String(RecordSet.getString("newWFName9"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName9"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName9"));
	}
	else{
		forwardName = Util.null2String(RecordSet.getString("forwardName8"));
		newWFName = Util.null2String(RecordSet.getString("newWFName8"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName8"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName8"));
	}
	haswfrm = Util.null2String(RecordSet.getString("haswfrm"));
	hassmsrm = Util.null2String(RecordSet.getString("hassmsrm"));
	hasccnoback = Util.null2String(RecordSet.getString("hasccnoback"));
	t_workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
}
if("".equals(forwardName)){
	forwardName = SystemEnv.getHtmlLabelName(6011,user.getLanguage());
}
if("".equals(ccsubnobackName)){
	ccsubnobackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"）";
}

%>
<%--xwj for td3665 20060224 begin--%>
<%
String strBar = "[";
//HashMap map = WfFunctionManageUtil.wfFunctionManageByNodeid(workflowid,nodeid);
//String ov = (String)map.get("ov");//能否强制归档依据查看人所在节点是否有权限
HashMap map = WfFunctionManageUtil.wfFunctionManageByNodeid(workflowid,currentnodeid);
String rb = (String)map.get("rb");
//if(!"0".equals(rb)){//强制收回:如果流程当前节点设置"查看前收回"或"查看后收回"，则上一节点的操作者有权限收回。 myq修改 TD9348
//	RecordSet.executeSql("select * from workflow_NodeLink where nodeid="+nodeid+" and destnodeid="+currentnodeid+" and workflowid="+workflowid);
//	if(!RecordSet.next()) rb = "0";//如果操作人所在节点不是强制收回节点的上一个节点，则没有强制收回的权限。
//}
haveStopright = WfFunctionManageUtil.haveStopright(currentstatus,creater,user,currentnodetype,requestid,false);//流程不为暂停或者撤销状态，当前用户为流程发起人或者系统管理员，并且流程状态不为创建和归档
haveCancelright = WfFunctionManageUtil.haveCancelright(currentstatus,creater,user,currentnodetype,requestid,false);//流程不为撤销状态，当前用户为流程发起人，并且流程状态不为创建和归档
haveRestartright = WfFunctionManageUtil.haveRestartright(currentstatus,creater,user,currentnodetype,requestid,false);//流程为暂停或者撤销状态，当前用户为系统管理员，并且流程状态不为创建和归档
if(currentstatus>-1&&!haveCancelright&&!haveRestartright)
{
	String tips = "";
	if(currentstatus==0)
	{
		tips = SystemEnv.getHtmlLabelName(26154,user.getLanguage());//流程已暂停,请与流程发起人或系统管理员联系!
	}
	else
	{
		tips = SystemEnv.getHtmlLabelName(26155,user.getLanguage());//流程已撤销,请与系统管理员联系!
	}
%>
	<script language="JavaScript">
		var tips = '<%=tips%>';
		if(tips!="")
		{
			alert(tips);
		}
		try
		{
			setTimeout('top.window.close()',1);
		}
		catch(e)
		{
			window.location.href="/notice/noright.jsp?isovertime=<%=isovertime%>";
		}
	</script>
<%
    return ;
}
//String ifremark=Util.null2String(WorkflowComInfo.getIsremark(workflowid+""));
//haveOverright=preisremark!=1 && preisremark!=5 && preisremark!=8 && preisremark!=9 && "1".equals(ov) && !"3".equals(currentnodetype) && WfForceOver.isNodeOperator(requestid,currentnodeid,userid);		//增加对流程当前所处节点类型的判断TD9023
haveBackright=preisremark!=1 && preisremark!=5 && preisremark!=8&& preisremark!=7 && preisremark!=9 && !"0".equals(rb) && WfForceDrawBack.isHavePurview(requestid,userid,Integer.parseInt(logintype),-1,-1);
if(intervenorright>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doIntervenor(this),_self}" ;//Modified by xwj for td3247 20051201
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls:'btn_doIntervenor',handler: function(){doIntervenor(this);}},";
}else{
if(preisremark!=8 && !wfmonitor){
if (isurger)
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(21223,user.getLanguage())+",javascript:doSupervise(this),_self}" ;//Modified by xwj for td3247 20051201
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(21223,user.getLanguage())+"',iconCls:'btn_Supervise',handler: function(){doSupervise(this);}},";
}else{
	//代理人的preisremark=2的情况
	String agenttypetmp = "0";
	RecordSet.executeSql("SELECT * FROM workflow_currentoperator where id=" + wfcurrrid);
	if(RecordSet.next()) agenttypetmp = RecordSet.getString("AGENTTYPE");
if (!haveRestartright&&((IsSubmitForward.equals("1")&&(preisremark==0||preisremark==9||(preisremark==1&&"1".equals(isremarkForRM)) || (preisremark==1 && "2".equals(isremarkForRM) && "1".equals(IsSubmitForward) && "1".equals(IsBeForward)) ||("1".equals(agenttypetmp) && preisremark==2)))||(IsBeForward.equals("1")&&preisremark==1&&(IsCanSubmit || isremarkForRM.equals("2") || isremarkForRM.equals("4")))||(coadisforward.equals("1")&&isremarkForRM.equals("7")))&&canview&&!isrequest.equals("1"))	
{

RCMenu += "{"+forwardName+",javascript:doReview(),_self}" ;//Modified by xwj for td3247 20051201
RCMenuHeight += RCMenuHeightStep ;	
strBar += "{text: '"+forwardName+"',iconCls:'btn_forward',handler: function(){doReview();}},";
}
//if(haveOverright){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+",javascript:doDrawBack(this),_self}" ;//xwj for td3665 20060224
//RCMenuHeight += RCMenuHeightStep ;
//strBar += "{text: '"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+"',iconCls:'btn_doDrawBack',handler: function(){doDrawBack(this);}},";
//}
%>
<%if(haveBackright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+",javascript:doRetract(this),_self}" ;//xwj for td3665 20060224
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+"',iconCls:'btn_doRetract',handler: function(){doRetract(this);}},";
}
}
}else if(preisremark==8 && !wfmonitor){//抄送不需要提交也有转发按钮TD9144
	//if(!"".equals(ifchangstatus) && "1".equals(hasccnoback)){
	//	RCMenu += "{"+ccsubnobackName+",javascript:doRemark_nNoBack(this),_self}";
	//	RCMenuHeight += RCMenuHeightStep;
  //      strBar += "{text: '"+ccsubnobackName+"',iconCls:'btn_ccsubnobackName',handler: function(){doRemark_nNoBack(this);}},";
	//}
	if (!haveRestartright&&((IsSubmitForward.equals("1")&&(preisremark==0||preisremark==8))||(IsBeForward.equals("1")&&preisremark==1))&&canview&&!isrequest.equals("1")&&isurger==false){
		RCMenu += "{"+forwardName+",javascript:doReview(),_self}" ;//Modified by xwj for td3247 20051201
		RCMenuHeight += RCMenuHeightStep ;	
		strBar += "{text: '"+forwardName+"',iconCls:'btn_forward',handler: function(){doReview();}},";
	}
}
if(haveStopright)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20387,user.getLanguage())+",javascript:doStop(this),_self}" ;//xwj for td3665 20060224
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(20387,user.getLanguage())+"',iconCls:'btn_end',handler: function(){bodyiframe.doStop(this);}},";
}
if(haveCancelright)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16210,user.getLanguage())+",javascript:doCancel(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(16210,user.getLanguage())+"',iconCls:'btn_backSubscrible',handler: function(){bodyiframe.doCancel(this);}},";
}
/* added by cyril on 2008-07-09 for TD:8835 **/
if(isModifyLog.equals("1") && preisremark>-1&&!isurger) {//TD10126
	RCMenu += "{"+SystemEnv.getHtmlLabelName(21625,user.getLanguage())+",javascript:doViewModifyLog(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(21625,user.getLanguage())+"',iconCls:'btn_doViewModifyLog',handler: function(){doViewModifyLog();}},";
}
/* end by cyril on 2008-07-09 for TD:8835 **/
if(!isurger&&!wfmonitor){
/*TD9145 START*/
if("1".equals(haswfrm)){
	if("".equals(newWFName)){
		newWFName = SystemEnv.getHtmlLabelName(1239,user.getLanguage());
	}
	RequestCheckUser.setUserid(userid);
	RequestCheckUser.setWorkflowid(t_workflowid);
	RequestCheckUser.setLogintype(logintype);
	RequestCheckUser.checkUser();
	int  t_hasright=RequestCheckUser.getHasright();
	if(t_hasright == 1){
		RCMenu += "{"+newWFName+",javascript:onNewRequest("+t_workflowid+", "+requestid+",0),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+newWFName+"',iconCls:'btn_newWFName',handler: function(){onNewRequest("+t_workflowid+", "+requestid+",0);}},";
	}
}
RTXConfig rtxconfig = new RTXConfig();
String temV = rtxconfig.getPorp(rtxconfig.CUR_SMS_SERVER_IS_VALID);
boolean valid = false;
if (temV != null && temV.equalsIgnoreCase("true")) {
	valid = true;
} else {
	valid = false;
}
if(valid == true && "1".equals(hassmsrm) && HrmUserVarify.checkUserRight("CreateSMS:View", user)){
	if("".equals(newSMSName)){
		newSMSName = SystemEnv.getHtmlLabelName(16444,user.getLanguage());
	}
	RCMenu += "{"+newSMSName+",javascript:onNewSms("+workflowid+", "+nodeid+", "+requestid+"),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+newSMSName+"',iconCls:'btn_newSMSName',handler: function(){onNewSms("+workflowid+", "+nodeid+", "+requestid+");}},";
}
/*TD9145 END*/
}
}
if(haveRestartright)
{
	strBar = "[";
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+",javascript:doRestart(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"',iconCls:'btn_next',handler: function(){bodyiframe.doRestart(this);}},";
}
if(modeid>0 && toexcel==1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+" Excel,javascript:ToExcel(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+" Excel',iconCls:'btn_excel',handler: function(){ToExcel();}},";
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:openSignPrint(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+"',iconCls:'btn_print',handler: function(){openSignPrint();}},";
strBar = strBar.substring(0,strBar.lastIndexOf(","));
strBar+="]";
if(isonlyview == 1||"1".equals(isworkflowhtmldoc)){
	strBar = "[]";
	RCMenu = "";
	RCMenuHeight = 0;
}
%>
<%--xwj for td3665 20060224 end--%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script language="javascript">
enableAllmenu();
</script>
        <input type=hidden name=seeflowdoc value="<%=seeflowdoc%>">
		<input type=hidden name=isworkflowdoc value="<%=isworkflowdoc%>">
        <input type=hidden name=wfdoc value="<%=wfdoc%>">
        <input type=hidden name=picInnerFrameurl value="/workflow/request/WorkflowRequestPictureInner.jsp?isview=1&fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>">

		<TABLE width=100%>
		<tr>
		<td valign="top"  colspan="4">
        <%if( message.equals("4") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(21266,user.getLanguage())%></font>
		<%} else if( message.equals("5") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(21270,user.getLanguage())%></font>
		<%} else if( message.equals("6") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(21766,user.getLanguage())%></font>
        <%} else if( message.equals("7") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(22751,user.getLanguage())%></font>
        <%} else if( message.equals("8") ) {%>
        <font color=red><%=SystemEnv.getHtmlLabelName(24676,user.getLanguage())%></font>
		<%}%>

<!--TD4262 增加提示信息  开始-->
<%
    if(modeid>0 && "1".equals(ismode)){
%>
<div id="divFavContent18982" style="display:none">  <!--流程提交成功。-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18982,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18983" style="display:none"> <!--流程退回成功。-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18983,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
<div id="divFavContent19205" style="display:none"> <!--正在获取数据。-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
<%
    }else{
%>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<%
	}
%>
<!--TD4262 增加提示信息  结束-->

<%
if(modeid>0 && ismode.equals("1")){
%>
<div id="divFavContent18978" style="display:none"><!--正在提交流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
<div id="divFavContent18984" style="display:none"><!--正在删除流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18984,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>


<%if(fromFlowDoc.equals("1") || (isbill.equals("1") && formid==7)){%>
<div id="t_headother"></div>
<%}%>
    <form name="frmmain" method="post" action="RequestOperation.jsp" <%if (!fromPDA.equals("1")) {%> enctype="multipart/form-data" <%}%>>
	<input type="hidden" name="needwfback"  id="needwfback" value="1"/>

	<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
	<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
	<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

<%
boolean hasRequestname = false;
boolean hasRequestlevel = false;
boolean hasMessage = false;
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-1");
if(RecordSet.next()) hasRequestname = true;
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-2");
if(RecordSet.next()) hasRequestlevel = true;
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-3");
if(RecordSet.next()) hasMessage = true;
%>
<%
if(!hasRequestname||!hasRequestlevel||!hasMessage){
%>
    <TABLE class="ViewForm" id="t_header">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TR class="Spacing">
    <TD class="Line1" colSpan=2></TD>
  </TR>
  <%
      String sqlWfMessage = "select messageType from workflow_base where id="+workflowid;
      int wfMessageType=0;
      RecordSet.executeSql(sqlWfMessage);
      if (RecordSet.next()) {
        wfMessageType=Util.getIntValue(Util.null2String(RecordSet.getString("messageType")),0);
      }
      if(!hasRequestname||!hasRequestlevel||(!hasMessage&&wfMessageType==1)){
  %>
  <TR>
    <TD>
    	<%if(!hasRequestname){%>
    	<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>
    	<%}else if(!hasRequestlevel){%>
    	<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>
    	<%}else if(!hasMessage&&wfMessageType == 1){%>
    	<%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%>
    	<%}%>
    </TD>
    <TD class=field>
    <%if(!hasRequestname){%>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
    <%}%>  
    <%if(!hasRequestlevel){%>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
		<%}%>

    <%if(!hasMessage){%>
      <!--add by xhheng @ 2005/01/25 for 消息提醒 Request06，流转过程中察看短信设置 -->
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%
      if(wfMessageType == 1){
        String sqlRqMessage = "select messageType from workflow_requestbase where requestid="+requestid;
        int rqMessageType=0;
        RecordSet.executeSql(sqlRqMessage);
        if (RecordSet.next()) {
          rqMessageType=RecordSet.getInt("messageType");
        }%>
        <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
        <%} else if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
        <%} else if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}%>
      <%}%>
      <%}%>
      </TD>
  </TR>
  <TR>
    <TD class="Line1" colSpan=2></TD>
  </TR>
  <%}%>
  </table> 
<%}%>     
    <%if(isbill.equals("1") && formid==7){%>
    <jsp:include page="/workflow/request/BillBudgetExpenseDetailMode.jsp" flush="true">
	<jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    </jsp:include>
    <%}%>
    <input type=hidden name="desrequestid" id="desrequestid" value="<%=desrequestid%>">
    <jsp:include page="WorkflowViewmode.jsp" flush="true">
    <jsp:param name="modeid" value="<%=modeid%>" />
    <jsp:param name="isform" value="<%=isform%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="isbill" value="<%=isbill%>" />    
    <jsp:param name="nodeid" value="<%=nodeid%>" />    
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="desrequestid" value="<%=desrequestid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="intervenorright" value="<%=intervenorright%>" />
    </jsp:include>
    <jsp:include page="ViewmodeValue.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="workflowid" value="<%=workflowid%>" />
	<jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="isurger" value="<%=isurger%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />  
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />   
    </jsp:include>
    <%if(isbill.equals("1") && formid==158){%>
        <jsp:include page="/workflow/request/FnaWipeExpenseDetailView.jsp" >
        <jsp:param name="billid" value="<%=billid%>" />
        <jsp:param name="requestid" value="<%=requestid%>" />
        <jsp:param name="creater" value="<%=creater%>" />
        </jsp:include>
    <%}%>
    </form>
	<!--此处为图形化表单的流转意见-->
	<%if(modeid>0 && "1".equals(ismode)){%>
		<div id="picSignFrame">
			<jsp:include page="WorkflowViewSignMode.jsp" flush="true">
		    <jsp:param name="isprint" value="<%=isprint%>"/>
			<jsp:param name="languageid" value="<%=user.getLanguage()%>"/>
			<jsp:param name="userid" value="<%=userid%>"/>
			<jsp:param name="requestid" value="<%=requestid%>"/>
			<jsp:param name="workflowid" value="<%=workflowid%>"/>
			<jsp:param name="nodeid" value="<%=nodeid%>"/>
			<jsp:param name="isOldWf" value="<%=isOldWf%>"/>
			<jsp:param name="desrequestid" value="<%=desrequestid%>"/>
			<jsp:param name="ismonitor" value="<%=ismonitor%>"/>
			<jsp:param name="logintype" value="<%=logintype%>"/>
			</jsp:include>		
		</div>
	<%}%>
<%
}else{
//end by mackjoe

String viewpage= "";
if(isbill.equals("1")){
    RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
    if(RecordSet.next()) viewpage = RecordSet.getString("viewpage");
}
if( !viewpage.equals("")) {
	//TD10126 部分服务器下直接使用Util.null2String(request.getParameter("isprint"))传参数会出错
	String isprint_viewpage = Util.null2String(request.getParameter("isprint"));
	if(formid == 6){
		session.setAttribute("viewresourceplan", ""+requestid);
	}
%>
<jsp:include page="<%=viewpage%>" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="requestmark" value="<%=requestmark%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="canactive" value="<%=canactive%>" />
    <jsp:param name="isprint" value="<%=isprint_viewpage%>" />
	<jsp:param name="desrequestid" value="<%=desrequestid%>" />
	<jsp:param name="isrequest" value="<%=isrequest%>" />
    <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="isurger" value="<%=isurger%>" />
    <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />

</jsp:include>
<%}else{%>

<form name="frmmain" method="post" action="RequestOperation.jsp" <%if (!fromPDA.equals("1")) {%> enctype="multipart/form-data" <%}%>>
<input type="hidden" name="needwfback"  id="needwfback" value="1"/>

<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>


	<%if("2".equals(ismode) && modeid>0){//这里故意写isremark=2%>
            <jsp:include page="WorkflowViewRequestHtml.jsp" flush="true">
				<jsp:param name="modeid" value="<%=modeid%>" />
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="canactive" value="<%=canactive%>" />
                <jsp:param name="deleted" value="<%=deleted%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="requestlevel" value="<%=requestlevel%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="billid" value="<%=billid%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="isprint" value="0" />
                <jsp:param name="logintype" value="<%=logintype%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="nodetype" value="<%=nodetype%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="isrequest" value="<%=isrequest%>" />
                <jsp:param name="isurger" value="<%=isurger%>" />
                <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="intervenorright" value="<%=intervenorright%>" />
                <jsp:param name="isremark" value="2" />
            </jsp:include>
	<%}else{%>
            <jsp:include page="WorkflowViewRequestBodyAction.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="canactive" value="<%=canactive%>" />
                <jsp:param name="deleted" value="<%=deleted%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="requestlevel" value="<%=requestlevel%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
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
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="intervenorright" value="<%=intervenorright%>" />
            </jsp:include>
	<%}%>
            <jsp:include page="WorkflowViewSignAction.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="usertype" value="<%=usertype%>" />
                <jsp:param name="isprint" value="<%=isprint%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="isOldWf" value="<%=isOldWf%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="isurger" value="<%=isurger%>" />
                <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
            </jsp:include>
</form>
<%}
}
int haslinkworkflow=Util.getIntValue(String.valueOf(session.getAttribute("haslinkworkflow")),0);
if(haslinkworkflow==1&&!isrequest.equals("1")){
    session.setAttribute("desrequestid",""+requestid);
}else{
    if(haslinkworkflow==0&&!isrequest.equals("1")){
        session.removeAttribute("desrequestid");
        int linkwfnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")),0);
        for(int i=0;i<=linkwfnum;i++){
            session.removeAttribute("resrequestid"+i);
        }
        session.removeAttribute("slinkwfnum");
    }
}
%>

<%
String custompage = "";
//查询该工作流的表单id，是否是单据（0否，1是），帮助文档id
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");
if(RecordSet.next()){
	custompage = Util.null2String(RecordSet.getString("custompage"));
}
%>
<%
	if(!custompage.equals("")){
%>
		<jsp:include page="<%=custompage%>" flush="true">
            <jsp:param name="workflowid" value="<%=workflowid%>" />
            <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
            <jsp:param name="canactive" value="<%=canactive%>" />
            <jsp:param name="deleted" value="<%=deleted%>" />
            <jsp:param name="nodeid" value="<%=nodeid%>" />
            <jsp:param name="requestid" value="<%=requestid%>" />
            <jsp:param name="requestlevel" value="<%=requestlevel%>" />
            <jsp:param name="isbill" value="<%=isbill%>" />
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
            <jsp:param name="desrequestid" value="<%=desrequestid%>" />
            <jsp:param name="intervenorright" value="<%=intervenorright%>" />
        </jsp:include>
<%		
	}
%>

	</td>
		</tr>
		</TABLE>

		
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">

try{
	window.opener.btnWfCenterReload.onclick()
}catch(e){}

if (window.addEventListener){
    window.addEventListener("load", windowOnload, false);
}else if (window.attachEvent){
    window.attachEvent("onload", windowOnload);
}else{
    window.onload=windowOnload;
}


//function doDrawBack(obj){
//obj.disabled=true;
//document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=ov&requestid=<%=requestid%>" //xwj for td3665 20060224
//}
function doRetract(obj){
obj.disabled=true;
document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=rb&requestid=<%=requestid%>" //xwj for td3665 20060224
}

function showWFHelp(docid){
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    var operationPage = "/docs/docs/DocDsp.jsp?id="+docid;
    window.open(operationPage,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
// modify by xhheng @20050304 for TD 1691
function openSignPrint1() {
    var redirectUrl = "PrintMode.jsp?requestid=<%=requestid%>&isbill=<%=isbill%>&workflowid=<%=workflowid%>&formid=<%=formid%>&nodeid=<%=nodeid%>&billid=<%=billid%>&fromFlowDoc=1&urger=<%=urger%>&ismonitor=<%=ismonitor%>" ;
  var width = screen.availWidth-10 ;
  var height = screen.availHeight-50 ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
   var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes,toolbar=no,location=no," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

//TD4262 增加提示信息  开始
//提示窗口
<%
    if(modeid>0 && "1".equals(ismode)){
%>
var oPopup = window.createPopup();
try{
    oPopup = window.createPopup();
}catch(e){}
function showObjectPopup(contentBox){
  try{
    var iX=document.body.offsetWidth/2-50;
	var iY=document.body.offsetHeight/2+document.body.scrollTop-50;

	var oPopBody = oPopup.document.body;
    oPopBody.style.border = "1px solid #8888AA";
    oPopBody.style.backgroundColor = "white";
    oPopBody.style.position = "absolute";
    oPopBody.style.padding = "0px";
    oPopBody.style.zindex = 150;

    oPopBody.innerHTML = contentBox.innerHTML;

    oPopup.show(iX, iY, 180, 22, document.body);
  }catch(e){}
}
function displaydivSign()
{
    if(oDivSign.style.display == ""){
        oDivSign.style.display = "none";
        workflowSignLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(21199,user.getLanguage())%></font>";
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none"&&oDivSign.style.display == "none"){
		    oDivAll.style.display = "none";
            spanimage.innerHTML = "<img src='/images/ArrowDownRed.gif' border=0>" ;
		}
    }
    else{
        oDivSign.style.display = "";
        workflowSignLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(21200,user.getLanguage())%></font>";
    }
}
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showallreceived(operator,operatedate,operatetime,returntdid,viewLogIds,logtype,destnodeid){
    <%
    if(modeid>0 && "1".equals(ismode)){
    %>
    showObjectPopup(document.getElementById("divFavContent19205"));
    <%}else{%>
    showPrompt("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    <%}%>
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowReceiviedPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid=<%=requestid%>&viewnodeIds="+viewLogIds+"&operator="+operator+"&operatedate="+operatedate+"&operatetime="+operatetime+"&returntdid="+returntdid+"&logtype="+logtype+"&destnodeid="+destnodeid);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            document.getElementById(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            hiddenPop();
        }
    }
}
function displaydiv_1()
{
    if(WorkFlowDiv.style.display == ""){
        WorkFlowDiv.style.display = "none";
        //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
    }
    else{
        WorkFlowDiv.style.display = "";
        //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";
    }
}
function openSignPrint() {
  var redirectUrl = "PrintRequest.jsp?requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=urger%>&ismonitor=<%=ismonitor%>" ;
  <%//解决相关流程打印权限问题  
  if(wflinkno>=0){
  %>
  redirectUrl = "PrintRequest.jsp?requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&isrequest=1&wflinkno=<%=wflinkno%>&urger=<%=urger%>&ismonitor=<%=ismonitor%>";   
  <%}%>  
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
szFeatures +="toolbar=yes," ;
  szFeatures +="scrollbars=yes," ;

  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}        
<%
    }else{
%>
var showTableDiv  = document.getElementById('_xTable');
var oIframe = document.createElement('iframe');
function showPrompt(content)
{
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.top=pTop;
     message_table_Div.style.left=pLeft;

     message_table_Div.style.zIndex=1002;
     //oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';

}
<%
    }
%>
//TD4262 增加提示信息  结束


function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}
function doReview(){
        var id = <%=requestid%>;
        //document.location.href="/workflow/request/Remark.jsp?requestid="+id; //xwj for td3247 20051201
		var forwardurl = "/workflow/request/Remark.jsp?requestid="+id;
		 <%if (!fromFlowDoc.equals("1")) {%>
        //document.location.href="/workflow/request/Remark.jsp?requestid="+id; //xwj for td3247 20051201
		<%}else {%>
        //parent.document.location.href="/workflow/request/Remark.jsp?requestid="+id; 
		<%}%>
		
		openFullWindowHaveBar(forwardurl);
		
		/**
		 var windforward = new Ext.Window({
	        layout: 'fit',
	        width: 500,
	        resizable: true,
	        height: 300,
	        closeAction: 'hide',
	        modal: true,
	        title: wmsg.wf.forward,
     	    html:'<iframe id="wfforward" name= "wfforward" BORDER=0 FRAMEBORDER=no height="100%" width="100%" scrolling="auto" src="'+forwardurl+'"></iframe>',
	        autoScroll: true,
	        buttons: [{
			            text: wmsg.wf.submit,// '提交',
			            handler: function(){
			                 document.frames['wfforward'].doSave(windforward);		                 
			            }
	        		},{
			            text: wmsg.wf.close,// '关闭',
			            handler: function(){
			                 windforward.hide();
			            }
        			}]
	    });
	    windforward.show("");     
		**/
		
   }
function onAddPhrase(phrase){//添加常用短语
	if(phrase!=null && phrase!=""){
		try{
			document.getElementById("remarkSpan").innerHTML = "";
		}catch(e){}
		try{
			var remarkHtml = FCKEditorExt.getHtml("remark");
			var remarkText = FCKEditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				FCKEditorExt.setHtml(phrase,"remark");
			}else{
				FCKEditorExt.setHtml(remarkHtml+"<p>"+phrase+"</p>","remark");
			}
		}catch(e){}
	}
}
<%if (isurger){%>
function doSupervise(obj)
{
var ischeckok="true";
<%
	if(isSignMustInputOfThisJsp.equals("1")){
	    if("1".equals(isFormSignatureOfThisJsp)){
		}else{
%>
            if(ischeckok=="true"){
            	getRemarkText_log();
			    if(!check_form(document.frmmain,'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>

    if(ischeckok=="true"){
        <% if(ismode.equals("1")){ %>
        contentBox = document.getElementById("divFavContent18978");
        showObjectPopup(contentBox)
    <% }else{ %>
        var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
        showPrompt(content);
    <%  } %>
        $G("src").value='supervise';
        obj.disabled=true;
        //附件上传
                StartUploadAll();
               checkuploadcomplet();
    }
}
<%}%>
<%if (intervenorright>0){%>
function doIntervenor(obj)
{
	var ischeckok="true";
	<%
		if(isSignMustInputOfThisJsp.equals("1")){
		    if("1".equals(isFormSignatureOfThisJsp)){
			}else{
	%>
	            if(ischeckok=="true"){
	            	getRemarkText_log();
				    if(!check_form(document.frmmain,'remarkText10404')){
					    ischeckok="false";
				    }
			    }
	<%
			}
		}
	%>
	if(ischeckok=="true"){
	    if(check_form(document.frmmain,"submitNodeId,Intervenorid")){
			if (confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>")){
	        <% if(modeid>0 && "1".equals(ismode)){ %>
	        contentBox = document.getElementById("divFavContent18978");
	        showObjectPopup(contentBox)
	    <% }else{ %>
	        var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
	        showPrompt(content);
	    <%  } %>
	        //document.getElementById("src").value='intervenor';
		    document.frmmain.src.value='intervenor';
	        document.frmmain.action="RequestOperation.jsp";
	        obj.disabled=true;
	            //附件上传
	                StartUploadAll();
	               checkuploadcomplet();
				}
		}
	}
}
<%}%>
/** added by cyril on 2008-07-09 for TD:8835*/
function doViewModifyLog() {
	var logURL = "/workflow/request/RequestModifyLogView.jsp?requestid=<%=requestid%>&nodeid=<%=nodeid%>&isAll=0&ismonitor=<%=ismonitor%>&urger=<%=urger%>";
	window.open(logURL);
	/*
	if(parent!=null)
		parent.document.location.href = logURL;
	else
		document.location.href = logURL;
	*/
}
/** end by cyril on 008-07-09 for TD:8835*/
function onNewRequest(wfid,requestid,agent){
	var redirectUrl =  "AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&reqid="+requestid;
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}
function onNewSms(wfid, nodeid, reqid){
	var redirectUrl =  "/sms/SendRequestSms.jsp?workflowid="+wfid+"&nodeid="+nodeid+"&reqid="+reqid;
	var width = screen.availWidth/2;
	var height = screen.availHeight/2;
	var top = height/2;
	var left = width/2;
	var szFeatures = "top="+top+"," ;
	szFeatures +="left="+left+"," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}
function doSubmitBack(obj){
	document.getElementById("needwfback").value = "1";
	doSubmit(obj);
}
function doSubmitNoBack(obj){
	document.getElementById("needwfback").value = "0";
	doSubmit(obj);
}
function doStop(obj){
	//您确定要暂停当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26156,user.getLanguage())%>?")){
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=stop&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
function doCancel(obj){
	//您确定要撤销当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26157,user.getLanguage())%>?")){
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=cancel&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
function doRestart(obj)
{
	//您确定要启用当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26158,user.getLanguage())%>?")){
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?flag=restart&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
function doRemark_nBack(obj){
	document.getElementById("needwfback").value = "1";
	doRemark_n(obj);
}
function doRemark_nNoBack(obj){
	document.getElementById("needwfback").value = "0";
	doRemark_n(obj);
}
function doAffirmanceBack(obj){
	document.getElementById("needwfback").value = "1";
	doAffirmance(obj);
}
function doAffirmanceNoBack(obj){
	document.getElementById("needwfback").value = "0";
	doAffirmance(obj);
}
function doRemark_n(obj){        <!-- 点击被转发的提交按钮,点击抄送的人员提交 -->
	document.frmmain.src.value='save';
	document.frmmain.action="RequestRemarkOperation8.jsp";
	//附件上传
    StartUploadAll();
    checkuploadcomplet();
}
function getRemarkText_log(){
	try{
		var reamrkNoStyle = FCKEditorExt.getText("remark");
		if(reamrkNoStyle == ""){
			document.getElementById("remarkText10404").value = reamrkNoStyle;
		}else{
			var remarkText = FCKEditorExt.getTextNew("remark");
			document.getElementById("remarkText10404").value = remarkText;
		}
		for(var i=0; i<FCKEditorExt.editorName.length; i++){
			var tmpname = FCKEditorExt.editorName[i];
			try{
				if(tmpname == "remark"){
					continue;
				}
				$(tmpname).value = FCKEditorExt.getText(tmpname);
			}catch(e){}
		}
	}catch(e){
	}
}
<%if("1".equals(session.getAttribute("istest"))){%>
function setAdiabled(){
	jQuery("a").attr("disabled", true);
	jQuery("a").attr("onclick", "");
	jQuery("a").attr("href", "");
	jQuery("a").attr("target", "_blank");
}
function setAdiabledLoad(){
	setAdiabled();
	setInterval(setAdiabled, 500);
}
jQuery(document).ready(function(){
	setAdiabledLoad();
});
<%}%>
</SCRIPT>
<!-- added by cyril on 20080605 for td8828-->
<script language=javascript src="/js/checkData.js"></script>
<script type="text/javascript" src="/js/swfupload/workflowswfupload.js"></script>