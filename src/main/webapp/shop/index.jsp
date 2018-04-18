<%@page import="com.ryanjbradley.iLazy.ShopApp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.ryanjbradley.iLazy.*, java.util.*"%>

<%
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
		
		//get the item from the url request
		String itemString = request.getParameter("item");
		
		//item string as an int
		int itemNumber = 0;
		
		//Array of suggested items
		LinkedList<Object> personalisedSuggestions = null;
		
		//get the customer from the session
		Customer customer = (Customer) session.getAttribute("customer");
		
		Object[] generalSuggestions = null;
		
		//test to see if there was a request to add an item to the cart
		if (itemString != null) {
			
			//convert the item into an integer
			itemNumber = Integer.parseInt(itemString);
			
			/***********************************************\
			increase the quantity of the item in the cart
			find the suggested items based off the added item
			\***********************************************/
			generalSuggestions = iLazy.addToCart(customer,itemNumber, 1);
			
			//get the personal suggestions
			personalisedSuggestions = customer.privateSuggestions(itemNumber);
		}
	%>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style.css">
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
			<li><a class="current" href="./">Shop</a></li>
			<li>
			<% 
			if (customer == null) 
				out.print("<a href=\"../login.jsp\">Login</a>");
			else
				out.print("<a href=\"../logout.jsp\">Logout</a>");
			%>
			</li>
			<li></li>
		</ul>
	</div>
	<div class="content">
		<h1>Shopping with iLazy</h1>
		<% if (customer != null) out.print("<p>Customer "+customer.toString()+"</p>"); %>
		<% if (customer != null) {
			
			String empty = request.getParameter("empty");
			if (empty != null && empty.equals("true"))
				customer.getCart().clear();			

			//get the item numbers from the customers cart
			Set<Integer> keys = customer.getCart().keySet();
			
			//get the quantity of each item from the customers cart
			Object[] values = customer.getCart().values().toArray(); %>
		<form>
			<select name="item">
				<% 
				//add each item for sale into a dropdown menu
				for (int i: iLazy.items()) { %>
				<option value="<%=i%>"><%=i %></option>
				<% } %>
			</select> 
			<br>
			<a href="" onclick="submit(this); return false" class="btn">Add To Cart</a>
		</form>
		<br>
		<center>
		<%	/***********************************************\
			test to see if the array of suggested items is 
			not null and test to see if there are items in it
			\***********************************************/
			if ((personalisedSuggestions != null && personalisedSuggestions.size() > 0) 
					|| (generalSuggestions != null && generalSuggestions.length > 0)) { 
				out.print("<table><thead><tr><th colspan=\"2\">"+itemNumber+"'s Suggested Items</th></tr>");
				out.print("<tr><th>Item</th><th>Add To Cart</th></tr></thead>");
				out.print("<tbody>");
				
				if (generalSuggestions != null)
					//loop over each suggested item
					for (Object o: generalSuggestions)  {	
						//if this current item in the loop isnt already in the cart 
						if (!keys.contains(o)) 
							//display the item number and add a link to add the item to the cart
							out.print("<tr><td>" + o + "</td><td><a href=\"?item=" + o + "\">Add</a></td></tr>");
						else 
							//display that you already have that item
							out.print("<tr><td>" + o + "</td><td>Item in cart</td></tr>");
					}
				
				if (personalisedSuggestions != null)
					//loop over each suggested item
					for (Object o: personalisedSuggestions)  {	
						//if this current item in the loop isnt already in the cart 
						if (!keys.contains(o)) 
							//display the item number and add a link to add the item to the cart
							out.print("<tr><td>" + o + "</td><td><a href=\"?item=" + o + "\">Add</a></td></tr>");
						else 
							//display that you already have that item
							out.print("<tr><td>" + o + "</td><td>Item in cart</td></tr>");
					}
				
				out.print("</tbody></table>");
			} 
		
			//if there were no suggestions or there were no items added to the cart
			else { %>
				
				<% 
				//get an array of all popular items
				if (iLazy != null) {
					Object[] popularItems = iLazy.popularItems();
					//index to get popular items from the array
					int index = 0;
					
					out.print("<table><thead><tr><th colspan=\"3\">10 of iLazy's Popular Items!!!</th></tr>");
					out.print("<tr><th>#</th><th>Item</th><th>Add To Cart</th></tr></thead>");
					out.print("<tbody>");
					
					//loop 10 times
					for (int i = 1; i <= 10; i++)
						//make sure the index is still in the array
						if (index < popularItems.length) {
							//get the popular item from the array at the index
							Object o = popularItems[index];
							//if this popular item is not in the cart
							if (!keys.contains(o)) {
								//display a message to add the item to the cart
								out.print("<tr><td>"+ i + "</td><td>" + o + "</td><td><a href=\"?item=" + o + "\">Add</a></td></tr>");
								//increase the index to move onto the next item
								index++;
							}
							
							//if this popular item is already in the cart
							else {
								/**********************************************************\
											decrease the number of items found
								cancels out the increment of i for the next loop iteration
											to ensure that we will find 10 matches
								\**********************************************************/
								--i;
								//increase the index to move on to the next item in the array
								++index;
							}
						}
					
					out.print("</tbody></table>");
				}
			} %>
			<br><br>
			<table>
				<thead>
					<tr>
						<td colspan="2">Items in your cart</td>
					</tr>
					<tr>
						<td>Item Number</td>
						<td>Quantity</td>
					</tr>
				</thead>
				<tbody>
					<%
					//convert the items in the cart to use array indexes
					Object[] keysArray = keys.toArray();
					
					//if there are no items in the cart
					if (keysArray.length <= 0) { %>
					<tr>
						<td colspan="2">Empty</td>
					</tr>
					<% 
					//if there are items in the cart
					}	else	{
						
						/*********************************************\
						loop over each item and display the item number
							along with its associated quantity
						\*********************************************/
						for (int i=0; i< keysArray.length; i++) {	%>
					<tr>
						<td><%=keysArray[i] %></td>
						<td><%=values[i] %></td>
					</tr>
					<%	} 
					}	%>
				</tbody>
			</table>
		</center>
		<% if (!customer.cartEmpty()) {%>
			<a href="?empty=true" class="btn">Empty Cart</a>
			<a href="buyListener.jsp" class="btn">Buy</a>
		<% }
		}	else	{ %>
		<h2>You must be logged in to shop</h2>
		<a class="btn" href="../login.jsp">Login</a>
		<% } %>
	</div>
</body>
</html>