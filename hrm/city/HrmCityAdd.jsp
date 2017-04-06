<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(493,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",/hrm/city/HrmCity.jsp,_self} " ;
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
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=weaver name=frmMain action="CityOperation.jsp" method=post >
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="10%">
  <COL width="20%">
  <COL width="40%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=3 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 maxlength="30" name="cityname" onchange='checkinput("cityname","citynameimage")'>
          <SPAN id=citynameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
		  <td align="left"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27086,user.getLanguage())%></font></td>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
       <TR>
          <TD><%=SystemEnv.getHtmlLabelName(801,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 maxlength="7" name="citylongitude" onKeyPress="ItemNum_KeyPress()" onchange='checknumber1(this) ; checkinput("citylongitude","citylongitudeimage")' >
          <SPAN id=citylongitudeimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
       <TR>
          <TD><%=SystemEnv.getHtmlLabelName(802,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 maxlength="7" name="citylatitude" onKeyPress="ItemNum_KeyPress()" onchange='checknumber1(this) ;checkinput("citylatitude","citylatitudeimage")'>
          <SPAN id=citylatitudeimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
          <TD class=Field><button type=button  class=Browser id=SelectCountryID onclick="onShowCountryID()"></BUTTON> 
              <SPAN id=countryidspan><IMG src="/images/BacoError.gif" 
            align=absMiddle></SPAN> 
              <input class=inputstyle id=CountryCode type=hidden name=countryid></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TD>
          <TD class=Field><button type=button  class=Browser id=SelectProvinceID onclick="onShowProvinceID()"></BUTTON> 
              <SPAN id=provinceidspan><IMG src="/images/BacoError.gif" 
            align=absMiddle></SPAN> 
              <input class=inputstyle id=ProvinceCode type=hidden name=provinceid></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
        <input class=inputstyle type="hidden" name=operation value=add>
 </TBODY></TABLE>
 </form>
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
<script language=javascript>  
var submit_flag=false;
function submitData() {
if(submit_flag){return;}else{submit_flag=true;}
 if(check_form($GetEle("frmMain"),'cityname,citylongitude,citylatitude,countryid,provinceid')){
	 $GetEle("frmMain").submit();
 }
}
</script>


<script type="text/javascript">
function onShowCountryID() {
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
    try {
        jsid = new Array();jsid[0] = wuiUtil.getJsonValueByIndex(id, 0); jsid[1] = wuiUtil.getJsonValueByIndex(id, 1);
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            $GetEle("countryidspan").innerHTML = jsid[1];
            $GetEle("countryid").value = jsid[0];
        }else {
            $GetEle("countryidspan").innerHTML = "";
            $GetEle("countryid").value = "";
        }
    }
}
function onShowProvinceID() {
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
    try {
        jsid = new Array();jsid[0] = wuiUtil.getJsonValueByIndex(id, 0); jsid[1] = wuiUtil.getJsonValueByIndex(id, 1);
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            $GetEle("provinceidspan").innerHTML = jsid[1];
            $GetEle("provinceid").value = jsid[0];
        }else {
            $GetEle("provinceidspan").innerHTML = "";
            $GetEle("provinceid").value = "";
        }
    }
}
</script>

</BODY>
</HTML>