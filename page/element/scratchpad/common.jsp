<%@page import="java.util.ArrayList;"%>
<jsp:useBean id="rs_Setting" class="weaver.conn.RecordSet" scope="page" />
<%
	ArrayList nameList = new ArrayList();
	ArrayList valueList = new ArrayList();
	nameList.add("height");
	String strSettingSql = "select * from hpElementSetting where eid = " + eid;
	//System.out.println("eid && " + eid);
	rs_Setting.execute(strSettingSql);
	if (!rs_Setting.next())
	{

		valueList.add("200");
		int maxId = 0;
		strSettingSql = "select count(*) as maxId from hpElementSetting ";
		rs_Setting.execute(strSettingSql);
		if (rs_Setting.next())
		{
			maxId = rs_Setting.getInt("maxId");
		}
		maxId++;
		//System.out.println("maxId && " + maxId);
		String insertStr = "";

		for (int i = 0; i < nameList.size(); i++)
		{
			insertStr = "insert into hpElementSetting (id,eid,name,value) values(" + (maxId + i) + "," + eid + ",'" + nameList.get(i) + "','"
					+ valueList.get(i) + "')";
			rs_Setting.execute(insertStr);
			valueList.add("");
		}
	}
	else
	{
		String selectStr = "";
		for (int i = 0; i < nameList.size(); i++)
		{
			selectStr = "select * from hpElementSetting where eid=" + eid + " and name='" + nameList.get(i) + "'";
			rs_Setting.execute(selectStr);
			if (rs_Setting.next())
			{
				valueList.add(rs_Setting.getString("value"));
			}
		}
	}
%>