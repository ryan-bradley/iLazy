package com.ryanjbradley.iLazy;

import java.io.IOException;
import java.util.*;

import ca.pfv.spmf.algorithms.frequentpatterns.apriori.AlgoApriori;
import ca.pfv.spmf.patterns.itemset_array_integers_with_count.*;


/**
 * This class uses the Apriori Algorithm to data mine frequent itemsets.
 * This algorithm and all of the classes within any ca.pv.spmf.* package
 * are not my own content. These classes were downloaded from the Philippe Fournier-Viger.
 * Download Link included below...
 *
 * @see AlgoApriori
 * @see http://www.philippe-fournier-viger.com/spmf/index.php?link=download.php
 *
 * @author Ryan Bradley
 * @author 11657196
 */
public class Suggestor {
    private AlgoApriori apriori;
    private String dataSetFilePath;
    private double minsup;
    private String output;
    private Itemsets itemsets;

    //Map to store suggested item numbers along with a measure of occurences
    private Map<Integer, Integer> suggestions;

    /**
     * Constructor to setup and run the algorithm on the dataset
     * @param dataSetFilePath	Filepath of the dataset
     * @param minsup			Minimum Support Value (Percentage Decimal)
     * @param output			Filepath to store results in a file
     * @throws Exception		When an instance can not be created
     */
    public Suggestor(String dataSetFilePath, double minsup, String output) throws Exception
    {
        this.dataSetFilePath = dataSetFilePath;
        this.minsup = minsup;
        this.output = output;
        apriori = new AlgoApriori();
        run();
    }

    /**
     * Execute the algorithm
     * Store the Itemsets
     * @throws Exception	when the file can not be found
     */
    private void run() throws IOException
    {
        itemsets = apriori.runAlgorithm(minsup, dataSetFilePath, output);
    }

    /**
     * Get an object array of suggested items based off itemNumber
     * @param itemNumber
     * @return Object[]
     */
    public Object[] suggest(int itemNumber)
    {
        //get all of the suggested items for the item added to the cart
        getSuggestions(itemNumber);
        //return the highest suggestion occurences for this item
        //so that the suggested items are the most frequently
        //suggested items
        return highestSuggestions().toArray();
    }

    /**
     * Store the suggested items based off selectedItem
     * @param selectedItem
     */
    private void getSuggestions(int selectedItem)
    {
        suggestions = new HashMap<Integer, Integer>();
        //get the list of suggested items for the selected item
        //NB: the list returned may contain duplicate entries
        for (int i : items(selectedItem)) {
            //Does the suggestions already have the current item
            //i.e. is ths a duplicate entry
            if (suggestions.containsKey(i))
                //increase the count of this item in the suggestions
                //to show that this suggested item is being suggested
                //multiple times
                suggestions.put(i, suggestions.get(i) + 1);
            else
                //this item is not already in the suggestions so
                //Add a new entry of the current item to the suggestions
                suggestions.put(i, 1);
        }
    }

    /**
     * Generate a LinkedList of Integers based off all of
     * the suggested items relating to the selected item
     * NB: this LinkedList may contain duplicate integer
     * entries, which is done on purpose
     *
     * @return LinkedList<Integer>
     */
    private LinkedList<Integer> items(int selectedItem)
    {
        LinkedList<Integer> items = new LinkedList<Integer>();
        //get each list of each itemset from the itemsets
        for (List<Itemset> list : itemsets.getLevels())
            //get each itemset from the list
            for (Itemset itemset : list)
                //ignore itemsets with only 1 item as there is no other items
                if (itemset.size() > 1)
                    //ignore itemsets that don't have the selected item
                    if (itemset.contains(selectedItem))
                        //get each item from the item set
                        for (int i = 0; i < itemset.size(); i++) {
                            int currentItem;
                            /*
                             ignore if the currentItem is the selected item as we
                             don't want to suggest the item they have already added
                             */
                            if ((currentItem = itemset.get(i)) != selectedItem)
                                items.add(currentItem);
                        }
        return items;
    }

    /**
     * Loops over each occurrences value to find the highest occurrence of
     * items.
     * @return LinkedList that contains the item number of
     * the most common pattern(s)
     */
    private LinkedList<Integer> highestSuggestions()
    {
        //This LinkedList will contain only the highest/most common
        //suggested items opposed to every single suggested item
        LinkedList<Integer> results = new LinkedList<Integer>();

        int highestValue = 0;

        Object[] values = suggestions.values().toArray();
        Object[] keys = suggestions.keySet().toArray();

        //loop over each value to get how many times the
        //suggested item occured
        for (int pos = 0; pos < values.length; pos++) {
            //convert the value into an integer
            int i = Integer.parseInt("" + values[pos]);

            //if this value is higher than all the others so far
            //therefore, this item is suggested more than the
            //others so far
            if (i > highestValue) {
                highestValue = i;
                //reset the results list as the current value
                //is now the highest, thus there are no results
                //currently with this new value
                results.clear();
                //add the corresponding item number to the results
                results.add(Integer.parseInt("" + keys[pos]));
            }

            //if this value is equal to the highest so far
            else if (i == highestValue)
                //add the corresponding item number
                results.add(Integer.parseInt("" + keys[pos]));
        }

        return results;
    }

    /**
     * Searches for Itemsets with one item only, a.k.a. the most
     * popular items that customers have purchased
     * @return Object[] of popular Items
     * @see Itemsets
     */
    public Object[] popularItems()
    {
        LinkedList<Integer> popular = new LinkedList<Integer>();

        //get each list of itemset from the itemsets
        for (List<Itemset> list : itemsets.getLevels())
            //get each itemset from the list
            for (Itemset itemset : list)
                //itemsets with 1 item only
                if (itemset.size() == 1)
                    //add the 1 item to the list of popular items
                    popular.add(itemset.get(0));

        return popular.toArray();
    }
}
