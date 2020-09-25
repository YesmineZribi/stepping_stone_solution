%Name: Yesmine Zribi (8402454)
% CSI2520 - Devoir 0 prolog

%Run: minimumTransportCost(C) in order to run 
%the program. 
% You will be prompted to enter the name of two files: 
% (1) The file describing the problem
% (2) The file describing the initial solution
% Wait for the matrix solution to appear as well as the 
% Marginal total cost in the end 
%
% (Note: the 10x10 matrix works but it takes a few seconds to display the results)
 
%Whole file in one list

listStream(File,L) :- open(File,read,F), readAll(F,L), close(F). 

listStreamInit(File,L) :- open(File,read,F), readAll(F,L), close(F).

						%Number of warehouses 
warehouseNum(File,N) :- listStream(File,[_,N|_]).

						%Number of factories 
factoryNum(File,N) :- listStream(File,[N|_]).

						%Cost: List of list and Initial Sol: List of list 

							%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%a.1. List until supplies of costs 
listUntilSupply(File,L) :- listStream(File,L1), listUntilSupply1(L,L1).
listUntilSupply1([X],[X|_]):- X = 'Supply',!.
listUntilSupply1([X|T],[X|Y]):- X \= 'Supply',
listUntilSupply1(T,Y).

	%a.2. List until supplies of initial solution
listUntilSupplyInit(File,L) :- listStreamInit(File,L1), listUntilSupplyInit1(L,L1).
listUntilSupplyInit1([X],[X|_]):- X = 'Supply',!.
listUntilSupplyInit1([X|T],[X|Y]):- X \= 'Supply',
listUntilSupplyInit1(T,Y).

							%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%b.1. List of everything after supply of costs
listAfterSupply(File,L):- listStream(File,L1),listUntilSupply(File,Pre),
append(Pre,L,L1).

	%b.2. List of everyhing after supply of initial solution
listAfterSupplyInit(File,L):- listStreamInit(File,L1),listUntilSupplyInit(File,Pre),
append(Pre,L,L1).

							%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%c.1. List after supply and before demand of costs
listOfCostsAndSupplies(File,L):- listAfterSupply(File,L1),
append(L,['Demand'|_],L1),!.

	%c.2. List after supply and before demand of initial solution
listOfCostsAndSuppliesInit(File,L):- listAfterSupplyInit(File,L1),
append(L,['Demand'|_],L1),!.
							%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%d.1. List of costs and supplies of factory F and List of initial solution and supplies of factory F

							%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%(1)(a) Parse each sublist that represents the costs of supplies of each factory: Find sublist starting from factory F

%In case the factory we are looking for is the first one
findSubStartingFromF(File,F,Result):-
F == 1, listOfCostsAndSupplies(File,Result),!.

%In case the factory we are looking for is NOT the first one: calling method 
findSubStartingFromF(File,F,Result):-
F \= 1, listOfCostsAndSupplies(File,L),
warehouseNum(File,N), N1 is N+2,
findSubStartingFromF(F,N1,1,L,Result),!.


%Found starting point to parse
findSubStartingFromF(F,_,1,[F|T],[F|T]).

%Keep iterating over row until we reach end of row
findSubStartingFromF(F,Incr,AccNum,[_|T],Res):-
AccNum < Incr, AccNum1 is AccNum+1, 
findSubStartingFromF(F,Incr,AccNum1,T,Res).

%Reached end of row 
findSubStartingFromF(F,Incr,AccNum,[_|T],Res):-
AccNum == Incr, AccNum1 is 1,
findSubStartingFromF(F,Incr,AccNum1,T,Res).

	%(1)(b) Parse each sublist that represents the current supply of supplies of each factory: Find sublist starting from factory F

%In case the factory we are looking for is the first one
findSubStartingFromFInit(File,F,Result):-
F == 1, listOfCostsAndSuppliesInit(File,Result),!.

%In case the factory we are looking for is NOT the first one: calling method 
findSubStartingFromFInit(File,F,Result):-
F \= 1, listOfCostsAndSuppliesInit(File,L),
warehouseNum(File,N), N1 is N+2,
findSubStartingFromFInit(F,N1,1,L,Result),!.


