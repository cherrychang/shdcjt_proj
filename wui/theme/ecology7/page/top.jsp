<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>

<%@ page import="weaver.systeminfo.menuconfig.MenuMaint"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.GCONST"%>

<%
    /*用户验证*/
    User user = HrmUserVarify.getUser(request, response);
    if (user == null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
%>

<%
    MenuMaint mm = new MenuMaint("left", 3, user.getUID(), user.getLanguage());
    List menuArray = byClickCntSort(user, mm.getAllMenus(user, 1));
    boolean rmflg = menuArray.remove(null); 
    while(rmflg) {
    	rmflg = menuArray.remove(null);
    }
    String skin = (String)request.getAttribute("REQUEST_SKIN_FOLDER");
%>


<%!
private String[] convMenuInfo(User user, Map map) {
	String[] result = new String[3];
	
    int level = Integer.parseInt((String) map.get("levelid"));
    String sicon = "";
    String sname = "";
	String position = "";
	String isDefault="1"; //是否具有默认图标菜单
    switch (level) {
    //任务管理
    case -2908:            
        sname = SystemEnv.getHtmlLabelName(1332, user.getLanguage());
        position += "-0 -111";
        break;
    //集成系统
    case -2774:            
        sname = SystemEnv.getHtmlLabelName(26267, user.getLanguage());
        position += "-0 -37";
        break;
    //计划任务
    case -2741:            
        sname = SystemEnv.getHtmlLabelName(407, user.getLanguage());
        position += "-148 -74";
        break;
    //临时LICENSE
    case -2080:
        sname = SystemEnv.getHtmlLabelName(18599, user.getLanguage());
        position += "-185 -74";
        break;
    //流程
    case 1:       
        sname = SystemEnv.getHtmlLabelName(22244, user.getLanguage());
        position += "-111 -0";
        break;
    //我的知识
    case 2:
        sname = SystemEnv.getHtmlLabelName(26268,user.getLanguage());
        position += "-74 -0";
        break;
    //我的客户
    case 3:
        sname = SystemEnv.getHtmlLabelName(21313, user.getLanguage());
        position += "-148 -0";
        break;
    //我的项目
    case 4:
        sname = SystemEnv.getHtmlLabelName(25106, user.getLanguage());
        position += "-185 -0";
        break;
    //人事
    case 5:
        sname = SystemEnv.getHtmlLabelName(20694, user.getLanguage());
        position += "-222 -0";
        break;
    //我的会议
    case 6:
        sname = SystemEnv.getHtmlLabelName(2103, user.getLanguage());
        position += "-74 -37";
        break;
    //我的资产
    case 7:
        sname = SystemEnv.getHtmlLabelName(535, user.getLanguage());
        position += "-37 -37";
        break;
    //我的邮件
    case 10:
        sname = SystemEnv.getHtmlLabelName(71, user.getLanguage());
        break;
    //我的短信
    case 11:
        sname = SystemEnv.getHtmlLabelName(22825, user.getLanguage());
        break;
    //我的协助    
    case 80:
        sname = SystemEnv.getHtmlLabelName(26269, user.getLanguage());
        position += "-37 -0";
        break;
    //目标绩效
    case 94:
        sname = SystemEnv.getHtmlLabelName(26270, user.getLanguage());
        position += "-111 -74";
        break;
    //我的通信
    case 107:
        sname = SystemEnv.getHtmlLabelName(26271, user.getLanguage());
        position += "-74 -111";
        break;
    //我的报表
    case 110:
        sname = SystemEnv.getHtmlLabelName(15101, user.getLanguage());
        position += "-37 -74";
        break;
    //信息中心
    case 111:
        sname = SystemEnv.getHtmlLabelName(87, user.getLanguage());
        position += "-0 -74";
        break;
    //系统设置
    case 114:
        sname = SystemEnv.getHtmlLabelName(22250, user.getLanguage());
        position += "-74 -74";
        break;
    //我的日程
    case 140:
        sname = SystemEnv.getHtmlLabelName(2211, user.getLanguage());
        position += "-148 -37";
        break;
     //车辆管理
    case 144:
        sname = SystemEnv.getHtmlLabelName(920, user.getLanguage());
        position += "-185 -37";
        break;
    //我的相册
    case 199:
        sname = SystemEnv.getHtmlLabelName(20003, user.getLanguage());
        position += "-222 -37";
        break;
    //临时LICENSE
    case 227:
        sname = SystemEnv.getHtmlLabelName(18599, user.getLanguage());
        position += "-185 -74";
        break;
    //计划任务
    case 263:
        sname = SystemEnv.getHtmlLabelName(407, user.getLanguage());
        position += "-148 -74";
        break;
    //我的客服
    case 352:
        sname = SystemEnv.getHtmlLabelName(26272, user.getLanguage());
        position += "-222 -74";
        break;
    case 392:
        sname = SystemEnv.getHtmlLabelName(26467, user.getLanguage());
        position += "-37 -111"; 
        break;  
    //我的邮件
    case 536:
        sname = SystemEnv.getHtmlLabelName(71, user.getLanguage());
        position += "-111 -37";
        break;
    default:
        sname = (String) map.get("name");
        String topIcon=(String)map.get("topIcon");
        if("".equals(topIcon))
    	   position += "";
        else{
           position+=topIcon;
           isDefault="0";
        }   
        break;
    }

    if (sname == null || "".equals(sname.trim())) {
    	sname = SystemEnv.getHtmlLabelName(149, user.getLanguage());
    } 
    
    if ("".equals(position)) {
        position += "-315 0";
    }
    
    result[0] = sname;
    result[1] = position;
    result[2] = isDefault;
    return result;
}

private List byClickCntSort(User user, List target) {
	int displayMenuCount = 6;
	//result
	List sortList = new ArrayList();
	//初始化返回菜单列表
	for(int i=0; i<displayMenuCount; i++) {
		sortList.add(null);
	}
	//点击量最高的6个菜单id列表
	List menuIds = new ArrayList();
	
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	String dbType = rs.getDBType();
	String exeSql = "";
	System.out.println(dbType);
	if ("sqlserver".equals((dbType))) {
		exeSql = "SELECT menuId, clickCnt FROM HrmUserMenuStatictics WHERE userid=" + user.getUID() + " order by clickCnt desc, menuid";
	} else {
		//exeSql = "select t.rownumber,t.menuId, t.clickCnt  from ( SELECT rownum as rownumber,menuId, clickCnt FROM HrmUserMenuStatictics WHERE userid=" + user.getUID() + " order by clickCnt desc, menuid) t  where t.rownumber<=6";	
		exeSql = "select t.rownumber,t.menuId, t.clickCnt  from ( SELECT rownum as rownumber,menuId, clickCnt from (SELECT menuId, clickCnt FROM HrmUserMenuStatictics WHERE userid=" + user.getUID() + " order by clickCnt desc, menuid) t ) t  where t.rownumber>=0";	
	}
	
	//取得点击量最高的6个菜单
	rs.executeSql(exeSql);
	int displayClickMenuCnt = 0;
	while(rs.next()) {
		long clickCnt = 0;
		int menuId = 0;
		try {
			clickCnt = Long.parseLong(rs.getString("clickCnt"));
		} catch(NumberFormatException e) {
			clickCnt = 0;
		}
		menuId = Util.getIntValue(rs.getString("menuId"), 0);
		
		if (clickCnt > 0 && hasVisible(menuId, target)) {
			if (displayClickMenuCnt > displayMenuCount - 1) {
				continue;				
			}
			displayClickMenuCnt++;
			menuIds.add(new Integer(menuId));	
		}
	}
	
	Iterator it = target.iterator();
	while(it.hasNext()) {
		Map map = (Map) it.next();
		int menuId = Integer.parseInt((String)map.get("levelid"));
		int index = menuIds.indexOf(new Integer(menuId));
		
		if (index != -1) {
			sortList.set(index, map);
			continue;
		}
		sortList.add(map);
	}
	
	return sortList;
}

private boolean hasVisible(int id, List target) {
	Iterator it = target.iterator();
	while(it.hasNext()) {
		Map map = (Map) it.next();
		int menuId = Integer.parseInt((String)map.get("levelid"));
		
		if (id == menuId) {
			return true;
		}
	}
	return false;
}
%>

<%
int pdHeight = 0;
if ((menuArray.size() + 1)%7 != 0) {
	pdHeight = ((menuArray.size() + 1)/7 + 1) *  65;
} else {
	pdHeight = ((menuArray.size() + 1)/7) *  65;
}
%>

<style>
    #divFloatBg{width:63px;height:70px;position:absolute;left:3px;top:1px;background:url(/wui/theme/ecology7/skins/<%= skin%>/page/top/slideItembg.png);background-repeat: no-repeat;cursor:pointer;}  
	
	.topMenuDiv {position:absolute;width:461px;height:70px;overflow:hidden;top:0;
	}
	.topMenuDiv_top {position:relative;width:410px;top:0;overflow:hidden;height:<%=pdHeight + 10%>;float:left;
		left:15px;
		padding-top:5px;
	}
	
	.menuItem{width:45px;height:65px;background:none;float:left;position:relative;margin-right:10px;cursor:pointer;}
	.menuItemIcon{width:32px;height:32px;margin-left:15px;margin-top:6px;cursor:pointer;background:url(/wui/theme/ecology7/skins/<%= skin%>/page/top/menutopicons.png) no-repeat;}
    .slideItemText{padding-left:2px;padding-right:3px;text-align:right;font-family:"微软雅黑","verdana";font-size:11px;color:#EFEFEF;margin-top:2px;font-weight:bold;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;}
	.menuItemEnd{clear:left}  
	.menuNavSpan_Expand {background:url(/wui/theme/ecology7/skins/<%=skin %>/page/top/menutopicons.png);background-position:-287 -0;background-repeat:no-repeat;}
	.menuNavSpan_Contraction {background:url(/wui/theme/ecology7/skins/<%=skin %>/page/top/menutopicons.png); background-position:-259 0; background-repeat:no-repeat;}
</style>

<script type="text/javascript">
<!--
function topMenuBgIframeOnload(_this) {
	_this.contentWindow.document.body.style.background = 'transparent';
	_this.contentWindow.document.body.style.border='none';
}
//-->
</script>

<table border="0" width="461px" height="70px" align="center" cellpadding="0px" cellspacing="0px">
<tr>
	<td valign="center" width="461px">
		<div class="topMenuDiv">
		<iframe src="" style="filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';filter:alpha(opacity=0);opacity:0;position:absolute; visibility:inherit; top:0px; left:0px; width:100%; height:100%; z-index:-1; ">
		</iframe>
		<div class="topMenuDiv_top">
			<div id="divFloatBg"></div>
			<div class="menuItem" style="" onClick="dymlftenu(this);topMenuContraction();" >
			    <DIV class="menuItemIcon" style="background-position:0 0;"></DIV>
				<DIV class="slideItemText"><%=SystemEnv.getHtmlLabelName(582,user.getLanguage())%></DIV>
			</div>
			<%
			
			
			//String sicon = "/wui/theme/ecology7/skins/" + skin + "/page/top/menutopicons.png";
			int topLine = 1;
			//String sicon = "";
			String positoin = "";
			String sname = "";
			String isDefault="";
			String browser_isie=(String)session.getAttribute("browser_isie"); //当前浏览器是否为IE浏览器
			for (int index = 0; index < menuArray.size(); index++) {
				Map map = (Map) menuArray.get(index);
				
				if (map == null) continue;
				
				//非IE下是否启用系统设置菜单
				if(!"true".equals(browser_isie)){
					int level = Integer.parseInt((String) map.get("levelid"));
					if(level==114){
						String isOpenSysSettingMenu=GCONST.getSystemSettingMenu(); //是否开启系统设置菜单
						if(!isOpenSysSettingMenu.equals("1"))
							continue; //没有开启则不显示系统设置菜单
					}
				}
			    String[] convInfo = convMenuInfo(user, map);
			    sname = convInfo[0];
			    //sicon = convInfo[1];
			    positoin = convInfo[1]; 
			    isDefault = convInfo[2]; 
			    String chinese = "[\u0391-\uFFE5]";
			    int length=0;
			    String tempName="";
			    for(int i=0;i<sname.length();i++){
			    	String temp = sname.substring(i, i + 1);
			    	if (temp.matches(chinese)) {
		                length += 2; /* 中文字符长度为2 */
		            } else {
		                length += 1; /* 其他字符长度为1 */
		            }
			    	if(length>4)
			    		break;
			    	else
			    		tempName+=temp;

			    }
			    
			%> 
			<div class="menuItem" style="" onClick="clickstatictics(this);" levelid="<%=map.get("levelid")%>" id="<%=map.get("id")%>" target="<%=map.get("target")%>"  title="<%=sname%>">
			    <DIV class="menuItemIcon" style="<%=isDefault.equals("1")?"background-position:"+positoin:"background: url('"+positoin+"')"%>;"></DIV>
				<DIV class="slideItemText"><%=tempName %></DIV>
			</div>
			<%
				topLine++;
			}
			%>
		</div>
		<div style="cursor:pointer;width:27px;height:55px;float:left;position:relative;top:5px;left:15px;" id="topMenuContr" style="" class="menuNavSpan_Expand"></div>
		</div>
	</td>
	
</tr>
</table>

<!-- For slide-->
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.cycle.all.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.easing.js"></script>    
<script language="javascript">

//顶部菜单最大高度
var TOP_MENU_MAX_HEIGHT = "<%=pdHeight + 10%>";   
jQuery(document).ready(function(){
	//导航块移动
    jQuery(".menuItem").hover(function() {
    	topMenuNavMove(this);
    }, function(){});
    //菜单展开或者收缩
    jQuery("#topMenuContr").bind("click", function() {
    	if (jQuery(".topMenuDiv").height() > 70) {
    		jQuery(this).removeClass("menuNavSpan_Contraction");
    		jQuery(this).addClass("menuNavSpan_Expand");
    		topMenuContraction();
    	} else {
    		jQuery(this).removeClass("menuNavSpan_Expand");
    		jQuery(this).addClass("menuNavSpan_Contraction");
	        topMenuExpand();
	    }
    });
    
    //光标不在菜单区域时，如果菜单时展开的则收缩。
    jQuery(".topMenuDiv").hover(function() {}, function() {
    	if (jQuery(".topMenuDiv").height() > 70) {
	    	topMenuContraction();
	    }
    });
});

function topMenuNavMove(_this) {
    $this=jQuery(_this);
    jQuery("#divFloatBg").show();
    jQuery("#divFloatBg").each(function(){jQuery.dequeue(this, "fx");}).animate({                
        top: $this.position().top -3,
        left: $this.position().left+4
    },600, 'easeOutExpo');
}

/**
* 菜单收缩
*/
function topMenuContraction() {
	jQuery("#topMenuContr").removeClass("menuNavSpan_Contraction");
    jQuery("#topMenuContr").addClass("menuNavSpan_Expand");
   	
	jQuery(".topMenuDiv").each(function() {jQuery.dequeue(this, "fx")}).animate({
		height:70
	} , 0);
	if (jQuery("#divFloatBg").offset().top >= 67 ) {
	    jQuery("#divFloatBg").hide();
	}
	jQuery(".topMenuDiv").css("background", "");
}

/**
* 菜单展开
*/
function topMenuExpand() {
	jQuery(".topMenuDiv").css("background", "url(/wui/theme/ecology7/skins/<%=skin %>/page/top/menu_expand_bg.jpg)  ");
	jQuery(".topMenuDiv").css("background-position","0 <%="-" + (342 - (pdHeight + 10)) %>");
	jQuery(".topMenuDiv").css("background-repeat","no-repeat");
	jQuery(".topMenuDiv").each(function() {jQuery.dequeue(this, "fx")}).animate({
   		height: TOP_MENU_MAX_HEIGHT
   	} , 0);
}

/**
* 点击菜单项时触发，会统计菜单点击的次数，并打开子项（左侧）
*/
function clickstatictics(_this) {
	topMenuContraction();

	//jQuery(".slideDivHidden").hide();//animate({opacity: "hide", height: "hide"}, 0);
	dymlftenu(_this);
	var ajaxUrl = "/wui/theme/ecology7/page/topMenuClickStatictics.jsp";
	ajaxUrl += "?mid=";
	ajaxUrl += jQuery(_this).attr("levelid");
	ajaxUrl += "&token=";
	ajaxUrl += new Date().getTime();
	
	jQuery.ajax({
	    url: ajaxUrl,
	    dataType: "text", 
	    contentType : "charset=gbk", 
	    error:function(ajaxrequest){}, 
	    success:function(content){
	    }  
    });
}
</script>