<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/>
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" />
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" />
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page" />
<jsp:useBean id="WFLinkInfo_nf" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="RecordSet6" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RecordSet7" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet8" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RecordSet9" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RequestTriDiffWfManager" class="weaver.workflow.request.RequestTriDiffWfManager" scope="page" /> 

<%
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
%>

<%
String isworkflowdoc = Util.getIntValue(request.getParameter("isworkflowdoc"),0)+"";//�Ƿ�Ϊ����
int seeflowdoc = Util.getIntValue(request.getParameter("seeflowdoc"),0);

String newfromdate="a";
String newenddate="b";
String  isrequest = Util.null2String(request.getParameter("isrequest")); // �Ƿ��Ǵ���ع���������������,1:��
int modeid = Util.getIntValue(request.getParameter("modeid"),0);
int isform = Util.getIntValue(request.getParameter("isform"),0);
String docCategory="";
int salesMessage = Util.getIntValue(request.getParameter("salesMessage"),-1);
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
String wfdoc = Util.null2String((String)session.getAttribute(requestid+"_wfdoc"));
String message = Util.null2String(request.getParameter("message"));  // ���صĴ�����Ϣ
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
String requestname="";      //��������
String requestlevel="";     //������Ҫ���� 0:���� 1:��Ҫ 2:����
String requestmark = "" ;   //������
String isbill="0";          //�Ƿ񵥾� 0:�� 1:��
int creater=0;              //����Ĵ�����
int creatertype = 0;        //���������� 0: �ڲ��û� 1: �ⲿ�û�
int deleted=0;              //�����Ƿ�ɾ��  1:�� 0�������� ��
int billid=0 ;              //����ǵ���,��Ӧ�ĵ��ݱ���id
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //�Ƿ�����̴����ĵ�����
int workflowid=0;           //������id
String workflowtype = "" ;  //����������
int formid=0;               //�������ߵ��ݵ�id
int helpdocid = 0;          //�����ĵ� id
int nodeid=0;               //�ڵ�id
String nodetype="";         //�ڵ�����  0:���� 1:���� 2:ʵ�� 3:�鵵
String workflowname = "" ;          //����������
String isreopen="";                 //�Ƿ�����ش�
String isreject="";                 //�Ƿ�����˻�
int isremark = -1 ;              //��ǰ����״̬  modify by xhheng @ 20041217 for TD 1291
String status = "" ;     //��ǰ�Ĳ�������
String needcheck="requestname";

String topage = Util.null2String(request.getParameter("topage")) ;        //���ص�ҳ��
String isaffirmance=Util.null2String(request.getParameter("isaffirmance"));//�Ƿ���Ҫ�ύȷ��
String reEdit=Util.null2String(request.getParameter("reEdit"));//�Ƿ�Ϊ�༭
// �������½��ĵ��Ĵ���
String docfileid = Util.null2String(request.getParameter("docfileid"));   // �½��ĵ��Ĺ������ֶ�

// ��ƽ 2004-12-2 FOR TD1421  �½�����ʱ�����������ϵ��ĵ��½���ť�����½����ĵ�֮���ܷ������̣������ĵ�ȴû�йҴ�������
String newdocid = Util.null2String(request.getParameter("newdocid"));        // �½����ĵ�
int desrequestid=0;

// �������û���Ϣ
int userid=user.getUID();                   //��ǰ�û�id
int usertype = 0;                           //�û��ڹ��������е����� 0: �ڲ� 1: �ⲿ
String logintype = user.getLogintype();     //��ǰ�û�����  1: ����û�  2:�ⲿ�û�
String username = "";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

String sql = "" ;
char flag = Util.getSeparator() ;
boolean wfmonitor="true".equals(session.getAttribute(userid+"_"+requestid+"wfmonitor"))?true:false;                //���̼����
boolean haveBackright=false;            //ǿ���ջ�Ȩ��
boolean haveOverright=false;            //ǿ�ƹ鵵Ȩ��
boolean haveStopright = false;			//��ͣȨ��
boolean haveCancelright = false;		//����Ȩ��
boolean haveRestartright = false;		//����Ȩ��
String currentnodetype = "";
int currentnodeid = 0;

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
formid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"formid"),0);
billid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"billid"),0);
isbill=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isbill"));
isremark=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"isremark"));
helpdocid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"helpdocid"),0);
docCategory=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"docCategory"));
String IsPendingForward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsPendingForward"));
boolean IsCanSubmit="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanSubmit"))?true:false;
String IsBeForward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsBeForward"));
currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"currentnodeid"),0);
currentnodetype=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"currentnodetype"));
boolean IsFreeWorkflow="true".equals(session.getAttribute(userid+"_"+requestid+"IsFreeWorkflow"))?true:false;
boolean isImportDetail="true".equals(session.getAttribute(userid+"_"+requestid+"isImportDetail"))?true:false;