%Found starting point to parse
findSubStartingFromFInit(F,_,1,[F|T],[F|T]).

%Keep iterating over row until we reach end of row
findSubStartingFromFInit(F,Incr,AccNum,[_|T],Res):-
AccNum < Incr, AccNum1 is AccNum+1, 
findSubStartingFromFInit(F,Incr,AccNum1,T,Res).

%Reached end of row 
findSubStartingFromFInit(F,Incr,AccNum,[_|T],Res):-
AccNum == Incr, AccNum1 is 1,
findSubStartingFromFInit(F,Incr,AccNum1,T,Res).

							%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%(2)(a) List of costs and supplies of factory F

%when my factory is not the last
costsAndSuppliesF(File,F,Result):-
warehouseNum(File,N), N1 is N+1,
findSubStartingFromF(File,F,[_|List]),
costsAndSuppliesF(N1,1,List,[],Result),!.

%Keep iterating over row until we reach end of row
costsAndSuppliesF(Incr,AccNum,[H|T],AccList,Result):-
AccNum =< Incr, AccNum1 is AccNum+1,
append(AccList,[H],AccList1), 
costsAndSuppliesF(Incr,AccNum1,T,AccList1,Result).

%Reached end of row
costsAndSuppliesF(Incr,AccNum,_,AccList,AccList):-
AccNum > Incr.


	%(2)(a) List of current supplies and supplies of factory F

%when my factory is not the last
costsAndSuppliesFInit(File,F,Result):-
warehouseNum(File,N), N1 is N+1,
findSubStartingFromFInit(File,F,[_|List]),
costsAndSuppliesFInit(N1,1,List,[],Result),!.

%Keep iterating over row until we reach end of row
costsAndSuppliesFInit(Incr,AccNum,[H|T],AccList,Result):-
AccNum =< Incr, AccNum1 is AccNum+1,
append(AccList,[H],AccList1), 
costsAndSuppliesFInit(Incr,AccNum1,T,AccList1,Result).

%Reached end of row
costsAndSuppliesFInit(Incr,AccNum,_,AccList,AccList):-
AccNum > Incr.
						%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%e.1. List of costs for one factory
listOfCosts(File,F,Costs):-
costsAndSuppliesF(File,F,Res),
append(Costs,[_],Res),!.

costs(File,Result):-
factoryNum(File,N),
costs(File,N,1,[],Result),!.

%When we are out of rows
costs(_,NumOfFactories,AccNum,AccList,AccList):-
AccNum > NumOfFactories.

%While we still have rows to add
costs(File,NumOfFactories,AccNum,AccList,Result):-
AccNum =< NumOfFactories,
listOfCosts(File,AccNum,Costs), append(AccList,[Costs],AccList1),
AccNum1 is AccNum+1,
costs(File,NumOfFactories,AccNum1,AccList1,Result).

	%e.2. List of current supplies for one factory
listOfCostsInit(File,F,Costs):-
costsAndSuppliesFInit(File,F,Res),
append(Costs,[_],Res),!.

costsInit(File,Result):-
factoryNum(File,N),
costsInit(File,N,1,[],Result),!.

%When we are out of rows
costsInit(_,NumOfFactories,AccNum,AccList,AccList):-
AccNum > NumOfFactories.

%While we still have rows to add
costsInit(File,NumOfFactories,AccNum,AccList,Result):-
AccNum =< NumOfFactories,
listOfCostsInit(File,AccNum,Costs), append(AccList,[Costs],AccList1),
AccNum1 is AccNum+1,
costsInit(File,NumOfFactories,AccNum1,AccList1,Result).


						%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		%List of Supplies
%Supply for one factory 
supplyF(File,F,Result):-
costsAndSuppliesF(File,F,Result1),
append(_,[Result],Result1),!.

%Supply for all factories 
supplies(File,Result):-
factoryNum(File,N),
supplies(File,N,1,[],Result),!.

%When we are out of rows 
supplies(_,NumOfFactories,AccNum,AccList,AccList):-
AccNum > NumOfFactories.

