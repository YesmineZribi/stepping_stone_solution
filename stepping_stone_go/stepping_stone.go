/*
Name: Yesmine Zribi (8402454)
Assignment 0 (Go) - Transportation problem -

This prorgam takes asks the user for a  file that contains a description of the problem and asks the user the name
of the file in which the solution will be transcribed. 

NOTE: Go Concurrency is implemented in the stepping stone method starting at line 384
NOTE: Resource control is implemented in marginalCost method starting at line 392
NOTE: This program performs the least cost algorithm so only one file name will be specified, that of the costs

To run the program type: go run a0_CSI2520_go.go and you will be prompted to enter one file name 
(the file with the costs only - initial solution is calculated by the program-), after calculation you will be 
prompted to enter the name of the file in which you want the solution to be transcribed. 

*/

package main 

import (
	"fmt"
	"strconv"
	"math"
	"sync"
    "bufio"
    "log"
    "os"
    "strings"
)

//Matrix that will hold the supplies from factories to warehouses
var matrix = make([][]*Supply, 0)
//Slice that stores all factories
var factories = make([]Factory, 0)
//Slice that stores all warehouses
var warehouses = make([]Warehouse, 0)
//Boolean value to monitor if we found cycle
var foundCycle bool

//Stack struct to store individual paths
type Stack struct {
	stack []*Supply
}

//** -- Stack Methods -- **//
/*
Pushes a supply in the stack 
*/
func(s *Stack) push(supply *Supply) {
	s.stack = append(s.stack, supply)
}

/*
Pops a supply from the stack and returns it
*/
func(s *Stack) pop() *Supply{
	lastElem := s.stack[len(s.stack)-1]
	//remove last elem 
	s.stack = s.stack[:len(s.stack)-1]
	return lastElem
}
// ** -- End of Stack Methods -- **//

//Factory struct: represents a factory with the total production, the current production and all the supplies 
// it needs to deliver 
type Factory struct {
	id int
	currentProduction int
	totalProduction int 
	supplies []*Supply //slice of pointers to supplies

}

//Warehouse struct: represents a warehouse with the total demand, the current demand and all the supplies 
// that need to be delivered 
type Warehouse struct {
	id string
	currentDemand int 
	totalDemand int 
	supplies []*Supply //slice of pointers to supplies
}

//Supply struct: represents a transaction between a factory and warehouse  
type Supply struct {
	id string
	supplyAmount int
	costPerUnit int
	factory *Factory 
	warehouse *Warehouse
	label string
}

//** -- Supply Methods -- **/
//transfer amount from factory to warehouse
func(s *Supply) transfer(amount int) {
	//transfer amount from factory to warehouse
	s.supplyAmount += amount 
	s.factory.currentProduction -= amount //deduct it from the production amount
	s.warehouse.currentDemand -= amount //dedict it from the demand amount
}

func(s *Supply) String() string { //string representation of supply
	return fmt.Sprintf("[%v-%v-%v, %v]",s.factory.id, s.supplyAmount, s.warehouse.id, s.label)
}

//** -- End of Supply Methods -- **//

//Route struct that will store a path and the cost of that path
type Route struct {
	path []*Supply //slice of pointers to supplies
	cost int
}

//** -- Functions -- **//

//Creates a supply and adds it to factory and warehouse
func addSupplies(costPerUnit int, f *Factory, w *Warehouse) {
	s := &Supply{strconv.Itoa(f.id)+"-"+w.id,0, costPerUnit, f, w, "empty"} //create supply
	f.supplies = append(f.supplies, s) //add it to factory
	w.supplies = append(w.supplies, s) //add it to warehouse

}

//Return empty cells from the matrix 
func getEmptyCells() []*Supply {
	//1. initialize slice
	emptyCells := make([]*Supply,0)

	//2. iterate over the 2D matrix 
	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ { //matrix[i] is a slice of pointers to supplies
			if matrix[i][j].supplyAmount == 0 && matrix[i][j].label == "empty" { //matrix[i][j] is a pointer to a supply
				//3. append the supplies with supplyAmount = 0 to the initialized slice
				emptyCells = append(emptyCells, matrix[i][j]) //append pointer to supply
			}
		}
	}
	//return slice
	return emptyCells
}

