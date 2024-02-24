;; =========================================================================
;;
;; gdbs0.scm
;;
;; Guile database system.
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
;; - See the documentation of the grsp library for details on grsp
;;   functions used here: https://peschoenberg.github.io/grsp/ with
;;   emphasis on file grsp3.scm.
;; - This library provides database-specific functions which supplement
;;   those
;;   found on the grsp library, which concern matrix manipulation.
;; - Functions in this library can - and should - be supplemented with those
;;   found in the grsp library, and especially with those of file grsp3.scm,
;;   since they might alow for faster access to the dayabase. Gdb
;;   functions in general work with the intermediate database layer,
;;   making it easier and safer to perfirme some database operations, but
;;   since entities are stored in files while matrices are stored in
;;   memory, there might be significant advantages to open the entities
;;   using functions lie gdbs-ent2my, work with grsp functions on the
;;   exposed matrices, and then save them to file using gdbs-my2ent.
;; - Be aware, however, that if you modify the structure of an entity in
;;   any way, as adding or removing columns, changing properties or column
;;   names, you may need to use gdbs-de-create-em instead of gdbs-my2ent.
;;   Usually, adding or editing column metadata implies modifying the
;;   structure of an entity, while adding, editing or deleting rows does
;;   not.
;;
;; - Compilation:
;;
;;   - (use-modules (gdbs gdb0)(gdbs gdb1)(gdbs gdb2)(gdbs ideario_db_tb0)(gdbs ideario_db_fl0))
;;   . Preferably complile the grsp library first and separatedly before
;;     compiling gdb.
;;   - Some functions require you to pass as arguments the database and
;;     entity name. These require more processing time and are not intended
;;     thus to be used for in-memory processing, except for some that
;;     specifically load or save entity data. On the other hand, those
;;     functions that do not require you to pass the databas and entity
;;     names can be used generally for in-memory processing.
;;   - In gdb, in-memory processing is defined by the direct use of matrices
;;     extracted from entities, manipulated at will and then saved back
;;     as entity elements.
;;
;; Sources:
;;
;; - [1] https://www.gnu.org/software/guile/manual/html_node/Dia-Hook.html


(define-module (gdbs gdbs0)  
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
  #:use-module (gdbs gdbs1)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 eval-string)
  #:export (gdbs-db-create
	    gdbs-delete
	    gdbs-db-delete
	    gdbs-db-dat2bak
	    gdbs-de-create-nm
	    gdbs-de-create-em
	    gdbs-de-delete
	    gdbs-description-create
	    gdbs-db-description-create
	    gdbs-de-description-col-create
	    gdbs-de-header-col-create
	    gdbs-ent2mc
	    gdbs-mc2ent
	    gdbs-de-explain
	    gdbs-db-explain
	    gdbs-explain-folder
	    gdbs-display-description
	    gdbs-display-txt
	    gdbs-de-colsm
	    gdbs-de-edit
	    gdbs-de-path
	    gdbs-de-colsln
	    gdbs-de-path-cfg
	    gdbs-de-path-dat
	    gdbs-de-colsld
	    gdbs-ent2ms
	    gdbs-ent2my
	    gdbs-ms2ent
	    gdbs-my2ent
	    gdbs-de-path-csv
	    gdbs-de-colslp
	    gdbs-de-colsle
	    gdbs-de-colslm
	    gdbs-de-colm
	    gdbs-de-coln
	    gdbs-de-colpn
	    gdbs-de-colqp
	    gdbs-csv2ent
	    gdbs-ent2csv
	    gdbs-de-coli
	    gdbs-de-col-modify
	    gdbs-de-col-edit
	    gdbs-de-col-add
	    gdbs-de-col-delete
	    gdbs-de-keygen
	    gdbs-de-has-property
	    gdbs-de-has-keynumai
	    gdbs-de-row-add
	    gdbs-de-row-updateln
	    gdbs-cols2coln
	    gdbs-de-row-update
	    gdbs-de-row-insert
	    gdbs-des2s
	    gdbs-de-esi
	    gdbs-de-tmtn
	    gdbs-de-str-cpy
	    gdbs-de-row-cpy
	    gdbs-de-vol-cpy
	    gdbs-de-vol-split
	    gdbs-de-colsll
	    gdbs-de-vol-join
	    gdbs-de-vol-cfg-create
	    gdbs-de-vol-cfg-get
	    gdbs-de-vol-cfg-subadd
	    gdbs-de-vol-cfg-subdel
	    gdbs-db-fix
	    gdbs-de-fix
	    gdbs-de-vol-cfg-edit
	    gdbs-de-row-zero
	    gdbs-vols2l
	    gdbs-de-vol-find-last
	    gdbs-de-has-vol
	    gdbs-de-vol-find-first
	    gdbs-de-edit-row
	    gdbs-de-edit-rows
	    gdbs-ldlc
	    gdbs-de-edit-selectm
	    gdbs-de-displaytms
	    gdbs-de-edittms
	    gdbs-ent2l
	    gdbs-l2ent
	    gdbs-de-ldescription
	    gdbs-de-lcolsln
	    gdbs-de-lcolsle
	    gdbs-de-lcolslp
	    gdbs-de-lcolsld
	    gdbs-de-lmatrix
	    gdbs-de-row-insertln
	    gdbs-de-create-tbiv
	    gdbs-db-create-preferences
	    gdbs-db-eval-preference))


;;;; gdbs-db-create - Creates a database.
;;
;; Keywords:
;;    
;; - database, creation
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t for verbose mode.
;;   - #f otherwise.
;;
;; - p_d1: database name.
;; - p_s1: string, database description.
;;
;; Notes:
;;
;; - This function creates a database, but not the database entities within
;;   it. They should be created using gdbs-de-create-nm after gdbs-db-create
;;   has been used.
;;
(define (gdbs-db-create p_b1 p_d1 p_s1)
  (let ((res1 0)
	(s1 "")
	(s2 "")
	(s3 "")
	(s4 "mkdir "))

    ;; Create folders.
    (set! s1 (strings-append (list s4 p_d1) 0))
    (displayc p_b1 s1)
    (system s1)
    (set! s2 (strings-append (list s1 "/dat") 0))
    (displayc p_b1 s2)    
    (system s2)
    (set! s2 (strings-append (list s1 "/doc") 0))
    (displayc p_b1 s2)    
    (system s2)
    (set! s2 (strings-append (list s1 "/bak") 0))
    (displayc p_b1 s2)
    (system s2)
    (set! s2 (strings-append (list s1 "/pic") 0))
    (displayc p_b1 s2)
    (system s2)
    (set! s2 (strings-append (list s1 "/cfg") 0))
    (displayc p_b1 s2)    
    (system s2)
    (set! s2 (strings-append (list s1 "/tmp") 0))
    (displayc p_b1 s2)    
    (system s2)    
    (set! s2 (strings-append (list s1 "/src") 0))
    (displayc p_b1 s2)    
    (system s2) 
    
    ;; Create description file.
    (set! s3 (gdbs-db-description-create p_s1 p_d1))
    (displayc p_b1 s3)
    (system s3)
    
    res1))