%While we still have supplies to add 
supplies(File,NumOfFactories, AccNum, AccList,Result):-
AccNum =< NumOfFactories,
supplyF(File,AccNum,Supply),
append(AccList, [Supply],AccList1),
AccNum1 is AccNum+1,
supplies(File,NumOfFactories,AccNum1,AccList1,Result).
						
						%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		%List of Demands

demand(File,Result):- listAfterSupply(File,L), append(_,['Demand'|Result],L),!.

						%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		%Merge costs and initial solution lists to have it in the format: supply(Factory, Warehouse, cost, current-supply,unexploredFull or unexploredEmpty)

%Merge two lists to get the format supply(Factory, Warehouse, cost, current-Supply)
convert(FactoryNum, WarehouseChar, [Cost|RestC],[Supply|RestS], Result) :-
convert(FactoryNum, WarehouseChar, [Cost|RestC],[Supply|RestS],[],Result).

%Base case: 
convert(_,_,[],[],A,A):- !.

%Recursive call for full cells:
convert(FactoryNum, WarehouseChar, [Cost|RestC],[Supply|RestS],AccList,Res):-
Supply \= 0,
char_code(WarehouseLet,WarehouseChar),
append(AccList, [supply(FactoryNum,WarehouseLet,Cost,Supply,'UnexploredFull')], AccList1),
WarehouseChar1 is WarehouseChar+1,
convert(FactoryNum, WarehouseChar1, RestC, RestS, AccList1, Res).

%Recursive call for empty cells:
convert(FactoryNum, WarehouseChar, [Cost|RestC],[Supply|RestS],AccList,Res):-
Supply == 0,
char_code(WarehouseLet,WarehouseChar),
append(AccList, [supply(FactoryNum,WarehouseLet,Cost,Supply,'UnexploredEmpty')], AccList1),
WarehouseChar1 is WarehouseChar+1,
convert(FactoryNum, WarehouseChar1, RestC, RestS, AccList1, Res).


matrix(File1,File2,X):-
costs(File1,Costs),
costsInit(File2,CurrentSupplies),
matrix(1,65,Costs,CurrentSupplies,[],X),!.

%Base case:
matrix(_,_,[],[],A,A):- !.

%Recursive call:
matrix(FactoryNum, WarehouseChar,[RowC|RestC],[RowS|RestS],AccList,Result):-
convert(FactoryNum, WarehouseChar, RowC, RowS,RowResult),
append(AccList, [RowResult], AccList1),
FactoryNum1 is FactoryNum+1,
matrix(FactoryNum1, WarehouseChar, RestC, RestS, AccList1, Result).

						%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

						%Find path of a given supply to other supplies 


			%(1) Find supplies in same row as target supply
%Calling method
select_row(TargetC,Matrix,Result):- select_row1(TargetC,Matrix,Result).

%If we found the row in which the target supply resides, grab all the elements except for TargetC
select_row1(TargetC,[Row|_],Result):-
member(TargetC, Row), delete(Row,TargetC,Result),!.

select_row1(TargetC,[Row|Rest],Result):-
not(member(TargetC,Row)), select_row1(TargetC,Rest,Result).



			%(2) Find supplies in same column as target supply 
%Calling method 
select_column(supply(Fac,TargetL,_,_,_),Matrix,Result):- 
select_column1(supply(Fac,TargetL,_,_,_),Matrix,[],Result1),
delete(Result1,supply(Fac,TargetL,_,_,_),Result),!.

%Base case:
select_column1(_,[],A,A).

%Recusrive call:
select_column1(supply(_,Letter,_,_,_),[Row|Rest],AccList,Result):-
delete(Row,supply(_,Letter,_,_,_), List),
select(ElemToAdd,Row,List),
append(AccList,[ElemToAdd],AccList1),
select_column1(supply(_,Letter,_,_,_), Rest, AccList1,Result).

		%(3)a. Find supplies adjacent to a given supply

adjacentCells(TargetC,Matrix,Result):-
select_row(TargetC,Matrix,AdjacentInR),
select_column(TargetC,Matrix,AdjancentInC),
append(AdjacentInR,AdjancentInC,Result).

	%(3)b. Test if Cell1 is adjancent to Cell2
