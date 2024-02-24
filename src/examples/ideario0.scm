#! /usr/local/bin/guile -s
!#


;; =========================================================================
;;
;; ideario0.scm
;;
;; Mamangement program for the ideario_db database. 
;;
;; Compilation:
;;
;; On a shell window simply write guile ideario00.scm<ENT>
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
;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;   GNU Lesser General Public License for more details.
;;
;;   You should have received a copy of the GNU Lesser General Public
;;   License along with this program.  If not, see
;;   <https://www.gnu.org/licenses/>.
;;
;; =========================================================================


;; Notes:
;;
;; - This programs should be used with the ideario_db database that can be
;;   created using program create_ideario_db.scm of the gdbs system.


;; Modules.
(use-modules (gdbs gdbs0)
	     (gdbs gdbs1)
	     (gdbs gdbs2)
	     (gdbs ideario_db_tb0)
	     (gdbs ideario_db_fl0)
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
	     (grsp grsp17)	     
	     (srfi srfi-19))


;; Vars. Change the path(s) to suit your system and installation.
;;
(define mc 0) 
(define db "../../dat/ideario_db")
(define opt (gconsten "opt"))
(define pdf (gconsten "pdf"))
(define bmm (gconsten "bmm"))
(define pec (gconsten "pec"))
(define nof (gconsten "notf"))
(define rni "Please enter the row number of the idea you want to review. ")
(define ideas "ideas")
(define reqs "reqs")
(define gekb "gexsys_kb")
(define l0 '())


;; enter-data - Data input function.  
;;
(define (enter-data)
  (let ((mc -1))
    
    (while (equal? #f (equal? mc 0))
	   (set! mc (grsp-menufv "Ideario - Data edition"
				 pdf
				 (list "Edit entity ideas"
				       "Edit entity requirements"
				       "Edit reqs in context of an idea"
				       "Edit knowledge base")))

	   (cond ((equal? mc 0)
		  (grsp-cd bmm))
		 ((equal? mc 1)
		  (gdbs-de-edit-selectm #t db ideas "Ideas"))
		 ((equal? mc 2)
		  (gdbs-de-edit-selectm #t db reqs "Requirements"))
		 ((equal? mc 3)
		  (view-idea-edit-reqs))
		 ((equal? mc 4)
		  (gdbs-de-edit-selectm #t db gekb "Knowledge base"))
		 (else (grsp-wrc))))))
    

;; process-data - Data processing function.
;; 
(define (process-data)
  (let ((mc -1)
	(l1 '()))
    
    (while (equal? #f (equal? mc 0))
	   (set! mc (grsp-menufv "Ideario - Data processing"
				 pdf
				 (list "Explain database"
				       "Explain entity ideas"
				       "Explain entity requirements"
				       "Update relationships"
				       "Cycle knowledge base")))
	   
	   (cond ((equal? mc 0)
		  (grsp-cd bmm))
		 ((equal? mc 1)
		  (clear)
		  (gdbs-db-explain #t db)
		  (grsp-ask pec))
		 ((equal? mc 2)
		  (clear)
		  (gdbs-de-explain #f #t db ideas)
		  (grsp-ask pec))
		 ((equal? mc 3)
		  (clear)
		  (gdbs-de-explain #f #t db reqs)
		  (grsp-ask pec))
		 ((equal? mc 4)
		  (clear)
		  (update-relationships))
		 ((equal? mc 5) 
		  (clear)

		  ;; Here we have some functions called as arguments of the
		  ;; flat-file expert system.
		  (set! l1 (kb-l1))
		  (gdbs-kb-eval-fl db l1 kb-f0 1)

		  ;; And this is a call to the entity (table) based expert
		  ;; system.
		  (gdbs-kb-eval-tb db gekb l0))		 
		 (else (grsp-wrc))))))


;; output-data - Data processing function. 
;; 
(define (output-data)
  (let ((mc -1))
    
    (while (equal? #f (equal? mc 0))
	   (set! mc (grsp-menufv "Ideario - Data output"
				 pdf
				 (list "Backup database"
				       "View ideas with requirements")))
	   
	   (cond ((equal? mc 0)
		  (grsp-cd bmm))
		 ((equal? mc 1)
		  (grsp-movc #t 0 0)
		  (gdbs-db-dat2bak #t db)
		  (grsp-askn "Backup done."))
		 ((equal? mc 2)
		  (grsp-movc #t 0 0)
		  (view-ideas-with-reqs))
		 (else (grsp-wrc))))))


;;;; view-ideas-with-reqs - Produces views of each idea with its respective
;; requirements. 
;;
(define (view-ideas-with-reqs)
  (let ((res1 0)
	(l0 '())
	(m1 0)
	(a1 0)
	(a2 0)
	(a3 0)
	(a4 0))

    (clear)
    (set! m1 (grsp-askn rni))

    ;; Get matrices.
    (set! a1 (gdbs-ent2my db ideas))
    (set! a2 (gdbs-ent2my db reqs))

    ;; Get row from ideas matrix.
    (set! a3 (grsp-matrix-row-select "#=" a1 0 m1))
    
    ;;(grsp-clear-cup 0)
    (grsp-movc #t 0 0)

    ;; Only attempt to display data if there is actually a non
    ;; empty selection from entity ideas.
    (cond ((equal? (null? a3) #f)
	   
	   ;; Display idea.
	   (gdbs-de-displaytms db ideas a3 "Idea:")
	   
	   ;; Find requirements of the selected idea.
	   (set! a4 (grsp-matrix-row-select "#=" a2 5 m1))

	   ;; Display requirements.
	   (gdbs-de-displaytms db reqs a4 "Requirements:"))
	  
	  (else (grsp-ld nof)))

    (grsp-ask-etc)
	   
    res1))


;;;; view-idea-edit-reqs - View (without editing) an idea and edit its
;; requirements. 
;;
(define (view-idea-edit-reqs)
  (let ((res1 0)
	(l0 '())
	(m1 0)
	(a1 0)
	(a2 0)
	(a3 0)
	(a4 0))

    (clear)
    (set! m1 (grsp-askn rni))

    ;; Get matrices.
    (set! a1 (gdbs-ent2my db ideas))
    (set! a2 (gdbs-ent2my db reqs))

    ;; Get row from ideas matrix.
    (set! a3 (grsp-matrix-row-select "#=" a1 0 m1))
    (grsp-movc #t 0 0)
    
    (cond ((equal? (null? a3) #f)
	   
	   ;; Display entity idea submatrix a3. 
	   (gdbs-de-displaytms db ideas a3 "Idea:")
	   
	   ;; Find requirements of the selected idea.
	   (set! a4 (grsp-matrix-row-select "#=" a2 5 m1))

	   ;; Edit entity requirements submatrix a4. 
	   (gdbs-de-edittms db reqs a4 "Requirements:"))
	  
	  (else (grsp-askn nof)))

    (grsp-ask-etc)
    
    res1))


;;;; Update relationships between entities ideas and reqs using temporary,
;; inmem matrices.
;;
(define (update-relationships)
  (let ((res1 0)
	(l1 '())
	(l2 '())
	(i2 0)
	(k1 0)
	(n1 0)
	(n4 0)
	(a1 0)
	(a2 0)
	(a3 0)
	(a4 0)
	(a5 0)
	(a6 0))

    ;; Load entities into memory.
    (grsp-ld (gdbs-gconsts "Len"))
    (set! a1 (gdbs-ent2my db ideas))
    (set! a2 (gdbs-ent2my db reqs))
    
    ;; Process. 
    (grsp-ld (gconsts "Pro"))

    ;; Create matrix to hold temporary results.
    (set! a3 (grsp-matrix-create 0 (grsp-tm a1) 5))

    ;; Copy cols 0 and 1 of all rows from a1 to a3.
    (set! a3 (grsp-matrix-subrep a3
				 (grsp-matrix-subcpy a1
						     (grsp-lm a1)
						     (grsp-hm a1)
						     0
						     1)
				 (grsp-lm a3)
				 (grsp-ln a3)))

    ;; Based on a3 count the number of total requeriments per idea and
    ;; pending requeriments per idea.
    (let loop ((i1 (grsp-lm a3)))
      (if (<= i1 (grsp-hm a3))

	  (begin (set! k1 (array-ref a3 i1 0))
		 (set! n1 (grsp-matrix-col-total-element "#=" a2 5 k1))
		 (set! a6 (grsp-matrix-row-select "#=" a2 5 k1))
		 (set! a4 (grsp-matrix-row-select "#eq" a6 2 "TODO"))
		 
		 (cond ((equal? (null? a4) #f)
			(array-set! a3 (grsp-tm a4) i1 2))
		       ((equal? (null? a4) #t)
			(array-set! a3 0 i1 2)))

		 ;; Find if there are composite rules per idea.
		 (set! a5 (grsp-matrix-row-select "#eq" a6 2 "RULE"))
		 
		 (cond ((equal? (null? a5) #f)
			(array-set! a3 (grsp-tm a5) i1 4))
		       ((equal? (null? a5) #t)
			(array-set! a3 0 i1 4)))

		 ;; Save total elements
		 (array-set! a3 n1 i1 1)

		 ;; Get the row number in a1 corresponding to the present
		 ;; key.
		 (set! i2 (grsp-matrix-row-numk a1 0 (array-ref a3 i1 0)))
		 
		 ;; Updating status in a1.
		 ;; TODO: Put these rules in gexsys_kb.

		 ;; Set status to RULE in ideas that have no
		 ;; requirements and no pending requirements.		 
		 (cond ((equal? (and (equal? (array-ref a3 i1 1) 0)
				     (equal? (array-ref a3 i1 2) 0))
				#t)
			
			(array-set! a1 "RULE" i2 2)))

		 ;; Set status to "DONE" in rows of ideas that have
		 ;; associated requirements but no pending ones.
		 (cond ((equal? (and (> (array-ref a3 i1 1) 0)
				     (equal? (array-ref a3 i1 2) 0))
				#t)

			(array-set! a1 "DONE" i2 2)))

		 ;; Set status to "RULE" in rows of ideas that have
		 ;; associated requirements that are all considered
		 ;; to be rules themselves.		 
		 (cond ((equal? (and (equal? (= (array-ref a3 i1 1)
						(array-ref a3 i1 4))
					     #t)
				     (> (array-ref a3 i1 1) 0))
				#t)
		       
			(array-set! a1 "RULE" i2 2)))

		 ;; Set status to "TODO" in rows of ideas that have
		 ;; pending requirements,		 
		 (cond ((equal? (and (equal? (and (> (array-ref a3 i1 1) 0)
						  (> (array-ref a3 i1 2) 0))
					     #t)
				     (equal? (> (array-ref a3 i1 2)
						(array-ref a3 i1 4))
					     #t))
				#t)

			(array-set! a1 "TODO" i2 2)))
			
		 (loop (+ i1 1)))))
    
    ;; Save inmem matrices to entities.
    (grsp-ld (gdbs-gconsts "Sen"))
    (gdbs-my2ent db ideas a1)
    ;;(gdbs-my2ent db reqs a2)
    
    res1))


;; Main program.
;;
(set! mc -1)

(while (equal? #f (equal? mc 0))
       (set! mc (grsp-menufv "Ideario - Main menu"
			     pdf
			     (list "Data edition"
				   "Data processing"
				   "Data output")))
       
       (cond ((equal? mc 0)
	      (grsp-cd "Bye!\n"))
	     ((equal? mc 1)
	      (enter-data))
	     ((equal? mc 2)
	      (process-data))
	     ((equal? mc 3)
	      (output-data))
	     (else (grsp-wrc))))

