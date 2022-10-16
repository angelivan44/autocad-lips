; Rutina que exporta puntos de coordenadas a un archivo CSV. Versi�n 1.0.
; Formato del archivo de puntos que genera: P,N,E,C (Punto, Norte=Y, Este=X, Cota=Z)


;|Este es un lisp en formato original, se puede ver el c�digo fuente, la intenci�n, es de que el c�digo fuente
; pueda ser modificado y adaptado a la necesidad de cada usuario, lo �nico que siempre se solicita en estos
; casos es de que siempre se haga referencia al autor del mismo (es decir que no se modifique la autor�a del lisp),
; salvo que este se modifique completamente.
; Si se construye un nuevo programa tomando como partes un lisp publicado, se deber�a de hacer el comentario
; de que parte del nuevo programa esta basado en el autor original.|;



(defun c:ipc()
	(princ "\nSeleccione los objetos de los cuales se exportar�n las coordenadas:")
	(setq sset (ssget '(
       (-4 . "<OR")
                (0 . "LWPOLYLINE")
                (0 . "INSERT")
                (-4 . "OR>")
                )
                )
    )
    
     
  (if sset 
    (progn 
      (setq itm 0 num (sslength sset))
      (setq fn (getfiled "Archivo a exportar las coordenadas" "" "csv" 1)) 
      (if (/= fn nil) 
        (progn 
          (setq fh (open fn "w"))
          (write-line "PUNTO,NORTE,ESTE,COTA" fh) 
                               
          (while (< itm num)
            
            (setq hnd (ssname sset itm))  ; retorna el nombre de la entidad segun el indice del array
            (setq ent (entget hnd)) ; retorna una lista de propiedades de la entidad
            (setq obj (cdr (assoc 0 ent))) ; retorna la coordenadas de la entidad y cdr retorna todo lo demas menos el primer
                (setq pnt (cdr (assoc 10 ent))) ; retorna el origen de la entidad
                (setq name (cdr (assoc 2 ent)))
                (setq capa (cdr (assoc 8 ent)))
                (setq datadata (vlax-ename->vla-object ( cdr (assoc -1 ent))))
                (setq thelist (vlax-get-property datadata 'coordinates))
                (setq thelist (vlax-safearray->list  (variant-value thelist)))
                (princ thelist)
                (setq coords (vl-list-length thelist))
                (setq i 0)
                (princ (/ coords 2))
                (while (> (/ coords 2) i)

                  (setq x (nth (* 2 i) thelist))  
                  (setq y (nth (+ (* 2 i) 1) thelist))
                  (princ x)
                  (princ y)
                  (write-line (strcat (itoa (+ 1 i)) "," (rtos y) "," 
                               (rtos x) ",0" 
                               ) fh) 
                (setq i (1+ i))
                )
            (setq itm (+ 1 itm))
          ) 
          (close fh) 
        ) 
      ) 
    ) 
  ) 
  	(if (> itm 0)
  		(setq msg (strcat "\nListo, se exportaron " (itoa itm) " puntos."))
  		(setq msg (strcat "\nNo se export� punto alguno."))	
	)
	
	(Alert msg)
  (princ)
	
) 


(setvar "modemacro" "")
 (princ) 
 