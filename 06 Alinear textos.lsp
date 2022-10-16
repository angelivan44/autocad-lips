; Rutina para alinear varios textos tomando como base el primero seleccionado



;|Este es un lisp en formato original, se puede ver el c�digo fuente, la intenci�n, es de que el c�digo fuente
; pueda ser modificado y adaptado a la necesidad de cada usuario, lo �nico que siempre se solicita en estos
; casos es de que siempre se haga referencia al autor del mismo (es decir que no se modifique la autor�a del lisp),
; salvo que este se modifique ampliamente, si se construye un nuevo programa tomando como partes un lisp publicado,
; se deber�a de hacer el comentario de que parte del nuevo programa esta basado en el autor original.|;

; Programa
; ConstrucGeek 2008

(defun c:alit()

	;Para evitar en caso de cancelar apararezca el mensaje "; error: Function cancelled"
	(setq old_err *error*)(defun *error* ( a / )(princ "") (setq *error* old_err)(princ))

	(setq ents 0)
	
	(if (null LtraSDef)(setq LtraSDef "Vertical"))
	
	(initget "Vertical Horizontal")
	(setq LtraS (getkword (strcat "\nIngrese el sentido de la alineaci�n [Vertical/Horizontal]<" LtraSDef ">: ")))
	
	(if (null LtraS)(setq LtraS LtraSDef))(setq LtraSDef LtraS)
	
	;Repetir las acciones mientras se seleccione un texto base
	(while
		(setq ents(entsel "\nSeleccione la entidad base: "))
		;Si no es nula la selecci�n
		(if (not (null ents))
			(progn
				(setq ents(car ents))
				(setq ents(entget ents))
				
				;Obtenemos la justificaci�n de texto
				;Si el objeto es un texto
				(if (= (cdr (assoc 0 ents)) "TEXT")
					(progn
						(setq just (cdr (assoc 72 ents)))
						
						(cond
							((= just 0) (setq sxi 10)) 
							((= just 1) (setq sxi 11))
							((= just 2) (setq sxi 11)) 
						)
					)
					(setq sxi 10) ;Si el objeto es una linea
				)
				
				(princ "\nSeleccione las entidades a alinear:")
				
				(if (setq textos(ssget))
					(progn
					
						(setq numt(sslength textos))(setq n 0)
						
						;Repetimos las acciones el n�mero de veces de los textos seleccionados
						(repeat numt
							(setq enti(ssname textos n))
							(setq enti(entget enti))
							
							(setq just (cdr (assoc 72 enti)))
							
							(cond
								((= just 0) (setq sx 10)) 
								((= just 1) (setq sx 11))
								((= just 2) (setq sx 11)) 
							)
							
							(setq ps1(cdr(assoc sxi ents)))
							
							(if (= LtraS "Vertical")
								(setq x(car ps1)) 	;Alineaci�n vertical
								(setq y(cadr ps1)) 	;Alineaci�n horizontal
							)
							
							(setq ps2(cdr(assoc sxi enti)))
							
							(if (= LtraS "Vertical")
								(setq y(cadr ps2))	;Alineaci�n vertical
								(setq x(car ps2)) 	;Alineaci�n horizontal
							)
							
							(setq punto(list x y))
							
							(setq nent	(SUBST (CONS sx punto)(assoc sx enti)enti))
							(entmod nent)
							(setq n(+ n 1))
						)
					)
				)
				
				(setq msg (strcat (rtos numt 2 0) " textos alineados."))
				
				(princ msg)
			) ;Fin de Progn
		);Fin de If
	);Fin de While

(princ)
)


(SETVAR "modemacro" "lisphob")
















(SETVAR "modemacro" "MTP")