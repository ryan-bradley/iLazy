package com.ryanjbradley.iLazy;

import java.io.Serializable;
import java.util.LinkedList;

public class Customers implements Serializable {
	private LinkedList<Customer> customers;
	
	public Customers() {
		customers = new LinkedList<Customer>();
		addCustomers();
	}
	
	private void addCustomers() {
		for (int i = 1000; i < 10000; i+= 1000)
			customers.add(new Customer(i));
	}
	
	public Customer getCustomer(int id) {
		for (Customer customer: customers)
			if (customer.match(id))
				return customer;
		
		return null;
	}
	
	public LinkedList<Customer> getCustomers() {
		return customers;
	}
	
}
