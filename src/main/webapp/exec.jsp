<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.ryanjbradley.iLazy.*"%>
	
	<%
		Customer customer = (Customer) session.getAttribute("customer");
	%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="style.css">
<title>iLazy - By Ryan Bradley</title>
</head>
<body>
	<div class="header">
		<h1>
			<a href="/">iLazy</a>
		</h1>
	</div>
	<div class="nav">
		<ul>
			<li></li>
			<li><a href="./">Home</a></li>
			<li><a href="./shop">Shop</a></li>
			<li>
			<% 
			if (customer == null) 
				out.print("<a href=\"./login.jsp\">Login</a>");
			else
				out.print("<a href=\"./logout.jsp\">Logout</a>");
			%>
			</li>
			<li><a class="current" href="exec.jsp"></a></li>
		</ul>
	</div>
	<div class="content">
		<H1>CONTENT</H1>
	</div>
</body>
</html>