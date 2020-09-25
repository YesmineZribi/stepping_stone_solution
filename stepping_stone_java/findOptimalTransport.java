/**
 * Name: Yesmine Zribi (8402454)
 * Class: CSI2520 
 * Assignment 0 Java (Transportation Problem)
 * 
 * This class reads transportation info from a file, finds the most optimal solution and writes it in a file 
 */

import java.io.*;
import java.util.*;

public class findOptimalTransport {
	
	/**
	 * List of factories involved in this transportation problem
	 */
	List<Factory> factories; 
	
	/**
	 * List of warehouses involved in this transportation problem
	 */
	List<Warehouse> warehouses;
	
	/**
	 * List of all supplies
	 */
	List<Supply> supplies; 
	
	/**
	 * Total production/demand 
	 */
	int totalProduction; 
	
	/**
	 * Constructor for this class
	 */
	public findOptimalTransport() {
		factories = new ArrayList<Factory>();
		warehouses = new ArrayList<Warehouse>();
		supplies = new ArrayList<Supply>();
		totalProduction = 0;
	}
	
	/**
	 * Reads a file called fileName and create the supply matrix and populates the variables of this class
	 * @param fileName
	 */
	public void fromFile(String fileName) {
		File file = new File(fileName);
		
		try {
			BufferedReader bf = new BufferedReader(new FileReader(file));
			
			
			//First line: #1 (num of factories) #1(num of warehouses)
			String[] firstLine = bf.readLine().split(" ");
			int numOfFactories = Integer.parseInt(firstLine[0]);
			int numOfWarehouses = Integer.parseInt(firstLine[1]);
			
			//Second line is all the warehouses 
			String[] secondLine = bf.readLine().split(" ");
			
			//create the warehouses
			for (int i = 0; i < secondLine.length-1; i++) {
				warehouses.add(new Warehouse(secondLine[i]));
			}
			
			boolean endOfFile = false;
			int index = 0;
			while (!endOfFile) {
				String[] line = bf.readLine().split("\\s+");
				//if first string is numeric we did not reach the last line 
				if (isNumeric(line[0])) {
					//first string is the id of the factory last string is the total production
					factories.add(new Factory(Integer.parseInt(line[0]), Integer.parseInt(line[line.length-1])));
					//Everything in btw is the supplies 
					for (int i = 1; i < line.length-1; i++) { //start from 1 since 0 is id of factory and end before last since production
						supplies.add(new Supply(index, factories.get(factories.size()-1),warehouses.get(i-1),Integer.parseInt(line[i])));
						index++;
					}
				} else { //we reached the last line 
					//first string is the word demand, last string is the total 
					for (int i = 1; i < line.length-1; i++) {
						warehouses.get(i-1).setCurrentDemand(Integer.parseInt(line[i]));
						warehouses.get(i-1).setTotalDemand(Integer.parseInt(line[i]));
					}
					totalProduction = Integer.parseInt(line[line.length-1]); //last elem is the total production/demand
					endOfFile = true;
				}		
			}
			bf.close();
			
		} catch (FileNotFoundException e1) {
			System.out.println("File not found!");
		} catch (IOException e2) {
			System.out.println("Could not read line");
		}
		
	}
	