boolean IsCanModify="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanModify"))?true:false;
String coadisforward=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"coadisforward"));
boolean coadCanSubmit="true".equals(session.getAttribute(userid+"_"+requestid+"coadCanSubmit"))?true:false;
RecordSet.executeSql("select isremark,nodeid from workflow_currentoperator where (isremark<8 or isremark>8) and requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by isremark");
while(RecordSet.next())	{
    int tempisremark = Util.getIntValue(RecordSet.getString("isremark"),0) ;
    int tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"));
    if( tempisremark == 0 || tempisremark == 1 || tempisremark == 5 || tempisremark == 9|| tempisremark == 7) {                       // ��ǰ�����߻�ת����
        isremark = tempisremark ;
        nodeid=tmpnodeid;
        nodetype=WFLinkInfo_nf.getNodeType(nodeid);
        break ;
    }
}
if( isremark != 0 && isremark != 1  && isremark != 5 && isremark != 8 && isremark != 9&& isremark != 7) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int currentstatus = -1;//��ǰ����״̬(��Ӧ������ͣ����������)
String isModifyLog = "";
RecordSet.executeSql("select t1.ismodifylog,t2.currentstatus from workflow_base t1, workflow_requestbase t2 where t1.id=t2.workflowid and t2.requestid="+requestid);
if(RecordSet.next()) {
	currentstatus = Util.getIntValue(RecordSet.getString("currentstatus"));
	isModifyLog = RecordSet.getString("isModifyLog");
	
}
haveStopright = WfFunctionManageUtil.haveStopright(currentstatus,creater,user,currentnodetype,requestid,false);//���̲�Ϊ��ͣ���߳���״̬����ǰ�û�Ϊ���̷����˻���ϵͳ����Ա����������״̬��Ϊ�����͹鵵
haveCancelright = WfFunctionManageUtil.haveCancelright(currentstatus,creater,user,currentnodetype,requestid,false);//���̲�Ϊ����״̬����ǰ�û�Ϊ���̷����ˣ���������״̬��Ϊ�����͹鵵
haveRestartright = WfFunctionManageUtil.haveRestartright(currentstatus,creater,user,currentnodetype,requestid,false);//����Ϊ��ͣ���߳���״̬����ǰ�û�Ϊϵͳ����Ա����������״̬��Ϊ�����͹鵵
if(currentstatus>-1&&!haveCancelright&&!haveRestartright)
{
	String tips = "";
	if(currentstatus==0)
	{
		tips = SystemEnv.getHtmlLabelName(26154,user.getLanguage());//��������ͣ,�������̷����˻�ϵͳ����Ա��ϵ!
	}
	else
	{
		tips = SystemEnv.getHtmlLabelName(26155,user.getLanguage());//�����ѳ���,����ϵͳ����Ա��ϵ!
	}
%>
	<script language="JavaScript">
		var tips = '<%=tips%>';
		if(tips!="")
		{
			alert(tips);
		}
		window.location.href="/notice/noright.jsp?isovertime=<%=isovertime%>";
	</script>
<%
    return ;
}
RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSet.next()){
	isreopen=RecordSet.getString("isreopen");
	isreject=RecordSet.getString("isreject");
}
// ��¼�鿴��־
String clientip = request.getRemoteAddr();
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;
if(isremark == 8){
	//RecordSet.executeSql("update workflow_currentoperator set isremark=2,operatedate='"+currentdate+"',operatetime='"+currenttime+"' where requestid="+requestid+" and userid="+userid+" and usertype=0"+usertype);
  //ʱ�������ݿⱣ��һ�£����Բ��ô洢�������������ݿ⡣
  RecordSet.executeProc("workflow_CurrentOperator_Copy",requestid+""+flag+userid+flag+usertype+"");
  if(currentnodetype.equals("3")){
  	RecordSet.executeSql("update workflow_currentoperator set iscomplete=1 where requestid="+requestid+" and userid="+userid+" and usertype="+usertype);
  }
	response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&isremark=8&fromFlowDoc="+fromFlowDoc);
	return;
}
/*--  xwj for td2104 on 20050802 begin  --*/
boolean isOldWf = false;
RecordSet.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSet.next()){
	if(RecordSet.getString("nodeid") == null || "".equals(RecordSet.getString("nodeid")) || "-1".equals(RecordSet.getString("nodeid"))){
			isOldWf = true;
	}
}
if(isOldWf){//������ , ��� td2104 ��ǰ
RecordSet.executeProc("workflow_RequestViewLog_Insert",requestid+"" + flag + userid+"" + flag + currentdate +flag + currenttime + flag + clientip + flag + usertype +flag + nodeid + flag + "9" + flag + -1);
//������û���κεط�ʹ����ordertype='-1'�����������Դ˴�ֱ�Ӱ�-1�ĳ�9 by ben 2006-05-24 for TD4396
}
else{
int showorder = 10000;
String orderType = ""; 
RecordSet.executeSql("select agentorbyagentid, agenttype, showorder from workflow_currentoperator where userid = " + userid +
" and nodeid = " + nodeid + " and requestid = " + requestid + " and isremark in ('0','1','4','5','8','9','7') and usertype = " + usertype);
if(RecordSet.next()){ 
  orderType = "1"; // ��ǰ�ڵ������
  showorder  = RecordSet.getInt("showorder");
}
else{

orderType = "2";// �ǵ�ǰ�ڵ������
RecordSet.executeSql("select max(showorder) from workflow_requestviewlog where id = " + requestid + "  and ordertype = '2' and currentnodeid = " + nodeid);
RecordSet.next();
if(RecordSet.getInt(1) != -1){ 
showorder = RecordSet.getInt(1) + 1;
}
}
RecordSet.executeProc("workflow_RequestViewLog_Insert",requestid+"" + flag + userid+"" + flag + currentdate +flag + currenttime + flag + clientip + flag + usertype + flag + nodeid + flag + orderType + flag + showorder);
}
/*--  xwj for td2104 on 20050802 end  --*/