//Return a pointer to the supply with least cost per unit
func getMinCostEmptyCells() (smallestCell *Supply) {
	emptyCells := getEmptyCells() //returns a slice with pointers to empty supplies 
	smallestCost := emptyCells[0].costPerUnit
	smallestCell = emptyCells[0]

	var (
		production1, demand1, production2, demand2 int
		candidate1, candidate2, chosen float64
		)

	for i:= 1; i < len(emptyCells); i++ {
		//compare the current smallestCost to the others
		if smallestCost > emptyCells[i].costPerUnit {
			smallestCost = emptyCells[i].costPerUnit
			smallestCell = emptyCells[i]
		} else if (smallestCost == emptyCells[i].costPerUnit) {
		//if both costs are equal pick the one with the biggest demand or production
			production1 = smallestCell.factory.currentProduction
			demand1 = smallestCell.warehouse.currentDemand
			candidate1 = math.Min(float64(production1), float64(demand1)) //smallest of demand or production for smallestCell so far

			production2 = emptyCells[i].factory.currentProduction
			demand2 = emptyCells[i].warehouse.currentDemand
			candidate2 = math.Min(float64(production2), float64(demand2)) //smallest of demand or production for current cell

			chosen = math.Max(candidate1, candidate2) //grab the biggest of both mins

			if (chosen == candidate2) {
				smallestCell = emptyCells[i]
				smallestCost = emptyCells[i].costPerUnit
			}

		}
	}
	return smallestCell
}

//Performs least cost algirthm 
func leastCost(totalProduction int) {
	for {
		if (totalProduction <= 0) {
			break;
		}
		//1. Get empty cell with least cost 
		targetSupply := getMinCostEmptyCells() //pointer to smallest supply 
		production := targetSupply.factory.currentProduction //current production of factory for that supply 
		demand := targetSupply.warehouse.currentDemand //current demand of warehosue for that supply 
		amountToTransfer := int(math.Min(float64(production), float64(demand))) //amount to transfer

		if (amountToTransfer == 0) {
			targetSupply.label = "unexploredEmpty"
		} else {
			targetSupply.transfer(amountToTransfer)
			targetSupply.label = "unexploredFull"
		}

		totalProduction -= amountToTransfer
	}

	//Adjust label of cells we didn't reach and that remained with label empty 
	emptyCells := getEmptyCells()
	for i := 0; i < len(emptyCells); i++ {
		emptyCells[i].label = "unexploredEmpty"
	}
}

//Returns a slice containing pointers to full cells
func getFullCells() []*Supply {
	//1. Initialize slice
	fullCells := make([]*Supply,0)

	//2. iterate over the 2D matrix 
	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ {
			if matrix[i][j].label == "unexploredFull" { //matrix[i][j] is a pointer to a slice 
				fullCells = append(fullCells, matrix[i][j])
			}
		}
	}
	return fullCells
}

//Returns the total cost 
func totalCost() int {
	//1. Get the full cells 
	fullCells := getFullCells() 
	totalCost := 0
	//2. iterate over them 
	for i := 0; i < len(fullCells); i++ {
		//calculate cost for each cell and sum it 
		totalCost += fullCells[i].supplyAmount * fullCells[i].costPerUnit
	}
	return totalCost
}

//Returns a slice containing pointers to unexplored empty cells: These are the ones we are using for stepping stone
func getUnexploredEmptyCells() []*Supply {
	unexploredEmptyCells := make([]*Supply, 0)

	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ {
			if matrix[i][j].label == "unexploredEmpty" { //matrix[i][j] is a pointer to a supply
				unexploredEmptyCells = append(unexploredEmptyCells, matrix[i][j])
			}
		}
	}
	return unexploredEmptyCells
}

