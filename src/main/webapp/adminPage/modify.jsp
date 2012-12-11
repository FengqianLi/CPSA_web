<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@page import="javabeans.User,javabeans.Group, dbManager.DBManager"%>
<%@page import="java.util.ArrayList"%>
<%
	User user = DBManager.dbUtil.getUserByUserId(Integer
			.parseInt(request.getParameter("id")));
	ArrayList<Group> groupList = DBManager.dbUtil.getGroupList();
%>
<html>
<head>
<title>修改用户信息</title>
<meta http-equiv="Content-Type" content="text/html;charset=gb2312">
<link href="../css/modify.css" rel="stylesheet" type="text/css">
</head>
<body>
	<form id="modify" method="post" action="modify_ok.jsp">
		<h1>修改资料</h1>
		用户名:<input id="username" type="text" name="username"
			onblur="checkname()" value="<%=user.getUserName()%>"> <br />
		密码:&nbsp;&nbsp;&nbsp;<input id="password" type="password"
			name="password" value="<%=user.getPassword()%>"> <br />
		组别:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="group">
			<%
				for (Group group : groupList) {
			%>
			<option value="group.getGroupId()"><%=group.getGroupName()%></option>
			<%
				}
			%>
		</select><br /> 角色:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="role"
			value="leader">
			<option value="member">member</option>
			<option value="leader">leader</option>
			<option value="manager">manager</option>
			<option value="admin">admin</option>
		</select><br /> 邮箱:&nbsp;&nbsp;&nbsp;<input id="email" type="email"
			name="email" value="<%=user.getEmail()%>"> <br />
		<fieldset id="actions">
			<input type="submit" id="submit" value="提交">
		</fieldset>
		</table>
	</form>
	</form>
</body>
</html>