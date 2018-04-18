package com.ryanjbradley.iLazy;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.LinkedList;

/**
 * This class is the main class to be used as a Javabean. This class consists
 * of a single Customer for simplicity to show how the Suggestor can analyse
 * a dataset in terms of association rules and frequent itemsets. This is
 * illustrated by taking an item number from an item added to a Customers
 * cart and then finding any items that frequently get purchased with this
 * item
 *
 * @see Suggestor
 * @see Customer
 *
 * @author Ryan Bradley
 * @author 11657196
 */
public class ShopApp {

    //all of the item numbers
    private LinkedList<Integer> items = new LinkedList<Integer>();
    private Suggestor suggestor;
    private String retail, customersPath;
    private Customers customers;
    

    public ShopApp()
    {
        this("/var/lib/openshift/55f2af104f985c45960001ed/app-root/data/retail.csv", 
        		"/var/lib/openshift/55f2af104f985c45960001ed/app-root/data/customer.dat");
    }

    public ShopApp(String retail, String customersPath)
    {
        //file path of the dataset
        this.retail = retail;
        this.customersPath = customersPath;

        //minimum support value (Percentage decimal)
        double minsup = 0.01;

        //load the customers from a file
        loadCustomers();
        try {
            suggestor = new Suggestor(retail, minsup, null);
            setup();
        } catch (Exception e)	{
            suggestor = null;
        }
    }
    
    /**
     * Load the customers from a file located at the 
     * @param customersPath
     */
    private void loadCustomers() {
    	try {
    		FileInputStream fis = new FileInputStream(customersPath);
	    	ObjectInputStream ois = new ObjectInputStream(fis);
	    	customers = (Customers) ois.readObject();
	    	fis.close();
    	}
    	catch (Exception e) {
    		customers = new Customers();
    		save();
    	}
    }
    
    /**
     * Save the customers to the parameter filepath
     * @param customersPath
     */
    public void save() {
    	try {
    		FileOutputStream fos = new FileOutputStream(customersPath);
        	ObjectOutputStream oos = new ObjectOutputStream(fos);
        	oos.writeObject(customers);
        	fos.close();
    	} catch (Exception e) {
    		
    	}
    }
    
    public LinkedList<Integer> getCustomerIDs() {
    	LinkedList<Integer> ids = new LinkedList<Integer>();
    	for (Customer customer: customers.getCustomers())
    		ids.add(customer.id());
    	
    	return ids;
    }
    
    /**
     * Find a customer with the parameter ID
     * @param id
     * @return Customer
     * @see Customer
     */
    public Customer login(int id)
    {
    	return customers.getCustomer(id);
    }

    /**
     * create the list of item numbers
     */
    private void setup()
    {
        for (int i = 1; i < 10000; i++)
            items.add(i);
    }

    /**
     * Return the list of item numbers
     */
    public LinkedList<Integer> items()
    {
        return items;
    }

    /**
     * get the popular items from the suggestor
     */
    public Object[] popularItems()
    {
        return suggestor.popularItems();
    }

    /**
     * Add the item to the cart
     *
     * @returns Object[] 	array of other suggested items
     * 						based off the item added
     */
    public Object[] addToCart(Customer customer, int itemNumber, int quantity)
    {
        customer.put(itemNumber, quantity);
        try {
            return suggestor.suggest(itemNumber);
        } catch (Exception e) {
            return null;
        }
    }
    
    public void buy(int id)
    {
    	customers.getCustomer(id).buy();
    	save();
    }
}
