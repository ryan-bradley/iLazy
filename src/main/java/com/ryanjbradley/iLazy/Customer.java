package com.ryanjbradley.iLazy;

import java.io.*;
import java.util.LinkedHashMap;
import java.util.LinkedList;

import javax.xml.crypto.dsig.keyinfo.KeyValue;

public class Customer implements Serializable {
	private int id;
	private LinkedHashMap<Integer, Integer> cart = new LinkedHashMap<Integer, Integer>();
	private LinkedList<String> pastItems = new LinkedList<String>();
	private Suggestor suggestor;
	String location = "/var/lib/openshift/55f2af104f985c45960001ed/app-root/data/customerTransactions/";

	public Customer(int id) {
		this.id = id;
		location += id + ".csv";
	}
	
	/**
	 * Creates a list of personal suggested items based off the
	 * item number entered
	 * @param itemNumber of the item added to the cart
	 * @return LinkedList<Object>
	 */
	public LinkedList<Object> privateSuggestions(int itemNumber) {
		LinkedList<Object> suggestions = new LinkedList<Object>();
		
		double minsup = 0.1;
		try {
			suggestor = new Suggestor(location, minsup, null);
			if (suggestor != null)
				for (Object object: suggestor.suggest(itemNumber))
					suggestions.add(object);
		} catch (Exception e) {
			return null;
		}
		return suggestions;
	}

	public int id() {
		return id;
	}
	
	public String toString() {
		return "ID " + id;
	}

	/**
	 * add the item number into the cart
	 * with the given quantity
	 * @param itemNumber
	 * @param quantity
	 */
	public void put(int itemNumber, int quantity) {
		//if the itemNumber is already in the cart
		if (cart.containsKey(itemNumber))
			//increase the quantity by how many are already in the cart
			quantity += cart.get(itemNumber);
		//add the itemNumber and its associated quantity to the cart
		cart.put(itemNumber, quantity);
	}

	public LinkedHashMap<Integer, Integer> getCart() {
		return cart;
	}

	public boolean cartEmpty() {
		return cart.isEmpty();
	}

	/**
	 * purchase the items in the cart
	 */
	public void buy() {
		//create a string to store all of the itemNumbers in this transaction
		String s = "";
		//loop over each itemNumber in the cart
		for (Integer key : cart.keySet())
			//if this is not the fist item
			if (s.length() > 0)
				//add a ',' before adding the key to represent csv
				s += "," + key;
			else
				//just add the key
				s += key;

		//store this transaction in the pastItems list
		pastItems.add(s);
		//empty the cart
		cart.clear();
		//add this transaction to the csv file
		save(s);
	}

	/**
	 * Write the transaction to the csv file
	 * @param transaction
	 */
	private void save(String transaction)
	{
		try {
			//create the connection to the file in append mode
			BufferedWriter out = new BufferedWriter(new FileWriter(location, true));
			//write the transaction to the file
		    out.write(transaction + "\n");
		    //close the connection
		    out.close();
		}
		catch (IOException e) {	}
	}

	/**
	 * Method to determine if this customer
	 * is the customer searched for
	 * @param id of the customer
	 * @return Boolean
	 */
	public boolean match(int id) {
		return this.id == id;
	}
}
