/**
 * Name: Yesmine Zribi (8402454)
 * Class: CSI2520 
 * Assignment 0 Java (Transportation Problem)
 * 
 * This class represents the warehouses 
 */

import java.util.ArrayList;
import java.util.List;

public class Warehouse {
	
	/**
	 * the id of this warehouse
	 */
	private String id;
	
	/**
	 * The demand in total
	 */
	private int totalDemand;
	
	/**
	 * The current demand 
	 */
	private int currentDemand;
	
	/**
	 *  Keeps track of the supplies this warehouse should receive
	 */
	private ArrayList<Supply> supplies; 
	
	/**
	 * Constructor for this class
	 * @param id
	 */
	public Warehouse(String id) {
		this.id = id;
		supplies = new ArrayList<Supply>();
	}
	
	/**
	 * Second constructor for this class
	 * @param id
	 * @param currentDemand
	 */
	public Warehouse(String id, int currentDemand) {
		this.id = id;
		this.totalDemand = currentDemand;
		this.currentDemand = currentDemand;
		supplies = new ArrayList<Supply>();
	}
	
	/**
	 * Third constructor for this class
	 * @param id
	 * @param currentDemand
	 * @param supplies
	 */
	public Warehouse(String id, int currentDemand, ArrayList<Supply> supplies) {
		this.id = id;
		this.totalDemand = currentDemand;
		this.currentDemand = currentDemand; 
		this.supplies = supplies; 
	}
	
	/**
	 * Setter for id
	 * @param id
	 */
	public void setID(String id) {
		this.id = id;
	}
	
	/**
	 * Getter for id
	 * @return id of this warehouse
	 */
	public String getID() {
		return id;
	}
	
	/**
	 * Getter for total demand
	 * @return total demand
	 */
	public int getTotalDemand() {
		return totalDemand;
	}
	
	/**
	 * Setter for total demand
	 * @param totalDemand
	 */
	public void setTotalDemand(int totalDemand) {
		this.totalDemand = totalDemand;
	}
	
	/**
	 * Setter for current demand
	 * @param currentDemand
	 */
	public void setCurrentDemand(int currentDemand) {
		this.currentDemand = currentDemand;
	}
	
	/**
	 * Getter for current demand
	 * @return current demand 
	 */
	public int getCurrentDemand() {
		return currentDemand;
	}
	
	/**
	 * Adds supply to this warehouse
	 * @param supply
	 */
	public void addSupply(Supply supply) {
		supplies.add(supply);
	}
	
	/**
	 * Getter for supplies of this warehouse
	 * @return
	 */
	public List<Supply> getSupplies() {
		return supplies;
	}
 	
	/**
	 * String representation of this class
	 */
	public String toString() {
		return "Warehouse: "+id;
	}
}
