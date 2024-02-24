#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example1.scm
;;
;; This program shows the use of gdbs functions.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example1.scm 
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
(define db "../../dat/example_db")
(define e1 "stock")
(define e2 "sales")


;; Remember what this program is about (optional).
(define q "This program shows the use of gdbs functions.")

;; Create database.
(gdbs-db-create #t db "Example database.")

;; Create tables.
(gdbs-de-create-nm db
		  e1
		  #t
		  "Example_db, stock"
		  (list "item" "value" "availability")
		  (list "Name ott" "Value ott" "In stock?")
		  (list "#str" "#num" "#bol")
		  (list 1 "Nada" 0 #f))

(gdbs-de-create-nm db
		  e2
		  #t
		  "Example_db, sales"
		  (list "item" "value")
		  (list "Name ott" "Units sold")
		  (list "#str" "#num")
		  (list 1 0 0))

;; Backup-
(gdbs-db-dat2bak #t db)

;; Show database info.
 (gdbs-db-explain #t db)


