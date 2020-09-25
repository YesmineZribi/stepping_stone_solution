/**
 * Name: Yesmine Zribi (8402454)
 * Class: CSI2520 
 * Assignment 0 Java (Transportation Problem)
 * 
 * This class represents a vertex of the graph that stores a supply value 
 */
public class Vertex {
	/**
	 * Supply stored in this vertex
	 */
	private Supply supply;
	
	/**
	 * Label of this vertex
	 */
	private VertexLabel label; 
	
	/**
	 * Constructor for this class
	 * @param supply
	 * @param label
	 */
	public Vertex(Supply supply, VertexLabel label) {
		this.supply = supply; 
		this.label = label;
		
	}
	
	/**
	 * Getter for the supply
	 * @return the supply stored in this vertex
	 */
	public Supply getSupply() {
		return supply;
	}
	
	/**
	 * Setter for the supply stored in this vertex
	 * @param supply
	 */
	public void setSupply(Supply supply) {
		this.supply = supply;
	}
	
	/**
	 * Getter for the label of this vertex
	 * @return
	 */
	public VertexLabel getLable() {
		return label;
	}
	
	/**
	 * Setter for the label of this vertex
	 * @param label
	 */
	public void setLabel(VertexLabel label) {
		this.label = label;
	}
	
	/**
	 * String representation of this class
	 */
	public String toString() {
		return supply.toString();
	}
	
}
