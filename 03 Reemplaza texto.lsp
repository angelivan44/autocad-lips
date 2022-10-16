; Cambia los textos seleccionados por textos seleccionados anteriormente (Visual Lisp).

; Programa 
; email: mariotorres@construcmedia.com

;|Este es un lisp en formato original, se puede ver el código fuente, la intención, es de que el código fuente
; pueda ser modificado y adaptado a la necesidad de cada usuario, lo único que siempre se solicita en estos
; casos es de que siempre se haga referencia al autor del mismo (es decir que no se modifique la autoría del lisp),
; salvo que este se modifique ampliamente, si se construye un nuevo programa tomando como partes un lisp publicado,
; se debería de hacer el comentario de que parte del nuevo programa esta basado en el autor original.|;

; ConstrucGeek 2008

;Cargar las funciones ActiveX (Visual Lisp)
(vl-load-com)

(defun c:rtex() ;Visual lisp
    ;Para evitar en caso de cancelar apararezca el mensaje "; error: Function cancelled"
    (setq old_err *error*)(defun *error* ( a / )(princ "")
    (setq *error* old_err)(princ))
    
    (setq ent (car (entsel "\nSeleccione el texto origen: ")))
    (setq entvla (vlax-ename->vla-object ent))
    (princ (strcat "<<" (vla-get-TextString entvla)">>"))
    
    (setq entSup (car (entsel "\nSeleccione el texto a reemplazar: ")))
    (setq entSupvla (vlax-ename->vla-object entsup))
    
    (vla-put-TextString entSupvla (vla-get-TextString entvla))
    
    (princ)
)

;;(setvar "modemacro" "lisphob")