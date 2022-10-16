

(DEFUN C:km ();este prog. dibuja una pl con un cir. y un numero dentro; y lo incrementa
  
  (command "-LAYER" "make" "kilometraje.lsp" "color" 5 "" "");0
  (command "-style" "Standard" "romans" 0 "" "" "" "" "")
  (setvar "CLAYER" "kilometraje.lsp");0
  (setq num (getvar "useri1"));1
  (setq n (getint(strcat "\nIngrese numero inicial <"(itoa num)">:")));1
  (if (= n nil);1
    (setq n num);1
    (setvar "useri1" n);1
    );end
  (setvar "useri2" 1)
  (setq dx (getvar "useri2"));2
  (setq d (getint(strcat "\nIngrese parametro de incremento <"(itoa dx)">:")));2
  (if (= d nil);2
    (setq d dx);2
    (setvar "useri2" d);2
    );end
  
  (setq e (getvar "userr1"))
  (setq h (getdist(strcat "\nIngrese altura de texto <"(rtos e 2 3)">:")))
  (if (= h nil)
    (setq h e)
    (setvar "userr1" h)
    );end
  (setq r (+ h (/ h 0.9)))
  (setq dd (/ h 10))
  (setq num n)
  (while (setq p1 (getpoint "\nIngrese punto inicial:"))
    ;(setq p2 (getpoint p1 "\nIngrese punto de inflexión:"))
    (setq p2 (getpoint p1 "\nIngrese punto final:"))
    (setq p4 (polar p2 -89.52 (- h (/ h 4.5))))
    (setq px (distance p1 p2))
    (setq an (angle p1 p2))
    (setq pt (polar p1 an (- px r)))
    (setq tt (strcat "km"))		;cad texto
    (setq pp (polar p2 89.52 (+ (/ h 2) (/ h 4))))
    ;(command "donut" 0 dd p1 "")
    (command "line" p1 pt "")
    (command "circle" p2 r)
    (command "text" "j" "mc" pp h 0 tt "" "")
    (command "text" "j" "mc" p4 h 0 num "" "")
    (setq num (+ d num))
  )					;end while
)					;end defun
