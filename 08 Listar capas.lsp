;|Este es un lisp en formato original, se puede ver el código fuente, la intención, es de que el código fuente
; pueda ser modificado y adaptado a la necesidad de cada usuario, lo único que siempre se solicita en estos
; casos es de que siempre se haga referencia al autor del mismo (es decir que no se modifique la autoría del lisp),
; salvo que este se modifique ampliamente, si se construye un nuevo programa tomando como partes un lisp publicado,
; se debería de hacer el comentario de que parte del nuevo programa esta basado en el autor original.|;

; Programa
; ConstrucGeek 2008

; Función ListarCapas
; Devuelve una lista con los nombres de capas ordenados alfabéticamente
; Obsérvese la posibilidad aquí demostrada de tener una función y una variable 
; con idéntico nombre en un mismo entorno. Para ello será necesario que dicha 
; variable, en este caso ListarCapas sea una variable local de la función.

;Cargar las funciones ActiveX (Visual Lisp)
(vl-load-com)

(setq AcadDocument (vla-get-ActiveDocument (vlax-get-acad-object)))
;se ejecuta previamente

(defun c:lc()
	(ListarCapas)
)

(defun ListarCapas (/ ListarCapas)
  (vlax-for objeto-VLA (vlax-get AcadDocument "Layers")
    (setq ListarCapas (cons (vlax-get objeto-VLA "Name") ListarCapas)) 
     ;el mismo nombre se utiliza para la variable local que guarda
     ;temporalmente el listado de capas.
  ) ;_ fin de vlax-for
  (acad_strlsort ListarCapas)
) ;_ fin de defun

(setvar "modemacro" "lisphob")