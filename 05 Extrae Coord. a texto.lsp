; Obtiene las coordenadas de un punto indicado y las sitúa en los textos seleccionados.


;|Este es un lisp en formato original, se puede ver el código fuente, la intención, es de que el código fuente
; pueda ser modificado y adaptado a la necesidad de cada usuario, lo único que siempre se solicita en estos
; casos es de que siempre se haga referencia al autor del mismo (es decir que no se modifique la autoría del lisp),
; salvo que este se modifique ampliamente, si se construye un nuevo programa tomando como partes un lisp publicado,
; se debería de hacer el comentario de que parte del nuevo programa esta basado en el autor original.|;

; Programa 
; ConstrucGeek 2008

;Cargar las funciones ActiveX (Visual Lisp)
(vl-load-com)

(defun c:cor()



        (command "ucs" "" "")
	(setq PuntoCoordenada (getpoint "\nIndique el punto donde obtener la coordenada: "))
	
	(if (not (null PuntoCoordenada))
		(progn
			(setq Norte (rtos (cadr PuntoCoordenada) 2 3))
			(setq Este (rtos (car PuntoCoordenada) 2 3))
			(setq Cota (rtos (caddr PuntoCoordenada) 2 3))
	 	
			;Norte
			(setq entSupN (car (entsel "\nSeleccione el texto de reemplazar el norte: ")))
			(setq entSupvlaN (vlax-ename->vla-object entsupN))
			(vla-put-TextString entSupvlaN (strcat Norte))
			;(vla-put-TextString entSupvlaN Norte)

			;Este
			(setq entSupE (car (entsel "\nSeleccione el texto de reemplazar el este: ")))
			(setq entSupvlaE (vlax-ename->vla-object entsupE))
			(vla-put-TextString entSupvlaE (strcat  Este))
			;(vla-put-TextString entSupvlaE Este)
		
			;Cota
			(setq entSupZ (car (entsel "\nSeleccione el texto de reemplazar la cota: ")))
			(if (not (null entSupZ))
				(progn
					(setq entSupvlaZ (vlax-ename->vla-object entsupZ))
					(vla-put-TextString entSupvlaZ (strcat "COTA=" Cota))
				)
			)
		)
	)
   (princ)
)
 

(setvar "modemacro" "lisphob")