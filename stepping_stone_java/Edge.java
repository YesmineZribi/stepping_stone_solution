/**
 * Name: Yesmine Zribi (8402454)
 * Class: CSI2520 
 * Assignment 0 Java (Transportation Problem)
 * 
 * This class represents an edge in the graph 
 */

public class Edge {
	
	/**
	 * The first vertex with this edge
	 */
	private Vertex vertex1; 
	
	/**
	 * The vertex at the other end of this edge
	 */
	private Vertex vertex2; 
	
	/**
	 * The label of this edge
	 */
	private EdgeLabel label;
	
	/**
	 * Constructor for this class
	 * @param vertice
	 * @param oppositeVertice
	 * @param label
	 */
	public Edge(Vertex vertice, Vertex oppositeVertice, EdgeLabel label) {
		this.vertex1 = vertice; 
		this.vertex2 = oppositeVertice; 
		this.label = label;
	}
	
	/**
	 * Getter for the first vertex
	 * @return the first vertex
	 */
	public Vertex getVertex1() {
		return vertex1;
	}
	
	/**
	 * Setter for the first vertex
	 * @param vertex
	 */
	public void setVertex1(Vertex vertex) {
		this.vertex1 = vertex;
	}
	
	/**
	 * Getter for the second vertex
	 * @return the second vertex
	 */
	public Vertex getVertex2() {
		return vertex2; 
	}
	
	/**
	 * Setter for the second vertex
	 * @param vertex
	 */
	public void setVertex2(Vertex oppositeVertice) {
		this.vertex2 = oppositeVertice;
	}
	
	/**
	 * Getter for the label of this edge
	 * @return
	 */
	public EdgeLabel getLabel() {
		return label;
	}
	
	/**
	 * Setter for the label of this edge
	 * @param label
	 */
	public void setLabel(EdgeLabel label) {
		this.label = label;
	}
	
	/**
	 * String representing of this class
	 * @return the string representation of this class
	 */
	public String toString() {
		return "("+vertex1.getSupply().getFactory().getID()+"-"+vertex1.getSupply().getWarehouse().getID()+"/"+
	vertex2.getSupply().getFactory().getID()+"-"+vertex2.getSupply().getWarehouse().getID()+")";
	}
	
}