//Returns a slice with pointers to supplies adjacent to s 
func getAdjacentCells(s *Supply) []*Supply {
	//1. Initialize slice 
	adjacents := make([]*Supply,0)
	//2. Grab adjacents in row 
	for i:= 0; i < len(s.factory.supplies); i++ {
		if (s.factory.supplies[i] != s) { //don't add s in the slice 
			adjacents = append(adjacents, s.factory.supplies[i])
		}
	}

	//3. Grab adjacents in column 
	for i:= 0; i < len(s.warehouse.supplies); i++ {
		if (s.warehouse.supplies[i] != s) { //don't add s in the slice 
			adjacents = append(adjacents, s.warehouse.supplies[i])
		}
	}
	return adjacents

}
//Returns true if the three supplies are contained in the same row 
func containedInRow(s, s1, s2 *Supply) bool {
	var found, found1, found2 bool
	for i := 0; i < len(s.factory.supplies); i++ { // check if row contains s
		if s.factory.supplies[i] == s {
			found = true
		} 
	}

	for i := 0; i < len(s.factory.supplies); i++ { //check if row contains s1
		if s.factory.supplies[i] == s1 {
			found1 = true
		} 
	}

	for i := 0; i < len(s.factory.supplies); i++ { //check if row contains s2
		if s.factory.supplies[i] == s2 {
			found2 = true
		} 
	}
	//Note: we use 3 different loops in case s, s1, s2 are in random order 

	if found && found1 && found2 {
		return true
	}
	return false
}
//Returns true if the three supplies are contained in the same column 
func containedInColumn(s, s1, s2 *Supply) bool {
	var found, found1, found2 bool 
	for i := 0; i < len(s.warehouse.supplies); i++ {
		if s.warehouse.supplies[i] == s { //Check if column contains s
			found = true
		}
	}
	for i := 0; i < len(s.warehouse.supplies); i++ {
		if s.warehouse.supplies[i] == s1 { //Check if column contains s1
			found1 = true
		}
	}

	for i := 0; i < len(s.warehouse.supplies); i++ {
		if s.warehouse.supplies[i] == s2 { //Check if column contains s2
			found2 = true
		}
	}
	if found && found1 && found2 {
		return true
	}
	return false
}

//Returns true if s is found in slice and false otherwise 
func containes(s *Supply, st *Stack) bool {
	for i := 0; i < len(st.stack); i++ {
		if s == st.stack[i] {
			return true
		}
	}
	return false
}

//Populates stack path with the supplies that form a valid cycle
//Stack s is used for temporary storage purposes
func cycleDFS(s *Supply, st *Stack, path *Stack) {
	s.label = "visited" //Set label to visited 
	st.push(s) //push in stack

	adjacentCells := getAdjacentCells(s) //get adjacent cells
	for i := 0; i < len(adjacentCells); i++ {
		if !foundCycle && (!containes(adjacentCells[i], st) || adjacentCells[i] == st.stack[0]) { //if we haven't explored it yet  
			if (adjacentCells[i].label == "unexploredFull") {
				//Get the last two pairs if stack's size is big enough
				if len(st.stack) >= 2 {
					pair1 := st.stack[len(st.stack)-2]
					pair2 := st.stack[len(st.stack)-1]
					//Make sure the last two elems in the stack are not in the same row or column as the current cell
					if (!containedInRow(adjacentCells[i], pair1, pair2) &&
						!containedInColumn(adjacentCells[i], pair1, pair2)) {
						cycleDFS(adjacentCells[i], st, path)
					}
				} else if len(st.stack) < 2 { //size is too small add whatever we found to the stack
					cycleDFS(adjacentCells[i], st, path)
				}
			} else if (adjacentCells[i].label == "visited") { //if adjacentCell is found again it's a cycle
				if !containedInRow(adjacentCells[i],st.stack[len(st.stack)-2],st.stack[len(st.stack)-1]) &&
				!containedInColumn(adjacentCells[i],st.stack[len(st.stack)-2],st.stack[len(st.stack)-1]) {
					for i := 0; i < len(st.stack); i++ {
						path.push(st.stack[i])
						foundCycle = true
					}
				}
			}
		}
	}
	st.pop()
}

