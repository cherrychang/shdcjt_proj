/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._system;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;

public class _createdb__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = _jsp_application.getJspApplicationContext().allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);
    javax.servlet.jsp.PageContext _jsp_parentContext = pageContext;
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html; charset=GBK");
    request.setCharacterEncoding("GBK");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

      out.write(_jsp_string1, 0, _jsp_string1.length);
      
String message = Util.null2String(request.getParameter("message")) ;
String imagefilename = "/images/hdSystem.gif";
String titlename = "\u6570\u636e\u5e93\u8bbe\u7f6e" ;
String needfav ="1";
String needhelp ="";

      out.write(_jsp_string2, 0, _jsp_string2.length);
      
	if(!message.equals("")){
	
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((message));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      }
      out.write(_jsp_string5, 0, _jsp_string5.length);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_application.getJspApplicationContext().freePageContext(pageContext);
    }
  }

  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.server.util.CauchoSystem.getVersionId() != 1886798272571451039L)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.vfs.Dependency depend;
      depend = (com.caucho.vfs.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void init(ServletConfig config)
    throws ServletException
  {
    com.caucho.server.webapp.WebApp webApp
      = (com.caucho.server.webapp.WebApp) config.getServletContext();
    super.init(config);
    com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
    com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.PageContextImpl(webApp, this);
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("system/CreateDB.jsp"), 8636729413813692726L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string4;
  private final static char []_jsp_string5;
  private final static char []_jsp_string0;
  private final static char []_jsp_string3;
  private final static char []_jsp_string1;
  static {
    _jsp_string2 = "\r\n<BODY>\r\n<DIV class=HdrProps>\r\n  <TABLE class=Form>\r\n    <COLGROUP> <COL width=\"20%\"> <COL width=\"80%\"><TBODY> \r\n    <TR class=Section> \r\n      <TH colSpan=2>\u6570\u636e\u5e93</TH>\r\n    </TR>\r\n    </TBODY> \r\n  </TABLE>\r\n</DIV>\r\n\r\n\r\n<FORM style=\"MARGIN-TOP: 0px\" name=frmMain method=post action=\"CreateDBOperation.jsp\">\r\n<div>\r\n<BUTTON class=btn id=btnSave accessKey=S name=btnSave type=button  onClick=\"OnSubmit()\"><U>S</U>-\u521b\u5efa</BUTTON> \r\n<BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-\u91cd\u7f6e</BUTTON> \r\n</div>    <br>\r\n   \r\n  <TABLE class=Form>\r\n    <COLGROUP> <COL width=\"20%\"> <COL width=\"80%\"><TBODY> \r\n    <TR class=Separator> \r\n      <TD class=sep1 colSpan=2></TD>\r\n    </TR>\r\n     <tr>\r\n        <td nowrap>\u9a8c\u8bc1\u7801:</td>\r\n        <td  class=Field><input type=password  name=code maxlength=16 size=16> <a  href=\"\\system\\ModifyCode.jsp\">\u66f4\u6539\u9a8c\u8bc1\u7801</a></td>\r\n    </tr>\r\n    <tr> \r\n      <td>\u6570\u636e\u5e93\u7c7b\u578b</td>\r\n      <td class=Field> \r\n        <select name=dbtype onchange=\"if(this.value==1) dbport.value='1433';else if(this.value==2) dbport.value='1521';\">\r\n			<option value=\"1\">SqlServer</option>\r\n			<option value=\"2\">Oracle</option>\r\n			<!--option value=\"3\">DB2</option-->\r\n		</select>\r\n      </td>\r\n    </tr>\r\n    <tr> \r\n      <td>\u6570\u636e\u5e93\u670d\u52a1\u5668IP</td>\r\n      <td class=Field> \r\n        <input accesskey=Z name=dbserver  maxlength=\"20\" value=\"127.0.0.1\">\r\n      </td>\r\n    </tr>\r\n    <tr>\r\n    <tr>\r\n      <td>\u6570\u636e\u5e93\u7aef\u53e3\u53f7</td>\r\n      <td class=Field>\r\n        <input accesskey=Z name=dbport  maxlength=\"20\" value=\"\">\r\n      </td>\r\n       <script>\r\n           if(document.all('dbtype').value==1)\r\n           document.all('dbport').value='1433';\r\n           else if(document.all('dbtype').value==2)\r\n           document.all('dbport').value='1521';\r\n       </script>\r\n    </tr>\r\n    <tr>\r\n      <td>\u6570\u636e\u5e93\u540d\u79f0</td>\r\n      <td class=Field> \r\n        <input accesskey=Z name=dbname  maxlength=\"20\" value=\"ecology\">\r\n      </td>\r\n    </tr>\r\n    <tr> \r\n      <td>\u7528\u6237\u540d</td>\r\n      <td class=Field> \r\n        <input accesskey=Z name=username  maxlength=\"20\" value=\"sa\">\r\n      </td>\r\n    </tr>\r\n    <tr> \r\n      <td>\u5bc6\u7801</td>\r\n      <td class=Field> \r\n        <input accesskey=Z type=password name=password  maxlength=\"20\" value=\"\">\r\n      </td>\r\n    </tr>\r\n    <tr> \r\n      <td>\u4f7f\u7528\u73b0\u6709\u6570\u636e\u5e93</td>\r\n      <td class=Field> \r\n        <input accesskey=Z type=checkbox name=isexist  value=\"1\">\r\n      </td>\r\n    </tr>\r\n\r\n    </TBODY> \r\n  </TABLE>\r\n  </FORM>\r\n	".toCharArray();
    _jsp_string4 = "\r\n	</font>\r\n	</DIV>\r\n	".toCharArray();
    _jsp_string5 = "\r\n\r\n<SCRIPT language=\"javascript\">\r\nfunction OnSubmit(){\r\n        document.frmMain.btnSave.disabled = true;\r\n		document.frmMain.submit();\r\n}\r\n</script>\r\n</BODY>\r\n</HTML>\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string3 = "\r\n	<DIV>\r\n	<font color=red size=2>\r\n	".toCharArray();
    _jsp_string1 = "\r\n\r\n<HTML><HEAD>\r\n<LINK href=\"/css/Weaver.css\" type=text/css rel=STYLESHEET>\r\n<META http-equiv=Content-Type content=\"text/html; charset=gbk\">\r\n<SCRIPT language=\"javascript\" src=\"/js/weaver.js\"></script>\r\n</head>\r\n".toCharArray();
  }
}
