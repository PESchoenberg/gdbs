;; =========================================================================
;;
;; ideario_db_fl0.scm
;;
;; Expert system functions.
;;
;; =========================================================================
;;
;; Copyright (C) 2023 - 2024 Pablo Edronkin (pablo.edronkin at yahoo.com)
;;
;;   This program is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU Lesser General Public License as
;;   published by the Free Software Foundation, either version 3 of the
;;   License, or (at your option) any later version.
;;
;;   This program is distributed in the hope that it will be useful, but
;;   WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;;   Lesser General Public License for more details.
;;
;;   You should have received a copy of the GNU Lesser General Public
;;   License along with this program. If not, see
;;   <https://www.gnu.org/licenses/>.
;;
;; =========================================================================


;;;; General notes:
;;
;; - Read sources for limitations on function parameters.
;; - Read at least the general notes of all scm files in this library before
;;   use.
;;
;; - Compilation:
;;
;;   - (use-modules (ideario_db ideario_db_fl0))


(define-module (gdbs ideario_db_fl0)
  #:use-module (gdbs gdbs0)
  #:use-module (gdbs gdbs1)
  #:use-module (gdbs gdbs2)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)
  #:use-module (grsp grsp5)
  #:use-module (grsp grsp6)
  #:use-module (grsp grsp7)
  #:use-module (grsp grsp8)
  #:use-module (grsp grsp9)
  #:use-module (grsp grsp10)
  #:use-module (grsp grsp11)
  #:use-module (grsp grsp12)
  #:use-module (grsp grsp13)
  #:use-module (grsp grsp14)
  #:use-module (grsp grsp15)
  #:use-module (grsp grsp16)
  #:use-module (grsp grsp17)      
  #:export (kb-f0
	    kb-l1
	    kb-f1
	    kb-f2
	    kb-f3
	    kb-f4))


;;;; kb-f0 - Knowledge base function 0. This function should be passed as
;; a parameter for gdbs-kb-eval-fl.
;;
;; Keywords:
;;
;; - decisions, interrogation
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_l1: list of entities.
;; - p_n1: number of inference cycles.
;;
;; Notes:
;;
;; - In list p_l1 we will put all the entities of database ideario_db in
;;   the order established in function kb-l1.
;; - This is loosely based on Prolog knowledge bases.
;;
(define (kb-f0 p_d1 p_l1 p_n1)
  (let ((res1 '())
	(ideas 0)
	(reqs 0)
	(ideario_kb 0)
	(preferences 0))

    ;; --------------------------------------------------------------------
    ;; Opening section.
    ;; --------------------------------------------------------------------
    ;; Here open all entities passed in p_l1.
    (set! ideas (gdbs-ent2my p_d1 (list-ref p_l1 0)))
    (set! reqs (gdbs-ent2my p_d1 (list-ref p_l1 1)))
    (set! ideario_kb (gdbs-ent2my p_d1 (list-ref p_l1 2)))
    (set! preferences (gdbs-ent2my p_d1 (list-ref p_l1 3)))    

    ;; --------------------------------------------------------------------
    ;; Procedural section (nference engine).
    ;; --------------------------------------------------------------------
    ;; Place here the functions that you will use.
    (let loop ((i1 1))
      (if (<= i1 p_n1)

	  (begin (set! ideas (kb-f1 ideas))
		 (set! reqs (kb-f2 reqs))
		 (set! ideario_kb (kb-f3 ideario_kb))
		 (set! preferences (kb-f4 preferences))
		 
		 (loop (+ i1 1)))))   

    ;; --------------------------------------------------------------------
    ;; Commitment section.
    ;; --------------------------------------------------------------------
    ;; Here we save back the results.
    (gdbs-my2ent p_d1 (list-ref p_l1 0) ideas)
    (gdbs-my2ent p_d1 (list-ref p_l1 1) reqs) 
    (gdbs-my2ent p_d1 (list-ref p_l1 2) ideario_kb)
    (gdbs-my2ent p_d1 (list-ref p_l1 3) preferences)   
    
    res1))


;;;; kb-l1: Creates the list required for argument p_l1 of function kb-f0.
;;
;; Keywords:
;;
;; - entities, database
;;
;; Output:
;;
;; - List of strings.
;;
(define (kb-l1)
  (let ((res1 '()))

    (set! res1 (list "ideas" "reqs" "ideario_kb" "preferences"))
    
    res1))


;;;; kb-f1 - Knowledge base function 1.
;;
;; Keywords:
;;
;; - decisions, interrogation
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
(define (kb-f1 p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-cpy p_a1))

    (grsp-ln p_a1)
    
    res1))


;;;; gdbs-kb-f2 - Knowledge base function 2.
;;
;; Keywords:
;;
;; - decisions, interrogation
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
(define (kb-f2 p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-cpy p_a1))
    
    (grsp-ln p_a1)
    
    res1))


;;;; kb-f3 - Knowledge base function 3.
;;
;; Keywords:
;;
;; - decisions, interrogation
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
(define (kb-f3 p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-cpy p_a1))

    (grsp-ln p_a1)
    
    res1))


;;;; kb-f4 - Knowledge base function 4.
;;
;; Keywords:
;;
;; - decisions, interrogation
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
(define (kb-f4 p_a1)
  (let ((res1 0))

    (set! res1 (grsp-matrix-cpy p_a1))

    (grsp-ln p_a1)
    
    res1))