isAdjacent(Cell1,Matrix,Cell2):- Cell1 \= Cell2, adjacentCells(Cell1,Matrix,Result), member(Cell2,Result).
isAdjacent(Cell1,_,Cell2):- Cell1 == Cell2.


		%(4) Find full adjancent cell of a given target cell
fullAdjacent(TargetC,Matrix,Result):-
adjacentCells(TargetC,Matrix,AdjacentCells),
fullAdjacent1(TargetC,AdjacentCells,Result).

%Found full adjacent cell
fullAdjacent1(_,[supply(Fac,War,Cost,X,Label)|_], supply(Fac,War,Cost,X,Label)):- X \= 0.

%Did not find full adjacentCell 
fullAdjacent1(TargetC,[supply(_,_,_,0,_)|Rest],Result):- !,
fullAdjacent1(TargetC,Rest,Result).

fullAdjacent1(TargetC,[_|Rest], Result):- 
fullAdjacent1(TargetC,Rest,Result).


		%(5) Find path from a given cells
path(Matrix,EmptyCell,Result):-
path(Matrix,EmptyCell,EmptyCell,[EmptyCell],Result),!.

%Base case: when the last added element is adjacent to the empty cell but the length of this list is greater
%than 2 
path(Matrix,EmptyCell,TargetC,AccList,AccList):-
length(AccList,Length), Length > 2,
isAdjacent(EmptyCell,Matrix,TargetC). 

%Recursive call:when AccList has less than two elements,  just add the first full adjacent found
path(Matrix,EmptyCell,TargetC,AccList,Result):-
length(AccList, Length), Length < 2,
fullAdjacent(TargetC,Matrix,FullAdjacent),
append(AccList,[FullAdjacent],AccList1),
path(Matrix,EmptyCell,FullAdjacent,AccList1,Result).

%Recursive call: when AccList has more than two elements we need to check that the adjacent obtained
%is not adjacent to the second last element added 
path(Matrix,EmptyCell,TargetC,AccList,Result):-
fullAdjacent(TargetC,Matrix,FullAdjacent),
append(_,[SecondLast,TargetC],AccList),
isAdjacent(FullAdjacent,Matrix,TargetC),
not(isAdjacent(FullAdjacent,Matrix,SecondLast)),
append(AccList,[FullAdjacent],AccList1),
path(Matrix,EmptyCell, FullAdjacent,AccList1,Result).

							%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

							%Find all paths for all empty cells

		%(1) Find empty cell of a given row 
%Base case: When we find the empty cell give it to result
get_emptyCell([supply(Fac,War,Cost,0,Label)|_],supply(Fac,War,Cost,0,Label)).

%If we did not find empty cell
get_emptyCell([_|Rest],Result):-
get_emptyCell(Rest,Result).

		%(2) Find all empty cells 
%Calling method
get_all_emptyCells(Matrix,Result):-
get_all_emptyCells(Matrix,[],Result).

%Base case: transfer all to result
get_all_emptyCells([],A,A).

%Recursive call: call get_emptyCell on each row 
get_all_emptyCells([Row|Rest],AccList,Result):-
findall(EmptyCell,get_emptyCell(Row,EmptyCell),EmptyCells),
append(AccList,EmptyCells,AccList1),
get_all_emptyCells(Rest,AccList1,Result).

	%(2) Find paths of all empty cells of a given matrix

%Calling method
find_paths(Matrix,Result):-
get_all_emptyCells(Matrix,EmptyCells),
find_paths(Matrix,EmptyCells,[],Result),!.

%Base case: transfer all to result
find_paths(_,[],A,A).

%Recusrive call
find_paths(Matrix,[EmptyCell|Rest],AccList,Result):-
path(Matrix,EmptyCell,Path),
append(AccList,[Path],AccList1),
find_paths(Matrix,Rest,AccList1,Result).

%Recusrive call
find_paths(Matrix,[EmptyCell|Rest],AccList,Result):-
not(path(Matrix,EmptyCell,_)),
find_paths(Matrix,Rest,AccList,Result).

								%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

								%Find smallest path 

	%(3) a. Calculate cost of a given path

path_cost(Path,Result):-
path_cost(Path,0,0,Result),!.

