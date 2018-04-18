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
			<li><a class="current" href="./">Home</a></li>
			<li><a href="./shop">Shop</a></li>
			<li>
			<% 
			if (customer == null) 
				out.print("<a href=\"./login.jsp\">Login</a>");
			else
				out.print("<a href=\"./logout.jsp\">Logout</a>");
			%>
			</li>
			<li><a href="exec.jsp"></a></li>
		</ul>
	</div>
	<div class="content">
		<h1>Welcome to iLazy</h1>
		<img src="http://www.authentic-life.net/wp-content/uploads/2015/06/lazy-cat.jpg">
		<h2>
			Are you naturally a lazy person? Then <em>iLazy</em> is for you!
		</h2>
		<p>
			Here at iLazy, we help you <span class="big">B</span>uild, <span
				class="big">B</span>argain, <span class="big">B</span>uy and <span
				class="big">B</span>ring. <br> <span class="big">Build</span><em>
				your shopping list!</em> - By analysing transaction data, we have worked
			out what products customers buy together, so rather than you
			searching to add these items, we will find them for you <br> <span
				class="big">Bargain</span><em> prices!</em> - Using your location
			information provided by you in your profile, we can then look for
			these items at stores near you and compare their prices to ensure
			that you get the best bargains <br> <span class="big">Buy</span><em>
				your shopping list!</em> - Once you have picked all of your items and
			what stores you want them from, we can take the hassle of buying
			these items out of your hands. All you need to do is provide us with
			a payment method <br> <span class="big">Bring</span><em>
				your shopping to you!</em> - We can even arrange to have your shopping
			delivered straight to your door when you shop with us
		</p>
		<h2>
			<a class="btn" href="./shop">Start Now!</a>
		</h2>
	</div>
</body>
</html>