if(! currentnodetype.equals("3") )
    RecordSet.executeProc("SysRemindInfo_DeleteHasnewwf",""+userid+flag+usertype+flag+requestid);
else
    RecordSet.executeProc("SysRemindInfo_DeleteHasendwf",""+userid+flag+usertype+flag+requestid);

String imagefilename = "/images/hdReport.gif";
String titlename =  SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage())+ " - " + status + " "+"<span id='requestmarkSpan'>"+requestmark+"</span>";//Modify by ����� 2004-10-26 For TD1231
String needfav ="1";
String needhelp ="";

//�ж��Ƿ������̴����ĵ��������ڸýڵ����������ֶ�
boolean docFlag=flowDoc.haveDocFiled(""+workflowid,""+nodeid);
String  docFlagss=docFlag?"1":"0";
session.setAttribute("requestAdd"+requestid,docFlagss);
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script>    
<meta http-equiv="Content-Type" content="text/html; charset=GBK">

<style>
.wordSpan{font-family:MS Shell Dlg,Arial;CURSOR: hand;font-weight:bold;FONT-SIZE: 10pt}
</style>
</head>
<title><%=requestname%></title>
<SCRIPT language=VBS>

Sub oc_CurrentMenuOnMouseOut(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = "hidden"
End Sub

Sub oc_CurrentMenuOnClick(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = ""
End Sub
</SCRIPT>

<script language="javascript">

//TD4262 ������ʾ��Ϣ  ��ʼ
function windowOnload()
{
    init();
    funcremark_log();
<%
	if( message.equals("1") ) {//��������Ϣ�������
%>
	      contentBox = document.getElementById("divFavContent16332");
          showObjectPopup(contentBox);
          window.setTimeout("oPopup.hide()", 2000);
<%
	} else if( message.equals("2") ) {//��������һ�ڵ����һ�ڵ�����ߴ���
%>
	      contentBox = document.getElementById("divFavContent16333");
          showObjectPopup(contentBox);
          window.setTimeout("oPopup.hide()", 2000);
<%
	} else if( message.equals("3") ) {//�����̴�������ֵ�����������̴��������á�
%>

		  var content="<%=SystemEnv.getHtmlLabelName(19455,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	} else if( message.equals("4") ) {//�Ѿ���ת����һ�ڵ㣬���������ύ��
%>

		  var content="<%=SystemEnv.getHtmlLabelName(21266,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	} else if( message.equals("5") ) {//������ת��ʱ�������ԡ�
%>

		  var content="<%=SystemEnv.getHtmlLabelName(21270,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	} else if( message.equals("6") ) {//ת��ʧ�ܣ������ԣ�
%>

		  var content="<%=SystemEnv.getHtmlLabelName(21766,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	} else if( message.equals("7") ) {//�Ѿ������������ظ�������
%>

		  var content="<%=SystemEnv.getHtmlLabelName(22751,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	}
%>
}


//TD4262 ������ʾ��Ϣ  ����

  function protectManageBillFlow(){
  	if(!checkDataChange())//modified by cyril on 2008-06-10 for TD:8828
        event.returnValue="<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
   }
   function doBack(){
	   jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		 <%if (!fromFlowDoc.equals("1")) {%>
        document.location.href="/workflow/request/RequestView.jsp"; //xwj for td3425 20051201
		<%}else {%>
        parent.document.location.href="/workflow/request/RequestView.jsp"; 
		<%}%>
   }

function replaceAll(strOrg,strFind,strReplace){ 
    var index = 0; 
    while(strOrg.indexOf(strFind,index) != -1){ 
        strOrg = strOrg.replace(strFind,strReplace); 
        index = strOrg.indexOf(strFind,index); 
    } 
    return strOrg 
} 

function doLocationHref(){
	var id = <%=requestid%>;
	var workflowRequestLogId=0;
	if(document.all("workflowRequestLogId")!=null){
		workflowRequestLogId=document.all("workflowRequestLogId").value;
	}
	try{
		FCKEditorExt.updateContent();
		frmmain.target = "_blank";
		frmmain.action = "/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId;
		var nowtarget = frmmain.target;
		var nowaction = frmmain.action;
		//�����ϴ�
                        StartUploadAll();
                        checkfileuploadcomplet();
		frmmain.target = nowtarget;
		frmmain.action = nowaction;
	}catch(e){
		var remark="";
		try{
			remark = FCKEditorExt.getHtml("remark");
		}catch(e){}
		var forwardurl = "/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&remark="+escape(remark);	
		openFullWindowHaveBar(forwardurl);
	}
}

<%
String isFormSignatureOfThisJsp=null;
int toexcel=0;
RecordSet.executeSql("select ismode,showdes,isFormSignature,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isFormSignatureOfThisJsp = Util.null2String(RecordSet.getString("isFormSignature"));
	toexcel=Util.getIntValue(RecordSet.getString("toexcel"),0);
}
int isUseWebRevisionOfThisJsp = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
if(isUseWebRevisionOfThisJsp != 1){
	isFormSignatureOfThisJsp = "";
}
String hasSign = "0";
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-4");
if(RecordSet.next()){ hasSign = "1";}
%>

   function doReview(){


	   jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

//����ǩ������
<%if("1".equals(isFormSignatureOfThisJsp)&&"0".equals(hasSign)){%>
	                    if(SaveSignature()){
                            doLocationHref();
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
							    alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							return ;
						}
<%}else{%>
                        doLocationHref();
<%}%>

   }

</SCRIPT>

<BODY><%--Modified by xwj for td3247 20051201--%>

<%@ include file="/systeminfo/TopTitle.jsp" %>

<iframe id="triSubwfIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<%//TD9145
Prop prop = Prop.getInstance();
String ifchangstatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
String submitname = "" ; // �ύ��ť������ : ����, ����, ʵ��
String forwardName = "";//ת��
String saveName = "";//����
String rejectName = "";//�˻�
String forsubName = "";//ת���ύ
String ccsubName = "";//�����ύ
String newWFName = "";//�½����̰�ť
String newSMSName = "";//�½����Ű�ť
String haswfrm = "";//�Ƿ�ʹ���½����̰�ť
String hassmsrm = "";//�Ƿ�ʹ���½����Ű�ť
int t_workflowid = 0;//�½����̵�ID
String subnobackName = "";//�ύ���跴��
String subbackName = "";//�ύ�跴��
String hasnoback = "";//ʹ���ύ���跴����ť
String hasback = "";//ʹ���ύ�跴����ť
String forsubnobackName = "";//ת����ע���跴��
String forsubbackName = "";//ת����ע�跴��
String hasfornoback = "";//ʹ��ת����ע���跴����ť
String hasforback = "";//ʹ��ת����ע�跴����ť
String ccsubnobackName = "";//������ע���跴��
String ccsubbackName = "";//������ע�跴��
String hasccnoback = "";//ʹ�ó�����ע���跴����ť
String hasccback = "";//ʹ�ó�����ע�跴����ť
String newOverTimeName=""; //��ʱ���ð�ť
String hasovertime="";    //�Ƿ�ʹ�ó�ʱ���ð�ť
String FreeWorkflowname=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"FreeWorkflowname"));
String sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+nodeid;
if(isremark != 0){
	RecordSet.executeSql("select nodeid from workflow_currentoperator c where c.requestid="+requestid+" and c.userid="+userid+" and c.usertype="+usertype+" and c.isremark='"+isremark+"' ");
	int tmpnodeid = 0;
	if(RecordSet.next()){
		tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"), 0);
	}
	sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+tmpnodeid;
}

RecordSet.executeSql(sqlselectName);

if(RecordSet.next()){
	if(user.getLanguage() == 7){
		submitname = Util.null2String(RecordSet.getString("submitname7"));
		forwardName = Util.null2String(RecordSet.getString("forwardName7"));
		saveName = Util.null2String(RecordSet.getString("saveName7"));
		rejectName = Util.null2String(RecordSet.getString("rejectName7"));
		forsubName = Util.null2String(RecordSet.getString("forsubName7"));
		ccsubName = Util.null2String(RecordSet.getString("ccsubName7"));
		newWFName = Util.null2String(RecordSet.getString("newWFName7"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName7"));
		subnobackName = Util.null2String(RecordSet.getString("subnobackName7"));
		subbackName = Util.null2String(RecordSet.getString("subbackName7"));
		forsubnobackName = Util.null2String(RecordSet.getString("forsubnobackName7"));
		forsubbackName = Util.null2String(RecordSet.getString("forsubbackName7"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName7"));
		ccsubbackName = Util.null2String(RecordSet.getString("ccsubbackName7"));
        newOverTimeName = Util.null2String(RecordSet.getString("newOverTimeName7"));
	}
	else if(user.getLanguage() == 9){
		submitname = Util.null2String(RecordSet.getString("submitname9"));
		forwardName = Util.null2String(RecordSet.getString("forwardName9"));
		saveName = Util.null2String(RecordSet.getString("saveName9"));
		rejectName = Util.null2String(RecordSet.getString("rejectName9"));
		forsubName = Util.null2String(RecordSet.getString("forsubName9"));
		ccsubName = Util.null2String(RecordSet.getString("ccsubName9"));
		newWFName = Util.null2String(RecordSet.getString("newWFName9"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName9"));
		subnobackName = Util.null2String(RecordSet.getString("subnobackName9"));
		subbackName = Util.null2String(RecordSet.getString("subbackName9"));
		forsubnobackName = Util.null2String(RecordSet.getString("forsubnobackName9"));
		forsubbackName = Util.null2String(RecordSet.getString("forsubbackName9"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName9"));
		ccsubbackName = Util.null2String(RecordSet.getString("ccsubbackName9"));
        newOverTimeName = Util.null2String(RecordSet.getString("newOverTimeName9"));
	}
	else{
		submitname = Util.null2String(RecordSet.getString("submitname8"));
		forwardName = Util.null2String(RecordSet.getString("forwardName8"));
		saveName = Util.null2String(RecordSet.getString("saveName8"));
		rejectName = Util.null2String(RecordSet.getString("rejectName8"));
		forsubName = Util.null2String(RecordSet.getString("forsubName8"));
		ccsubName = Util.null2String(RecordSet.getString("ccsubName8"));
		newWFName = Util.null2String(RecordSet.getString("newWFName8"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName8"));
		subnobackName = Util.null2String(RecordSet.getString("subnobackName8"));
		subbackName = Util.null2String(RecordSet.getString("subbackName8"));
		forsubnobackName = Util.null2String(RecordSet.getString("forsubnobackName8"));
		forsubbackName = Util.null2String(RecordSet.getString("forsubbackName8"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName8"));
		ccsubbackName = Util.null2String(RecordSet.getString("ccsubbackName8"));
        newOverTimeName = Util.null2String(RecordSet.getString("newOverTimeName8"));
	}
	haswfrm = Util.null2String(RecordSet.getString("haswfrm"));
	hassmsrm = Util.null2String(RecordSet.getString("hassmsrm"));
	hasnoback = Util.null2String(RecordSet.getString("hasnoback"));
	hasback = Util.null2String(RecordSet.getString("hasback"));
	hasfornoback = Util.null2String(RecordSet.getString("hasfornoback"));
	hasforback = Util.null2String(RecordSet.getString("hasforback"));
	hasccnoback = Util.null2String(RecordSet.getString("hasccnoback"));
	hasccback = Util.null2String(RecordSet.getString("hasccback"));
	t_workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
    hasovertime = Util.null2String(RecordSet.getString("hasovertime"));
}
if(isremark == 1){
	submitname = forsubName;
	subnobackName = forsubnobackName;
	subbackName = forsubbackName;
}
if(isremark == 9||isremark == 7){
	submitname = ccsubName;
	subnobackName = ccsubnobackName;
	subbackName =  ccsubbackName;
}
if("".equals(submitname)){
	if(nodetype.equals("0") || isremark == 1 || isremark == 9 ||isremark == 7)	{
		submitname = SystemEnv.getHtmlLabelName(615,user.getLanguage());      // �����ڵ����ת��, Ϊ�ύ
	}else if(nodetype.equals("1")){
		submitname = SystemEnv.getHtmlLabelName(142,user.getLanguage());  // ����
	}else if(nodetype.equals("2")){
		submitname = SystemEnv.getHtmlLabelName(725,user.getLanguage());  // ʵ��
	}
}
if("".equals(subbackName)){
		if(nodetype.equals("0") || isremark == 1 || isremark == 9||isremark == 7)	{
			if((nodetype.equals("0") && ("1".equals(hasnoback)||"1".equals(hasback))) || (isremark==1 && ("1".equals(hasfornoback)||"1".equals(hasforback))) || (isremark==9 && ("1".equals(hasccnoback)||"1".equals(hasccback)))){
				subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"��"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"��";      // �����ڵ����ת��, Ϊ�ύ
			}else{
				subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage());
			}
		}else if(nodetype.equals("1")){
			if("1".equals(hasnoback)||"1".equals(hasback)){
				subbackName = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"��"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"��";  // ����
			}else{
				subbackName = SystemEnv.getHtmlLabelName(142,user.getLanguage());
			}
		}else if(nodetype.equals("2")){
			if("1".equals(hasnoback)||"1".equals(hasback)){
				subbackName = SystemEnv.getHtmlLabelName(725,user.getLanguage())+"��"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"��";  // ʵ��
			}else{
				subbackName = SystemEnv.getHtmlLabelName(725,user.getLanguage());
			}
		}
}
if("".equals(subnobackName)){
	if(nodetype.equals("0") || isremark == 1 || isremark == 9||isremark == 7)	{
		subnobackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"��"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"��";      // �����ڵ����ת��, Ϊ�ύ
	}else if(nodetype.equals("1")){
		subnobackName = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"��"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"��";  // ����
	}else if(nodetype.equals("2")){
		subnobackName = SystemEnv.getHtmlLabelName(725,user.getLanguage())+"��"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"��";  // ʵ��
	}
}
if("".equals(forwardName)){
	forwardName = SystemEnv.getHtmlLabelName(6011,user.getLanguage());
}
if("".equals(saveName)){
	saveName = SystemEnv.getHtmlLabelName(86,user.getLanguage());
}
if("".equals(rejectName)){
	rejectName = SystemEnv.getHtmlLabelName(236,user.getLanguage());
}
if("".equals(FreeWorkflowname.trim())){
	FreeWorkflowname = SystemEnv.getHtmlLabelName(21781,user.getLanguage());
}
%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
String strBar="[";//�˵�
if(!wfmonitor){
    if (isaffirmance.equals("1") && nodetype.equals("0") && !reEdit.equals("1")){//�ύȷ�ϲ˵�
if(IsCanSubmit||coadCanSubmit){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(16634,user.getLanguage())+",javascript:doSubmit_Pre(this),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(16634,user.getLanguage())+"',iconCls:'btn_draft',handler: function(){bodyiframe.doSubmit_Pre(this);}},";
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location.href='ViewRequest.jsp?requestid="+requestid+"&isovertime="+isovertime+"&reEdit=1&fromFlowDoc=1',_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"',iconCls:'btn_draft',handler: function(){do2ReEditPage();}},";
}else{%>
<% if(isremark == 1||isremark == 9){ %>
<%
    if("".equals(ifchangstatus)){
		//RCMenu += "{"+submitname+",javascript:doRemark_nNoBack(),_self}" ;
		//RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){bodyiframe.doRemark_nNoBack();}},";
	}else{
		if((!"1".equals(hasfornoback)&&isremark==1) || (!"1".equals(hasccnoback)&&isremark==9)){
			//RCMenu += "{"+subbackName+",javascript:doRemark_nBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doRemark_nBack(this);}},";
		}else{
			if(("1".equals(hasforback)&&isremark==1) || ("1".equals(hasccback)&&isremark==9)){
				//RCMenu += "{"+subbackName+",javascript:doRemark_nBack(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doRemark_nBack(this);}},";
			}
			//RCMenu += "{"+subnobackName+",javascript:doRemark_nNoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doRemark_nNoBack(this);}},";
		}
	}
		if(isremark==1&&IsCanModify){
        strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){bodyiframe.doSave_nNew();}},";
    }
    if((isremark==1&&IsBeForward.equals("1"))||(isremark==9&&IsPendingForward.equals("1"))){
        //RCMenu += "{"+forwardName+",javascript:doReview(),_self}" ;//add by mackjoe
        //RCMenuHeight += RCMenuHeightStep ;
        strBar += "{text: '"+forwardName+"',iconCls:'btn_forward',handler: function(){bodyiframe.doReview();}},";
    }
}else if(isremark == 5){
    if("".equals(ifchangstatus)){
		//RCMenu += "{"+submitname+",javascript:doSubmitNoBack(this),_self}" ;
		//RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){bodyiframe.doSubmitNoBack(this);}},";
	}else{
		if(!"1".equals(hasnoback)){
			//RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},";
		}else{
			if("1".equals(hasback)){
				//RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},";
			}
			//RCMenu += "{"+subnobackName+",javascript:doSubmitNoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doSubmitNoBack(this);}},";
		}
	}
}else { %>
<%
if(IsCanSubmit||coadCanSubmit){
if (isaffirmance.equals("1") && nodetype.equals("0") && reEdit.equals("1")){
	if("".equals(ifchangstatus)){
		//RCMenu += "{"+submitname+",javascript:doAffirmanceNoBack(this),_self}" ;
		//RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){bodyiframe.doAffirmanceNoBack(this);}},";
	}else{
		if(!"1".equals(hasnoback)){
			//RCMenu += "{"+subbackName+",javascript:doAffirmanceBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doAffirmanceBack(this);}},";
		}else{
			if("1".equals(hasback)){
				//RCMenu += "{"+subbackName+",javascript:doAffirmanceBack(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doAffirmanceBack(this);}},";
			}
			//RCMenu += "{"+subnobackName+",javascript:doAffirmanceNoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doAffirmanceNoBack(this);}},";
		}
	}
}else{
    if("".equals(ifchangstatus)){
		//RCMenu += "{"+submitname+",javascript:doSubmitNoBack(this),_self}" ;
		//RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+submitname+"',iconCls:'btn_submit',handler: function(){bodyiframe.doSubmitNoBack(this);}},";
	}else{
		if(!"1".equals(hasnoback)){
			//RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},";
		}else{
			if("1".equals(hasback)){
				//RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
				strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},";
			}
			//RCMenu += "{"+subnobackName+",javascript:doSubmitNoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doSubmitNoBack(this);}},";
		}
	}
}
if(IsFreeWorkflow){
    //RCMenu += "{"+FreeWorkflowname+",javascript:doFreeWorkflow(),_self}" ;
    //RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+FreeWorkflowname+"',iconCls:'btn_edit',handler: function(){bodyiframe.doFreeWorkflow(this);}},";
}
if (isImportDetail) {
        strBar += "{text: '" + SystemEnv.getHtmlLabelName(26255, user.getLanguage()) + "',iconCls:'btn_edit',handler: function(){bodyiframe.doImportDetail();}},";
    }
//RCMenu += "{"+saveName+",javascript:doSave_nNew(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){bodyiframe.doSave_nNew();}},";
if( isreject.equals("1") &&isremark==0){
    //RCMenu += "{"+rejectName+",javascript:doReject_New(),_self}" ;
    //RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+rejectName+"',iconCls:'btn_rejectName',handler: function(){bodyiframe.doReject_New();}},";
}
}
if((isremark!=7&&IsPendingForward.equals("1"))||(isremark==7&&"1".equals(coadisforward))){
//RCMenu += "{"+forwardName+",javascript:doReview(),_self}" ;//Modified by xwj for td3247 20051201
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+forwardName+"',iconCls:'btn_forward',handler: function(){bodyiframe.doReview();}},";
}
%>

<%  if(isreopen.equals("1") && false ){%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:doReopen(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+"',iconCls:'btn_doReopen',handler: function(){bodyiframe.doReopen();}},";
%>
<%  }%>

<%
HashMap map = WfFunctionManageUtil.wfFunctionManageByNodeid(workflowid,nodeid);
String ov = (String)map.get("ov");
String rb = (String)map.get("rb");
haveOverright=isremark != 1&&isremark != 9&&isremark != 7&&isremark != 5&&"1".equals(ov) && WfForceOver.isNodeOperator(requestid,userid) && !currentnodetype.equals("3");
haveBackright=isremark != 1&&isremark != 9&&isremark != 7&&isremark != 5&&!"0".equals(rb) && WfForceDrawBack.isHavePurview(requestid,userid,Integer.parseInt(logintype),-1,-1) && !currentnodetype.equals("0");

if(haveOverright){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+",javascript:doDrawBack(this),_self}" ;//xwj for td3665 20060224
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+"',iconCls:'btn_doDrawBack',handler: function(){bodyiframe.doDrawBack(this);}},";
}

if(haveBackright){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+",javascript:doRetract(this),_self}" ;//xwj for td3665 20060224
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+"',iconCls:'btn_doRetract',handler: function(){bodyiframe.doRetract(this);}},";
}
if(haveStopright)
{
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(20387,user.getLanguage())+"',iconCls:'btn_end',handler: function(){bodyiframe.doStop(this);}},";
}
if(haveCancelright)
{
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(16210,user.getLanguage())+"',iconCls:'btn_backSubscrible',handler: function(){bodyiframe.doCancel(this);}},";
}
if(haveRestartright)
{
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"',iconCls:'btn_next',handler: function(){bodyiframe.doRestart(this);}},";
}
if(nodetype.equals("0")&&isremark != 1&&isremark != 9&&isremark != 7&&isremark != 5&&WfFunctionManageUtil.IsShowDelButtonByReject(requestid,workflowid)){    // �����ڵ�(�˻ش����ڵ�Ҳ��)
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"',iconCls:'btn_detele',handler: function(){bodyiframe.doDelete();}},";
}
}
%>
<%
/*added by cyril on 2008-07-10 for TD:8835*/
if(isModifyLog.equals("1")) {
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(21625,user.getLanguage())+",javascript:doViewModifyLog(),_self}" ;
	//RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(21625,user.getLanguage())+"',iconCls:'btn_doViewModifyLog',handler: function(){bodyiframe.doViewModifyLog();}},";
}
/*end added by cyril on 2008-07-10 for TD:8835*/
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
		//RCMenu += "{"+newWFName+",javascript:onNewRequest("+t_workflowid+", "+requestid+",0),_top} " ;
		//RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+newWFName+"',iconCls:'btn_newWFName',handler: function(){bodyiframe.onNewRequest("+t_workflowid+", "+requestid+",0);}},";
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
	//RCMenu += "{"+newSMSName+",javascript:onNewSms("+workflowid+", "+nodeid+", "+requestid+"),_top} " ;
	//RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+newSMSName+"',iconCls:'btn_newSMSName',handler: function(){bodyiframe.onNewSms("+workflowid+", "+nodeid+", "+requestid+");}},";
}
/*TD9145 END*/
if("1".equals(hasovertime)&&isremark==0){
	if("".equals(newOverTimeName)){
		newOverTimeName = SystemEnv.getHtmlLabelName(18818,user.getLanguage());
	}
	//RCMenu += "{"+newOverTimeName+",javascript:onNewOverTime(),_top} " ;
	//RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+newOverTimeName+"',iconCls:'btn_newSMSName',handler: function(){bodyiframe.onNewOverTime();}},";
}
String isTriDiffWorkflow=null;
RecordSet.executeSql("select isTriDiffWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
	isTriDiffWorkflow=Util.null2String(RecordSet.getString("isTriDiffWorkflow"));
}

if(!"1".equals(isTriDiffWorkflow)){
	isTriDiffWorkflow="0";
}


                StringBuffer sb=new StringBuffer();
				if("1".equals(isTriDiffWorkflow)){
					sb.append("  select  ab.id as subwfSetId,c.id as buttonNameId,c.triSubwfName7,c.triSubwfName8 from ")
					  .append(" ( ")
					  .append("  select a.triggerType,b.nodeType,b.nodeId,a.triggerTime,a.fieldId ,a.id ")
					  .append("    from Workflow_TriDiffWfDiffField a,workflow_flownode b ")
					  .append("   where a.triggerNodeId=b.nodeId ")
					  .append("     and a.mainWorkflowId=b.workflowId ")
					  .append("     and a.mainWorkflowId=").append(workflowid)
					  .append("     and a.triggerNodeId=").append(nodeid)
					  .append("     and a.triggerType='2' ")
					  .append(" )ab left join  ")
					  .append(" ( ")
					  .append("   select *  ")
					  .append("     from Workflow_TriSubwfButtonName ")
					  .append("    where workflowId=").append(workflowid)
					  .append("      and nodeId=").append(nodeid)
					  .append("      and subwfSetTableName='Workflow_TriDiffWfDiffField' ")
					  .append(" )c on ab.id=c.subwfSetId ")
					  .append(" order by ab.triggerType asc,ab.nodeType asc,ab.nodeId asc,ab.triggerTime asc,ab.fieldId asc ,ab.id asc ")
					  ;
				}else{
					sb.append("  select  ab.id as subwfSetId,c.id as buttonNameId,c.triSubwfName7,c.triSubwfName8 from ")
					  .append(" ( ")
					  .append("  select a.triggerType,b.nodeType,b.nodeId,a.triggerTime,a.subWorkflowId ,a.id ")
					  .append("    from Workflow_SubwfSet a,workflow_flownode b ")
					  .append("   where a.triggerNodeId=b.nodeId ")
					  .append("     and a.mainWorkflowId=b.workflowId ")
					  .append("     and a.mainWorkflowId=").append(workflowid)
					  .append("     and a.triggerNodeId=").append(nodeid)
					  .append("     and a.triggerType='2' ")
					  .append(" )ab left join  ")
					  .append(" ( ")
					  .append("   select *  ")
					  .append("     from Workflow_TriSubwfButtonName ")
					  .append("    where workflowId=").append(workflowid)
					  .append("      and nodeId=").append(nodeid)
					  .append("      and subwfSetTableName='Workflow_SubwfSet' ")
					  .append(" )c on ab.id=c.subwfSetId ")
					  .append(" order by ab.triggerType asc,ab.nodeType asc,ab.nodeId asc,ab.triggerTime asc,ab.subWorkflowId asc,ab.id asc ")
					  ;
				}
				int subwfSetId=0;
				int buttonNameId=0;
				String triSubwfName7=null;
				String triSubwfName8=null;
				String triSubwfName=null;
				String trClass="datalight";
				int indexId=0;
				RecordSet.executeSql(sb.toString());
				while(RecordSet.next()){
					subwfSetId=Util.getIntValue(RecordSet.getString("subwfSetId"),0);
					buttonNameId=Util.getIntValue(RecordSet.getString("buttonNameId"),0);
					triSubwfName7=Util.null2String(RecordSet.getString("triSubwfName7"));
					triSubwfName8=Util.null2String(RecordSet.getString("triSubwfName8"));
					indexId++;
					triSubwfName="";
					if(isremark!=1){
					if(user.getLanguage()==8){
						triSubwfName=triSubwfName8;
					}else{
						triSubwfName=triSubwfName7;
					}
					if(triSubwfName.equals("")){
						triSubwfName=SystemEnv.getHtmlLabelName(22064,user.getLanguage())+indexId;
					}
					//lihaibo start
					String finalsubworkflownameS="";
					if("1".equals(isTriDiffWorkflow)){
			        	finalsubworkflownameS = RequestTriDiffWfManager.getWorkFlowNameByisTriDiffWorkflow(requestid,subwfSetId,workflowid,nodeid);
					}else{
						finalsubworkflownameS = RequestTriDiffWfManager.getWorkFlowNameByDiffWorkflow(subwfSetId,workflowid);
					}
					strBar += "{text: '"+triSubwfName+"',iconCls:'btn_relateCwork',handler: function(){bodyiframe.triSubwf2("+subwfSetId+",\\\""+finalsubworkflownameS+"\\\");}},";
					//lihaibo end
					
					//RCMenu += "{"+triSubwfName+",javascript:triSubwf("+subwfSetId+"),_top} " ;
					//RCMenuHeight += RCMenuHeightStep ;
					//strBar += "{text: '"+triSubwfName+"',iconCls:'',handler: function(){bodyiframe.triSubwf("+subwfSetId+");}},";
				}
}

if(!isfromtab&&!"1".equals(session.getAttribute("istest"))){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+"',iconCls:'btn_back',handler: function(){bodyiframe.doBack();}},";
}
}
if(toexcel==1){
strBar += "{text: '"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+" Excel',iconCls:'btn_excel',handler: function(){bodyiframe.ToExcel();}},";
}
strBar += "{text: '"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+"',iconCls:'btn_print',handler: function(){bodyiframe.openSignPrint();}},";
}
if(strBar.lastIndexOf(",")>-1) strBar = strBar.substring(0,strBar.lastIndexOf(","));
strBar+="]";
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%@ include file="/workflow/request/RequestShowHelpDoc.jsp" %>
        <input type=hidden name=seeflowdoc value="<%=seeflowdoc%>">
		<input type=hidden name=isworkflowdoc value="<%=isworkflowdoc%>">
        <input type=hidden name=wfdoc value="<%=wfdoc%>">
        <input type=hidden name=picInnerFrameurl value="/workflow/request/WorkflowRequestPictureInner.jsp?fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&randpara=<%=System.currentTimeMillis()%>">
		<input type=hidden name=statInnerFrameurl value="WorkflowRequestPicture.jsp?hasExt=true&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&desrequestid=<%=desrequestid %>&randpara=<%=System.currentTimeMillis()%>">

		<%@ include file="/workflow/request/NewRequestFrame.jsp" %>
</body>
</html>
<script language="JavaScript">
	var bodyiframeurl = location.href.substring(location.href.indexOf("ManageRequestNoFormMode.jsp?")+28);
	function setbodyiframe(){
		document.getElementById("bodyiframe").src="ManageRequestNoFormModeIframe.jsp?"+bodyiframeurl;
		initNewRequestFrame();
		enableAllmenuParent();
		eventPush(document.getElementById('bodyiframe'),'load',loadcomplete);
	}
	//window.attachEvent("onload", setbodyiframe);
	if (window.addEventListener){
	    window.addEventListener("load", setbodyiframe, false);
	}else if (window.attachEvent){
	    window.attachEvent("onload", setbodyiframe);
	}else{
	    window.onload=setbodyiframe;
	}
	
    var wftitle="<%=titlename%>";
	var isfromtab=<%=isfromtab%>;	
	var bar=eval("<%=strBar%>");
	if("<%=seeflowdoc%>"=="1"){
		bar = eval("[]");
		if(document.all("rightMenu")!=null){
			document.all("rightMenu").style.display="none";
		}
	}  
	function do2ReEditPage(){
		location.href = "ViewRequest.jsp?requestid=<%=requestid%>&isovertime=<%=isovertime%>&reEdit=1&fromFlowDoc=<%=fromFlowDoc%>";
	}
</script>