//Returns a channel that contains the possible routes for the iteration
func steppingStone() chan Route {
	//Get all unexplored empty cells
	unexploredEmptyCells := getUnexploredEmptyCells()

	//Make a channel that will contain all the routes 
	routes := make(chan Route, len(unexploredEmptyCells))

	var mux sync.Mutex //mutex to synchronize routines
	var wg sync.WaitGroup //wait group to sychronize routines

	for i := 0; i < len(unexploredEmptyCells); i++ {
		wg.Add(1) //add to wait group
		//send all empty cells on a go routine to find their paths
		go marginalCost(unexploredEmptyCells[i], &mux, &wg, routes) 
	}
	wg.Wait() //Wait for all routines to finish before closing route
	close(routes) //close route 
	return routes 
}
//Calculates the marginal cost of each route, sets its value and adds the route to the channel
func marginalCost(emptyCell *Supply, c *sync.Mutex, wg *sync.WaitGroup, routes chan Route) {
	c.Lock() //Lock resources for concurrency control
	st := Stack{make([]*Supply, 0)} //st is for temporary storage used by cycleDFS
	path := Stack{make([]*Supply,0)} //stack that will contain a valid path by the end of cycleDFS

	cycleDFS(emptyCell, &st, &path) //find cycle and populate path

	//clean up labels for other go routines: reset all visited to unexploredEmpty or unexploredFull
	for i:= 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ {
			if matrix[i][j].label == "visited" {
				if matrix[i][j].supplyAmount == 0 { //reset to unexploredEmpty
					matrix[i][j].label = "unexploredEmpty"
				} else { //if supplyAmount is not 0 reset to unexploredFull
					matrix[i][j].label = "unexploredFull"
				}
			}
		}
	}
	foundCycle = false //reset to false for other go routines

	c.Unlock() //unlock resources
	//From this point this code is executed concurrently
	route := Route{path.stack, 0} //create route from the obtained path
	
	//calculate marginal cost of route 
	cost := 0
	for i := 0; i < len(route.path); i++ {
		if i % 2 == 0 {
			cost += route.path[i].costPerUnit
		} else {
			cost -= route.path[i].costPerUnit
		}
	}
	route.cost = cost
	routes <- route //Add route to channel
	wg.Done() //signal done
}


//Finds the most optimal transport 
func optimalTransport() {
	var routes chan Route

	for {
		//1. Grab all valid paths starting from an empty cell (concurrently)
		routes = steppingStone() //channel of routes 

		//2. Find smallest marginal cost path 
		min:= <-routes
		for route := range routes {
			if min.cost > route.cost {
				min = route
			}
		}

		//3 a. if smallest is not negative we are done
		if min.cost >= 0 {
			break
		}

		//3. b. at this point there is a more optimal path 
		chosenPath := min.path


		//4. Transfer the smallest negative cell to the empty cell and adjust everything
		//4.a. Look for negative min cell in chosenPath
		minCell := chosenPath[1] //We start at 1 because cell 0 is empty
		for i:= 3; i < len(chosenPath); i = i+2 {
			if minCell.supplyAmount > chosenPath[i].supplyAmount {
				minCell = chosenPath[i]
			}
		}

		//4.b. Transfer to empty cell and adjust 
		amount := minCell.supplyAmount
		for i:= 0; i < len(chosenPath); i++ {
			if i % 2 == 0 {
				chosenPath[i].supplyAmount += amount
			} else {
				chosenPath[i].supplyAmount -= amount
			}
		}

		//5. Update labels
		for i := 0; i < len(matrix); i++ {
			for j := 0; j < len(matrix[i]); j++ {
				if (matrix[i][j].supplyAmount == 0) {
					matrix[i][j].label = "unexploredEmpty"
				} else {
					matrix[i][j].label = "unexploredFull"
				}
			}
		}
	} 
}

