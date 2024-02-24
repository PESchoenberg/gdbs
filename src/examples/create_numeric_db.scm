#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; create_numeric_db.scm
;;
;; This program shows the use of gdbs functions.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile create_numeric_db.scm 
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
;; See code of functions used and their respective source files for more
;; credits and references.


;; Required modules.
(use-modules (gdbs gdbs0)
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
(define tm 100)
(define tn 5)

;; Multipurpose description.
(define s1 "Examples of in-memory operations.")

;; Remember what this program is about (optional).
(define q s1)

;; Create database.
(gdbs-db-create #t db s1)

(grsp-ldl "Database created. Creating entities." 1 1)

;; Create matrix for entity "random".
(set! a1 (grsp-matrix-create 0 tm tn))
(set! a2 (grsp-matrix-create "#rprnd" tm 2))

;; Create primary key values.
(let loop ((i1 (grsp-lm a1)))
  (if (<= i1 (grsp-hm a1))

      (begin (array-set! a1 i1 i1 0)
	     
	     (loop (+ i1 1)))))

;; Merge matrices.
(set! a1 (grsp-matrix-subrep a1 a2 (grsp-lm a1) 1))


;; Create entity random.
(gdbs-de-create-em db
		  e1
		  "Random numbers."
		  (list "id" "Rnd 1" "Rnd 2" "Real sum" "Int")
		  (list "Primary key." "Random number 1." "Random number 2." "Real sum." "Rounded integer.")
		  (list "#key#num#ai" "#num" "#num" "#num" "#num")
		  (list 0 0 0 0 0)
		  a1)

(grsp-ldl "Entity random created." 1 1)

;; Backup-
(gdbs-db-dat2bak #t db)
(grsp-ldl "Backup of the original database structure done." 1 1)



(grsp-ldvl "Finished creating " db  1 1) 


