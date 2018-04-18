<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.ryanjbradley.iLazy.*" %>

   			
   			<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="./style.css">
<title>iLazy Shop - By Ryan Bradley</title>


<script type="text/javascript">
    //<![CDATA[
    function submit( element )
    {
    	var form = get_form(element);
    	if (form != null)
    		form.submit();
    }
               
               
    function get_form( element ) {
        while( element ) {
            element = element.parentNode
            if( element.tagName.toLowerCase() == "form" ) {
                //alert( element ) //debug/test
                return element
            }
        }
        return 0; //error: no form found in ancestors
    }
    //]]>
</script>
</head>
    <%
  		//get the customer from the session
  		Customer customer = (Customer) session.getAttribute("customer");
    
    	//if a customer is logged in
   		if (customer != null) {
   			//redirect them to the homepage
   			response.sendRedirect("./");
		}
   		else {
   			//get the iLazy object from the application scope
   			ShopApp iLazy = (ShopApp) application.getAttribute("iLazy");

   			//if iLazy hasnt been set
   			if (iLazy == null) {
   				//make a new instance
   				//iLazy = new ShopApp(application.getRealPath("/shop/retail.csv"));		//local test filepath
   				iLazy = new ShopApp();
   				
   				//add iLazy into the application scope.
   				application.setAttribute("iLazy", iLazy);
   			} %>

<body>
	<div class="header">
		<h1>
			<a href="/">iLazy</a>
		</h1>
	</div>
	<div class="nav">
		<ul>
			<li></li>
			<li><a href="../">Home</a></li>
			<li><a href="./">Shop</a></li>
			<li><a class="current" href="../login.jsp">Login</a></li>
			<li></li>
		</ul>
	</div>
	<div class="content">
		<h1>Customer Login</h1>
		<form action="loginAction.jsp" method="post">
			<select name="id">
				<% 
				//add each item for sale into a dropdown menu
				for (int i: iLazy.getCustomerIDs()) { %>
				<option value="<%=i%>"><%=i %></option>
				<% } %>
			</select> 
			<br>
			<a href="" onclick="submit(this); return false" class="btn">Login</a>
		</form>
	</div>
</body>
</html>
<% } %>
