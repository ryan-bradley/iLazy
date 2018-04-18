<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.ryanjbradley.iLazy.*" %>
<%
	int id = Integer.parseInt(request.getParameter("id"));

	//get the iLazy object from the application scope
	ShopApp iLazy = (ShopApp) application.getAttribute("iLazy");

	//if iLazy hasnt been set
	if (iLazy == null) {
		//make a new instance
		//iLazy = new ShopApp(application.getRealPath("/shop/retail.csv"));		//local test filepath
		iLazy = new ShopApp();
		
		//add iLazy into the application scope.
		application.setAttribute("iLazy", iLazy);
	} 
	
	Customer customer = iLazy.login(id);
	if (customer != null)
	{
		session.setAttribute("customer", customer);
		response.sendRedirect("./");
	}

%>