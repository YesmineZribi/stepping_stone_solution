#lang racket

(current-directory)
(define fp (build-path "C:" "teaching" "CSI2120" "assignW19" "assign0"))
(current-directory fp)
(current-directory)



; (define in (open-input-file "3by3_inputdata.txt"))
; (close-input-port in)
; (file->lines "3by3_inputdata.txt")


(define (readTableau fileIn)  
  (let ((sL (map (lambda s (string-split (car s))) (file->lines fileIn))))
    (map (lambda (L)
           (map (lambda (s)
                  (if (eqv? (string->number s) #f)
                      s
                      (string->number s))) L)) sL)))
    
(readTableau "3by3_inputdata.txt")

(define tb (readTableau "3by3_inputdata.txt"))

(define (writeTableau tb fileOut)
  (if (eqv? tb '())
      #t
      (begin (display-lines-to-file (car tb) fileOut #:separator #\space #:exists 'append)
             (display-to-file #\newline fileOut #:exists 'append)
             (writeTableau (cdr tb) fileOut))))
                             
; (display-lines-to-file (readTableau "3by3_inputdata.txt") "test.txt")

; (writeTableau tb "test.txt")