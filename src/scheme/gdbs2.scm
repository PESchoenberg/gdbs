;; =========================================================================
;;
;; gdbs2.scm
;;
;; gdbs expert system.
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
;;
;; - Conventions:
;;
;;   - tb: tabular format.
;;   - fl: flat format.


(define-module (gdbs gdbs2)
  #:use-module (gdbs gdbs0)
  #:use-module (gdbs gdbs1)
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
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 eval-string)     
  #:use-module (gdbs ideario_db_tb0) ;; Knowledge base for ideario_db.
  #:use-module (gdbs ideario_db_fl0) ;; Knowledge base for ideario_db.
  #:export (gdbs-kb-eval-fl
	    gdbs-kb-eval-tb
	    gdbs-kb-create-fl
	    gdbs-kb-create-tb))


;;;; gdbs-kb-eval-fl - Run a full decision iteration over list of functions p_l1
;; in a flat flie based expert system.
;;
;; Keywords:
;;
;; - decisions, interrogation
;;
;; Parameters:
;;
;; . p_d1: database.
;; - p_l1: list of entities of p_d1 that will be used by p_f1.
;; - p_f1 function containing the list of decision functions.
;; - p_n1: number of iterations.
;;
;; Notes:
;;
;; - p_f1 should take p_d1 and p_l1 as arguments. See template_fl0.kb-f0
;;
(define (gdbs-kb-eval-fl p_d1 p_l1 p_f1 p_n1)
  (let ((res1 '()))

    ;; Only permorm the evaluation if the system is enabled.
    (cond ((equal? (gdbs-db-eval-preference p_d1 "KB_FL") "ENABLED")

	   (p_f1 p_d1 p_l1 p_n1)))
    
    res1))


;;;; gdbs-kb-eval-tb - Run a full decision iteration over list of functions
;; in a table-based expert system.
;;
;; Keywords:
;;
;; - ai, intelligence, intelligent, artificial
;;
;; Parameters:
;;
;; - p_d1: database.
;; - p_e1: entity.
;; - p_l1: list of additional arguments (matrices).
;;
;; Notes:
;;
;; - The function follows rules that are deemed to be #t (see
;;   gdbs-kb-create.
;;
;; - Notes:
;;
;;   - TODO: needs some work; does not eval variables correctly.
;;
;; Sources:
;;
;; - [1].
;;
;; Output:
;;
;; - Updated list p_l1.
;;
(define (gdbs-kb-eval-tb p_d1 p_e1 p_l1)
  (let ((res1 '())
	(a1 0)
	(l1 '())
	(l2 '())
	(s1 "")
	(s2 ""))

    ;; Only permorm the evaluation if the system is enabled
    (cond ((equal? (gdbs-db-eval-preference p_d1 "KB_FL") "ENABLED")
	   
	   ;; Extract the knowledge base matrix.
	   (set! a1 (gdbs-ent2my p_d1 p_e1))
	   
	   ;; Row loop.  
	   (let loop ((i1 (grsp-lm a1)))
	     (if (<= i1 (grsp-hm a1))

		 ;; See first if the status of each rule is ok.
		 ;; If the condition stated on col 1 of a1 is #t then
		 ;; apply.
		 (begin (set! s1 (array-ref a1 i1 1))

			;;(cond ((equal? (primitive-eval s1) #t)
			;;(set! s2 (array-ref a1 i1 2))
			;;(grsp-ld s2)
			;;(primitive-eval s2)))
			
			(cond ((equal? (eval-string s1) #t)
			       (set! s2 (array-ref a1 i1 2))
			       (eval-string s2)))
			
			(loop (+ i1 1)))))

	   ;; Save the updated knowledge base.
	   (gdbs-my2ent p_d1 p_e1 a1)
	   
	   ;; Return the updated list.
	   (set! res1 p_l1)))
    
    res1))


;;;; gdbs-kb-create-fl - Creates the entities of a flat file expert system
;; ub database p_d1.
;;
;; Keywords:
;;
;; - ai, intelligence, intelligent, artificial, flat, file
;;
;; Parameters:
;;
;; - p_d1: database.
;;
;; Notes:
;;
;; - The following Scheme files will be involved in this
;;   operation.
;;
;;   - File template_fl0.scm.
;;   - File [database name]_fl0.scm.
;;
;; - In file [database name]_fl0.scm you should place the
;;   expert system rules or functions belonging to the database
;;   in question.
;;
(define (gdbs-kb-create-fl p_d1)
  (let ((res1 0)
	(n1 0)
	(s1 "")
	(s2 "")
	(s3 "")
	(s4 ""))

    ;; Isolate database name from full path.
    (set! s3 (grsp-file-isolate-name p_d1))

    ;; Create replacement name.
    (set! s4 (strings-append (list s3 "_fl0") 0))
    
    ;; Load file template_fl0.scm as string s1.
    (set! s1 (read-file-as-string "template_fl0.scm"))

    ;; Replace substring "template_fl0.scm" with the name of the database.
    (set! s1 (string-replace-substring s1 "template_fl0" s4))

    ;; Create replacement file name.
    (set! s2 (strings-append (list s4 ".scm") 0))
    
    ;; Save s1 as scm file.
    (grsp-save-to-file s1 s2 "w")
    
    res1))


;;;; gdbs-kb-create-tb - Creates the entities of a gexsys (table-based)
;; expert system in database p_d1.
;;
;; Keywords:
;;
;; - ai, intelligence, intelligent, artificial
;;
;; Parameters:
;;
;; - p_d1: database.
;;
;; Notes:
;;
;; - Status should be set to ENABLED or DISABLED. Only ENABLED rules will
;;   be evaluated by the knowledge engine.
;; - Category SYSTEM is reserved.
;; Notes:
;;
;; - The following Scheme files will be involved in this
;;   operation.
;;
;;   - Entity gexsys_kb.
;;   - File template_tb0.scm.
;;   - File [database name]_tb0.scm.
;;
;; - In file [database name]_fl0.scm you should place the
;;   expert functions belonging to the database in question.
;; - In entity gexsys_kb you should place the rules used by the expert
;;   system.
;;
(define (gdbs-kb-create-tb p_d1)
  (let ((res1 0)
	(e1 "gexsys_kb"))

    ;; Create entity
    (gdbs-de-create-nm p_d1
		      e1
		      #f
		      (strings-append (list "Knowledge base for database" p_d1) 1)
		      (list "id" "rule" "action" "result" "status" "desc" "category")
		      (list "Pr key." "Rule of inference." "Action if rule true." "Result." "Status." "Description." "Category.")
		      (list "#key#num#ai" "#str" "#str" "#str" "#str" "#str" "#str")
		      (list 0 " " " " " " " " " " " "))

    ;; Update first row to place a self-deactivating test rule.
    (gdbs-de-row-updateln p_d1 e1 0 (list (list 0 0)
					 (list 1 "(equal? (array-ref a1 0 4) \"ENABLED\")")
					 (list 2 "(array-set! a1 \"DISABLED\" 0 4)")
					 (list 3 "NONE")
					 (list 4 "ENABLED")
					 (list 5 "Test rule.")				   
					 (list 6 "SYSTEM")))
        
    res1))