//Reads a file, populates the matrix from it and returns the total production
func fromFile(fileName string) int {
	file, err := os.Open(fileName)
	//log error if could not open file
	if err != nil {
		log.Fatal(err)
	}
	defer func() {
		if err = file.Close(); err != nil {
			log.Fatal(err)
		}
	}()
	//Create new scanner using the file 
	sc := bufio.NewScanner(file)

	//First line #1 (# of factories) #2 (# of warehouses)
	sc.Scan() //Read first line
	firstLine := strings.Fields(sc.Text()) //convert to String
	numOfWarehouses, errInt2 := strconv.Atoi(firstLine[1]) //num of warehouses

	if errInt2 != nil {
		log.Fatal(errInt2)
	}
	// -- End of errors -- //

	//Second line is all warehouses plus the word Supply
	sc.Scan() //Read second line
	secondLine := strings.Fields(sc.Text())

	for i := 0; i < numOfWarehouses; i++ {
		warehouse := Warehouse{id:secondLine[i]}
		warehouses = append(warehouses, warehouse)
	}

	endOfFile := false 
	// index := 0
	var line []string
	var totalProduction int
	for !endOfFile {
		sc.Scan() //Read line
		line = strings.Fields(sc.Text())

		//If first string is an int we are not in the last line yet
		if num,err:= strconv.Atoi(line[0]); err == nil {
			//first string is id and last string is total production
			production, err := strconv.Atoi(line[len(line)-1])
			if err != nil { log.Fatal(err)}
			factory := Factory{id:num, currentProduction:production, totalProduction: production}
			factories = append(factories, factory)

			//Every other line in btw is a supply
			for i := 1; i < len(line)-1; i++ {
				costPerUnit, err := strconv.Atoi(line[i])
				if err != nil {log.Fatal(err)}
				addSupplies(costPerUnit, &factories[len(factories)-1], &warehouses[i-1])
			}

		} else { //last line
			//first string is the word demand, last string is the total
			for i:= 1; i < len(line)-1; i++ {
				demand, err := strconv.Atoi(line[i])
				if err != nil {log.Fatal(err)}
				warehouses[i-1].currentDemand = demand
				warehouses[i-1].totalDemand = demand
			}
			totalProduction, err = strconv.Atoi(line[len(line)-1])
			if err != nil {log.Fatal(err)}
			endOfFile = true
		}
	}
	//populate matrix 
	for _,f := range factories {
		matrix = append(matrix, f.supplies)
	}

	return totalProduction
}

//Writes matrix to file - called once solution is found
func toFile(fileName string, totalCost int) {
	file, err := os.Create(fileName) //create file
	//if something goes wrong
	if err != nil { 
		log.Fatal(err)
		file.Close()
	}
	defer func() {
		if err = file.Close(); err != nil {
			log.Fatal(err)
		}
	}()

	//first line: #1 (num of factories) #2 (num of warehouses)
	numOfFactories := strconv.Itoa(len(matrix))
	numOfWarehouses := strconv.Itoa(len(matrix[0]))
	file.WriteString(numOfFactories+" "+numOfWarehouses)
	file.WriteString("\r\n") //go back in line

	//Second line: list of warehouses + the word supply in the end
	for _,w:= range warehouses {
		file.WriteString(w.id)
		file.WriteString(" ")
	}
	file.WriteString("Supply")
	file.WriteString("\r\n") 

	index := 0
	for index < len(factories) {
		//first word is always the id of the factory
		file.WriteString(strconv.Itoa(factories[index].id))
		file.WriteString(" ")

		//Supplies of that factory 
		supplies := factories[index].supplies
		for i := 0; i < len(supplies); i++ {
			file.WriteString(strconv.Itoa(supplies[i].supplyAmount))
			file.WriteString(" ")
		}
		//Write total production of the factory 
		file.WriteString(strconv.Itoa(factories[index].totalProduction))
		file.WriteString("\r\n")
		index++
	}
	//before last line: write the word demand + total demand for each warehouse
	file.WriteString("Demand ")

	for i := 0; i < len(warehouses); i++ {
		file.WriteString(strconv.Itoa(warehouses[i].totalDemand)+" ")
	}
	file.WriteString("\r\n")

	//last line write the total production 
	file.WriteString(strconv.Itoa(totalCost))
}

func main() {
	//Ask for file name 
	var fileName string
	fmt.Print("Please enter file name: ")
	fmt.Scanln(&fileName)
	fmt.Println("Reading file...")
	fmt.Println("")
	totalProduction := fromFile(fileName)

	//Perform least cost algorithm
	fmt.Println("Matrix populated - performing least cost...")
	fmt.Println("")
	leastCost(totalProduction)

	//Find optimal solution 
	fmt.Println("Finding optimal solution...")
	fmt.Println("")
	optimalTransport()
	fmt.Println("Optimal Solution found!")

	//Write solution to file
	var fileNameToWriteIn string
	fmt.Print("Please enter file name to write in: ")
	fmt.Println("")
	fmt.Scanln(&fileNameToWriteIn)
	toFile(fileNameToWriteIn, totalCost())
	fmt.Println("File written successfully - exiting program")

}