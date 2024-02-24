#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example2.scm
;;
;; This program shows the use of gdbs functions used to edit database contents.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example2.scm 
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
(define de "stock")

;; Prep.
(clear)

;; Remember what this program is about (optional).
(define q "This program shows the use of gdbs functions used to edit database contents.")

;; SHow database info:
(gdbs-display-description db "Database description;")
(gdbs-explain-folder db "/dat" "Available entities:")

;; Edit selected entity.
(set! de (symbol->string (grsp-ask "Entity to edit? ")))
(gdbs-de-edit #t db de)

;; Backup database.
(cond ((equal? (grsp-confirm-ask #t "Backup your database now? [#t/#f]") #t)
       (gdbs-db-dat2bak #t db)))
       
