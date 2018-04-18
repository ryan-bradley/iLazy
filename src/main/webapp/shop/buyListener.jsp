
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.ryanjbradley.iLazy.*"%>

<%
		//get the iLazy object from the application scope
		ShopApp iLazy = (ShopApp) application.getAttribute("iLazy");

		//if iLazy hasnt been set
		if (iLazy == null) {
			
			//make a new instance
			iLazy = new ShopApp();
			
			//add iLazy into the application scope.
			application.setAttribute("iLazy", iLazy);
		}
		
		//get the customer from the session
		Customer customer = (Customer) session.getAttribute("customer");
		if (customer != null)
			//tell the iLazy system to buy the items in a specific customers cart
			iLazy.buy(customer.id());
		
		response.sendRedirect("./");
%>