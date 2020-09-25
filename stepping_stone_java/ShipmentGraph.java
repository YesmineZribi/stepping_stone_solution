/**
 * Name: Yesmine Zribi (8402454)
 * Class: CSI2520 
 * Assignment 0 Java (Transportation Problem)
 * 
 * This class represents the graph that contains the supplies  
 */
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Stack;


public class ShipmentGraph {
	
	//Node nested class
	/**
	 * Nested class that represents the nodes in the graph
	 */
	public class Node {
		/**
		 * Vertex in the node
		 */
		private Vertex vertex; 
		/**
		 * All adjacent edges of this vertex are also stored in a node
		 */
		private List<Edge> adjacentEdges; 
		
		/**
		 * Constructor for this nested class
		 * @param vertice
		 */
		private Node(Vertex vertice) {
			this.vertex = vertice; 
			adjacentEdges = new ArrayList<Edge>();
		}
		
		/**
		 * Getter for the vertex
		 * @return the vertex
		 */
		private Vertex getVertex() {
			return vertex; 
		}
		
		/**
		 * Adds an adjacent edge to vertex 
		 * @param e
		 */
		private void addEdge(Edge e) {
			adjacentEdges.add(e);
		}
		
		/**
		 * Getter for the adjacent edges of vertex
		 * @return
		 */
		public List<Edge> getAdjacentEdges() {
			return adjacentEdges;
		}
		
		/**
		 * String representation of a node
		 */
		public String toString() {
			return vertex.toString();
		}
		
	}
	
	/**
	 * List of nodes
	 */
	public List<Node> nodes;
	
	/**
	 * Total production/demand
	 */
	private int totalProduction;
	
	/**
	 * List of factories involved in this transportation problem
	 */
	private List<Factory> factories;
	
	/**
	 * List of warehouses involved in this transportation problem
	 */
	private List<Warehouse> warehouses; 
	
	/**
	 * Boolean to track if a cycle was found or not
	 */
	boolean foundCycle; 
	
	/**
	 * Constructor for this class
	 * @param totalProduction
	 * @param factories
	 * @param warehouses
	 */
	public ShipmentGraph(int totalProduction, List<Factory> factories,
			List<Warehouse> warehouses) {
		nodes = new ArrayList<Node>();
		this.totalProduction = totalProduction;
		this.factories = factories; 
		this.warehouses = warehouses; 
		foundCycle = false;

		
	}
	
