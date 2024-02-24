#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; create_ideario_db.scm
;;
;; This program shows the use of gdbs functions.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile create_ideario_db.scm 
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
(define db "../../dat/ideario_db")
(define e1 "ideas")
(define e2 "reqs")
(define e3 "gekb")
(define e4 "preferences")

;; Multipurpose description.
(define s1 "Ideas para el desarrollo de proyectos.")

;; Remember what this program is about (optional).
(define q s1)

;; Create database.
(gdbs-db-create #t db s1)

(grsp-ldl "Database created. Creating entities." 1 1)

;; Create tables.

;; Creation of entity reqs.
(gdbs-de-create-nm db
		  e2
		  #f
		  "Requerimientos para poner en práctica las ideas expresadas en la entidad ideas."
		  (list "id" "item" "status" "prioridad" "desc" "idea" "costo")
		  (list "Clave primaria." "Título o breve descipción." "Estado de implementación o adquisición del requerimiento." "Prioridad." "Descripción detallada." "Id de la idea con la que se relaciona." "Costo estimado del requerimiento.")
		  (list "#num" "#str" "#str" "#num" "#str" "#num" "#num")
		  (list 0 "" "TODO" 0 "" 0 0))

(grsp-ldl "Entity reqs created." 1 1)

;; Creation of entity ideas.
(gdbs-de-create-nm db
		  e1
		  #f
		  "Ideas respecto de varios proyectos."
		  (list "id" "item" "status" "ambito" "prioridad" "desc")
		  (list "Clave primaria." "Breve descipc." "Estado de desarrollo de la idea." "Proyecto, conjunto o entorno de la idea." "Prioridad." "Descripc detallada.")
		  (list "#num" "#str" "#str" "#str" "#num" "#str")
		  (list 0 "" "TODO" "indefinido" 0 ""))

(grsp-ldl "Entity ideas created." 1 1)

;; Creation of preferences entity.
(gdbs-db-create-preferences #f "../../dat/ideario_db")

;; Creation of table knowledge base. Note that this is done with a function
;; because this is a standard entity.
(gdbs-kb-create-tb db)

;; Creation of flat file knowledge base.
(gdbs-kb-create-fl db)

;; Putting some initial data into entities. Note that their respective
;; matrices have been created with one empty row, so before inserting new
;; rows we need to update these first rows.
;; TODO Test first that these updates on row 0 work before inserting
;; anything else.

;; In ideas.
(gdbs-de-row-updateln db e2 0 (list (list 0 0)
				   (list 1 "Agregar ideas")
				   (list 2 "TODO")
				   (list 3 "indefinido")
				   (list 4 0)
				   (list 5 "Agregar algo de info ṕara probar el sistema.")))

;; In reqs.
(gdbs-de-row-updateln db e1 0 (list (list 0 0)
				   (list 1 "Agregar requerimientos")
				   (list 2 "TODO")
				   (list 3 0)
				   (list 4 "Agregar reqs para las ideas.")
				   (list 5 0)				   
				   (list 6 0)))

;; In knowledge base.
;; TODO fl.

;; In preferences, we enable the database for use (databases might be
;; created while being kept disabled, see info on entity preferences

(gdbs-de-row-updateln db e4 0 (list (list 0 0)
				   (list 1 "ENABLED")))

;; Backup.
(gdbs-db-dat2bak #t db)
(grsp-ldl "Backup of the original database structure done." 1 1)

(grsp-ldvl "Finished creating " db  1 1) 


