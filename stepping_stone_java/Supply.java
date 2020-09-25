/**
 * Name: Yesmine Zribi (8402454)
 * Class: CSI2520 
 * Assignment 0 Java (Transportation Problem)
 * 
 * This class represents the supplies 
 */
public class Supply {
	
	/**
	 * Id of this supply
	 */
	private int id; 
	
	/**
	 * Factory that transfers through this Supply
	 */
	private Factory factory; 
	
	/**
	 * Warehouse that receives supply through this Supply
	 */
	private Warehouse warehouse; 
	
	/**
	 * Amount this Supply holds
	 */
	private int supply; 
	
	/**
	 * Cost of one unit to transfer through this Supply
	 */
	private int costPerUnit;
	
	/**
	 * Constructor for this class
	 * @param id
	 * @param costPerUnit
	 */
	public Supply(int id, int costPerUnit) {
		this.id = id; 
		this.costPerUnit = costPerUnit;
		
	}
	
	/**
	 * Second constructor for this class
	 */
	public Supply(int id, Factory factory, Warehouse warehouse, int costPerUnit) {
		this.factory = factory; 
		factory.addSupply(this); //add this supply to the factory's list
		this.warehouse = warehouse; 
		warehouse.addSupply(this); //add this supply to the warehouse's list
		this.costPerUnit = costPerUnit;
		this.id = id;
		supply = 0;
	}
	
	
	/**
	 * Setter for the supply amount
	 * @param supply
	 */
	public void setSupply(int supply) {
		this.supply = supply;
	}
	
	/**
	 * Getter for the id
	 * @return the id of this supply
	 */
	public int getID() {
		return id;
	}
	
	/**
	 * Setter for the id
	 * @param id
	 */
	public void setID(int id) {
		this.id = id; 
	}
	
	/**
	 * Getter for the supply amount
	 * @return the supply amount
	 */
	public int getSupply() {
		return supply;
	}
	
	/**
	 * Setter for the cost per unit 
	 * @param costPerUnit
	 */
	public void setCostPerUnit(int costPerUnit) {
		this.costPerUnit = costPerUnit;
	}
	
	/**
	 * Getter for the cost per unit
	 * @return
	 */
	public int getCostPerUnit() {
		return costPerUnit;
	}
	
	/**
	 * Setter for the factory
	 * @param factory
	 */
	public void setFactory(Factory factory) {
		this.factory = factory;
		factory.addSupply(this); //add this supply to the factory's list
	}
	
	/**
	 * Getter for the factory
	 * @return the factory using this Supply
	 */
	public Factory getFactory() {
		return factory;
	}
	
	/**
	 * Setter for the warehouse
	 * @param warehouse
	 */
	public void setWarehouse(Warehouse warehouse) {
		this.warehouse = warehouse;
		warehouse.addSupply(this); //add this supply to the warehouse's list
	}
	
	/**
	 * Getter for the warehouse 
	 * @return the warehouse using this Supply
	 */
	public Warehouse getWarehouse() {
		return warehouse;
	}
	
	/**
	 * Transfers amount from factory to warehouse
	 * @param amount
	 */
	public void transfer(int amount) {
		supply += amount;
		factory.setCurrentStock(factory.getCurrentStock()- amount);
		warehouse.setCurrentDemand(warehouse.getCurrentDemand() - amount);
	}
	
	/**
	 * String representation of this class
	 */
	public String toString() {
		return factory.getID()+"("+factory.getCurrentStock()+")"+"-->"+supply+"-->"+warehouse.getID()+"("+warehouse.getCurrentDemand()+")";
	}
}