;;;; gdbs-delete - Deletes folders recursively.
;;
;; Keywords:
;;    
;; - database
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t for verbose mode.
;;   - #f otherwise.
;;
;; - p_d1: folder name.
;;
(define (gdbs-delete p_b1 p_f1)
  (let ((res1 0)
	(s1 "")
	(b1 #t))

    ;; Ask for confirmation.
    (cond ((equal? p_b1 #t)
	   (set! b1 (grsp-confirm p_b1))))

    (cond ((equal? b1 #t)
	   (set! s1 (strings-append (list "rm -r " p_f1) 0))
	   (displayc p_b1 s1)
	   (system s1)))
    
    res1))


;;;; gdbs-db-delete - Deletes a database.
;;
;; Keywords:
;;    
;; - database, deletion, elimination
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t for verbose mode.
;;   - #f otherwise.
;;
;; - p_d1: database name.
;;
(define (gdbs-db-delete p_b1 p_d1)
  (let ((res1 0))

    (gdbs-delete p_b1 p_d1)
    
    res1))


;;;; gdbs-db-dat2bak - Creates a copy of a database contained in folder
;; /dat in folder /bak.
;;
;; Keywords:
;;    
;; - database, backing, backups, copying
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t for verbose mode.
;;   - #f otherwise.
;;
;; - p_d1: database name.
;;
(define (gdbs-db-dat2bak p_b1 p_d1)
  (let ((res1 0)
	(s1 "")
	(s2 ""))

    (set! s2 (string-replace-substring p_d1 "/dat/" "/bak/"))
    (set! s1 (strings-append (list "cp -R" p_d1 s2) 1))
    (displayc p_b1 s1)
    (system s1)
    
    res1))


;;;; gdbs-de-create-nm - Creates a database entity with a new matrix.
;;
;; Keywords:
;;    
;; - database, initial, creation, entity, tables, entities
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_e1: entity name.
;; - p_b2: boolean.
;;
;;   - #t: to create a primary column.
;;   - #f: if you do not want to create a primary key,
;;
;; - p_s1: string, entity description.
;; - p_l1: string list, names of columns.
;; - p_l2: string list, description of columns.
;; - p_l3: string list, column types.
;; - p_l4: multi type list, column defaults.
;;
;; Notes:
;;
;; - The database should exist prior to attempting to create an entity. See
;;   gdbs-db-create.
;; - The primary key column will be called id.
;; - The function creates a one row matrix, which can be expanded later.
;; - If p_b1 is set to #t, the first column of the matrix created will
;;   contain the primay key values, starting at zero in order to keep
;;   compatibility with grsp matrix conventions.
;; - This function does allow for the creation of primary-key columns,
;;   since it creates a new entity from scratch, unlike gdbs-de-create-em
;;   which creates entities based on already existing matrices and has to
;;   respect the matrix structure when it creates and configures the
;;   respective entities.
;; - See also gdbs-de-create-em.
;;
(define (gdbs-de-create-nm p_d1 p_e1 p_b2 p_s1 p_l1 p_l2 p_l3 p_l4)
  (let ((res1 0)
	(l1 '("id"))
	(l2 '("Id"))
	(l3 '("#key#num#ai#0"))	
	(l4 '())
	(e1 "")
	(j1 0)
	(a1 0)
	(s1 "")
	(s2 "")
	(s3 ""))

    ;; Build list of column names.
    (cond ((equal? p_b2 #t)
	   (set! l1 (append l1 p_l1))
	   (set! l2 (append l2 p_l2))
	   (set! l3 (append l3 p_l3))
	   (set! l4 (append l4 p_l4)))	   
	  ((equal? p_b2 #f)
	   (set! l1 p_l1)
	   (set! l2 p_l2)
	   (set! l3 p_l3)
	   (set! l4 p_l4)))

    ;; Name of the matrix csv file.
    (set! e1 (strings-append (list p_e1 ".csv") 0))
    
    ;; Create matrix.
    (set! j1 (length l2))
    (set! a1 (grsp-matrix-create 0 1 j1))
    (set! s2 (strings-append (list p_d1 "/dat/" p_e1 "/dat") 0))    
    (set! s3 (strings-append (list "mkdir " p_d1 "/dat/" p_e1) 0))   
    (system s3)
    (set! s3 (strings-append (list "mkdir " p_d1 "/dat/" p_e1 "/cfg") 0))
    (system s3)
    (set! s3 (strings-append (list p_d1 "/dat/" p_e1) 0)) 
    (grsp-mc2dbc-csv s2 a1 e1)
    
    ;; Create entity description.
    (set! s1 (gdbs-description-create p_s1 s3))
    (system s1)

    ;; Create matrix and cols description.
    (set! s3 (strings-append (list p_d1 "/dat/" p_e1 "/cfg") 0))
    (gdbs-de-description-col-create s3 l1 l2 l3 l4)

    ;; Create vol configuration table.
    (gdbs-de-vol-cfg-create p_d1 p_e1)
    
    res1))


;;;; gdbs-de-create-em - Creates a database entity with an existing matrix.
;;
;; Keywords:
;;    
;; - database, initial, creation, entity, tables, entities
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_e1: entity name.
;; - p_s1: string, entity description.
;; - p_l1: string list, names of columns.
;; - p_l2: string list, description of columns.
;; - p_l3: string list, column types.
;; - p_l4: multi type list, column defaults.
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - The database should exist prior to attempting to create an entity. See
;;   gdbs-db-create.
;; - The primary key column will be called id.
;; - This function does not create a primary key column for the input
;;   matrix p_a1. Key columns should have been created on the input
;;   matrix in advance.
;; - See also gdbs-de-create-nm.
;;
(define (gdbs-de-create-em p_d1 p_e1 p_s1 p_l1 p_l2 p_l3 p_l4 p_a1)
  (let ((res1 0))

    ;; Firste create an entity with the same properties but zero data
    ;; in it.
    (gdbs-de-create-nm p_d1 p_e1 #f p_s1 p_l1 p_l2 p_l3 p_l4)
    
    ;; Replace the entity matrix with p_a1 the structure and properties
    ;; should be the same.
    (gdbs-my2ent p_d1 p_e1 p_a1)

    res1))


;;;; gdbs-de-delete - Deletes a database entity.
;;
;; Keywords:
;;    
;; - database, deletion, elimination, erasing, erase
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t for verbose mode.
;;   - #f otherwise.
;;
;; - p_d1: database name.
;; - p_e1: entity name.
;;
(define (gdbs-de-delete p_b1 p_d1 p_e1)
  (let ((res1 0)
	(e1 ""))

    ;; Since deleting a database element is in reality deleting
    ;; recursively a folder, we construct the full path to the element
    ;; within the database.
    (set! e1 (strings-append (list p_d1 "/dat/" p_e1) 0))

    ;; Perform actual deletion.
    (gdbs-delete p_b1 e1)
    
    res1))    
    
    
;;;; gdbs-description-create - Creates a description.txt file for folder
;; p_f1 with contents p_s1-
;;
;; Keywords:
;;
;; - description, folder, files, metadata
;;
;; Parameters:
;;
;; - p_s1: string, file contents.
;; - p_f1: folder path and name.
;;
(define (gdbs-description-create p_s1 p_f1)
  (let ((res1 0))

    (set! res1 (strings-append (list "echo \""
				     p_s1
				     "\" > "
				     p_f1
				     "/cfg/description.txt")
			       0))
    
    res1))


;;;; gdbs-db-description-create - Creates a description.txt file for
;; database p_d1 with contents p_s1.
;;
;; Keywords:
;;
;; - description, database, files, metadata
;;
;; Parameters:
;;
;; - p_s1: string, file contents.
;; - p_d1: database.
;;
(define (gdbs-db-description-create p_s1 p_d1)
  (let ((res1 ""))

    (set! res1 (gdbs-description-create p_s1 p_d1))
    
    res1))
	    

;;;; gdbs-db-description-col-create - Creates a description matrix with the
;; list of column names and column descriptions for entity p_e1 of database
;; p_d1.
;;
;; Keywords:
;;
;; - description, metadata, table
;;
;; Parameters:
;;
;; - p_e1: database entity.
;; - p_l1: list of column headers.
;; - p_l2: list of column header descriptions.
;; - p_l3: list of column properties
;; - p_l4: list of column default values
;;
;; Notes:
;;
;; - See gdbs-de-header-col-create.
;;
;; Output:
;;
;; - Matrix saved as csv file.
;;
(define (gdbs-de-description-col-create p_e1 p_l1 p_l2 p_l3 p_l4)
  (let ((res1 0)
	(s1 "")
	(a1 0)
	(a2 0)
	(a3 0)
	(a4 0)
	(a5 0)
	(a6 0)
	(a7 0)
	(a8 0))

    ;; Transform lists into col vectors and then into matrices with a
    ;; primary key in col 1.
    (set! a1 (grsp-l2m p_l1))
    (set! a2 (grsp-l2m p_l2))
    (set! a5 (grsp-l2m p_l3))
    (set! a6 (grsp-l2m p_l4))    
    (set! a7 (grsp-my2ms a6))
    
    ;; Add two rows to a1 and transpose.
    (set! a1 (grsp-matrix-row-append a1 a2))
    (set! a1 (grsp-matrix-row-append a1 a5))    
    (set! a1 (grsp-matrix-row-append a1 a7))
    (set! a3 (grsp-matrix-transpose a1))
    
    ;; Cast to numeric database matrix.
    (set! a4 (grsp-ms2dbc (grsp-my2ms a3)))
		 
    ;; Save.
    (set! s1 p_e1)
    (grsp-mc2dbc-csv s1 a4 "cols.csv")
    
    res1))


;;;; gdbs-de-header-col-create - Creates a list of default column names
;; and a list of default column descriptions for matrix p_a1. This
;; function is useful to create default descriptive elements for a
;; matrix, which could then be edited in order to build a database
;; element. The function just creates a list with three lists of the
;; following form:
;;
;; - Elem 0: list of column names of the form "Col n" where n is the column
;;   number.
;; - Elem 1: list of column descriptions of the form "Description Col n"
;;   with the same considerations for n as in the case of element 0.
;; - Elem 2: centered column names.
;;
;; In order to provide full and accurate descriptions for each matrix
;; column, it is just necessary to edit each corresponding pair of
;; strings, which is generally easier than builidng the descriptions
;; specifically and from zero.
;;
;; Keywords:
;;
;; - header, column, description, headers, naming
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - See gdbs-de-description-col-create.
;;
;; Output:
;;
;; - List of lists containing strings:
;;
;;   - Elem 0: list of default column names.
;;   - Elem 1: list of default column descriptions.
;;   - Elem 2: centered column names.
;;
(define (gdbs-de-header-col-create p_a1)
  (let ((res1 '())
	(l1 '())
	(l2 '())
	(l3 '())	
	(n1 0)
	(s1 "")
	(s2 "")
	(s3 ""))

    ;; Set lists length to number of columns.
    (set! n1 (grsp-tn p_a1))
    (set! l1 (make-list n1 ""))
    (set! l2 (make-list n1 ""))
    (set! l3 (make-list n1 ""))    
    
    ;; Col loop.
    (let loop ((j1 (grsp-ln p_a1)))
      (if (<= j1 (grsp-hn p_a1))
	  
	  (begin (set! s1 (strings-append (list (gdbs-gconsts "Col")
						(grsp-n2s j1))
					  1))
		 (set! s2 (strings-append (list (gdbs-gconsts "Desc")
						s1)
					  1))
		 (set! s3 (strings-append (list " " s1) 1))
		 (list-set! l1 j1 s1)
		 (list-set! l2 j1 s2)
		 (list-set! l3 j1 s3)
			    
		 (loop (+ j1 1)))))    

    ;; Compose results
    (set! res1 (list l1 l2 l3))
    
    res1))


;;;; gdbs-ent2mc - Gets a numeric matrix from a database entity.
;;
;; Keywords:
;;
;; - matrices, open, get, read, entity, entities
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_e1: entity name.
;;
;; Notes:
;;
;; - See gdbs-mc2ent, grsp-dbc2ms, grsp-ms2dbc.
;;
;; Output:
;;
;; - Matrix.
;;
(define (gdbs-ent2mc p_d1 p_e1)
  (let ((res1 0)
	(s1 "")
	(s2 ""))

    (set! s1 (strings-append (list p_d1 "/dat/" p_e1 "/dat") 0))
    (set! s2 (strings-append (list p_e1 ".csv") 0))	
    (set! res1 (grsp-dbc2mc-csv s1 s2))
    
    res1))


;;;; gdbs-mc2ent - Saves a numeric matrix to a database entity.
;;
;; Keywords:
;;
;; - matrices, open, get, read, entity, entities
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_a1: matrix, numeric.
;; - p_e1: entity name.
;;
;; Notes:
;;
;; - See gdbs-ent2mc, grsp-dbc2ms, grsp-ms2dbc.
;;
;; Output:
;;
;; - Matrix.
;;
(define (gdbs-mc2ent p_d1 p_a1 p_e1)
  (let ((res1 0)
	(s1 "")
	(s2 ""))

    (set! s1 (strings-append (list p_d1 "/dat/" p_e1 "/dat") 0))
    (set! s2 (strings-append (list p_e1 ".csv") 0))	
    (grsp-mc2dbc-csv s1 p_a1 s2)
    
    res1))


;;;; gdbs-de-explain - Shows database entity information.
;;
;; Keywords:
;;
;; - matrices, open, get, read, entity, entities, info, metadata
;;
;; Parameters:
;;
;; - p_b1:
;;
;;   - #t to show the matrix itself.
;;   - #f otherwise.
;;
;; - p_b2:
;;
;;   - #t to show entity folders.
;;   - #f otherwise.
;;
;; - p_d1: database name.
;; - p_e1: entity name.
;;
(define (gdbs-de-explain p_b1 p_b2 p_d1 p_e1)
  (let ((res1 0)
	(l1 '())
	(a1 0)
	(a2 0)
	(a3 0)
	(a4 0)
	(a5 0)
	(a6 0)
	(a7 0)
	(s1 "")
	(s2 "")
	(s3 "")
	(s4 "")
	(s5 "")
	(s6 "")
	(s7 "")
	(s8 "")
	(s10 ""))

    ;; Get matrix structure.
    (set! s10 (gdbs-de-path p_d1 p_e1))
    (set! a1 (gdbs-ent2mc p_d1 p_e1))
    (set! s1 (strings-append (list "Db: " p_d1) 0))
    (set! s2 (strings-append (list (gdbs-gconsts "Ent") p_e1) 0))
    (set! s3 (strings-append (list (gdbs-gconsts "Rows")
				   (grsp-n2s (grsp-tm a1)))
			     0))
    (set! s4 (strings-append (list (gdbs-gconsts "Cols")
				   (grsp-n2s (grsp-tn a1)))
			     0))
    
    ;; Get col names.
    (set! s5 (strings-append (list s10 "/cfg") 0))
    (set! a4 (grsp-dbc2mc-csv s5 "cols.csv"))
    (set! a2 (grsp-matrix-create-dim " " a4))
    (set! a3 (grsp-dbc2ms a4))
    
    ;; Display.
    (gdbs-display-description s10 (gdbs-gconsts "Desc"))
    (grsp-ld s1)
    (grsp-ld s2)
    (grsp-ld s3)
    (grsp-ld s4)
    (grsp-ldl (gdbs-gconsts "Colsat") 1 1)
    (grsp-matrix-display a3)
    (grsp-ld "\n")

    ;; Show matrix.
    (cond ((equal? p_b1 #t)
	   (grsp-ldl (gdbs-gconsts "Entm") 1 1)
	   (set! a5 (grsp-matrix-subcpy a3
					(grsp-lm a3)
					(grsp-hm a3)
					(grsp-ln a3)
					(grsp-ln a3)))
	   (set! a5 (grsp-matrix-transpose a5))
	   (set! a7 (grsp-mn2ms a1))
	   (set! a6 (grsp-matrix-row-append a5 a7))
	   (grsp-matrix-display a6)
	   (grsp-ld "\n")))

    ;; Show folders.
    (cond ((equal? p_b2 #t)	   
	   (gdbs-explain-folder s10 "" (gdbs-gconsts "Entf"))
	   (gdbs-explain-folder s10 "/cfg" (gdbs-gconsts "Entc"))
	   (gdbs-explain-folder s10 "/dat" (gdbs-gconsts "Entd"))))
	       
    res1))


;;;; gdbs-db-explain - Shows database information.
;;
;; Keywords:
;;
;; - matrices, open, get, read, entity, entities, databases, info, data
;;
;; Parameters:
;;
;; - p_b1:
;;
;;   - #t to show data entity information.
;;   - #f otherwise.
;;
;; - p_d1: database name.
;;
(define (gdbs-db-explain p_b1 p_d1)
  (let ((res1 0))

    (gdbs-display-description p_d1 (gdbs-gconsts "Dbdesc"))
    (gdbs-explain-folder p_d1 "/dat" (gdbs-gconsts "Datfol"))
    (gdbs-explain-folder p_d1 "/bak" (gdbs-gconsts "Bakfol"))
    (gdbs-explain-folder p_d1 "/cfg" (gdbs-gconsts "Cfgfol"))    
    (gdbs-explain-folder p_d1 "/dat" (gdbs-gconsts "Datfol"))
    (gdbs-explain-folder p_d1 "/doc" (gdbs-gconsts "Docfol"))
    (gdbs-explain-folder p_d1 "/pic" (gdbs-gconsts "Picfol"))    
    (gdbs-explain-folder p_d1 "/src" (gdbs-gconsts "Srcfol"))
    (gdbs-explain-folder p_d1 "/tmp" (gdbs-gconsts "Tmpfol"))    
    
    res1))


;;;; gdbs-explain-folder - Shows database or entity folder information.
;;
;; Keywords:
;;
;; - matrices, open, get, read, entity, entities, databases, elements,
;;   entity, entities
;;
;; Parameters:
;;
;; - p_d1: string, database name.
;; - p_f1: string, folder name.
;; - p_s1: string, title.
;;
(define (gdbs-explain-folder p_d1 p_f1 p_s1)
  (let ((res1 0)
	(s1 ""))

    (grsp-ldl p_s1 0 0)
    (set! s1 (strings-append (list "ls " p_d1 p_f1) 0))
    (grsp-ldl s1 0 0)
    (system s1)
    (grsp-ldl " " 0 0)
    
    res1))


;;;; gdbs-display-description - Displays a text description file from a
;; config folder.
;;
;; Keywords:
;;
;; - reading, text, txt, descriptor, configuration
;;
;; Parameters:
;;
;; - p_d1: string, database name.
;; - p_s2: string, title.
;;
(define (gdbs-display-description p_d1 p_s2)
  (let ((res1 0)
	(s1 ""))

    (set! s1 (strings-append (list p_d1 "/cfg/") 0))
    (gdbs-display-txt s1 p_s2 "description.txt")
    
    res1))


;;;; gdbs-display-txt - Reads and displays a text file.
;;
;; Keywords:
;;
;; - reading, text, txt, document, descriptor, files
;;
;; Parameters:
;;
;; - p_d1: string, database name and path to file.
;; - p_s2: string, title.
;; - p_s3: string, file name.
;;
(define (gdbs-display-txt p_d1 p_s2 p_s3)
  (let ((res1 0)
	(s1 ""))

    (set! s1 (strings-append (list "cat " p_d1 p_s3) 0))
    (grsp-ldl p_s2 0 1)
    (system s1)
    (grsp-ldl "" 0 1)
    
    res1))


;;;; dgb-de-colsm - Returns a string matrix containing the column names, 
;; their descriptions and metadata of a database entity.
;;;
;; Keywords:
;;
;; - reading, text, txt, document, descriptor, strings, descripting
;;
;; Parameters:
;;
;; - p_d1: string, database name.
;; - p_e1: entity name.
;;
;; Output:
;;
;; - Matrix of strings.
;;
;;   - Col 0: Name.
;;   - Col 1: Description.
;;   - Col 2: Metadata.
;;
(define (gdbs-de-colsm p_d1 p_e1)
  (let ((res1 0)
	(s1 "")
	(a1 0)
	(a2 0))

    (set! s1 (gdbs-de-path-cfg p_d1 p_e1))    
    (set! a1 (grsp-dbc2mc-csv s1 "cols.csv"))
    (set! a2 (grsp-matrix-create-dim " " a1))
    (set! res1 (grsp-dbc2ms a1))
    
    res1))


;;;; grsp-de-edit - Edit a database entity interactively.
;;
;; Keywords:
;;
;; - edit, add, delete, modify, default, interaction
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: save to entity on exit.
;;   - #f: otherwise; still allows to output the modified entity matrix
;;     as the return value of the function.
;;
;; - p_d1: database.
;; - p_e1: database element.
;;
;; Notes:
;;
;; - See gdbs-de-vol-edit to see how to deal with volumes.
;;
(define (gdbs-de-edit p_b1 p_d1 p_e1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(b1 #f)
	(e1 "")
	(l1 '())
	(p1 "")
	(s1 ""))

    ;;(system "tput cup 0")
    
    ;; Get metadata.
    ;; - Elem 0: string, entity description.
    ;; - Elem 1: list, col names.
    ;; - Elem 2: list, col descriptions.
    ;; - Elem 3: list, col properties:
    ;; - Elem 4: list, col default values.
    (set! l1 (gdbs-de-colsll p_d1 p_e1))

    (set! e1 p_e1)
    
    ;; Cast as ent to my.
    (set! a2 (gdbs-ent2my p_d1 e1))

    ;; Edit
    (set! res1 (grsp-matrix-edit a2
				 (list-ref l1 1)
				 (list-ref l1 4)
				 (list-ref l1 3)))

    ;; Save on exit.
    (cond ((equal? p_b1 #t)
	   (gdbs-my2ent p_d1 e1 res1)))
    
    res1))


;;;; gdbs-de-path - Path to entity.
;;
;; Keywords:
;;
;; - path, location, qualified
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-path p_d1 p_e1)
  (let ((res1 0))

    (set! res1 (strings-append (list p_d1 "/dat/" p_e1) 0))

    res1))


;;;; gdbs-de-colsln - Returns a list with the column names of a matrix.
;;
;; Keywords:
;;
;; - path, location, names, columnar, cols
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-colsln p_d1 p_e1)
  (let ((res1 '()))

    (set! res1 (gdbs-de-colslm p_d1 p_e1 0))
    
    res1))


;;;; gdbs-de-path-cfg - Returns the path to the subfolder cfg of element
;; p_e1 of database p_d1 as a string.
;;
;; Keywords:
;;
;; - path, location, subfolders, config
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-path-cfg p_d1 p_e1)
  (let ((res1 ""))

    (set! res1 (strings-append (list (gdbs-de-path p_d1 p_e1) "/cfg") 0))
    
    res1))


;;;; gdbs-de-path-dat - Returns the path to the subfolder dat of element
;; p_e1 of database p_d1 as a string.
;;
;; Keywords:
;;
;; - path, location
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-path-dat p_d1 p_e1)
  (let ((res1 ""))

    (set! res1 (strings-append (list (gdbs-de-path p_d1 p_e1) "/dat") 0))
    
    res1))
    

;;;; gdbs-de-colsld - Returns a list with the default values of a matrix.
;;
;; Keywords:
;;
;; - path, location, defaults, configured, preset
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-colsld p_d1 p_e1)
  (let ((res1 '()))

    (set! res1 (gdbs-de-colslm p_d1 p_e1 3))
    
    res1))  


;;;; gdbs-ent2ms - Gets a matrix of strings from a database entity.
;;
;; Keywords:
;;
;; - matrices, open, get, read, entity, entities
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_e1: entity name.
;;
;; Notes:
;;
;; - See gdbs-ent2mc, gdbs-mc2ent, grsp-dbc2ms, grsp-ms2dbc.
;;
;; Output:
;;
;; - Matrix.
;;
(define (gdbs-ent2ms p_d1 p_e1)
  (let ((res1 0)
	(a1 0)
	(s1 "")
	(s2 "")
	(s3 ""))
    
    (set! s3 (gdbs-de-path-csv p_d1 p_e1))
    (set! a1 (grsp-dbc2mc-csv p_d1 s3))
    (set! res1 (grsp-dbc2ms a1))
    
    res1))


;;;; gdbs-ent2my - Gets a matrix of multiple data types from a database
;; entity.
;;
;; Keywords:
;;
;; - matrices, open, get, read, entity, entities, types
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_e1: entity name.
;;
;; Notes:
;;
;; - this function should be used to access the data matrix of any data
;;   entity.
;;
;; Output:
;;
;; - Matrix.
;;
(define (gdbs-ent2my p_d1 p_e1)
  (let ((res1 0)
	(a1 0))

    (set! a1 (gdbs-ent2ms p_d1 p_e1))
    (set! res1 (grsp-ms2my a1))
    
    res1))


;;;; gdbs-ms2ent - Saves string matrix p_a1 as entity p_e1 of database
;; p_d1.
;;
;; Keywords:
;;
;; - cast, save, store, storage, strings
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_e1: entity name.
;; - p_a1: matrix of strings.
;;
(define (gdbs-ms2ent p_d1 p_e1 p_a1)
  (let ((res1 0)
	(a1 0)
	(s1 "")
	(e1 ""))

    (set! a1 (grsp-ms2dbc p_a1))
    (set! s1 (strings-append (list p_d1 "/dat/" p_e1 "/dat/") 0))
    (set! e1 (strings-append (list p_e1 ".csv") 0))
    (grsp-mc2dbc-csv s1 a1 e1)
    
    res1))


;;;; gdbs-my2ent - Saves matrix p_a1 as entity p_e1 of database p_d1.
;;
;; Keywords:
;;
;; - cast, save, store, storage
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_e1: entity name.
;; - p_a1: matrix.
;;
;; Notes:
;;
;; - This function should be used to save a data matrix as a data entity.
;;
(define (gdbs-my2ent p_d1 p_e1 p_a1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(s1 "")
	(s2 ""))

    (set! a1 (grsp-my2ms p_a1))
    (set! res1 (gdbs-ms2ent p_d1 p_e1 a1))
    
    res1))


;;;; gdbs-de-path-csv - Full path to .csv file of entity p_e1 of database
;; p_d1.
;;
;; Keywords:
;;
;; - cast, save, paths, comma, separated
;;
;; Parameters:
;;
;; - p_d1: database name.
;; - p_e1: entity name.
;;
(define (gdbs-de-path-csv p_d1 p_e1)
  (let ((res1 "")
	(s1 "")
	(s2 ""))

    (set! s1 (strings-append (list p_d1 "/dat/" p_e1 "/dat/") 0))
    (set! s2 (strings-append (list p_e1 ".csv") 0))
    (set! res1 (strings-append (list s1 s2) 0))
    
    res1))


;;;; gdbs-de-colslp - Returns a list with the column properties
;; (metadata) of a matrix.
;;
;; Keywords:
;;
;; - path, location, names, columnar, cols
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-colslp p_d1 p_e1)
  (let ((res1 '()))

    (set! res1 (gdbs-de-colslm p_d1 p_e1 2))
    
    res1))


;;;; gdbs-de-colsle - Returns a list with the column descriptions of a
;; matrix.
;;
;; Keywords:
;;
;; - path, location, names, culumnar, cols
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-colsle p_d1 p_e1)
  (let ((res1 '()))

    (set! res1 (gdbs-de-colslm p_d1 p_e1 1))
    
    res1))


;;;; gdbs-de-colslm - Returns a list with the column metadata of a matrix
;; given the column number.
;;
;; Keywords:
;;
;; - path, location, names, culumnar, cols
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_j1: column number.
;;
(define (gdbs-de-colslm p_d1 p_e1 p_j1)
  (let ((res1 '())
	(a1 0)
	(a2 0))

    (set! a1 (gdbs-de-colsm p_d1 p_e1))
    (set! a2 (grsp-matrix-subcpy a1 (grsp-lm a1) (grsp-hm a1) p_j1 p_j1))
    (set! a2 (grsp-matrix-transpose a2))
    (set! res1 (grsp-m2l a2))
    
    res1))


;;;; gdbs-de-colm - Returns a list with the metadata of a specified column.
;;
;; Keywords:
;;
;; - path, location, names, columnar, cols
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_j1: column number.
;;
(define (gdbs-de-colm p_d1 p_e1 p_j1)
  (let ((res1 '())
	(a1 0)
	(a2 0))

    (set! a1 (gdbs-de-colsm p_d1 p_e1))
    (set! a2 (grsp-matrix-subcpy a1 p_j1 p_j1 (grsp-ln a1) (grsp-hn a1)))
    (set! res1 (grsp-m2l a2))
    
    res1))


;;;; gdbs-de-coln - Returns a two element list with the number of a column
;; given its name.
;;
;; Keywords:
;;
;; - path, location, names, culumnar, cols
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_s1: column name.
;;
;; Notes:
;;
;; - See grsp-de-coli.
;;
;; Output:
;;
;; - List:
;;
;;   - Elem 0:
;;
;;     - t# if column named p_s1 exists.
;;     - #f otherwise.
;;
;;  - Elem 1: number of column named p_s1. Defaults to zero if the column
;;    in question is not found. Thus, the column exists if and only if
;;    elem 1 returns #t.
;;
(define (gdbs-de-coln p_d1 p_e1 p_s1)
  (let ((res1 '())
	(b1 #f)
	(n1 0)
	(a1 0)
	(a2 0)
	(s1 "")
	(s2 ""))

    (set! a1 (gdbs-de-colsm p_d1 p_e1))

    ;; This is necessary because strings in matrices must have quotation
    ;; marks to be identified as strings.
    (set! s1 p_s1)
    
    ;; Row loop.
    (let loop ((i1 (grsp-lm a1)))
      (if (<= i1 (grsp-hm a1))
	  
	  (begin (set! s2 (array-ref a1 i1 0))

		 (cond ((equal? s2 s1)
			(set! b1 #t)
			(set! n1 i1)))
		 
		 (loop (+ i1 1)))))

    ;; Compose results.
    (set! res1 (list b1 n1))
    
    res1))


;;;; gdbs-de-colpn - Returns a list of metadata of column named p_s1.
;;
;; Keywords:
;;
;; - named, cols, columns, properties, metadata
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_s1: column name.
;;
;; Output:
;;
;; - List:
;;
;;   - Elem 0:
;;
;;     - t# if column named p_s1 exists.
;;     - #f otherwise.
;;
;;  - Elem 1: metadata of column p_s1. Defaults to zero if the column in
;;    question is not found. Thus, the column exists if and only if elem 0
;;    returns #t.
;;
(define (gdbs-de-colpn p_d1 p_e1 p_s1)
  (let ((res1 '())
	(l1 '())
	(l2 '())
	(b1 #f)
	(n1 0))

    (set! l1 (gdbs-de-coln p_d1 p_e1 p_s1))
    (set! b1 (list-ref l1 0))

    (cond ((equal? b1 #f)
	   (set! res1 l1))
	  ((equal? b1 #t)
	   (set! n1 (list-ref l1 1))
	   (set! l2 (gdbs-de-colm p_d1 p_e1 n1))
	   (set! res1 (list b1 l2))))
    
    res1))


;;;;; gdbs-de-colqp - Queries for the existence of a certain property in
;; the metadata of an entity. Returns a matrix with the metadata of all
;; columns of an entity that include property p_s1.
;;
;; Keywords:
;;
;; - named, cols, columns, properties, metadata
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_s1: property.
;;
;; Output:
;;
;; - Matrix.
;;
(define (gdbs-de-colqp p_d1 p_e1 p_s1)
  (let ((res1 0)
	(a1 0))

    (set! a1 (gdbs-de-colsm p_d1 p_e1))
    (set! res1 (grsp-matrix-row-select "#ct" a1 2 p_s1))
    
    res1))


;;;; gdbs-csv2ent - Given a csv, plain text file p_f1, this functions
;; casts its contents as a database entity.
;;
;; Keywords:
;;
;; - datasets, csv, comma, sparated, values, import
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity name (it will be created).
;; - p_f1: csv file.
;; - p_b1: boolean.
;;
;;   - #t to read the first row of p_f1 as header and use its contents to
;;     create a description of column names.
;;   - #f otherwise, and use the first row of p_f1 as regular data.
;;
;; - p_n1: number of rows from p_f1 to be used.
;;
;;   - 0: use all rows.
;;   - > 0 : otherwise.
;;
(define (gdbs-csv2ent p_d1 p_e1 p_f1 p_b1 p_n1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(c1 #\newline)
	(c2 #\,)
	(ln1 0)
	(tn1 0)
	(s1 "")
	(s2 "")
	(l1 '())
	(l2 '())
	(l3 '())
	(l4 '())
	(l5 '())
	(l6 '()))

    ;; Read p_f1 as a string.
    (set! s1 (read-file-as-string p_f1))

    ;; Split by newline characters and create a list. Each element of
    ;; this list contains a full row of the csv file.
    (set! l1 (string-split s1 c1))
    
    ;; Determine the size of the list and get the first line.
    (cond ((= p_n1 0)
	   (set! tn1 (length l1)))
	  (else (set! tn1 p_n1)))
	  
    (set! s2 (list-ref l1 0))
    (set! l2 (string-split s2 c2))

    ;; If the first line (line 0) of the file is used as header, we will
    ;; start reading data for conversion from element 1 of the list.
    ;; Element 0 will be used to create the column names.
    (cond ((equal? p_b1 #t)
	   (set! l3 (list-copy l2))
	   (set! ln1 1))
	  (else (set! l3 (make-list (length l2) "Col"))))

    ;; Prepare description lists.
    (set! l4 (make-list (length l2) (gdbs-gconsts "Nodes")))
    (set! l5 (make-list (length l2) "#str"))
    (set! l6 (make-list (length l2) ""))    

    ;; List loop.
    (let loop ((j1 ln1))
      (if (< j1 tn1)

	  (begin (set! s2 (list-ref l1 j1))
		 (set! l2 (string-split s2 c2))
		 (set! a2 (grsp-l2m l2))

		 (cond ((= j1 ln1)
			(set! a1 (grsp-matrix-cpy a2)))
		       ((> j1 ln1)
			(set! a1 (grsp-matrix-subadd a1 a2))))
		 
		 (loop (+ j1 1)))))

    ;; Create entity.
    (gdbs-de-create-em p_d1 p_e1 (gdbs-gconsts "Cfed") l3 l4 l5 l6 a1)
    
    res1))


;;;; gdbs-csv2ent - For entity p_e1 of database p_d1, this function
;; produces a csv, plain text file p_f1.
;;
;; Keywords:
;;
;; - datasets, csv, comma, sparated, values, export, dump
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity name.
;;
;; Notes:
;;
;; - The resulting p_f1 will be stored in the same /dat folder as the
;;   entity csv file, under the name "export.csv"; it is easy to see
;;   that export.csv corresponds to the entity in which it is stored.
;;
(define (gdbs-ent2csv p_d1 p_e1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(s1 (make-string 0))
	(s2 "")
	(l1 '()))

    ;; Get column names.
    (set! l1 (gdbs-de-colsln p_d1 p_e1))
    (set! a2 (grsp-l2m l1))
    
    ;; Cast the entity's matrix as a string matrix.
    (set! a1 (gdbs-ent2ms p_d1 p_e1))

    ;; Path to export file.
    (set! s2 (strings-append (list p_d1
				   "/dat/"
				   p_e1
				   "/dat/"
				   "export.csv")
			     0))

    ;; Row loop. Add column names to s1.
    (let loop ((j2 (grsp-ln a2)))
      (if (<= j2 (grsp-hn a2))

	  (begin (cond ((= j2 (grsp-ln a2))
			(set! s1 (array-ref a2 0 j2)))
		       ((> j2 (grsp-ln a2))
			(set! s1 (strings-append (list s1
						       ","
						       (array-ref a2
								  0
								  j2))
						 0))))
		 
		 (loop (+ j2 1)))))
    
    ;; Add a newline character converted to string at the end of s1 as
    ;; it stands.
    (set! s1 (strings-append (list s1 (string #\newline)) 0))
    
    ;; Write each element of a1 to a continuous string, adding newline
    ;; characters.

    ;; Row loop.
    (let loop ((i1 (grsp-lm a1)))
      (if (<= i1 (grsp-hm a1))

	  ;; Col loop.
	  (begin (let loop ((j1 (grsp-ln a1)))
		   (if (<= j1 (grsp-hn a1))

		       (begin (cond ((= j1 (grsp-ln a1))
				     (set! s1 (strings-append (list s1 (array-ref a1 i1 j1)) 0)))
				    ((> j1 (grsp-ln a1))
				     (set! s1 (strings-append (list s1 "," (array-ref a1 i1 j1)) 0))))
			      
			      (loop (+ j1 1)))))

		 ;; Add a newline character converted to string at the
		 ;; end of each row of elements converted to a string
		 (set! s1 (strings-append (list s1 (string #\newline)) 0))
		 
		 (loop (+ i1 1)))))
    
    ;; Write the string to export.csv file.
    (grsp-save-to-file s1 s2 "w")
    
    res1))


;;;; gdbs-de-coli - Returns a two element list with the name of a column
;; given its number.
;;
;; Keywords:
;;
;; - path, location, names, culumnar, cols
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_j1: column number.
;;
;; Notes:
;;
;; - See grsp-de-coln.
;;
;; Output:
;;
;; - List:
;;
;;   - Elem 0:
;;
;;     - t# if column number p_j1 exists.
;;     - #f otherwise.
;;
;;  - Elem 1: name of column number p_j1. Defaults to blank if the
;;    column in question is not found. Thus, the column exists if and
;;    only if elem 1 returns #t.
;;
(define (gdbs-de-coli p_d1 p_e1 p_j1)
  (let ((res1 '())
	(b1 #f)
	(l1 '())
	(s1 ""))

    ;; Get the list of column names.
    (set! l1 (gdbs-de-colsln p_d1 p_e1))

    ;; If column number exists, get the name and update boolean.
    (cond ((<= p_j1 (- (length l1) 1))
	   (set! b1 #t)
	   (set! s1 (list-ref l1 p_j1))))
    
    ;; Compose results.
    (set! res1 (list b1 s1))
    
    res1))


;;;; gdbs-de-col-modify - Edit and change properties of column number
;; p_j1 as p_s1.
;;
;; Keywords:
;;
;; - path, location, names, culumnar, cols, renaming, rename, edition,
;;   column
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_j1: column number to modify.
;; - p_s1: column property to change.
;;
;;   - "#name": change the column name.
;;   - "#desc": change the description.
;;   - "#meta": metadata.
;;   - "#defa": default value.
;;
;; - p_s2: new column value.
;;
;; Notes:
;;
;; - See gdbs-de-col-edit.
;;
(define (gdbs-de-col-modify p_d1 p_e1 p_j1 p_s1 p_s2)
  (let ((res1 0)
	(s3 "")
	(l1 '())
	(l2 '())
	(l3 '())
	(l4 '()))

    ;; Get the list of column names.
    (set! l1 (gdbs-de-colsln p_d1 p_e1))

    ;; If column number exists, make changes in the corresponding list l1.
    (cond ((<= p_j1 (- (length l1) 1))

	   ;; Retrieve additional column info.
	   (set! l2 (gdbs-de-colsle p_d1 p_e1))
	   (set! l3 (gdbs-de-colslp p_d1 p_e1))
	   (set! l4 (gdbs-de-colsld p_d1 p_e1))

	   ;; Cahnge element in corresponding list
	   (cond ((equal? p_s1 "#name")
		  (list-set! l1 p_j1 p_s2))
		 ((equal? p_s1 "#desc")
		  (list-set! l2 p_j1 p_s2))
		 ((equal? p_s1 "#meta")
		  (list-set! l3 p_j1 p_s2))
		 ((equal? p_s1 "#defa")
		  (list-set! l4 p_j1 p_s2)))
	   
	   ;; Create matrix and cols description.
	   (set! s3 (strings-append (list p_d1 "/dat/" p_e1 "/cfg") 0))

	   ;; Save changes.
	   (gdbs-de-description-col-create s3 l1 l2 l3 l4)))

    res1))


;;;; gdbs-de-col-edit - Edit properties of columns interactively.
;;
;; Keywords:
;;
;; - path, location, names, columnar, cols, renaming, rename, edition,
;;   column
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
;; Notes:
;;
;; - See gdbs-de-col-modify.
;;
(define (gdbs-de-col-edit p_d1 p_e1)
  (let ((res1 0)
	(a1 0)
	(s1 "")
	(s2 "")
	(j1 0)
	(i1 1)
	(m1 0)
	(m2 0)
	(m3 0)
	(m4 0)
	(m5 0)
	(l1 '())
	(l2 '())
	(l3 '())
	(l4 '())
	(l5 '())
	(l6 '()))

    (while (> i1 0)

	   (clear)
	   
	   ;; Get properties of all columns. We need to express them
	   ;; explicitly as lists for prcessing later.
	   (set! l1 (gdbs-de-colsln p_d1 p_e1))
	   (set! l2 (gdbs-de-colsle p_d1 p_e1))
	   (set! l3 (gdbs-de-colslp p_d1 p_e1))
	   (set! l4 (gdbs-de-colsld p_d1 p_e1))

	   ;; Build presentation matrix.
	   (set! a1 (grsp-matrix-create "" 5 (+ 1 (length l1))))

	   ;; Create lateral labels.
	   (array-set! a1 "//////////// " 0 0)
	   (array-set! a1 (gdbs-gconsts "Names:") 1 0)
	   (array-set! a1 (gdbs-gconsts "Desc:") 2 0)
	   (array-set! a1 (gdbs-gconsts "Metadata:") 3 0)
	   (array-set! a1 (gdbs-gconsts "Def:") 4 0)

	   ;; Cast lists as matrices.
	   (set! m1 (grsp-l2m l1))
	   (set! m2 (grsp-l2m l2))
	   (set! m3 (grsp-l2m l3))
	   (set! m4 (grsp-l2m l4))

	   ;; Create headers.
	   (set! l5 (gdbs-de-header-col-create m1))	   
	   (set! m5 (grsp-l2m (list-ref l5 0)))

	   ;; Update display matrix.
	   (set! a1 (grsp-matrix-subrep a1 m5 0 1))
	   (set! a1 (grsp-matrix-subrep a1 m1 1 1))
	   (set! a1 (grsp-matrix-subrep a1 m2 2 1))
	   (set! a1 (grsp-matrix-subrep a1 m3 3 1))
	   (set! a1 (grsp-matrix-subrep a1 m4 4 1))

	   ;; Display.
	   (system "tput cup 0")
	   (grsp-ldvl (gdbs-gconsts "Db") p_d1 0 0)
	   (grsp-ldvl (gdbs-gconsts "Ent") p_e1 0 0)	   
	   (grsp-ldl (gdbs-gconsts "Ecp") 0 1)
	   (grsp-matrix-display a1)

	   ;; Menu.
	   (set! i1 (grsp-askn (gdbs-gconsts "0e1n2d3m4d")))
	   
	   ;; If column number exists, make changes in the corresponding
	   ;; list l1.
	   (cond ((> i1 0)

	          (set! j1 (grsp-askn (gdbs-gconsts "Ecnte")))
		  (set! s2 (symbol->string (grsp-ask (gdbs-gconsts "Env"))))
		  
		  (cond ((= i1 1)
			 (set! s1 "#name"))
			((= i1 2)
			 (set! s1 "#desc"))
			((= i1 3)
			 (set! s1 "#meta"))
			((= i1 4)
			 (set! s1 "#defa")))	
		  		  
		  (cond ((<= j1 (- (length l1) 1))		  
			 (gdbs-de-col-modify p_d1 p_e1 j1 s1 s2))))))
    
    res1))


;;;; gdbs-de-col-add - Adds a column to entity p_e1.
;;
;; Keywords:
;;
;; - column, addinng
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_s1: sitrng, col name.
;; - p_s2: string, col description.
;; - p_s3: string, col metadata.
;; - p_s4: string, col defaulta value.
;;
;; Output:
;;
;; - A saved element with a matrix that includes one more column.
;;
(define (gdbs-de-col-add p_d1 p_e1 p_s1 p_s2 p_s3 p_s4)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(a3 0)
	(s3 "")
	(l1 '())
	(l2 '())
	(l3 '())
	(l4 '()))	

    ;; Get properties of all existing columns. We need to express them
    ;; explicitly as lists for processing.
    (set! l1 (gdbs-de-colsln p_d1 p_e1))
    (set! l2 (gdbs-de-colsle p_d1 p_e1))
    (set! l3 (gdbs-de-colslp p_d1 p_e1))
    (set! l4 (gdbs-de-colsld p_d1 p_e1))

    ;; Get description file as a string.
    (set! s3 (gdbs-des2s p_d1 p_e1))
    
    ;; Get matrix.
    (set! a1 (gdbs-ent2my p_d1 p_e1))
    
    ;; Add new values to the lists corresponding to the added column.
    (set! l1 (append l1 (list p_s1)))
    (set! l2 (append l2 (list p_s2)))
    (set! l3 (append l3 (list p_s3)))
    (set! l4 (append l4 (list p_s4)))    
    
    ;; Expand matrix and set default value in all elements of the new
    ;; column.
    (set! a2 (grsp-matrix-create p_s4 (grsp-tm a1) 1))
    (set! a3 (grsp-matrix-col-append a1 a2))
    
    ;; Create "new" entity with updated values. It is necessary to keep
    ;; all metadata updated after modifying the columns.
    (gdbs-de-create-em p_d1 p_e1 s3 l1 l2 l3 l4 a3)
    
  res1))


;;;; - gdbs-de-col-delete - Deletes column p_j1 from entity p_e1 of
;; database p_d1.
;;
;; Keywords:
;;
;; - column, addinng
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_j1: col number.
;;
(define (gdbs-de-col-delete p_d1 p_e1 p_j1)
  (let ((res1 0)
	(a1 0)
	(s3 "")
	(l1 '())
	(l2 '())	
	(l3 '())
	(l4 '()))

    ;; Get properties of all existing columns. We need to express them
    ;; explicitly as lists for later processing.
    (set! l1 (gdbs-de-colsln p_d1 p_e1))
    (set! l2 (gdbs-de-colsle p_d1 p_e1))
    (set! l3 (gdbs-de-colslp p_d1 p_e1))
    (set! l4 (gdbs-de-colsld p_d1 p_e1))

    ;; Get description file as a string.
    (set! s3 (gdbs-des2s p_d1 p_e1))
    
    ;; Get matrix.
    (set! a1 (gdbs-ent2my p_d1 p_e1))
    
    ;; Delete list elements corresponding to the deleted column.
    (set! l1 (grsp-lal-deletee l1 p_j1))
    (set! l2 (grsp-lal-deletee l2 p_j1))
    (set! l3 (grsp-lal-deletee l3 p_j1))
    (set! l4 (grsp-lal-deletee l4 p_j1))    
    
    ;; Delete col.
    (set! a1 (grsp-matrix-subdel "#Delc" a1 p_j1))

    ;; Create "new" entity with updated values. Necessary to keep metadata
    ;; updated after modifying columns.
    (gdbs-de-create-em p_d1 p_e1 s3 l1 l2 l3 l4 a1)
	  
    res1))


;;;; gdbs-de-keygen - Creates an unique numeric key value for column p_j1
;; of entity p_e1.
;;
;; Keywords:
;;
;; - column, adding
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_j1: col number.
;; - p_n1; increment value.
;;
;; Notes:
;;
;; - Should only be used on columns defined as primary key.
;;
;; Output:
;;
;; - Numeric value.
;;
(define (gdbs-de-keygen p_d1 p_e1 p_j1 p_n1)
  (let ((res1 0)
	(a1 0)
	(a2 0))

    (set! a1 (gdbs-ent2my p_d1 p_e1))
    (set! res1 (grsp-matrix-keygen a1 p_j1 p_n1))
    
    res1))


;;;; - gdbs-de-has-property - Finds if entity p_e1 has property p_s1 in
;; any of its columns.
;;
;; Keywords:
;;
;; - properties, property
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_s1: string, property.
;;
;; Output:
;;
;; - Returns a list with the column numbers in which
;;   said property was found, or an empty list if the property
;;   requested was not dound.
;;
(define (gdbs-de-has-property p_d1 p_e1 p_s1)
  (let ((res1 '())
	(l3 '())
	(s1 "")
	(tn 0)
	(b1 #t)
	(a1 0))

    ;; Get matrix.
    (set! a1 (gdbs-ent2my p_d1 p_e1))
    
    ;; Get metadata of all existing columns.
    (set! l3 (gdbs-de-colslp p_d1 p_e1))
    (set! tn (length l3))
    ;; ***a
    ;; List loop.
    (let loop ((j1 0))
      (if (< j1 tn)

	  (begin (set! s1 (list-ref l3 j1))
		 (set! b1 (string-contains s1 p_s1))
		 
		 (cond ((equal? (equal? b1 #f) #f)
			(set! b1 #t)
			(set! res1 (append res1 (list j1)))))
		 
		 (loop (+ j1 1)))))
    
    res1))


;;;; gdbs-de-has-keynumai - Finds out if entity p_e1 has an auto
;; incrementable, numeric primary key column.
;;
;; Keywords:
;;
;; - properties, property, krimary, keys
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
;; Output:
;;
;; - List.
;; 
;;   - Empty list if there are no primary key, numeric, autoincrement
;;     columns.
;;   - Otherwise, a list with each element representing each primary key
;;     column found if it has primary keys.
;;
(define (gdbs-de-has-keynumai p_d1 p_e1)
  (let ((res1 '())
	(l3 '())
	(tn 0))
    
    ;; Get metadata of all existing columns.
    (set! l3 (gdbs-de-colslp p_d1 p_e1))
    (set! tn (length l3))
    
    ;; List loop.
    (let loop ((j1 0))
      (if (< j1 tn)

	  (begin (cond ((equal? (equal? (string-contains (list-ref l3 j1) "#key") #f) #f)
			
			(cond ((equal? (equal? (string-contains (list-ref l3 j1) "#num") #f) #f)

			       (cond ((equal? (equal? (string-contains (list-ref l3 j1) "#ai") #f) #f)

				      (set! res1 (append res1 (list j1)))))))))
		 
		 (loop (+ j1 1)))))
        
    res1))


;;;; gdbs-de-row-add - Adds a new row at the bottom of the matrix of entity
;; p_e1 with default values.
;;
;; Keywords:
;;
;; - rows, adding
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-row-add p_d1 p_e1)
  (let ((res1 0)
	(a1 0)
	(n1 0)
	(l4 '())
	(l6 '()))

    ;; Get properties of all existing columns.
    (set! l4 (gdbs-de-colsld p_d1 p_e1))

    ;; Get matrix.
    (set! a1 (gdbs-ent2my p_d1 p_e1))

    ;; Add a new row.
    (set! a1 (grsp-matrix-subexp a1 1 0))

    ;; Determine if entity has primary key columns.
    (set! l6 (gdbs-de-has-keynumai p_d1 p_e1))

    (cond ((equal? (null? l6) #f)
	   (set! n1 (list-ref l6 0))))
    
    ;; Replace values of the new row with those in l4.
    ;; ***a
    (set! a1 (grsp-matrix-editu a1 (grsp-hm a1) l4 n1))

    ;; Determine if entity has primary key columns.
    ;;(set! l5 (gdbs-de-has-keynumai p_d1 p_e1))
    
    ;; If it has primary key columns, update last row.
    (cond ((equal? (null? l6) #f)

	   ;; List loop.
	   (let loop ((j1 0))
	     (if (< j1 (length l6))

		 (begin (array-set! a1
				    (gdbs-de-keygen p_d1
						   p_e1
						   (list-ref l6 j1)
						   1)
				    (grsp-hm a1)
				    (list-ref l6 j1))
			
			(loop (+ j1 1)))))))

    ;; save matrix.
    (gdbs-my2ent p_d1 p_e1 a1) 
    
    res1))


;;;; gdbs-de-row-updateln - Updates the values of row p_m1 of entity p_e1
;; of database p_d1 based on the contents of list p_l1.
;;
;; Keywords:
;;
;; - column, updating
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_m1: row number.
;; - p_l1: list.
;;
;;   - Contains lists of two elements as elements of p_l1.
;;
;;     - Elem 0: numeric, col number.
;;     - Elem 1: string, new value for element at [p_m1, Elem 0].
;;
;; Notes:
;;
;; - Be aware that all pairs passed on list p_l1 should refer to the
;;   same row p_m1.
;; - This function does not add a new row; it should be used on
;;   preexisting rows.
;; - This function does not require that p_l1 has as many elements as
;;   there are cols in the matrix of p_e1. You can pass only the elements
;;   that you need, identifying them by their col number in the pairs
;;   that constitute the elements of p_l1.
;; - See gdbs-cols2coln, gdbs-de-row-insert, gdbs-de-row-update.
;;
(define (gdbs-de-row-updateln p_d1 p_e1 p_m1 p_l1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(n1 0)
	(s1 "")
	(s2 "")
	(s3 "")
	(l1 '())
	(l2 '())	
	(l3 '())
	(l4 '())
	(l5 '())
	(l6 '()))

    ;; Get properties of all existing columns.
    (set! l1 (gdbs-de-colsln p_d1 p_e1))
    (set! l2 (gdbs-de-colsle p_d1 p_e1))
    (set! l3 (gdbs-de-colslp p_d1 p_e1))
    (set! l4 (gdbs-de-colsld p_d1 p_e1))
    
    ;; Get description file as a string.
    (set! s3 (gdbs-des2s p_d1 p_e1))
    
    ;; Extract matrix.
    (set! a2 (gdbs-ent2my p_d1 p_e1))

    ;; Determine if entity has primary key columns.
    (set! l6 (gdbs-de-has-keynumai p_d1 p_e1))

    (cond ((equal? (null? l6) #f)
	   (set! n1 (list-ref l6 0))))

    (set! a1 (grsp-matrix-editu a2 p_m1 l4 n1))        

    ;; Replace values of the row p_m1 with those in p_l1.
    (let loop ((j1 0))
      (if (< j1 (length p_l1))

	  (begin (set! l5 (list-ref p_l1 j1))
		 (array-set! a1 (list-ref l5 1) p_m1 (list-ref l5 0))
		       
		 (loop (+ j1 1)))))

    ;; Create "new" entity with updated values.
    (gdbs-de-create-em p_d1 p_e1 s3 l1 l2 l3 l4 a1)
      
    res1))


;;;; gdbs-cols2coln - Given a list p_l1 whose elements are lists that
;; have the following structure:
;;
;; - Elem 0: string. Representing a column name of entity p_e1.
;; - Elem 1: string. Representing a value.
;;
;; the function finds the column number correspnding to Elem 0, and
;; returns a list of lists similar to p_l1 but containing one elem 0 of
;; each of its sublists the respective col numbers instead of col names,
;; or an empty list if any of its requested col names does not exist.
;;
;; Keywords:
;;
;; - column, identifying
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_l1: list.
;;
;; Notes:
;;
;; - See gdbs-de-row-updateln.
;;
;; Output:
;;
;; - List of identified columns containing:
;;
;;   - Elem 0: col number.
;;   - Elem 1: col value.
;;
(define (gdbs-cols2coln p_d1 p_e1 p_l1)
  (let ((res1 '())
	(l2 '())
	(l3 '())
	(l4 '())
	(l5 '()))

    ;; Get the names of all existing columns in the entity.
    (set! l2 (gdbs-de-colsln p_d1 p_e1))

    ;; Arguments list loop. We look at each argument pair, extract it,
    ;; then read the first element, which is the column name, then look
    ;; for the corresponding column number.
    (let loop ((j1 0))
      (if (< j1 (length p_l1))

	  (begin (set! l5 (list-ref p_l1 j1))
		 
		 ;; Test if column exists.
		 (set! l3 (gdbs-de-coln p_d1 p_e1 (list-ref l5 0)))

		 (cond ((equal? (list-ref l3 0) #t)
			(set! l4 (list (list-ref l3 1)
				       (list-ref l5 1)))
			(set! res1 (append res1 (list l4)))))
		 
		 (loop (+ j1 1)))))
    
    res1))


;;;; gdbs-de-row-update - Updates the values of row p_m1 of entity p_e1 of
;; database p_d1 based on the contents of list p_l1.
;;
;; Keywords:
;;
;; - column, adding
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_m1: row number.
;; - p_l1: list.
;;
;;   - Contains lists of two elements as elements of p_l1.
;;
;;     - Elem 0: string, col name.
;;     - Elem 1: string, new value for element at [p_m1, Elem 0].
;;
;; Notes:
;;
;; - Be aware that all pairs passed on list p_l1 should refer to the
;;   same row p_m1.
;; - Also take into account that the list p_l1 should not include value
;;   pairs for primary key fields unless you are absolutely sure you
;;   need to update those values.
;; - This function does not add a new row; it should be used on
;;   preexisting rows.
;; - This function does not require that p_l1 has as many elements as
;;   there are cols in the matrix of p_e1. You can pass only the elements
;;   that you need, identifying them by their col name in the pairs
;;   that constitute the elements of p_l1.
;; - See gdbs-cols2coln, gdbs-de-row-updateln, gdbs-row-add,
;;   gdbs-de-row-insert.
;;
(define (gdbs-de-row-update p_d1 p_e1 p_m1 p_l1)
  (let ((res1 '())
	(l2 '()))

    ;; Identify col numbers. Tis produces a list containing:
    ;;
    ;; - Elements which are themselves lists, corresponding to data of
    ;;   each column.
    ;;
    ;;   - Elem 0: numeric, col number.
    ;;   - Elem 1: string, col name.
    ;;
    (set! l2 (gdbs-cols2coln p_d1 p_e1 p_l1))

    ;; Update entity.
    (gdbs-de-row-updateln p_d1 p_e1 p_m1 l2)    
    
    res1))

	
;;;; gdbs-de-row-insert - Inserts a new row on element p_e1, updating it
;; with the data specified on list p_l1 and default values.
;;
;; Keywords:
;;
;; - insert, adding, data, information
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_m1: row number.
;; - p_l1: list.
;;
;;   - Contains lists of two elements as elements of p_l1.
;;
;;     - Elem 0: string, col name.
;;     - Elem 1: string, new value for element at [p_m1, Elem 0].
;;
;; Notes:
;;
;; - See gdbs-de-row-add, gdbs-de-row-update, gdbs-row-updateln,
;;   gdbs-row-insertln.
;;
(define (gdbs-de-row-insert p_d1 p_e1 p_l1)
  (let ((res1 0)
	(a1 0)
	(l5 '()))

    ;; Add a row.
    (gdbs-de-row-add p_d1 p_e1)
    
    ;; Get matrix.
    (set! a1 (gdbs-ent2my p_d1 p_e1))
    
    ;; Replace values of the new row with those in p_l1.
    (gdbs-de-row-update p_d1 p_e1 (grsp-hm a1) p_l1)

    ;; Get matrix again.
    (set! a1 (gdbs-ent2my p_d1 p_e1))
    
    ;; Determine if entity has primary key columns.
    (set! l5 (gdbs-de-has-keynumai p_d1 p_e1))
    
    ;; If it has primary key columns, update last row.
    (cond ((equal? (null? l5) #f)

	   ;; List loop.
	   (let loop ((j1 0))
	     (if (< j1 (length l5))

		 (begin (array-set! a1
				    (gdbs-de-keygen p_d1
						   p_e1
						   (list-ref l5 j1)
						   1)
				    (grsp-hm a1)
				    (list-ref l5 j1))
			
			(loop (+ j1 1)))))))

    ;; save matrix.
    (gdbs-my2ent p_d1 p_e1 a1) 
    
    res1))


;;;; gdbs-des2s - Gets a description file text as a string.
;;
;; Kewywords:
;;
;; - describe, text
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-des2s p_d1 p_e1)
  (let ((res1 "")
	(s1 "")
	(s2 ""))

    ;; Get description file as a string.
    (set! s1 (gdbs-de-path-cfg p_d1 p_e1))
    (set! s2 (strings-append (list s1 "/description.txt") 0))
    (set! res1 (read-file-as-string s2))

    ;; TODO: this is a stopgap. Find why newline chars are added on
    ;; updates.
    (set! res1 (string-replace-substring res1 "\n\n" "\n"))
    
    res1))


;;;; gdbs-de-esi - Extracts shape information from a database entity.
;;
;; Keywords:
;;
;; - database, entity, file , table, properties, dimensions, size
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
;; Output:
;;
;; - A list of numbers corresponding to min and max row and col values.
;;
;;   - Elem 0: lm, row min.
;;   - Elem 1: hm, row max.
;;   - Elem 2: ln, col min.
;;   - Elem 3: hn, col max.
;;
(define (gdbs-de-esi p_d1 p_e1)
  (let ((res1 '())
	(a1 0))

    (set! res1 (make-list 4 0))
    (set! a1 (gdbs-ent2my p_d1 p_e1))

    ;; List loop.
    (let loop ((j1 0))
      (if (<= j1 3)

	  (begin (list-set! res1 j1 (grsp-matrix-esi (+ j1 1) a1))
		 
		 (loop (+ j1 1)))))
        
    res1))

;;;; gdbs-de-tmtn - Provides the size in number of rows and cols of an
;; entity.
;;
;; Keywords:
;;
;; - database, entity, file , table, properties, dimensions, size
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
;; Output:
;;
;; - A list.
;;
(define (gdbs-de-tmtn p_d1 p_e1)
  (let ((res1 '())
	(l1 '()))

    (set! l1 (gdbs-de-esi p_d1 p_e1))
    (set! res1 (list (+ 1 (- (list-ref l1 1) (list-ref l1 0)))
		     (+ 1 (- (list-ref l1 3) (list-ref l1 2)))))

    res1))


;;;; gdbs-de-str-cpy - Copies the structure of entity p_e1 to a new
;; entity p_e2, adding p_m1 rows.
;;
;; Keywords:
;;
;; - entity, structure, sshape, properties
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity, original.
;; - p_e2: entity, structurally copied.
;; - p_m1: numeric, number of rows to create.
;;
;; Notes:
;;
;; . Produces a new, empty entity p_e2 with p_m1 rows.
;; - Does not copy the actual data from p_e1 to p_e2.
;; - See gdbs-de-row-cpy.
;;
(define (gdbs-de-str-cpy p_d1 p_e1 p_e2 p_m1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(s1 "")
	(s2 "")
	(l1 '()))

    ;; Get metadata.
    ;; - Elem 0: string, entity description.
    ;; - Elem 1: list, col names.
    ;; - Elem 2: list, col descriptions.
    ;; - Elem 3: list, col properties:
    ;; - Elem 4: list, col default values.
    (set! l1 (gdbs-de-colsll p_d1 p_e1))
    
    ;; Get matrix and copy it.
    (set! a1 (gdbs-ent2my p_d1 p_e1))
    (set! a2 (grsp-matrix-create "" p_m1 (grsp-tn a1)))

    ;; Create new entity.
    (gdbs-de-create-em p_d1
		      p_e2
		      (list-ref l1 0)
		      (list-ref l1 1)
		      (list-ref l1 2)
		      (list-ref l1 3)
		      (list-ref l1 4)
		      a2)
    
    res1))


;;;; gdbs-de-row-cpy - Copies from row p_m1 to row p_m2 of entity p_e1 to
;; a new entity p_e2.
;;
;; Keywords:
;;
;; - entity, submatrix, properties, sections
;;
;; Parameters:
;;
;; - p_d1: database, origin.
;; - p_e1: entity, origin.
;; - p_d2: database, target.
;; - p_e2: entity, target.
;; - p_m1: numeric, row.
;; - p_m2: numeric, row.
;;
;; Notes:
;;
;; - Produces a new entity p_e2 with the same structure and metadata as
;;   p_e1, with contents from row p_m1 to p_m2 of p_e1.
;; - See grsp-de-str-cpy.
;; - Entities p_e1 and p_e2 and their respective databases should
;;   already exist when using this function.
;; - This function will override the data in p_e2, leaving p_e1 as is.
;;
(define (gdbs-de-row-cpy p_d1 p_e1 p_d2 p_e2 p_m1 p_m2)
  (let ((res1 0)
	(a1 0)
	(a2 0))

    ;; Get matrix and copy it.
    (set! a1 (gdbs-ent2my p_d1 p_e1))
    (set! a2 (grsp-matrix-subcpy a1 p_m1 p_m2 (grsp-ln a1) (grsp-hn a1)))

    ;; Save.
    (gdbs-my2ent p_d2 p_e2 a2)

    res1))


;;;; gdbs-de-vol-cpy - Copies from entity p_e1 of database p_d1 to entity
;; p_e2 of database p_d2 a subset from row p_m1 to row p_m2 inclusive,
;; effectively creating a volume of the entity of origin.
;;
;; Keywords:
;;
;; - entity, submatrix, properties, sections
;;
;; Parameters:
;;
;; - p_d1: database, origin.
;; - p_e1: entity, origin.
;; - p_d2: database, target.
;; - p_e2: entity, target.
;; - p_m1: numeric, row.
;; - p_m2: numeric, row.
;; - p_b1: boolean.
;;
;;   - #t: to create p_e2.
;;   - #f: otherwise.
;;
;; - p_b2: boolean.
;;
;;   - #t: to delete copied rows from p_e1.
;;   - #f: otherwise.
;;
;; Notes.
;;
;; - Databases p_d1 and p_d2, and entity p_e1 should exist before using
;;   this function.
;; - If p_b2 is set to #t and copied rows are deleted from p_e1, care
;;   must be taken on repeated use of this function and the values
;;   assigned to p_m1 and p_m2, since the number of rows in p_e1 would
;;   have changed.
;;
(define (gdbs-de-vol-cpy p_d1 p_e1 p_d2 p_e2 p_m1 p_m2 p_b1 p_b2)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(a3 0))

    ;; Create p_e2 if p_b1 is #t.
    (cond ((equal? p_b1 #t)
	   (gdbs-de-str-cpy p_d1 p_e1 p_e2 1)))    

    ;;Get matrix.
    (set! a1 (gdbs-ent2my p_d1 p_e1))

    ;; Carve volume from matrix a1.
    (set! a2 (grsp-matrix-subcpy a1 p_m1 p_m2 (grsp-ln a1) (grsp-hn a1)))

    ;; Save submatrix to the second entity.
    (gdbs-my2ent p_d2 p_e2 a2)

    ;; Update vols.cfg to indicate the existence of two volumes now:
    ;;
    ;; - The newly created volume. 
    ;; - The remainder of the file, which is in essence another volume.
    ;; TODO
    (gdbs-de-vol-cfg-subadd p_d1 p_e1 p_e2)
    
    ;; Delete rows from origin if p_b2 is #t.
    (cond ((equal? p_b2 #t)
	   
	   ;; Delete volume from a1.
	   (set! a3 (grsp-matrix-subdelr a1 p_m1 p_m2))
	   
	   ;; Save updated matrix to p_e1.
	   (gdbs-my2ent p_d1 p_e1 a3)))
        
    res1))


;;;; gdbs-de-vol-split - Splits an entity into smaller volumes of p_n1
;; rows each.
;;
;; Keywords:
;;
;; - entity, submatrix, properties, sections
;;
;; Parameters:
;;
;; - p_d1: database, origin.
;; - p_e1: entity, origin.
;; - p_d2: database, target.
;; - p_e2: entity volume base name, target.
;; - p_n1: numeric, rows per volume.
;; - p_b2: boolean.
;;
;;   - #t: to delete copied rows from p_e1.
;;   - #f: otherwise.
;;
;; Notes:
;;
;; - IMPORTANT: make a backup of p_e1 before using this function.
;; - Make sure that p_e1 has enough rows in its matrix to actually build
;;   the volumes.
;;
(define (gdbs-de-vol-split p_d1 p_e1 p_d2 p_e2 p_n1 p_b2)
  (let ((res1 0)
	(a1 0)
	(a3 0)
	(e2 "")
	(l1 '()))
    
    ;; Get metadata.
    (set! l1 (gdbs-de-colsll p_d1 p_e1))
    
    ;; Get the matrix.
    (set! a1 (gdbs-ent2my p_d1 p_e1))

    ;; Calculate row assignment per volume.
    (set! a3 (grsp-matrix-row-vol a1 p_n1))

    (grsp-ld "a3 ") 
    (grsp-ld a3)
    
    ;; Row loop.
    (let loop ((i1 (grsp-lm a3)))
      (if (<= i1 (grsp-hm a3))

	  (begin (set! e2 (strings-append (list p_e2
						"_vol_"
						(grsp-n2s i1))
					  0))
		 (gdbs-de-vol-cpy p_d1
				 p_e1
				 p_d2
				 e2
				 (array-ref a3 i1 0)
				 (array-ref a3 i1 1)
				 #t
				 #f)
		 
		 (loop (+ i1 1)))))

    ;; If the original file is to be deleted (replaced by an empty one)
    (cond ((equal? p_b2 #t)
	   (gdbs-de-row-zero p_d1 p_e1)))
	   
    res1))


;;;; gdbs-de-colsll - Returns a list of metadata strings and lists.
;;
;; Keywords:
;;
;; - path, location, names, columnar, cols
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
;; Output:
;;
;; - Elem 0: string, entity description.
;; - Elem 1: list, col names.
;; - Elem 2: list, col descriptions.
;; - Elem 3: list, col properties:
;; - Elem 4: list, col default values.
;;
(define (gdbs-de-colsll p_d1 p_e1)
  (let ((res1 '()))

    (set! res1 (list (gdbs-des2s p_d1 p_e1)		     
		     (gdbs-de-colslm p_d1 p_e1 0)		     
		     (gdbs-de-colslm p_d1 p_e1 1)
		     (gdbs-de-colslm p_d1 p_e1 2)
		     (gdbs-de-colslm p_d1 p_e1 3)))
    
    res1))


;;;; gdbs-de-vol-join - Joins volumes contained into list p_l1 of
;; database into entity p_e1 of database p_d1.
;;
;; Keywords:
;;
;; - path, location, names, columnar, cols
;;
;; Parameters:
;;
;; - p_b1: verbose mode.
;;
;;   - #t: activaded.
;;   - #f: otherwise.
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_l1: list of entity volume names. 
;;
(define (gdbs-de-vol-join p_b1 p_d1 p_e1 p_l1)
  (let ((res1 0)
	(e2 "")
	(a1 0)
	(a2 0))

    ;; List loop.
    (let loop ((i1 0))
      (if (< i1 (length p_l1))

	  (begin (set! e2 (list-ref p_l1 i1))
		 
		 ;; Show in verbose mode.
		 (cond ((equal? p_b1 #t)
			(grsp-ldl (gdbs-gconsts "Pv") 1 1)
			(grsp-ldl p_d1 1 1)
			(grsp-ldl e2 1 1)))
		 
		 ;; Append matrix from volume.
		 (displayc p_b1 (gdbs-gconsts "Mat"))
		 (displayc p_b1 i1)
		 
		 (cond ((= i1 0)
			(set! a1 (gdbs-ent2my p_d1 e2))
			(displayc p_b1 a1))
		       ((> i1 0)
			(set! a2 (gdbs-ent2my p_d1 e2))
			(displayc p_b1 a1)
			(set! a1 (grsp-matrix-subadd a1 a2))))

		 ;; Delete volume.
		 (gdbs-de-delete p_b1 p_d1 e2)

		 ;; Update vols.csv, deleting the record that corresponds
		 ;; to the deleted volume.
		 (gdbs-de-vol-cfg-subdel p_d1 p_e1 e2)
		 
		 (loop (+ i1 1)))))
    
    ;; Copy joined matrix to entity.
    (gdbs-my2ent p_d1 p_e1 a1)

    ;; Create default vol configuration table.
    (gdbs-de-vol-cfg-create p_d1 p_e1)

    ;; Wrap up.
    (displayc p_b1 (gdbs-gconsts "Avpej"))

    ;; TODO: make sure that the first and last volume records on
    ;; vols.csv are deleted during the cycle.
    
    res1))


;;;; - gdbs-de-vol-cfg-create - Creates a default configuration file for
;; volumetric operations.
;;
;; Keywords:
;;
;; - volumes, split
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-vol-cfg-create p_d1 p_e1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(s1 ""))

    ;; Create a 1x1 matrix. Do not use gconsts here.
    (set! a1 (grsp-matrix-create "no volumes" 1 1))

    ;; Find path to cfg folder.
    (set! s1 (strings-append (list p_d1 "/dat/" p_e1 "/cfg/") 0))

    ;; Cast to numeric database matrix.
    (set! a2 (grsp-ms2dbc a1))

    ;; Save.
    (grsp-mc2dbc-csv s1 a2 "vols.csv")
    
    res1))


;;;; gdbs-de-vol-cfg-get - Retrieves the volumetric configuration file as a
;; matrix.
;;
;; Keywords:
;;
;; - volumes, split
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-vol-cfg-get p_d1 p_e1)
  (let ((res1 0)
	(s1 "")
	(a1 0)
	(a2 0))

    ;; Find path to cfg folder.
    (set! s1 (strings-append (list p_d1 "/dat/" p_e1 "/cfg") 0))

    ;; Retrieve matrix.
    (set! a2 (grsp-dbc2mc-csv s1 "vols.csv"))
    
    ;; Cast as matrix of strings.
    (set! res1 (grsp-dbc2ms a2))
    
    res1))


;;;; gdbs-de-vol-cfg-subadd - Adds a row to the vol configuration matrix
;; with the name of volume p_s1.
;;
;; Keywords:
;;
;; - volumes, split
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_s1: string, volume name.
;;
(define (gdbs-de-vol-cfg-subadd p_d1 p_e1 p_s1)
  (let ((res1 0)
	(s1 "")
	(s2 "")
	(a1 0)
	(a2 0)
	(a3 0))

    ;; Get data.
    (set! a1 (gdbs-de-vol-cfg-get p_d1 p_e1))
    (set! s1 (array-ref a1 0 0))

    ;; If there are no volumes for the entity, the default vols.csv file
    ;; is overwritten with the name of the first volume. Once this
    ;; happens, new vplume names are added in new rows. This means that
    ;; vols.csv always holds one row at least.
    (cond ((equal? s1 "no volumes")
	   (array-set! a1 p_s1 0 0))
	  (else (set! a2 (grsp-matrix-create p_s1 1 1))
		(set! a1 (grsp-matrix-subadd a1 a2))))

    ;; Build path to cfg folder.
    (set! s2 (strings-append (list p_d1 "/dat/" p_e1 "/cfg/") 0))

    ;; Cast to numeric database matrix.
    (set! a3 (grsp-ms2dbc a1))

    ;; Save.
    (grsp-mc2dbc-csv s2 a3 "vols.csv")    
    
    res1))


;;;; gdbs-de-vol-cfg-subdel - Deletes a row from the vol configuration
;; matrix with the name of volume p_s1.
;;
;; Keywords:
;;
;; - volumes, split
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_s1: string, volume name.
;;
(define (gdbs-de-vol-cfg-subdel p_d1 p_e1 p_s1)
  (let ((res1 0)
	(l1 '())
	(s1 "")
	(a1 0)
	(a2 0)
	(a3 0)
	(m1 0))

    ;; Get the configuration matrix for entity p_e1.
    (set! a1 (gdbs-de-vol-cfg-get p_d1 p_e1))

    ;; Find the row to be deleted.
    (set! l1 (grsp-matrix-row-number a1 p_s1 0))

    ;; Delete corresponding row if list is not empty. If the list is
    ;; empty, then we assume that all volumes have been joined and
    ;; therefero, a default file vols.csv is recreated.
    (cond ((equal? (null? l1) #f)
	   (set! m1 (list-ref l1 0))
	   (set! a2 (grsp-matrix-subdelr a1 m1 m1))

	   ;; Build path to cfg folder.
	   (set! s1 (strings-append (list p_d1 "/dat/" p_e1 "/cfg/") 0))

	   ;; Cast to numeric database matrix.
	   (set! a3 (grsp-ms2dbc a2))

	   ;; Save.
	   (grsp-mc2dbc-csv s1 a3 "vols.csv"))
	  ((equal? (null? l1) #t)
	   (gdbs-de-vol-cfg-create p_d1 p_e1)))
		   	   
    res1))


;;;; gdbs-db-fix - A general-purpose function to check varios aspects of
;; the integrity of a datavase.
;;
;; Keywords:
;;
;; - repair, fix
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t for verbose mode.
;;   - #f otherwise.
;;
;; - p_d1: database.
;;
(define (gdbs-db-fix p_b1 p_d1)
  (let ((res1 0)
	(s1 "")
	(s2 "")
	(s3 "")
	(s4 ""))

    ;; Backup database.
    (displayc p_b1 (gdbs-gconsts "Pb"))
    (gdbs-db-dat2bak p_b1 p_d1)

    ;; Database checks.
    
    ;; Check if all configuration tables and files exists. If not,
    ;; create them.
    ;;
    ;; - Database configuration.
    (displayc p_b1 (gdbs-gconsts "Cdc"))

    ;; Check description file.
    (set! s1 (strings-append (list p_d1 "/cfg/description.txt") 0))
    (set! s2 (strings-append (list (gdbs-gconsts "Nodesfd")
				   p_d1
				   ". "
				   (gdbs-gconsts "Cf"))
			     0))
    (set! s3 (gdbs-gconsts "Fifo"))
    (cond ((equal? (file-exists? s1) #f)
	   (displayc p_b1 s2)
	   (set! s4 (gdbs-db-description-create s2 p_d1))
	   (system s4))
	  ((equal? (file-exists? s1) #t)
	   (displayc p_b1 s1)
	   (displayc p_b1 s3)))
	   
    (displayc p_b1 (gdbs-gconsts "Fin"))
    
    res1))


;;;; gdbs-de-fix - A general-purpose function to check varios aspects of
;; the integrity of a database entity.
;;
;; Keywords:
;;
;; - repair, fix, entities
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t for verbose mode.
;;   - #f otherwise.
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-fix p_b1 p_d1 p_e1)
  (let ((res1 0)
	(s1 "")
	(s2 "")
	(s3 "")
	(s4 "")
	(s5 "")
	(s6 ""))

    ;; Backup database.
    (displayc p_b1 (gdbs-gconsts "Pb"))
    (gdbs-db-dat2bak p_b1 p_d1)

    ;; Check cfg folder.
    (displayc p_b1 (gdbs-gconsts "Cec"))
    
    ;; Check description file.
    (set! s5 (strings-append (list p_d1 "/dat/" p_e1) 0))
    (set! s1 (strings-append (list s5 "/cfg/description.txt") 0))
    (set! s2 (strings-append (list (gdbs-gconsts "Nodesfe") p_e1) 0))
    (set! s3 "File found.")
    (cond ((equal? (file-exists? s1) #f)
	   (displayc p_b1 s2)
	   (set! s6 (strings-append (list (gdbs-gconsts "Dde")
					  p_e1
					  ". "
					  (gdbs-gconsts "Noinfo")
					  ".")
				    0))
	   (displayc p_b1 s4)
	   (set! s4 (gdbs-db-description-create s6 p_d1))
	   (system s4))
	  ((equal? (file-exists? s1) #t)
	   (displayc p_b1 s1)
	   (displayc p_b1 s3)))

    ;; cols.csv

    ;; vols.csv
    
    ;; Check dat folder.
    (displayc p_b1 (gdbs-gconsts "Ced"))    

    (displayc p_b1 (gdbs-gconsts "Fin"))
    
    res1))


;;;; gdbs-de-vol-cfg-edit - Interactive edition of vols.cfg file of
;; entity p_e1 of database p_d1.
;;
;; Keywords:
;;
;; - volumes, split
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-vol-cfg-edit p_d1 p_e1)
  (let ((res1 0)
	(a1 0)
	(a2 0)
	(s1 ""))

    (set! a1 (gdbs-de-vol-cfg-get p_d1 p_e1))

    ;; Do not use gdbs-gconststr here.
    (set! a1 (grsp-matrix-edit a1
			       (list "Volumes")
			       (list "no volumes")
			       (list "#str")))
    
    (set! a2 (grsp-ms2dbc a1))
    (set! s1 (strings-append (list p_d1 "/dat/" p_e1 "/cfg/") 0))
    (grsp-mc2dbc-csv s1 a2 "vols.csv")   
        
    res1))


;;;; gdbs-de-row-zero - Deletes every row from the matrix of data entity
;; p_e1, and leaves only row zero with no values on it.
;;
;; Jeywords:
;;
;; - resetting, erasing
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-row-zero p_d1 p_e1)
  (let ((res1 0)
	(a1 0))

    (set! a1 (gdbs-ent2my p_d1 p_e1))
    (set! a1 (grsp-matrix-subexp a1 1 0))
    (set! a1 (grsp-matrix-subcpy a1
				 (grsp-hm a1)
				 (grsp-hm a1)
				 (grsp-ln a1)
				 (grsp-hn a1)))
    (gdbs-my2ent p_d1 p_e1 a1)
    
    res1))


;;;; gdbs-vols2l - Casts the contents of file vols.csv as a list.
;;
;; Keywords:
;;
;; - configuration, volumes
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-vols2l p_d1 p_e1)
  (let ((res1 '())
	(a1 0))

    (set! a1 (gdbs-de-vol-cfg-get p_d1 p_e1))
    (set! a1 (grsp-matrix-transpose a1))
    (set! res1 (grsp-m2l a1))
    
    res1))


;;;; gdbs-de-vol-find-last - Finds the last volume of an entity if it has
;; been divided into volumes and returns its name as a string. Otherwise
;; it returns the name of the entity as a string.
;;
;; Keywords:
;;
;; - volumes, searching, finding
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-vol-find-last p_d1 p_e1)
  (let ((res1 "")
	(a1 0))

    (set! a1 (gdbs-de-vol-cfg-get p_d1 p_e1))

    ;; Do not use gdbs-gconststr here.
    (cond ((equal? (equal? (array-ref a1 (grsp-hm a1) 0) "no volumes") #f)
	   (set! res1 (array-ref a1 (grsp-hm a1) 0)))
	  (else (set! res1 p_e1)))
    
    res1))


;;;; gdbs-de-has-vol- Returns #t if the data entity has volumes, #f
;; otherwise.
;;
;; Keywords:
;;
;; - volumes, find, count
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-has-vol p_d1 p_e1)
  (let ((res1 #t)
	(s1 ""))

    (set! s1 (gdbs-de-vol-find-last p_d1 p_e1))

    (cond ((equal? s1 p_e1)
	   (set! res1 #f)))
    
    res1))


;;;; gdbs-de-vol-find-first - Finds the first volume of an entity if it
;; has been divided into volumes and returns its name as a string.
;; Otherwise it returns the name of the entity as a string.
;;
;; Keywords:
;;
;; - volumes, searching, finding
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-vol-find-first p_d1 p_e1)
  (let ((res1 p_e1)
	(b1 #f)
	(a1 0))

    (set! b1 (gdbs-de-has-vol p_d1 p_e1))
    
    (cond ((equal? b1 #t) 
	   (set! a1 (gdbs-de-vol-cfg-get p_d1 p_e1))
	   (set! res1 (array-ref a1 0 0))))
    
    res1))


;;;; gdbs-de-edit-row - Edit one row of an entity.
;;
;; Keywords:
;;
;; - rows, forms
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: clear.
;;   - #f: otherwise.
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_m1: row number.
;;
;; Notes:
;;
;; - If the row number does not exist (it is higher than the value
;;   returned by grsp-hm, then a new row will be added and the row
;;   number requested will be updateds to reflect the row number of
;;   the newly-added row.
;; - Row number checks should be provided outside this function if
;;   you do not want to add a new row each time a wrong row number
;;   is passed.
;;
(define (gdbs-de-edit-row p_b1 p_d1 p_e1 p_m1)
  (let ((res1 0)
	(a0 0)
	(a1 0)
	(a2 0)
	(a3 0)
	(a4 0)
	(a5 0)
	(b1 #t)
	(i1 0)
	(m1 0)
	(n1 0)
	(l0 '())
	(l1 '())
	(l2 '())
	(l3 '())
	(l4 '())
	(s1 ""))
    
    (gdbs-gdc p_b1)
    (set! m1 p_m1)
    
    ;; Get entity metadata.
    (set! l0 (gdbs-de-colsll p_d1 p_e1))  
    
    ;; Cast lists as matrices.
    (set! a1 (grsp-l2m (list-ref l0 1)))

    ;; Cycle while editing.
    (while (equal? b1 #t)

	   (grsp-clear-on-demand p_b1)
	   
	   ;; Get matrix from entity.
	   (set! a0 (gdbs-ent2my p_d1 p_e1))

	   ;; See if we have to add a new row.
	   (cond ((> m1 (grsp-hm a0))
		  (set! a0 (grsp-matrix-subexp a0 1 0))
		  (set! m1 (grsp-hm a0))))
	   
	   ;; Get row from matrix.
	   (set! a2 (grsp-matrix-row-select "#=" a0 0 m1))
	   
	   ;; Append matrices.
	   (set! a3 (grsp-matrix-subadd a1 a2))
	   (set! a3 (grsp-matrix-transpose a3))

	   ;; Display.
	   (system "tput cup 0")
	   (plinetn "-")
	   (grsp-ldl (strings-append (list "Entity "
					   p_e1
					   ", row "
					   (grsp-n2s m1))
				     0)
		     1
		     1)
	   (set! a5 (grsp-my2ms a3))
	   (grsp-color-set "fgreen")
	   (grsp-matrix-display a5)
	   (grsp-color-set "fcyan")
	   (grsp-ldl (gdbs-gconsts "0e1e2d") 0 0)
	   (grsp-color-set "fdefault")
	   (set! n1 (grsp-askn "? "))

	   (cond ((equal? n1 0)
		  (set! b1 #f))
		 ((equal? n1 1)
		  (set! i1 (grsp-askn (gdbs-gconsts "Ernte")))

		  ;; Only change things if the row entered is correct.
		  (cond ((equal? (and (>= i1 (grsp-lm a3))
				      (<= i1 (grsp-hm a3))) #t)
			 (set! a3 (grsp-matrix-inputev #f #f a3 i1 1))
			 (set! a3 (grsp-matrix-transposer a3 1))
			 (set! a4 (grsp-matrix-subcpy a3
						      1
						      1
						      (grsp-ln a3)
						      (grsp-hn a3)))

			 ;; Save if the row or record has actually been
			 ;; edited.
			 (set! a0 (grsp-matrix-subrep a0
						      a4
						      m1
						      (grsp-ln a0)))
			 (gdbs-my2ent p_d1 p_e1 a0))))		 
		 ((equal? n1 2)
		  (set! s1 (grsp-confirm-ask #t (gdbs-gconsts "Con")))
		  (cond ((equal? s1 "y")
			 (set! a0 (grsp-matrix-subdel "#Delr" a0 m1))
			 (gdbs-my2ent p_d1 p_e1 a0))))))
       
    res1))


;;;; gdbs-de-edit-rows - Edit one or several rows of an entity.
;;
;; Keywords:
;;
;; - rows, forms
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: clear.
;;   - #f: otherwise.
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
(define (gdbs-de-edit-rows p_b1 p_d1 p_e1)
  (let ((res1 0)
	(a1 0)
	(n1 0)
	(i1 0)
	(b2 #t))

    (while (equal? b2 #t)
	   (grsp-clear-on-demand p_b1)

	   (cond ((equal? p_b1 #t)
		  (system "tput cup 0")))

	   (grsp-color-set "fcyan")
	   (grsp-ldl (gdbs-gconsts "0e1emr") 0 0)
	   (grsp-color-set "fdefault")
	   (set! n1 (grsp-askn "? "))
	   
	   (cond ((equal? n1 0)
		  (set! b2 #f))
		 ((equal? n1 1)
		  (set! i1 (grsp-askn (gdbs-gconsts "Ernte")))
		  (gdbs-de-edit-row p_b1 p_d1 p_e1 i1))))

    res1))


;;;; gdbs-gdc - Posts a "Getting data" message if p_b1 is #t.
;;
;; Keywrods:
;;
;; - clear, console, screen, shell, terminal
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: clear.
;;   - #f: otherwise.
;;
(define (gdbs-gdc p_b1)
  (let ((res1 0))

    (grsp-ldlc p_b1 (gdbs-gconsts "ged") 1 1)
    
    res1))


;;;; gdbs-de-edit-selectm - Select a method to edit the contents of an
;; entity.
;;
;; Keywords:
;;
;; - entities, edition, rows, records, tables, matrix, matrices
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: clear.
;;   - #f: otherwise.
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_s1: string, title to show.
;;
(define (gdbs-de-edit-selectm p_b1 p_d1 p_e1 p_s1)
  (let ((res1 0)
	(a1 0)
	(n1 0)
	(i1 0)
	(b2 #t))

    (while (equal? b2 #t)
	   (grsp-clear-on-demand p_b1)

	   (cond ((equal? p_b1 #t)
		  (system "tput cup 0")))

	   (grsp-color-set "fcyan")
	   (grsp-ldl (gdbs-gconsts "0e1et2er") 0 0)
	   (grsp-color-set "fdefault")
	   (set! n1 (grsp-askn "? "))

	   (grsp-clear-on-demand p_b1)
	   
	   (cond ((equal? n1 0)
		  (set! b2 #f))
		 ((equal? n1 1)
		  (gdbs-de-edittms p_d1 p_e1 (gdbs-ent2my p_d1 p_e1) p_s1))
		 ((equal? n1 2)
		  (gdbs-de-edit-rows #t p_d1 p_e1))))
		   
    res1))


;;;; gdbs-de-displaytms - Displays submatrix p_a1 of entity p_e1. This
;; function follows the same presentation format as gdbs-de-edittms but
;; does not let the user edit data. It only displays it.
;;
;; Keywords:
;;
;; - submatrix. display
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_a1: matrix (submatrix of p_e1).
;; - p_s1: string, title to show.
;;
;; Notes:
;;
;; - See gdbs-de-edittms.
;;
(define (gdbs-de-displaytms p_d1 p_e1 p_a1 p_s1)
  (let ((res1 0)
	(tm 0)
	(l0 '()))

    ;; Display title.
    (plinetn "-")
    (grsp-ldl p_s1 1 1)

    ;; Get properties.
    (set! l0 (gdbs-de-colsll p_d1 p_e1))

    ;; Display if the number of rows of p_a1 is greater than zero.
    (set! tm (grsp-tm p_a1))
    
    (cond ((> tm 0)
	   (grsp-color-set "fgreen")
	   (grsp-matrix-displaytms p_a1 (list-ref l0 1) (list-ref l0 3))
	   (grsp-color-set "fdefault")))
    
    res1))


;;;; gdbs-de-edittms - Edits submatrix p_a1 of entity p_e1 following the
;; gdbs-de-displaytms format.
;;
;; Keywords:
;;
;; - submatrix. display
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_a2: matrix (submatrix of p_e1).
;; - p_s1: string, title to show.
;;
;; Notes:
;;
;; - See gdbs-de-displaytms.
;;
(define (gdbs-de-edittms p_d1 p_e1 p_a2 p_s1)
  (let ((res1 0)
	(a2 0)
	(tm 0)
	(l0 '()))

    ;; Get matrix.
    (set! res1 (gdbs-ent2my p_d1 p_e1))
    
    ;; Safety copy.
    (set! a2 (grsp-matrix-cpy p_a2))
    
    ;; Display title.
    (plinetn "-")
    (grsp-ldl p_s1 1 1)

    ;; Get properties.
    (set! l0 (gdbs-de-colsll p_d1 p_e1))
    ;; ***a
    ;; Edit if the number of rows of p_a2 is greater than zero.
    (set! tm (grsp-tm a2))
    
    (cond ((> tm 0)
	   (set! a2 (grsp-matrix-edit a2
				      (list-ref l0 1)
				      (list-ref l0 4)
				      (list-ref l0 3)))

	   ;; Commit submatrix.
	   (set! res1 (grsp-matrix-subrepk #t res1 a2 0)) ;; Leave #f for now.
	   
	   ;; Save matrix to entity.
	   (gdbs-my2ent p_d1 p_e1 res1)))

    res1))


;;;; gdbs-ent2l - Opens a database entity by casting it as a list, 
;; effectively loading its data and metadata into memory.
;;
;; Keywords:
;;
;; - lists, in-memory, inmem, tables
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;;
;; Output:
;;
;; - List:
;;
;;   - Elem 0: list, the result of applying colsll.
;;
;;     - Elem 0: string, entity description.
;;     - Elem 1: list, col names.
;;     - Elem 2: list, col descriptions.
;;     - Elem 3: list, col properties:
;;     - Elem 4: list, col default values.
;;
;;   - Elem 1: matrix, the result of applying gdbs-ent2my.
;;
(define (gdbs-ent2l p_d1 p_e1)
  (let ((res1 '())
	(l1 '())
	(a1 0))

    ;; Get metadata.
    (set! l1 (gdbs-de-colsll p_d1 p_e1))

    ;; Get matrix:
    (set! a1 (gdbs-ent2my p_d1 p_e1))

    ;; Compose results.
    (set! res1 (list l1 a1))
    
    res1))


;;;; gdbs-l2ent - Closes an inmem entity opened with gdbs-ent2l,
;; effectively saving its contents into non-volatile memory.
;;
;; Keywords:
;;
;; Keywords:
;;
;; - lists, inmem, tables
;;
;; Parameters:
;;
;; - p_d1: database (should exists before applying this function).
;; - p_e1: entity (should exists before applying this function).
;; - p_l1: list. Inmem entity. See gdbs-ent2l.
;; - p_j1: primary key column to use.
;;
;; Notes:
;;
;; - In order to save the contents of p_l1 into entity p_e1 correctly,
;;   it is required that the entity and the matrix of p_l1 share the
;;   same primary key. The function copies each matrix row into the
;;   entity matrix based on the said key, on a row by row basis, and not
;;   as a whole. This allows for reducing the matrix obtained with
;;   gdbs-ent2l, work only with the rows of interest and saving it back
;;   to non volatile memory afterwards.
;; - p_l1 and p_e1 must have the same metadata definitions. i.e p_l1 must
;;   have been obtained via gdbs-ent2l from p_e1 or from an entity whose
;;   structure is the same.
;; - Deletion of rows should be perfomed directly onver the entity, not
;;   using this function.
;;
;; Output:
;;
;, - Saved entity.
;;
(define (gdbs-l2ent p_d1 p_e1 p_l1 p_j1)
  (let ((res1 0)
	(l2 '())
	(a1 0)
	(a2 0)
	(a3 0)
	(a4 0)
	(j1 0))

    ;; Extract data matrix from the target entity.
    (set! a2 (gdbs-ent2my p_d1 p_e1))

    ;; Extract matrix from p_l1.
    (set! a3 (gdbs-de-lmatrix p_l1))

    ;; Copy the rows in a3 to a2 based on their key values.
    (set! a2 (grsp-matrix-subrepk #t a2 a3 p_j1))

    ;; Once finished, save a2 to p_e1.
    (gdbs-my2ent p_d1 p_e1 a2)
    
    res1))


;;;; gdbs-de-ldescription - Get entity description from the results
;; provided by gdbs-ent2l.
;;
;; Keywords:
;;
;; - properties, description, inmem
;;
;; Parameters:
;;
;; - p_l1: list as provided by gdbs-ent2l.
;;
;; Output:
;;
;; - List.
;;
(define (gdbs-de-ldescription p_l1)
  (let ((res1 ""))

    (set! res1 (list-ref (list-ref p_l1 0) 0)) 
    
    res1))


;;;; gdbs-de-lcolsln - Get column names from the results
;; provided by gdbs-ent2l.
;;
;; Keywords:
;;
;; - properties, names, inmem
;;
;; Parameters:
;;
;; - p_l1: list as provided by gdbs-ent2l.
;;
;; Output:
;;
;; - List.
;;
(define (gdbs-de-lcolsln p_l1)
  (let ((res1 ""))

    (set! res1 (list-ref (list-ref p_l1 0) 1)) 
    
    res1))


;;;; gdbs-de-lcolsle - Get column descriptions from the results
;; provided by gdbs-ent2l.
;;
;; Keywords:
;;
;; - properties, descriptions, inmem
;;
;; Parameters:
;;
;; - p_l1: list as provided by gdbs-ent2l.
;;
;; Output:
;;
;; - List.
;;
(define (gdbs-de-lcolsle p_l1)
  (let ((res1 '()))

    (set! res1 (list-ref (list-ref p_l1 0) 2)) 
    
    res1))


;;;; gdbs-de-lcolslp - Get column properties from the results
;; provided by gdbs-ent2l.
;;
;; Keywords:
;;
;; - properties, metadata, inmem
;;
;; Parameters:
;;
;; - p_l1: list as provided by gdbs-ent2l.
;;
;; Output:
;;
;; - List.
;;
(define (gdbs-de-lcolslp p_l1)
  (let ((res1 '()))

    (set! res1 (list-ref (list-ref p_l1 0) 3)) 
    
    res1))


;;;; gdbs-de-lcolsld - Get column defaults from the results
;; provided by gdbs-ent2l.
;;
;; Keywords:
;;
;; - properties, defaults, inmem
;;
;; Parameters:
;;
;; - p_l1: list as provided by gdbs-ent2l.
;;
;; Output:
;;
;; - List.
;;
(define (gdbs-de-lcolsld p_l1)
  (let ((res1 '()))

    (set! res1 (list-ref (list-ref p_l1 0) 4)) 
    
    res1))


;;;; gdbs-de-lmatrix - Get an entity matrix from the results
;; provided by gdbs-ent2l.
;;
;; Keywords:
;;
;; - matrix, extraction, inmem
;;
;; Parameters:
;;
;; - p_l1: list as provided by gdbs-ent2l.
;;
;; Output:
;;
;; - List.
;;
(define (gdbs-de-lmatrix p_l1)
  (let ((res1 0))

    (set! res1 (list-ref p_l1 1))
    
    res1))


;;;; gdbs-de-row-insertln - Inserts a new row on element p_e1, updating it
;; with the data specified on list p_l1 and default values.
;;
;; Keywords:
;;
;; - insert, adding, data, information
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_m1: row number.
;; - p_l1: list.
;;
;;   - Contains lists of two elements as elements of p_l1.
;;
;;     - Elem 0: numeric, col number.
;;     - Elem 1: string, new value for element at [p_m1, Elem 0].
;;
;; Notes:
;;
;; - See gdbs-de-row-add, gdbs-de-row-update, gdbs-row-insert.
;;
(define (gdbs-de-row-insertln p_d1 p_e1 p_l1)
  (let ((res1 0)
	(l2 '()))

    ;; Add a row.
    (gdbs-de-row-add p_d1 p_e1)

    ;; Get matrix properties.
    (set! l2 (gdbs-de-esi p_d1 p_e1))
    
    ;; Replace values of the new row with those in p_l1.
    (gdbs-de-row-updateln p_d1 p_e1 (list-ref l2 1) p_l1)
    
    res1))


;;;; gdbs-de-create-tbiv Creates a standard item value table in
;; database p_d1 with name p_s.
;;
;; Keywords:
;;
;; - item, value, pairs
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_s1: desired entity name.
;; - p_s2: short description.
;; - p_s3: default status.
;;
(define (gdbs-de-create-tbiv p_d1 p_s1 p_s2 p_s3)
  (let ((res1 0)
	(a1 0)
	(l2 '())
	(e1 p_s1))

    ;; List of default values.
    (set! l2 (list 0 p_s3 " " " " " ")) 
    
    ;; Create entity
    (gdbs-de-create-nm p_d1
		      e1
		      #f
		      (strings-append (list p_s2 p_d1) 1)
		      (list "id" "status" "item" "value" "comments")
		      (list "Pr key." "Status." "Item or concept." "Value." "Any comments.")
		      (list "#key#num#ai" "#str" "#str" "#str" "#str")
		      l2)

    ;; Assign default values to ro2 0 (entities are always created with one row at least).
    (set! a1 (gdbs-ent2my p_d1 e1))
    (set! a1 (grsp-matrix-editu a1 0 l2 0))

    ;; Path for still buggy editu. Key does not update correctly.
    (array-set! a1 0 0 0)

    ;; Save
    (gdbs-my2ent p_d1 e1 a1)
    
    res1))


;; gdbs-db-create-preferenes - Creates a preferences entity.
;;
;; Keywords:
;;
;; . preferences, configuration
;;
;; Parameters:
;;
;; - p_b1: boolean.
;;
;;   - #t: for ENABLED status in all rows.
;;   - #f: for DISABLED status in all rows.
;;
;; Notes:
;;
;; - WHen p_b1 is set to #f, even the database will be DISABLED
;;   for use, as might other parameters required from the beginning
;;   for normal operation. These parameters shoud be set as ENABLED
;;   independently. At this moment, these are the following.
;;
;;   - DB.
;;
;; - The parameters that exist in the preferences entity at this
;;   moment in development are:
;;
;;   - DB: enables or disables the database.
;;   - KB_FL: enables or disables the flat file expert system.
;;   - KB_TB: enables or disables the use of the entity based (table
;;     based) expert system.
;;
;; - p_d1: database name.
;;
(define (gdbs-db-create-preferences p_b1 p_d1)
  (let ((res1 0)
	(l1 '())
	(a1 0)
	(e1 "preferences")
	(s2 "")
	(s3 "ENABLED"))

    (cond ((equal? p_b1 #f)
	   (set! s3 "DISABLED")))
    
    ;; Create default comment.
    (set! s2 (strings-append (list (gdbs-gconsts "Prfcfg") p_d1) 0))
    
    ;; Create entity.
    (gdbs-de-create-tbiv p_d1 e1 s2 s3)

    ;; Extract matrix.
    (set! a1 (gdbs-ent2my p_d1 e1))

    ;; Here we add rows to define preferences.

    ;; Update first row (already created) with database status.
    (set! l1 (list (list 0 0)
		   (list 1 s3)
		   (list 2 "DB")
		   (list 3 "#t")
		   (list 4 "Is the db open for work?")))       
    (gdbs-de-row-updateln p_d1 e1 0 l1)

    ;; Add row with kb_fl status.
    (set! l1 (list (list 1 s3)
		   (list 2 "KB_FL")
		   (list 3 "#t")
		   (list 4 "Flat file kb.")))
    (gdbs-de-row-insertln p_d1 e1 l1)
    
    ;; Add row with kb_tb status.    
    (set! l1 (list (list 1 s3)
		   (list 2 "KB_TB")
		   (list 3 "#t")
		   (list 4 "Table file kb.")))
    (gdbs-de-row-insertln p_d1 e1 l1)
    
    res1))


;;;; gdbs-db-eval-preference - Returns the status of prefernce p_s1 of
;; database p_d1.
;;
;; Keywords:
;;
;; . preferences, configuration
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_s1: preference name.
;;
;; Notes:
;;
;; - See gdbs-db-create-preferenes
;;
(define (gdbs-db-eval-preference p_d1 p_s1)
  (let ((res1 "NA")
	(a1 0)
	(a2 0))

    (set! a1 (gdbs-ent2my p_d1 "preferences"))
    (set! a2 (grsp-matrix-row-select "#eq" a1 2 p_s1))
 
    (cond ((> (array-length a2) 0)
	   (set! res1 (array-ref a2 0 1))))
    
    res1))
