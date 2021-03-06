#lang scheme
;Name: Yesmine Zribi (8402454)
;Devoir 0 - SCHEME

;BEFORE RUNNING THE PROGRAM: PLEASE CHANGE THE BUILD-PATH TO THE APPROPRIATE ONE ON YOUR MACHINE 
;TO RUN THE PROGRAM: (minimumCell "file1.txt" "file2.txt")


                     ;;;;;;;;;;;;;;;;;;;;;;READ FROM FILE CODE;;;;;;;;;;;;;;;;;;;;;;

;NOTE: PLEASE CHANGE THE BUILD-PATH TO THE APPROPRIATE ONE ON YOUR MACHINE
;Ex: <path:C:\Users\Jasmine Z\Desktop\a0_CSI2520_scheme\>
(define fp (build-path "C:" "Users" "Jasmine Z" "Desktop" "a0_CSI2520_scheme"))





(define (readTableau fileIn)  
  (let ((sL (map (lambda s (string-split (car s))) (file->lines fileIn))))
    (map (lambda (L)
           (map (lambda (s)
                  (if (eqv? (string->number s) #f)
                      s
                      (string->number s))) L)) sL)))
   
                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


                      ;;;;;;;;;;;;;;;;;;;ASK USER FOR APPROPRIATE FILES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(define minimumCell
  (lambda (file1 file2)
    (let* ([list-from-file (readTableau file1)]
           [num_fac (num_of_fac list-from-file)]
           [num_war (num_of_war list-from-file)]
           [list_cells_with_sup (list_of_cells_with_sup (list_cells_with_demand list-from-file) num_fac)]
           [cost_matrix (list_of_cells list_cells_with_sup)]
           [list_of_supplies (list_supplies list_cells_with_sup num_fac)]
           [list_of_demands (list_demands (list_demands_with_total (list_cells_with_demand list-from-file) num_fac))]
           [cell_matrix (initial_matrix cost_matrix)]
           [supply_matrix (initial_matrix_supp cost_matrix list_of_supplies)]
           [demand_matrix (initial_matrix_dem cost_matrix list_of_demands)]
           [solution (least_cost_solution cost_matrix supply_matrix demand_matrix cell_matrix list-from-file list_of_supplies num_fac)])
      (display solution) (display newline)
      (writeTableau solution file2))))
      


; (1.a) This procedure returns the list of list of cells with the demand list
;Calling function
(define list_cells_with_demand
  (lambda (list)
    (list_cells_with_demand_aux list 0)))

;Recursive function
(define list_cells_with_demand_aux
  (lambda (list index)
    (if (= 2 index)
        list
        (list_cells_with_demand_aux (cdr list) (+ 1 index)))))


; (1.b) This procedure returns the number of factories
(define num_of_fac
  (lambda (list)
    (car (car list))))


; (1.c) This procedure returns the number of warehouses
(define num_of_war
  (lambda (list)
    (cadar list)))


; (1.d) This procudre returns the list of list of cells w/t the demand list
;but with their supplies
;Calling function
(define list_of_cells_with_sup
  (lambda (list num-fac)
    (list_of_cells_with_sup_aux list 1 num-fac)))


;Recursive function
(define list_of_cells_with_sup_aux
  (lambda (list index num_fac)
    (if (= index num_fac)
        (cons (car list) '())
        (cons (car list) (list_of_cells_with_sup_aux (cdr list) (+ 1 index) num_fac)))))



; (1.e) This procedure returns the list of list of cells without the last column of supplies
; and first column of factory number
;i. Helper procedure: This procedure returns a list without its last column
(define list_without_last
  (lambda (list)
    (list_without_last_aux list (length list) 1)))

(define list_without_last_aux
  (lambda (list length index)
    (if (= length index)
        '()
        (cons (car list) (list_without_last_aux (cdr list) length (+ 1 index))))))

;ii. Return list of list of cells without their first and last columns
(define list_of_cells
  (lambda (list)
    (if (null? list)
        '()
        (cons (cdr(list_without_last (car list))) (list_of_cells (cdr list))))))

; (1.e) This procedure returns the list supplies
;i. Helper procedure:  This procedure returns the last number in a list
(define last_elem
  (lambda (list)
    (last_elem_aux list (length list) 1)))

(define last_elem_aux
  (lambda (list length index)
    (if (= length index)
        (car list)
        (last_elem_aux (cdr list) length (+ 1 index)))))
    
;ii. return list of supplies
(define list_supplies
  (lambda (list num-fac)
    (list_supplies_aux list num-fac 1)))

(define list_supplies_aux
  (lambda (list num-fac index)
    (if (= (+ 1 num-fac) index)
        '()
        (cons (last_elem (car list)) (list_supplies_aux (cdr list) num-fac (+ 1 index))))))


; (1.f) This procedure returns the list of demands with total in last column
(define list_demands_with_total
  (lambda (list num-fac)
    (list_demands_aux list num-fac 1)))

(define list_demands_aux
  (lambda (list num-fac index)
    (if (= (+ 1 num-fac) index)
        (cdr (car list))
        (list_demands_aux (cdr list) num-fac (+ 1 index)))))

;List of demands without total 
(define list_demands
  (lambda (list)
    (list_demands_NoTotal list (length list) 1)))

(define list_demands_NoTotal
  (lambda (list length index)
    (if (= length index)
        '()
        (cons (car list) (list_demands_NoTotal (cdr list) length (+ 1 index))))))


;HELPER PROCEDURE: This procedure returns a list with same length as list but full of 0's
(define row_initial
  (lambda (list)
    (if (null? list)
        '()
        (cons 0 (row_initial (cdr list))))))

;Construct initial matrix
(define initial_matrix
  (lambda (list)
    (if (null? list)
        '()
        (cons (row_initial (car list)) (initial_matrix (cdr list))))))

;HELPER PROCEDURE: This procedure returns a list of supplies that match every cell in a row
(define row_initial_supp
  (lambda (list supp)
    (if (null? list)
        '()
        (cons supp (row_initial_supp (cdr list) supp)))))

;Construct initial matrix of supplies
(define initial_matrix_supp
  (lambda (list supplies)
    (if (null? list)
        '()
        (cons (row_initial_supp (car list) (car supplies)) (initial_matrix_supp (cdr list) (cdr supplies))))))


;HELPER PROCEDURE: This procedure returns a list of demands that match every cell in a row

(define initial_matrix_dem
  (lambda (list demands)
    (if (null? list)
        '()
        (cons demands (initial_matrix_dem (cdr list) demands)))))



                       ;;;;;;;;;;;;;;;;;;LEAST COST FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;

;(1) Find smallest cell


;a. This procedure returns a list (smallestCell itsSupply itsDemand) when given
;row of costs, row of supplies, row of demands
;Calling function
(define smallest_in_row
  (lambda (cost_row supplies_row demands_row cell_row)
    (smallest_in_row_aux (cdr cost_row) (car cost_row) (cdr supplies_row) (car supplies_row) (cdr demands_row) (car demands_row) (cdr cell_row) (car cell_row) 1 1)))


;Recursive function
(define smallest_in_row_aux
  (lambda (cost_row acc supplies_row accRow demands_row accDemand cells_row accCell col_index acc_index)
    (cond
      ;Row is empty but every cell is full? return nothing
      [(and (null? cost_row) (not (= 0 accCell))) '()]

       ;base case 2: We reach end of row but thw accumulator's cell has an empty supply or demand
      [(and (null? cost_row) (or (= 0 accRow) (= 0 accDemand))) '()]
      ;Row is empty but we have empty cell return that
      [(null? cost_row) (list acc accRow accDemand accCell acc_index)]

      ;if the current is empty however its supplies and demands are also empty transfer it still to the next one...
      [(or (= 0 accRow) (= 0 accDemand))
       (smallest_in_row_aux (cdr cost_row) (car cost_row) (cdr supplies_row) (car supplies_row) (cdr demands_row) (car demands_row) (cdr cells_row) (car cells_row) (+ 1 col_index) (+ 1 col_index))]

      
      ;Current cost is smaller than acc, make acc = current cost
      [(or (and (< (car cost_row) acc) (= 0 (car cells_row)) (not (= 0 (car supplies_row))) (not (= 0 (car demands_row)))) (not (= 0 accCell)))
       (smallest_in_row_aux (cdr cost_row) (car cost_row) (cdr supplies_row) (car supplies_row) (cdr demands_row) (car demands_row) (cdr cells_row) (car cells_row) (+ 1 col_index) (+ 1 col_index))]
      
      ;Current cost is equal to acc, pick the one with the biggest demand or supply
      [(and (= (car cost_row) acc) (= 0 (car cells_row)))
       ;Candidate-1 is the min btw supplie and demand of current cell
       ;Candidate-2 is the min btw supplies and demand of acc cell
       (let ([candidate-1 (min (car supplies_row) (car demands_row))]
             [candidate-2 (min accRow accDemand)])
         ;if the biggest is candidate-1 the chosen is the current cell, so acc becomes current cell
         (if (= (max candidate-1 candidate-2) candidate-1)
             (smallest_in_row_aux (cdr cost_row) (car cost_row) (cdr supplies_row) (car supplies_row) (cdr demands_row) (car demands_row) (cdr cells_row) (car cells_row) (+ 1 col_index) (+ 1 col_index))
             (smallest_in_row_aux (cdr cost_row) acc (cdr supplies_row) accRow (cdr demands_row) accDemand (cdr cells_row) accCell (+ 1 col_index) acc_index)))]

      
      [else (smallest_in_row_aux (cdr cost_row) acc (cdr supplies_row) accRow (cdr demands_row) accDemand (cdr cells_row) accCell (+ 1 col_index) acc_index)]))) 











;b. return list containig (smallestEmptyCell its supply its demand) from a matrix
;Calling function
(define smallest_in_matrix
  (lambda (matrix supplies-matrix demand-matrix cell-matrix)
    (smallest_in_matrix_aux (cdr matrix) (cdr supplies-matrix) (cdr demand-matrix) (cdr cell-matrix) (smallest_in_row (car matrix) (car supplies-matrix) (car demand-matrix) (car cell-matrix)))))

;Recursive function
(define smallest_in_matrix_aux
  (lambda (matrix supplies-matrix demand-matrix cell-matrix accList)
    (cond
      ;base case: empty matrix
      [(null? matrix) accList]
      
      ;if the current smallest row returns empty cell move on and don't replace
      [(null? (smallest_in_row (car matrix) (car supplies-matrix) (car demand-matrix) (car cell-matrix)))
       (smallest_in_matrix_aux (cdr matrix) (cdr supplies-matrix) (cdr demand-matrix) (cdr cell-matrix) accList)]

      ;if the initial value we assigned is empty replace 
      [(null? accList)
       (let ([newAccList (smallest_in_row (car matrix) (car supplies-matrix) (car demand-matrix) (car cell-matrix))])
            (smallest_in_matrix_aux (cdr matrix) (cdr supplies-matrix) (cdr demand-matrix) (cdr cell-matrix) newAccList))]
      
      ;if the current row has a smaller empty cell than the acc one, replace
      [(< (car (smallest_in_row (car matrix) (car supplies-matrix) (car demand-matrix) (car cell-matrix))) (car accList))
          (let ([newAccList (smallest_in_row (car matrix) (car supplies-matrix) (car demand-matrix) (car cell-matrix))])
            (smallest_in_matrix_aux (cdr matrix) (cdr supplies-matrix) (cdr demand-matrix) (cdr cell-matrix) newAccList))]

      ;if the current row has same empty cell as acc one, pick the one with the biggest demand or supply
      [(= (car (smallest_in_row (car matrix) (car supplies-matrix) (car demand-matrix) (car cell-matrix))) (car accList))
       (let* ([current-equal (smallest_in_row (car matrix) (car supplies-matrix) (car demand-matrix) (car cell-matrix))]
              [current-supp (cadr current-equal)]
              [current-dem (caddr current-equal)]
              [candidate-1 (min current-supp current-dem)]
              [candidate-2 (min (cadr accList) (caddr accList))])
         ;if new is winner replace
         (if (= (max candidate-1 candidate-2) candidate-1)
             (smallest_in_matrix_aux (cdr matrix) (cdr supplies-matrix) (cdr demand-matrix) (cdr cell-matrix) current-equal)
              ; else don't replace
             (smallest_in_matrix_aux (cdr matrix) (cdr supplies-matrix) (cdr demand-matrix) (cdr cell-matrix) accList)))]
      ;if the current row is not smaller we keep going
      [else (smallest_in_matrix_aux (cdr matrix) (cdr supplies-matrix) (cdr demand-matrix) (cdr cell-matrix) accList)])))


;c. HELPER PROCEDURE: Update cell row given index of element to update and the value
;Calling function
(define update_cell_row
  (lambda (row amount index_col)
    (update_cell_row_aux row amount index_col 1)))

;Recursive function
(define update_cell_row_aux
  (lambda (row amount index_col current_index)
    (cond
      ;End of list? return empty list
      [(null? row) '()]
      ;Found the index we want to replace, replace
      [(= index_col current_index)
       (cons amount (update_cell_row_aux (cdr row) amount index_col (+ 1 current_index)))]
      ;Did not find the index yet, keep going
      [else (cons (car row) (update_cell_row_aux (cdr row) amount index_col (+ 1 current_index)))])))


;Update cell matrix given index of element to update and the value
;Calling function
(define update_cell_matrix
  (lambda (cell_matrix amount index_row index_col)
    (update_cell_matrix_aux cell_matrix amount index_row index_col 1)))


;Recursive function
(define update_cell_matrix_aux
  (lambda (cell_matrix amount index_row index_col accRow)
    (cond
      ;base case
      [(null? cell_matrix) '()]
      ;if we found the row we want to change call update_row on it
      [(= index_row accRow)
       (let ([newRow (update_cell_row (car cell_matrix) amount index_col)])
         (cons newRow (cdr cell_matrix)))]
      ;if we did not find the row we want to change keep going
      [else (cons (car cell_matrix) (update_cell_matrix_aux (cdr cell_matrix) amount index_row index_col (+ 1 accRow)))])))


;d. HELPER PROCEDURE: Update supplies row given the row and the amount to deduct from every
;element in that row
(define update_supp_row
  (lambda (row amount)
    (if (null? row)
        '()
        (cons (- (car row) amount) (update_supp_row (cdr row) amount)))))

;Update supplies matrix given the amount and the index of the row to update
;Calling function
(define update_supp_matrix
  (lambda (matrix amount index_row)
    (update_supp_matrix_aux matrix amount index_row 1)))


;Recursive function
(define update_supp_matrix_aux
  (lambda (matrix amount index_row accRow)
    (cond
      ;base case
      [(null? matrix) '()]
      ;If we found the index of the row we want to change, call update_row on it
      [(= index_row accRow)
       (let ([newRow (update_supp_row (car matrix) amount)])
         (cons newRow (cdr matrix)))]
      ;If we did not find the index of the row we want to change, keep going
      [else (cons (car matrix) (update_supp_matrix_aux (cdr matrix) amount index_row (+ 1 accRow)))])))

;e. HELPER PROCEDURE: Update demand row given the column and the amount to deduct
;Calling function
(define update_dem_row
  (lambda (row amount index_col)
    (update_dem_row_aux row amount index_col 1)))

;Recursive function
(define update_dem_row_aux
  (lambda (row amount index_col accCol)
    (cond
      ;base case
      [(null? row) '()]
      ;if we found the column we are looking for change it
      [(= index_col accCol)
       (cons (- (car row) amount) (cdr row))]
      ;if we did not find the column we are looking for keep going
      [else (cons (car row) (update_dem_row_aux (cdr row) amount index_col (+ 1 accCol)))])))

;Update demand matrix given the index of the column and the amount to deduct 
(define update_dem_matrix
  (lambda (demand-matrix amount index_col)
    (if (null? demand-matrix)
        '()
        (cons (update_dem_row (car demand-matrix) amount index_col) (update_dem_matrix (cdr demand-matrix) amount index_col)))))


;This procedure returns true if it finds the position of the smallest empty cell given rows: cost-row, supply-row, demand-row, cell-row
(define found_smallest_in_row?
  (lambda (cost-row supply-row demand-row cell-row smallest-empty-cell-list)
    ;exrtact elements of the snallest-empty-cell: (smallestCost, itsSupply, itsDemand, itsCell, itsColumn)
    (let ([small-cost (car smallest-empty-cell-list)]
          [small-supp (cadr smallest-empty-cell-list)]
          [small-demand (caddr smallest-empty-cell-list)]
          [small-cell (cadddr smallest-empty-cell-list)]
          [col-index (car (cddddr smallest-empty-cell-list))])
      (cond
        ;base case: we reached end of row, the smallest cell is not here return false
        [(null? cost-row) #f]
        ;if we found the position we are looking for, return true
        [(and (= small-cost (car cost-row)) (= small-supp (car supply-row)) (= small-demand (car demand-row)) (= small-cell (car cell-row))) #t]
        ;if not, we keep looking
        [else (found_smallest_in_row? (cdr cost-row) (cdr supply-row) (cdr demand-row) (cdr cell-row) smallest-empty-cell-list)]))))
      


;This procedure finds the smallest empty cell in a matrix and transfers min(demand, supply) to it
;Calling function
(define transfer_min
   (lambda (cost-matrix supply-matrix demand-matrix cell-matrix ori-supply ori-demand ori-cell)
    ;find smallest empty cell in matrix
    (let ([small-empty-cell (smallest_in_matrix cost-matrix supply-matrix demand-matrix cell-matrix)])
          ;transfer to it min(demand,supply)
          (transfer_min_aux cost-matrix supply-matrix demand-matrix cell-matrix small-empty-cell 1 ori-supply ori-demand ori-cell))))

;Recursive function
(define transfer_min_aux
  (lambda (cost-matrix supply-matrix demand-matrix cell-matrix small-empty-cell index-row ori-supply ori-demand ori-cell)
    ;extract elements in small-empty-cell
    (let ([small-supp (cadr small-empty-cell)]
          [small-demand (caddr small-empty-cell)]
          [index-col (car (cddddr small-empty-cell))])
      (cond
        ;base case: matrix is empty we are done
        [(null? cost-matrix)]
       ;We found the positin of the row that contains the cell we need to update, update info in cell, supplies and demands matrices
        [(found_smallest_in_row? (car cost-matrix) (car supply-matrix) (car demand-matrix) (car cell-matrix) small-empty-cell)
         (let ([amount (min small-supp small-demand)])
           (update_matrices ori-cell ori-supply ori-demand amount index-row index-col))]
        ;If we did not find the smallest cell yet keep looking
        [else (transfer_min_aux (cdr cost-matrix) (cdr supply-matrix) (cdr demand-matrix) (cdr cell-matrix) small-empty-cell (+ 1 index-row) ori-supply ori-demand ori-cell)]))))
           
      
;This procedure updates the global variables 
(define update_matrices
  (lambda (cell-matrix supply-matrix demand-matrix amount index-row index-col)
    (list (update_cell_matrix cell-matrix amount index-row index-col) (update_supp_matrix supply-matrix amount index-row)(update_dem_matrix demand-matrix amount index-col))))


;This procedure returns true if the row it is given is full of 0's
(define zero_row?
  (lambda (row)
    (cond
      ;base case: if we reach end of row, it is full of 0's return true
      [(null? row) #t]
      ;if we find a number that is not zero return false
      [(not (= 0 (car row))) #f]
      ;we keep going otherwise
      [else (zero_row? (cdr row))])))


;This procedure returns true if the matrix it is given is full of 0's
(define zero_matrix?
  (lambda (matrix)
    (cond
      ;base case: if we reach end of matrix it is full of 0's return true
      [(null? matrix) #t]
      ;If we find a row that is not full of 0's return false
      [(not (zero_row? (car matrix))) #f]
      ;we keep going otherwise
      [else (zero_matrix? (cdr matrix))])))

;This procedure performs least cost algorithm
(define least_cost
  (lambda (cost-matrix supply-matrix demand-matrix cell-matrix)
    ;return cell matrix if we are done
      (if (and (zero_matrix? supply-matrix) (zero_matrix? demand-matrix))
          cell-matrix
          (let ([list-of-matrix (transfer_min cost-matrix supply-matrix demand-matrix cell-matrix supply-matrix demand-matrix cell-matrix)])
            (least_cost cost-matrix (cadr list-of-matrix) (caddr list-of-matrix) (car list-of-matrix))))))



                                         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CREATE MATRIX THAT WILL BE INPUTTED IN FILE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;This procedure when given a cell row and an index will output that row with index prefixed to it
(define append_index_in_row
  (lambda (row index)
    (cons index row)))

;This procedure when given a matrix will append the factory number to each row
(define append_index_in_matrix
  (lambda (matrix num-fac)
    (append_index_in_matrix_aux matrix num-fac 1)))

(define append_index_in_matrix_aux
  (lambda (matrix num-fac fac-index)
    (if (> fac-index num-fac)
        '()
        (cons (append_index_in_row (car matrix) fac-index) (append_index_in_matrix_aux (cdr matrix) num-fac (+ 1 fac-index))))))




;This procedure when given a cell row and a supply with append the supply at the end of that row
(define append_supp_in_row
  (lambda (row supply)
    (if (null? row)
        (cons supply '())
        (cons (car row) (append_supp_in_row (cdr row) supply)))))


;This procedure when given a matrix and supply list will append the supply at end of each row in the matrix
(define append_supp_in_matrix
  (lambda (matrix supply-list)
    (if (null? matrix)
        '()
        (cons (append_supp_in_row (car matrix) (car supply-list)) (append_supp_in_matrix (cdr matrix) (cdr supply-list))))))

;This procedure returns the last row from the read file
(define demand_row
  (lambda (matrix)
    (if (null? (cdr matrix))
        (car matrix)
        (demand_row (cdr matrix)))))

;This procedure returns the first row from the read file
(define first_row
  (lambda (matrix)
    (car matrix)))

;This procedure returns the second row from the read file
(define second_row
  (lambda (matrix)
    (cadr matrix)))

;This procedure returns the solution of least cost in appropriate format to write in file
(define least_cost_solution
  (lambda (cost-matrix supply-matrix demand-matrix cell-matrix list-from-file list-of-supplies num-fac)
    (let* ([solution (least_cost cost-matrix supply-matrix demand-matrix cell-matrix)]
          [first-row (first_row list-from-file)]
          [second-row (second_row list-from-file)]
          [matrix-with-i (append_index_in_matrix solution num-fac)]
          [final-matrix (append_supp_in_matrix matrix-with-i list-of-supplies)]
          [last-row (demand_row list-from-file)])
      (list first-row second-row final-matrix last-row))))


;(define solution (least_cost_solution))


             ;;;;;;;;;;;;;;;;;;;;;;;;;;;;WRITE SOLUTION IN FILE;;;;;;;;;;;;;;;;;;;;;;;
(define (writeTableau tb fileOut)
  (if (eqv? tb '())
     #t
      (begin (display-lines-to-file (car tb) fileOut #:separator #\space #:exists 'append)
             (display-to-file #\newline fileOut #:exists 'append)
             (writeTableau (cdr tb) fileOut))))

;(writeTableau solution file-write)

