;;; define application package
(defpackage :sgf-analyser
  (:use :common-lisp ) 
  (:export :main))

(in-package :sgf-analyser)

;;; define game data related global variables
(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")
(defvar *libraries-path*    (concatenate 'string *app-path* "libraries/"))
(defvar *sgf-data-filename* (concatenate 'string *app-path* "game_records/" "jacekpod-coalburner.sgf"))
 
;;; load libraries
(load (concatenate 'string *app-path* "load.lisp"))

;;; other global variables
(defparameter *all-moves*  (sgf-importer:get-move-list *sgf-data-filename*))
(defparameter *header-data* (car *all-moves*))

(defun find-kv (kv-list key)
  (dolist (kv kv-list)
    (if (equal key (car kv))
	(return kv))))

(defun get-v-part (kv)
  (if (eq 1 (length (cadr kv))) 
      (caadr kv) 
      (cadr kv)))

(defun get-value (kv-list key)
  (get-v-part (find-kv kv-list key)))

(defun header-value (key)
  (get-value *header-data* key))

(defun game-stats ()
  (let ((stats " ") (new-line (format nil "~%"))) 
    (concatenate 'string "white: " (header-value "PW") " " (header-value "WR") " black: " (header-value "PB") " " (header-value "BR")
		 " board size: "  (header-value "SZ") new-line "rules: " (header-value "RU") " result: "  (header-value "RE")
		 " komi: " (header-value "KM") " handicap: " (cond  ((length (header-value "AB")) "white") 
											  ((length (header-value "AW")) "black")
											  (T nil))  
		 " " (header-value  "HA"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main ()
  (let* ( (header-value))      
    (format T "~%~%~A <<<<<<<<<<~%" *all-moves*)    
    (format t ">>>> ~S <<<<<~%" *header-data*)
    (format t "game stats:~%~A~%" (game-stats ))
    ))

;;;==================================================
(in-package :cl-user)
(sgf-analyser:main)