%Base case: 
path_cost([],_,A,A).

%Recursive call: if N is even add
path_cost([supply(_,_,Cost,_,_)|Rest],N,AccNum,Result):-
0 is N mod 2, 
N1 is N+1,
AccNum1 is AccNum+Cost,
path_cost(Rest,N1,AccNum1,Result).

%Recursive call: if N is odd subtract 
path_cost([supply(_,_,Cost,_,_)|Rest],N,AccNum,Result):-
1 is N mod 2,
N1 is N+1,
AccNum1 is AccNum-Cost,
path_cost(Rest,N1,AccNum1,Result).

	%(3) b. Calculate cost of all paths 
%Calling method
all_path_cost(Matrix,Result):-
find_paths(Matrix,Paths),
all_path_cost(Paths,[],Result).

%Base case: transfer all to result 
all_path_cost([],A,A).

%Recursive call: Add each cost to the accumulator list 
all_path_cost([Path|Rest],AccList,Result):-
path_cost(Path,Cost),
append(AccList,[Cost],AccList1),
all_path_cost(Rest,AccList1,Result).

	%(3) c. Get smallest cost 
%Calling method
smallest_cost(Matrix,Result):-
all_path_cost(Matrix,[Cost|Rest]),
smallest_cost(Rest,Cost,Result),!.

%Base case: 
smallest_cost([],A,A).


%Recursive call: if encountered cost is smaller than accumulator
smallest_cost([Cost|Rest],Acc,Result):-
Cost < Acc, smallest_cost(Rest,Cost,Result).

%Recursive call: if encountered cost is bigger than accumulator
smallest_cost([Cost|Rest],Acc,Result):-
Cost >= Acc, smallest_cost(Rest,Acc,Result).

	%(3) d. Get path responsible for smallest cost 

smallest_path(Matrix,Result):-
all_path_cost(Matrix,AllCosts),
smallest_cost(Matrix,SmallestCost), SmallestCost < 0,
nth0(Index,AllCosts,SmallestCost),
find_paths(Matrix,Paths),
nth0(Index,Paths,Result),!.

								%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

								%Given the smallest path, move things around in the old matrix 

	%(1) Find all negative cells
negative_cells(Matrix,Result):-
smallest_path(Matrix,SmallestPath),
negative_cells(SmallestPath,0,[],Result),!.

%Base case: 
negative_cells([],_,A,A).

%Recursive call: If N is odd add cell to accumulator
negative_cells([Supply|Rest],N,AccList,Result):-
1 is N mod 2, N1 is N+1,
append(AccList,[Supply],AccList1),
negative_cells(Rest,N1,AccList1,Result).

%Recusrive call: If N is even do not add cells 
negative_cells([_|Rest],N,AccList,Result):-
0 is N mod 2, N1 is N+1,
negative_cells(Rest,N1,AccList,Result).

	%(2) Find negative cell with smallest supply
%Calling method:
smallest_negative_cell(Matrix,Result):-
negative_cells(Matrix,[supply(Fac,War,Cos,S,Lab)|Rest]),
smallest_negative_cell(Rest,S,supply(Fac,War,Cos,S,Lab),Result).

%Base case: 
smallest_negative_cell([],_,CurrentSup,CurrentSup).

%Recursive call: If we found a smaller supply cell
smallest_negative_cell([supply(Fac,War,Cos,S,Lab)|Rest],AccNum,_,Result):-
S < AccNum, smallest_negative_cell(Rest,S,supply(Fac,War,Cos,S,Lab),Result).

%Recursive call: If we did not find a smaller supply cell
smallest_negative_cell([supply(_,_,_,S,_)|Rest],AccNum,CurrentSup,Result):-
S >= AccNum, smallest_negative_cell(Rest,AccNum,CurrentSup,Result).

	%(3)transfer smallest negative supply to empty cell, shift everything in smallest path

transfer_InPath(Matrix,Result):-
smallest_path(Matrix,SmallestPath),
smallest_negative_cell(Matrix,supply(_,_,_,Sup,_)),
transfer_InPath(SmallestPath,Sup,0,[],Result),!.

%Base case: 
transfer_InPath([],_,_,AccList,AccList).

