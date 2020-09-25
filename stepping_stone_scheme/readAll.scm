#lang racket

(current-directory)
(define fp (build-path "C:" "Users" "Jasmine Z" "Desktop" "a0_CSI2520_scheme"))
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
    
(readTableau "prob1.txt")

(define tb (readTableau "prob1.txt"))

(define (writeTableau tb fileOut)
  (if (eqv? tb '())
      #t
      (begin (display-lines-to-file (car tb) fileOut #:separator #\space #:exists 'append)
             (display-to-file #\newline fileOut #:exists 'append)
             (writeTableau (cdr tb) fileOut))))
                             
; (display-lines-to-file (readTableau "3by3_inputdata.txt") "test.txt")

; (writeTableau tb "test.txt")