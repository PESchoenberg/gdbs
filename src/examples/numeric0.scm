#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; numeric0.scm
;;
;; This program shows the use of gdbs functions.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile numeric0.scm 
;;
;; =============================================================================
;;
;; Copyright (C) 2023 - 2024 Pablo Edronkin (pablo.edronkin at yahoo.com)
;;
;;   This program is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU Lesser General Public License as published by
;;   the Free Software Foundation, either version 3 of the License, or
;;   (at your option) any later version.
;;
;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;   GNU Lesser General Public License for more details.
;;
;;   You should have received a copy of the GNU Lesser General Public License
;;   along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;
;; =============================================================================


;;;; General notes:
;;
;; - Read sources for limitations on function parameters.
;;
;; - See code of functions used and their respective source files for more
;;   credits and references.
;;
;; - Before using this program run create_numeric_db.scm in order to create
;;   the database that is used in this example.


;; Required modules.
(use-modules (gdbs gdbs0)
	     (gdbs gdbs1)
	     (grsp grsp0)
	     (grsp grsp1)
	     (grsp grsp2)
	     (grsp grsp3)
	     (grsp grsp4)
	     (grsp grsp5)
	     (grsp grsp6)
	     (grsp grsp7)
	     (grsp grsp8)
	     (grsp grsp9)
	     (grsp grsp10)
	     (grsp grsp11)
	     (grsp grsp12)
	     (grsp grsp13)
	     (grsp grsp14)
	     (grsp grsp15)
	     (grsp grsp16)
	     (grsp grsp17))


;;;; Vars.
(define db "../../dat/numeric_db")
(define e1 "random")
(define a1 0)
(define a2 0)
(define Lrandom '())
(define n1 0)
(define n2 0)
(define n3 0)
(define n4 0)


;; First we load the random entity directly into memory. Extraction
;; usually requires more time than processing. Therefore, extracting
;; entities just once, at the beginning, is usually more efficient
;; than exctracting the data each time an entity is queried.
(grsp-ldl "Extracting data..." 1 1)
(set! Lrandom (gdbs-ent2l db e1))


;; Extract matrix.
(set! a1 (gdbs-de-lmatrix Lrandom))

;; Process.
(grsp-ldl "Processing data..." 1 1)

;; Row loop. Substract the random numbers of rows 1 and 2, place
;; the result in col 3, square n3 and place the result in row 4.
(let loop ((i1 (grsp-lm a1)))
  (if (<= i1 (grsp-hm a1))

      (begin (set! n1 (array-ref a1 i1 1))
	     (set! n2 (array-ref a1 i1 2))
	     (set! n3 (- n1 n2))
	     (set! n4 (expt n3 2))
	     (array-set! a1 n3 i1 3)
	     (array-set! a1 n4 i1 4)
	     
	     (loop (+ i1 1)))))


;; View matrix.
(set! a1 (grsp-matrix-edit a1
			   (gdbs-de-lcolsln Lrandom)
			   (gdbs-de-lcolsld Lrandom)
			   (gdbs-de-lcolslp Lrandom)))


;; Save the in-memory matrix back to its entity.
(grsp-ldl "Commiting data..." 1 1)
(list-set! Lrandom 1 a1)
(gdbs-l2ent db e1 Lrandom 0)

;; Poste edition to check if everything went ok (this opens the entity, and
;; not the inmem matrix extracted from the entity.
(gdbs-de-edit #t db e1)

;; Finishing.
(grsp-ldl (gdbs-gconsts "Fin") 1 1)