%Recursive call: Add if N is even
transfer_InPath([supply(Fac,War,Cos,Sup,Lab)|Rest],Move,N,AccList,Result):-
0 is N mod 2, N1 is N+1,
Sup1 is Sup+Move,
append(AccList,[supply(Fac,War,Cos,Sup1,Lab)],AccList1),
transfer_InPath(Rest,Move,N1,AccList1,Result).

%Recursive call: Subtract if N is odd 
transfer_InPath([supply(Fac,War,Cos,Sup,Lab)|Rest],Move,N,AccList,Result):-
1 is N mod 2, N1 is N+1,
Sup1 is Sup-Move,
append(AccList,[supply(Fac,War,Cos,Sup1,Lab)],AccList1),
transfer_InPath(Rest,Move,N1,AccList1,Result).

	%(4)Make changes to matrix based on changes in supplies in smallest path:
	%Returns a modified matrix 

	%(4)a. Change one row in matrix 

modify_matrix(Matrix,Supply,Result):-
replace(Matrix,Supply,Replaced,NewRow),
select(Replaced,Matrix,NewRow,Result),!.


%Base case: found the row I need to replace
replace([[supply(Fac,W,C,S,L)|RestOfRow]|_],supply(Fac,War,Cos,Supp,Lab),[supply(Fac,W,C,S,L)|RestOfRow],Result):-
select(supply(Fac,War,_,_,_),[supply(Fac,W,C,S,L)|RestOfRow],supply(Fac,War,Cos,Supp,Lab),Result),!.

%Recusrive call: did not find row keep iterating
replace([[supply(Fac1,_,_,_,_)|_]|RestOfMatrix],supply(Fac,War,Cos,Supp,Lab),Replaced,Result):-
Fac1 \= Fac,
replace(RestOfMatrix,supply(Fac,War,Cos,Supp,Lab),Replaced,Result).


	%(4)b. Change all elements in matrix by the ones in smallest path
%Calling Method
transfer_InMatrix(Matrix,Result):-
transfer_InPath(Matrix,ChangedSupplies),
transfer_InMatrix(Matrix,ChangedSupplies,Result),!.

%Base case:
transfer_InMatrix(NewMatrix,[],NewMatrix).

%Recursive call:
transfer_InMatrix(Matrix,[ChangedSupply|Rest],Result):-
modify_matrix(Matrix,ChangedSupply,ResultMatrix),
transfer_InMatrix(ResultMatrix,Rest,Result).

								%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

								%Find the most optimal solution
%Calling method
optimal_sol(File1,File2,Result):-
matrix(File1,File2,X),
optimal_sol(X,Result),
write(Result).


%Recusrive call
optimal_sol(Matrix,Result):-
(smallest_path(Matrix,_) ->

	transfer_InMatrix(Matrix,NewMatrix),
	optimal_sol(NewMatrix,Result)

	;
	Result = Matrix
	).

								%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

								%Calculate total costs

		%(1) Calculate total cost of each row 
%Calling method
row_tc(Row,Result):-
row_tc(Row,0,Result).

%Base case:
row_tc([],A,A).

%Recusrive call: 
row_tc([supply(_,_,Cos,Sup,_)|RestOfRow],AccNum,Result):-
AccNum1 is AccNum+Cos*Sup,
row_tc(RestOfRow,AccNum1,Result).

	%(2)Calculate total cost for the whole matrix
%Calling method
total_cost(File1,File2,Result):-
optimal_sol(File1,File2,Matrix),
total_cost1(Matrix,0,Result).

%Base case:
total_cost1([],A,A).

%Recusrive call
total_cost1([Row|RestOfMatrix],AccNum,Result):-
row_tc(Row,RowTC),
AccNum1 is AccNum+RowTC,
total_cost1(RestOfMatrix,AccNum1,Result).

								%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
								%Ask files from user input and solve transportation problem 

minimumTransportCost(Cost):-
write('Please enter the cost file:'),
read(File1),
write('Please enter the initial solution file:'),
read(File2),
minimumTransportCost(File1,File2,Cost).

minimumTransportCost(File1,File2,Cost):-
total_cost(File1,File2,Cost).