	/**
	 * Returns true if str is numeric and false otherwise
	 * @param str
	 * @return
	 */
	public boolean isNumeric (String str) {
		try {
			Integer num = Integer.parseInt(str);
		} catch (NumberFormatException e) {
			return false;
		}
		return true;
	}
	
	
	/**
	 * Writes the solution of the transporation problem to fileName
	 * @param fileName
	 * @param totalCost
	 */
	public void toFile(String fileName, int totalCost) {
		try {
			BufferedWriter writer = new BufferedWriter(new FileWriter(fileName));
			//first line #1 (num of factories) #2(num of warehouses) 
			writer.write(Integer.toString(factories.size()));
			writer.write(" ");
			writer.write(Integer.toString(warehouses.size()));
			writer.newLine();
			
			//second line: list of warehouses + the word Supply
			for (Warehouse w: warehouses) {
				writer.write(w.getID());
				writer.write(" ");
			}
			//word supply 
			writer.write("Supply");
			writer.newLine();
			
			int index = 0;
			List<Supply> supplies; 
			while (index < factories.size()) {
				//first word is always the id of the factory 
				writer.write(String.valueOf(factories.get(index).getID()));
				writer.write(" ");
				
				supplies = factories.get(index).getSupplies();
				for (int i = 0; i < supplies.size(); i++) {
					writer.write(String.valueOf(supplies.get(i).getSupply()));
					writer.write(" ");
				}
				//write the total production of the factory 
				writer.write(String.valueOf(factories.get(index).getTotalStock()));
				writer.newLine();
				index++;
			}
			//before last line: write the word demand + total demand of each warehouse
			writer.write("Demand");
			writer.write(" ");
			
			for (int i = 0; i < warehouses.size(); i++) {
				writer.write(String.valueOf(warehouses.get(i).getTotalDemand()));
				writer.write(" ");
			}
			writer.newLine();
			//last line: writer the total production 
			writer.write(String.valueOf(totalCost));
			writer.close();
			
			
		} catch (IOException e) {
			System.out.println("Could not write to file");
		}
	}
	 
	/**
	 * Populates the graph from the information from factories, warehouses and supplies
	 * @param sh
	 */
	public void populateGraph(ShipmentGraph sh) {
		//Add vertices 
		for (int i = 0; i < supplies.size(); i++) {
			sh.addVertex(supplies.get(i), VertexLabel.EMPTY);
		}
		
		//Add edges btw vertices 
		List<Supply> s;
		for (int i = 0; i < factories.size()-1; i++) {
			s = factories.get(i).getSupplies();
			for (int j = 0; j < s.size()-1; j++) {
				for (int k = j+1; k < s.size(); k++) {
					sh.addEdge(s.get(j), s.get(k));
				}
				for (int c = i+1; c < factories.size(); c++) {
					sh.addEdge(s.get(j), factories.get(c).getSupplies().get(j));
				}
			}
		}
		//add edges in last column
		for (int i = 0; i < factories.size()-1; i++) {
			s = factories.get(i).getSupplies();
			for (int c = i+1; c < factories.size(); c++) {
				sh.addEdge(s.get(s.size()-1), factories.get(c).getSupplies().get(s.size()-1));
			}
		}
		
		//add edges in last row 
		List<Supply> lastRow = factories.get(factories.size()-1).getSupplies();
		for (int i = 0; i < lastRow.size()-1; i++) {
			for (int j = i+1;  j < lastRow.size(); j++) {
				sh.addEdge(lastRow.get(i), lastRow.get(j));
			}
		}
	}
	
	
	/**
	 * Main method 
	 * @param args
	 */
	public static void main(String[] args) {
		Scanner userInput = new Scanner(System.in);
		
		findOptimalTransport op = new findOptimalTransport();
		System.out.println("Please enter the name of the file: ");
		String name = userInput.nextLine().trim();
		System.out.println("Reading file...");
		op.fromFile(name);
		System.out.println("");

		System.out.println("Generating graph...");
		ShipmentGraph sh = new ShipmentGraph(op.totalProduction, op.factories, op.warehouses);
		op.populateGraph(sh);
		System.out.println("");
		
		System.out.println("Applying least cost algorithm...");
		sh.leastCost();
		System.out.println("");
		
		System.out.println("Finding optimal solution");
		sh.optimalTransport();
		System.out.println("");
		
		System.out.println(sh);
		System.out.println("");
		
		System.out.println("Please enter a file name to write in: ");
		String nameWrite = userInput.nextLine().trim();
		System.out.println("Writing to file...");
		op.toFile(nameWrite, sh.totalCost());
		System.out.println("File written successfully - exiting program");
		
		userInput.close(); //close scanner		
	}
}
