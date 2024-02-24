;; =========================================================================
;;
;; gdbs1.scm
;;
;; gdbs constants.
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
;; - See also the general notes of gdb0.scm

(define-module (gdbs gdbs1)
  #:use-module (gdbs gdbs0)
  #:use-module (gdbs gdbs2)  
  #:export (gdbs-gconsts  
            gdbs-gconsten))


;;;; gdbs-gconsts - String constants.
;;
;; Keywords:
;;
;; - constants
;;
;; Parameters:
;;
;; - p_s1: string, constant identifier.
;;
;; Notes:
;;
;; - Change the name of the inner function in order to change language.
;;
(define (gdbs-gconsts p_s1)
  (let ((res1 ""))

    ;; Change the function here to use different languages.
    (set! res1 (gdbs-gconsten p_s1))
    
    res1))
  
  
;;;; gdbs-gconsten - Constants, strings, for gdbs in English.
;;
;; Keywords:
;;
;; - constants.
;;
;; Parameters:
;;
;; - p_s1: string, constant identifier.
;;
(define (gdbs-gconsten p_s1)
  (let ((res1 ""))

    (cond ((equal? p_s1 "0e1n2d3m4d")
	   (set! res1 "0-Exit  1-Name  2-Description  3-Metadata  4-Defaults\n"))
	  ((equal? p_s1 "0e1e2d")
	   (set! res1 "0 - Exit  1 - Edit  2 - Delete"))
	  ((equal? p_s1 "0e1emr")
	   (set! res1 "0 - Exit  1 - Edit a matrix row"))
	  ((equal? p_s1 "0e1et2er")
	   (set! res1 "0 - Exit  1 - Edit table  2 - Edit rows"))	  
	  ((equal? p_s1 "Avpej")
	   (set! res1 "All volumes processed; entity joined."))
	  ((equal? p_s1 "Bakfol")
	   (set! res1 "Backup folder "))
	  ((equal? p_s1 "Cfed")
	   (set! res1 "Cast from external dataset. "))
	  ((equal? p_s1 "Cdc")
	   (set! res1 "Checking database configuration... "))
	  ((equal? p_s1 "Cec")
	   (set! res1 "Checking entity configuration... "))
	  ((equal? p_s1 "Ced")
	   (set! res1 "Checking entity data... "))	  
	  ((equal? p_s1 "Cf")
	   (set! res1 "Creating file... "))	  
	  ((equal? p_s1 "Cfgfol")
	   (set! res1 "Config folder "))	  
	  ((equal? p_s1 "Col")
	   (set! res1 "Col "))
	  ((equal? p_s1 "Cols")
	   (set! res1 "Cols "))
	  ((equal? p_s1 "Colsat")
	   (set! res1 "Col structure and type "))
	  ((equal? p_s1 "Con")
	   (set! res1 "Confirm (y/n) "))	  
	  ((equal? p_s1 "Db")
	   (set! res1 "Database "))	  
	  ((equal? p_s1 "Dbdesc")
	   (set! res1 "Database description "))
	  ((equal? p_s1 "Datfol")
	   (set! res1 "Database folder "))
	  ((equal? p_s1 "Datfol")
	   (set! res1 "Data folder "))
	  ((equal? p_s1 "Docfol")
	   (set! res1 "Documents folder "))	  
	  ((equal? p_s1 "Desc")	   
	   (set! res1 "Description "))
	  ((equal? p_s1 "Desc:")	   
	   (set! res1 "Description: "))
	  ((equal? p_s1 "Dde")	   
	   (set! res1 "Default description for entity "))	  
	  ((equal? p_s1 "Def:")	   
	   (set! res1 "Defaults:    "))	  
	  ((equal? p_s1 "Ecp")
	   (set! res1 "Edit column properties "))	  
	  ((equal? p_s1 "Ent")
	   (set! res1 "Entity "))
	  ((equal? p_s1 "Entc")
	   (set! res1 "Entity config "))
	  ((equal? p_s1 "Entc")
	   (set! res1 "Entity config "))
	  ((equal? p_s1 "Entd")
	   (set! res1 "Entity data "))
	  ((equal? p_s1 "Entf")
	   (set! res1 "Entity folder "))	  
	  ((equal? p_s1 "Entm")
	   (set! res1 "Entity matrix "))
	  ((equal? p_s1 "Ecnte")
	   (set! res1 "Enter col number to edit: "))
	  ((equal? p_s1 "Ernte")
	   (set! res1 "Enter row number to edit: "))	  
	  ((equal? p_s1 "Env")
	   (set! res1 "Enter new value: "))
	  ((equal? p_s1 "Fifo")
	   (set! res1 "File found "))
	  ((equal? p_s1 "Fin")
	   (set! res1 "Finished "))
	  ((equal? p_s1 "Len")
	   (set! res1 "Loading entities... "))	  
	  ((equal? p_s1 "Mat")
	   (set! res1 "Matrix "))		  
	  ((equal? p_s1 "Metadata:")
	   (set! res1 "Metadata:    "))	  
	  ((equal? p_s1 "Names:")
	   (set! res1 "Names:       "))	  
	  ((equal? p_s1 "Nodes")
	   (set! res1 "No description "))
	  ((equal? p_s1 "Nodesfd")
	   (set! res1 "No description for database "))
	  ((equal? p_s1 "Nodesfe")
	   (set! res1 "No description for entity "))
	  ((equal? p_s1 "Noinfo")
	   (set! res1 "No info available "))	  
	  ((equal? p_s1 "Picfol")
	   (set! res1 "Pictures folder "))
	  ((equal? p_s1 "Pb")
	   (set! res1 "Processing backup... "))
	  ((equal? p_s1 "Prfcfg")
	   (set! res1 "Preferences and configs for database "))		  
	  ((equal? p_s1 "Pv")
	   (set! res1 "Processing volume "))	  
	  ((equal? p_s1 "Row")
	   (set! res1 "Row "))	  
	  ((equal? p_s1 "Rows")
	   (set! res1 "Rows "))
	  ((equal? p_s1 "Srcfol")
	   (set! res1 "Source code folder "))
	  ((equal? p_s1 "Sen")
	   (set! res1 "Saving entities... "))	  
	  ((equal? p_s1 "Tmpfol")
	   (set! res1 "Temp folder "))
	  )
	  
    res1))
