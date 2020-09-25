/**
 * Name: Yesmine Zribi (8402454)
 * Class: CSI2520 
 * Assignment 0 Java (Transportation Problem)
 * 
 * This class represents the factories 
 */
import java.util.ArrayList;
import java.util.List;


public class Factory {
	
	/**
	 * ID of the factory
	 */
	private int id; 
	
	/**
	 * Keeps track of the stock after transfers 
	 */
	private int currentStock;
	
	
	/**
	 * Keeps track of the stock in total
	 */
	private int totalStock; 
	
	/**
	 * Keeps track of the supplies this factory is responsible to supply
	 */
	private ArrayList<Supply> supplies; 
	
	
	/**
	 * Construct for this class
	 * @param id
	 * @param currentStock
	 */
	public Factory(int id, int currentStock) {
		this.id = id;
		this.currentStock = currentStock; 
		this.totalStock = currentStock;
		supplies = new ArrayList<Supply>();
	}
	
	/**
	 * Second constructor for this class
	 * @param id
	 * @param currentStock
	 * @param supplies
	 */
	public Factory(int id, int currentStock, ArrayList<Supply> supplies) {
		this.id = id;
		this.currentStock = currentStock;
		this.totalStock = currentStock;
		this.supplies = supplies;
	}
	
	/**
	 * Setter for the id
	 * @param id
	 */
	public void setID(int id) {
		this.id = id;
	}
	
	/**
	 * Getter for the id
	 * @return return the id of this factory
	 */
	public int getID() {
		return id;
	}
	
	/**
	 * Getter for the total production
	 * @return the total stock of this factory
	 */
	public int getTotalStock() {
		return totalStock;
	}
	
	/**
	 * Setter for the total production
	 * @param totalStock
	 */
	public void setTotalStock(int totalStock) {
		this.totalStock = totalStock;
	}
	
	/**
	 * Setter for the current production 
	 * @param currentStock
	 */
	public void setCurrentStock(int currentStock) {
		this.currentStock = currentStock;
	}
	
	/**
	 * Getter for the current production
	 * @return the current production of this factory
	 */
	public int getCurrentStock() {
		return currentStock;
	}
	
	/**
	 * Adds supply to the list of supplies of this factory
	 * @param supply
	 */
	public void addSupply(Supply supply) {
		supplies.add(supply);
	}
	
	/**
	 * Getter for the this factory's supplies
	 * @return this factory's supplies
	 */
	public List<Supply> getSupplies() {
		return supplies;
	}
	
	/**
	 * String representation of this class
	 */
	public String toString() {
		return "Factory: "+id+" ("+currentStock+")";

	}
	
}