	/**
	 * Determines if target, pair1 and pair2 are found in the same row
	 * @param target
	 * @param pair1
	 * @param pair2
	 * @return true if target, pair1 and pair2 are found in the same row and false otherwise
	 */
	private boolean containedInRow(Node target, Node pair1, Node pair2) {
		Supply targetSupply = target.getVertex().getSupply();
		Supply pairSupply1 = pair1.getVertex().getSupply();
		Supply pairSupply2 = pair2.getVertex().getSupply();
		for (Factory f: factories) {
			if (f.getSupplies().contains(pairSupply1) &&
					f.getSupplies().contains(pairSupply2) && 
					f.getSupplies().contains(targetSupply)) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Determines if target, pair1 and pair2 are found in the same column
	 * @param target
	 * @param pair1
	 * @param pair2
	 * @return true if target, pair1 and pair2 are found in the same column and false otherwise
	 */
	private boolean containedInColumn(Node target, Node pair1, Node pair2) {
		Supply targetSupply = target.getVertex().getSupply();
		Supply pairSupply1 = pair1.getVertex().getSupply();
		Supply pairSupply2 = pair2.getVertex().getSupply();
		for (Warehouse w: warehouses) {
			if (w.getSupplies().contains(pairSupply1) &&
					w.getSupplies().contains(pairSupply2) &&
					w.getSupplies().contains(targetSupply)) {
				return true;
			}
		}
		return false; 
	}
	
	/**
	 * Adds a vertex given supply s (the vertex will store supply s)
	 * @param s
	 * @param label
	 */
	public void addVertex(Supply s, VertexLabel label) {
		Vertex v = new Vertex(s, label);
		nodes.add(new Node(v));
		
	}
	
	/**
	 * Adds an edge btw vertex that stores supply s1 and vertex that stores supply s2
	 * @param s1
	 * @param s2
	 */
	public void addEdge(Supply s1, Supply s2) {
		Node n1 = nodes.get(s1.getID()); //find the vertex that stores s1
		Node n2 = nodes.get(s2.getID()); //find the vertex that stores s2 
		Edge e = new Edge(n1.getVertex(), n2.getVertex(), EdgeLabel.UNEXPLORED); //create edge
		n1.addEdge(e);
		n2.addEdge(e);
	}
	
	/**
	 * Gives the incident edges of the vertex that stores s
	 * @param s
	 * @return the incident edges of vertex that stores s
	 */
	public List<Edge> incidentEdges(Supply s) {
		Node n = nodes.get(s.getID()); //find vertex that stores s
		return n.getAdjacentEdges();
	}
	
	/**
	 * Finds the node opposite to n in edge e 
	 * @param e
	 * @param n
	 * @return the node opposite to n through edge e
	 */
	private Node opposite(Edge e, Node n) {
		Node n1 = nodes.get(e.getVertex1().getSupply().getID());
		Node n2 = nodes.get(e.getVertex2().getSupply().getID());
		
		if (n1.equals(n)) {
			return n2;
		} else {
			return n1;
		}
	}
	
	/**
	 * Getter for the total production
	 * @return
	 */
	public int getTotalProduction() {
		return totalProduction;
	}
 	
	/**
	 * Performs least cost algorithm on the graph 
	 */
	public void leastCost() {
		//1. Spot smallest cell
		while (totalProduction > 0) {
			
			Vertex smallestCell = getMinCostCell().getVertex();
			Supply targetSupply = smallestCell.getSupply();
			int demand = targetSupply.getWarehouse().getCurrentDemand();
			int production = targetSupply.getFactory().getCurrentStock();
			int amountToTransfer = Math.min(demand, production);
			
			if (amountToTransfer == 0) {
				smallestCell.setLabel(VertexLabel.UNEXPLOREDEMPTY);
				
			} else {
				targetSupply.transfer(amountToTransfer);
				smallestCell.setLabel(VertexLabel.UNEXPLOREDFULL);
			}
			
			totalProduction -= amountToTransfer;
		}
		
		/*adjust the label of the cells we didn't reach and remained with label EMPTY
		Since we will be moving to the stepping stone phase we will change all labels EMPTY for
		UNEXPLOREDEMPTY */
		List<Node> emptyCells = getEmptyCells();
		for (Node n: emptyCells) {
			n.getVertex().setLabel(VertexLabel.UNEXPLOREDEMPTY);
		}
			
	}
	
	/**
	 * Finds all nodes with vertices labelled EMPTY
	 * @return a list of nodes which vertices are labelled EMPTY
	 */
	private List<Node> getEmptyCells() {
		ArrayList<Node> emptyCells = new ArrayList<Node>();
		Node node;
		Factory f;
		for (int i = 0; i < nodes.size(); i++) {
			node = nodes.get(i);
			f = node.getVertex().getSupply().getFactory();
			if (node.getVertex().getLable() == VertexLabel.EMPTY) {
				emptyCells.add(node);
			}
		}
		return emptyCells;
	}
	
	/**
	 * Finds the cell with the smallest cost per unit
	 * @return the node which supply has the smallest cost per unit
	 */
	private Node getMinCostCell() {
		List<Node> emptyCells = getEmptyCells();
		
		Node smallestCell = emptyCells.get(0);
		int smallestCost = smallestCell.getVertex().getSupply().getCostPerUnit();
		
		Node currentCell; int currentCost; int demand1; int demand2; int production1; int production2;
		int candidate1; int candidate2; int chosen;
		for (int i = 1; i < emptyCells.size(); i++) {
			currentCell = emptyCells.get(i);
			currentCost = currentCell.getVertex().getSupply().getCostPerUnit();
			
			if (smallestCost > currentCost) {
				smallestCell = currentCell;
				smallestCost = currentCost;
			}
			else if (smallestCost == currentCost) {
				//if both costs are equal pick the one with the biggest demand or supply 
				production1 = smallestCell.getVertex().getSupply().getFactory().getCurrentStock();
				demand1 = smallestCell.getVertex().getSupply().getWarehouse().getCurrentDemand();
				candidate1 = Math.min(production1, demand1);
				
				production2 = currentCell.getVertex().getSupply().getFactory().getCurrentStock();
				demand2 = currentCell.getVertex().getSupply().getWarehouse().getCurrentDemand();
				candidate2 = Math.min(production2, demand2);
				
				chosen = Math.max(candidate1, candidate2);
				if (chosen == candidate2) {
					smallestCell = currentCell;
					smallestCost = currentCost;
				}
				
			}
		}
		return smallestCell;
	}
	
	/**
	 * Finds all full cells
	 * @return list of nodes which vertices have supplies with supply amount greater than 0 
	 */
	private List<Node> getFullCells() {
		List<Node> fullCells = new ArrayList<Node>();
		for (Node n: nodes) {
			if (n.getVertex().getLable() == VertexLabel.UNEXPLOREDFULL) {
				fullCells.add(n);
			}
		}
		return fullCells;
	}
	
	/**
	 * Calculates the total cost of the current state of the matrix
	 * @return the total cost with the current state of the matrix
	 */ 
	public int totalCost() {
		//total cost is calcualted through the full cells * cost per unit
		List<Node> fullCells = getFullCells();
		int totalCost = 0;
		Supply s;
		for (Node n: fullCells) {
			s = n.getVertex().getSupply();
			//supply amount * cost per unit and sum
			totalCost += s.getSupply()*s.getCostPerUnit();
		}
		return totalCost;
		
	}
	
	//Returns a list of all unexplored empty cells
	private List<Node> getUnexploredEmptyCells() {
		List<Node> unexploredEmptyCells = new ArrayList<Node>();
		
		for (Node n: nodes) {
			if (n.getVertex().getLable() == VertexLabel.UNEXPLOREDEMPTY) {
				unexploredEmptyCells.add(n);
			}
		}
		return unexploredEmptyCells;
	}
	
	/**
	 * Finds all edges labelled DISCOVERED
	 * @return a list of edges with label DISCOVERED
	 */
	private List<Edge> getDiscoveredEdges() {
		List<Edge> discoveredEdges = new ArrayList<Edge>();
		for (Node n: nodes) {
			for (Edge e: n.getAdjacentEdges()) {
				if (e.getLabel() == EdgeLabel.DISCOVERED) {
					discoveredEdges.add(e);
				}
			}
		}
		return discoveredEdges;
	}
	
	/**
	 * Applies the stepping stone algorithm 
	 * @return all paths found from applying the stepping stone algorithm 
	 */
	public List<List<Node>> steppingStone() {
		//1. Find all the cycles starting from the unexplored empty cells
		List<Node> unexploredEmptyCells = getUnexploredEmptyCells();
		List<List<Node>> paths = new ArrayList<List<Node>>();
		
		for (int i = 0; i < unexploredEmptyCells.size(); i++) {
//			System.out.println("Moving to "+unexploredEmptyCells.get(i));
			List<Node> path = new ArrayList<Node>();
			List<Node> s = new ArrayList<Node>();
			cycleDFS(unexploredEmptyCells.get(i),s,path);
			paths.add(path);
			
				
			//clean up for next round: reset all cells and edges to unexplored 
			for (Node n: nodes) {
				if (n.getVertex().getLable() == VertexLabel.VISITED) {
					if (n.getVertex().getSupply().getSupply() == 0) {
						n.getVertex().setLabel(VertexLabel.UNEXPLOREDEMPTY);
					} else {
						n.getVertex().setLabel(VertexLabel.UNEXPLOREDFULL);
					}
				}
				for (Edge e: n.getAdjacentEdges()) {
					if (e.getLabel() == EdgeLabel.DISCOVERED) {
						e.setLabel(EdgeLabel.UNEXPLORED);
					}
				}
			}
			//rest found cycle to false for next round 
			foundCycle = false;
		}
		return paths;
	}

	/**
	 * Get the marginal cost of path
	 * @param path
	 * @return the marginal cost of path
	 */
	public int marginalCost(List<Node> path) {
		int cost = 0; 
		Supply s;
		for (int i = 0; i < path.size(); i++) {
			s = path.get(i).getVertex().getSupply();
			if (i % 2 == 0) {
				cost += s.getCostPerUnit();
			} else {
				cost -= s.getCostPerUnit();
			}
		}
		return cost; 
	}
	
	/**
	 * Performs depth first search to find a valid cycle from n, using list s and put it in path
	 * @param n
	 * @param s
	 * @param path
	 */
	private void cycleDFS( Node n, List<Node> s, List<Node> path) {
		n.getVertex().setLabel(VertexLabel.VISITED);
		s.add(n);
		List<Edge> edges = n.getAdjacentEdges();
		for (Edge e: edges) {
			if (!foundCycle && e.getLabel() == EdgeLabel.UNEXPLORED) {
				e.setLabel(EdgeLabel.DISCOVERED);
				Node w = opposite(e, n);
				if (w.getVertex().getLable() == VertexLabel.UNEXPLOREDFULL) {
					//Get the 2 last pairs if possible
					if (s.size() >= 2) {
						Node pair1, pair2;
						pair1 = s.get(s.size()-2);
						pair2 = s.get(s.size()-1);
						
						if (!containedInRow(w, pair1, pair2) &&
								!containedInColumn(w, pair1, pair2)) {
//							System.out.println("Adding"+ w.getVertex().getSupply());
							cycleDFS(w, s, path);
						}
					} else if (s.size() < 2) { //size is small add whatever we found
//						System.out.println("Adding"+ w.getVertex().getSupply());
						cycleDFS(w, s, path);
					} 
				} else if (w.getVertex().getLable() == VertexLabel.VISITED) {
					if (!containedInRow(w,s.get(s.size()-2),s.get(s.size()-1)) && 
							!containedInColumn(w,s.get(s.size()-2),s.get(s.size()-1))) {
						for (Node i : s) {
							path.add(i);
							foundCycle = true;
						}
								
					}

				}
			}
		}
//		System.out.println("Removing: "+s.get(s.size()-1).getVertex().getSupply());
		s.remove(s.size()-1);
	}
	
	/**
	 * Finds an optimal path given the graph of supplies
	 */
	public void optimalTransport() {
		//1. Find all the cycles starting from the unexplored cells
		List<List<Node>> paths;
		
		while (true) {
			paths = steppingStone();	
			//2. Calculate marginal cost of all found paths 
			List<Integer> costOfPaths = new ArrayList<Integer>();
			for (List<Node> path: paths) {
				costOfPaths.add(marginalCost(path));
			}
			
			//3. Find the smallest marginal cost
			int min = 0; //min will be the index of the smallest marginal cost 
			for (int i = 1; i < costOfPaths.size(); i++) {
				if(costOfPaths.get(min) > costOfPaths.get(i)) {
					min = i ;
				}
			}
			
			//4. If the smallest is negative that's our optimal path
			//if we can't find negative marginal costs we are done
			if (costOfPaths.get(min) >= 0) {
				break; //We are done
			}
			
			//At this point we found a more optimal path 
			List<Node> chosenPath = paths.get(min);
//			System.out.println(Arrays.toString(chosenPath.toArray()));
			
			//5. Transfer the smallest - cell to the empty cell and adjust everything
			
			Supply minCell = chosenPath.get(1).getVertex().getSupply(); //looking for min cell
			Supply currentCell; 
			int minCellIndex = 1;
			for(int i = 3; i < chosenPath.size(); i = i+2) {
				currentCell = chosenPath.get(i).getVertex().getSupply();
				if (minCell.getSupply() > currentCell.getSupply()) {
					minCell = currentCell;
					minCellIndex = i;
				}
			}
			
			int currentSupply; 
			int amount = minCell.getSupply();
			Supply s; 
			for (int i = 0; i < chosenPath.size(); i++) {
				s = chosenPath.get(i).getVertex().getSupply();
				currentSupply = s.getSupply();
				if (i % 2 == 0) {
					s.setSupply(currentSupply + amount);
					
				} else {
					s.setSupply(currentSupply - amount);
				}
			}
			
			//clean up 
			for (Node n: chosenPath) {
				if (n.getVertex().getSupply().getSupply() == 0) {
					n.getVertex().setLabel(VertexLabel.UNEXPLOREDEMPTY);
				} else {
					n.getVertex().setLabel(VertexLabel.UNEXPLOREDFULL);
				}
			}
			
			
		}
	
	}
	
	/**
	 * String representation of this graph 
	 */
	public String toString() {
		String s = "";
		for (int i = 0; i < nodes.size(); i++) {
			s += nodes.get(i)+"\n";
		}
		return s;
	}
}
