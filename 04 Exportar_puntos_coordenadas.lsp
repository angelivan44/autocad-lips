; Rutina que exporta puntos de coordenadas a un archivo CSV. Versión 1.0.
; Formato del archivo de puntos que genera: P,N,E,C (Punto, Norte=Y, Este=X, Cota=Z)


;|Este es un lisp en formato original, se puede ver el código fuente, la intención, es de que el código fuente
; pueda ser modificado y adaptado a la necesidad de cada usuario, lo único que siempre se solicita en estos
; casos es de que siempre se haga referencia al autor del mismo (es decir que no se modifique la autoría del lisp),
; salvo que este se modifique completamente.
; Si se construye un nuevo programa tomando como partes un lisp publicado, se debería de hacer el comentario
; de que parte del nuevo programa esta basado en el autor original.|;



(defun c:ipc()
	(princ "\nSeleccione los objetos de los cuales se exportarán las coordenadas:")
	(setq sset (ssget '((-4 . "<OR")
				(0 . "POINT") 
                (0 . "TEXT")
                (0 . "MTEXT")
                (0 . "INSERT")
                (-4 . "OR>")))
    )
    
     
  (if sset 
    (progn 
      (setq itm 0 num (sslength sset)) 
      (setq fn (getfiled "Archivo a exportar las coordenadas" "" "csv" 1)) 
      (if (/= fn nil) 
        (progn 
          (setq fh (open fn "w"))
          (write-line "PUNTO, NORTE, ESTE, COTA" fh) 
                               
          (while (< itm num) 
            (setq hnd (ssname sset itm)) 
            (setq ent (entget hnd)) 
            (setq obj (cdr (assoc 0 ent))) 

                (setq pnt (cdr (assoc 10 ent))) 
                
                (write-line (strcat (itoa (1+ itm)) "," (rtos (cadr pnt) 2 8) "," 
                               (rtos (car pnt) 2 8) "," 
                               (rtos (caddr pnt) 2 8)) fh) 

            (setq itm (1+ itm)) 
          ) 
          (close fh) 
        ) 
      ) 
    ) 
  ) 
  	(if (> itm 0)
  		(setq msg (strcat "\nListo, se exportaron " (itoa itm) " puntos."))
  		(setq msg (strcat "\nNo se exportó punto alguno."))	
	)
	
	(Alert msg)
	
  (princ) 
) 


(setvar "modemacro" "")
(princ) 
 