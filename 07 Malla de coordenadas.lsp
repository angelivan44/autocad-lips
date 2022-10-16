;|Este es un lisp en formato original, se puede ver el código fuente, la intención, es de que el código fuente
; pueda ser modificado y adaptado a la necesidad de cada usuario, lo único que siempre se solicita en estos
; casos es de que siempre se haga referencia al autor del mismo (es decir que no se modifique la autoría del lisp),
; salvo que este se modifique ampliamente, si se construye un nuevo programa tomando como partes un lisp publicado,
; se debería de hacer el comentario de que parte del nuevo programa esta basado en el autor original.|;

; 
; Constru2008

; Crear una malla de coordenadas

(DEFUN C:M4 ()
  
         (command "ucs" "" "")
         (command "-layer" "make" "Malla Coordenadas.lsp" "color" "01" "" "")
	
	(acet-error-init(list (list "cmdecho" 0  "osmode" 0 "DIMZIN" 1) T ))

	(setq osa (getvar "osmode"))
	(setvar "cmdecho" 0)
	
	(SETQ VETN NIL VETE NIL VETMAXN NIL VETMAXE NIL VETM NIL VETDY NIL VETDX NIL)
	(SETQ MALHAE NIL MALHAN NIL)
	(SETQ OP (GETINT "\nIngrese el tipo: 1 - XY , 2 - NE : "))
	(IF (= OP 1)
		(SETQ ABSC "X " ORDE "Y ")
		(SETQ ABSC "E " ORDE "N ")
	)


        ;(SETQ INTERV (GETINT "\nIntervalo de la malla: ")) CON ESTA RUTINA NO NECESITA LAS 6 SGTES.

        (setq N (getvar "useri1"));1
        (setq INTERV (getint(strcat "\nIntervalo de la malla <"(itoa N)">: ")));1
        (if (= INTERV nil);1
        (setq INTERV N);1
        (setvar "useri1" INTERV);1
        );end IF

  
	;(SETQ ALT (GETREAL "\nAltura de texto: ")) CON ESTA RUTINA ACTIVADA NO NECESITA LAS 6 SGTES DE ABAJO.

        (setq esc (getvar "userr1")); adquiero el valor de userr1 y lo agrego a esc
        (setq ALT (getdist(strcat "\nAltura de texto <"(rtos esc 2 3)">: "))); muestro en pantalla valor de esc, y a la vez lo agrego a ALT
        (if (= ALT nil); pero si ALT esta vacio realizara lo sgte:
        (setq ALT esc); a la variable ALT como esta vacio le agrego el valor de esc(que ya viene con valor desde arriba
        (setvar "userr1" ALT); luego a userr1 le agrego el valor de ALT para que al entrar de nuevo entre con el msmo valor
        );end IF


    
	(SETQ PT1 (GETPOINT "\nPrimer vértice del área:"))
	(SETQ PT2 (GETPOINT "\nSegundo vértice del área:"))
	(SETQ PT3 (GETPOINT "\nTercer vértice del área:"))
	(SETQ PT4 (GETPOINT "\nCuarto vértice del área:"))
	(SETQ ANGX (GETINT "\nAngulo de texto del eje X: "))
	(SETQ ANGY (GETINT "\nAngulo de texto del eje Y: "))
	(SETQ PTOS (LIST PT1 PT2 PT3 PT4))
	(COMMAND "STYLE" "ROMANS" "ROMANS" ALT "1" "0" "N" "N" "N" )

	(SETVAR "OSMODE" 0)
	
	(SETQ ESP " ")
	(SETQ I 0)
	(WHILE (/= I 4)
	(SETQ VETN (CONS (CADR (NTH I PTOS)) VETN))
		(SETQ VETE (CONS (CAR (NTH I PTOS)) VETE))
		(SETQ I (+ 1 I))
	)
	(SETQ VETN (REVERSE VETN) VETE (REVERSE VETE))
	(SETQ I 0)
	(WHILE (/= I 4)
		(IF (= I 3) (SETQ J 0) (SETQ J (1+ I)))
		(SETQ VETMAXN (CONS (MAX (NTH I VETN) (NTH J VETN)) VETMAXN))
		(SETQ VETMAXE (CONS (MAX (NTH I VETE) (NTH J VETE)) VETMAXE))
		(SETQ I (+ 1 I))
	)
	(SETQ VETMAXN (CONS (MAX (NTH 3 VETMAXN) (NTH 1 VETMAXN)) VETMAXN))
	(SETQ VETMAXE (CONS (MAX (NTH 3 VETMAXE) (NTH 1 VETMAXE)) VETMAXE))
	(SETQ VETMAXN (REVERSE VETMAXN) VETMAXE (REVERSE VETMAXE))
	(SETQ I 0)
	(WHILE (/= I 4)
		(IF (= I 3) (SETQ J 0) (SETQ J (1+ I)))
		(SETQ VETDY (CONS (- (NTH J VETN) (NTH I VETN)) VETDY))
		(SETQ VETDX (CONS (- (NTH J VETE) (NTH I VETE)) VETDX))
		(SETQ I (+ 1 I))
	)   
	(SETQ VETDY (REVERSE VETDY) VETDX (REVERSE VETDX))
	(SETQ I 0)
	(WHILE (/= I 4)
		(SETQ VARDX (NTH I VETDX))
		(IF (= VARDX 0.0) 
			(SETQ VARDX 0.000001)
		)
;        (SETQ VETM (CONS (/ (NTH I VETDY) (NTH I VETDX)) VETM))
		(SETQ VETM (CONS (/ (NTH I VETDY) VARDX) VETM))
		(SETQ I (+ 1 I))
	)   
	(SETQ VETM (REVERSE VETM))
	(SETQ I 0)
	(WHILE (/= I 4)
		(SETQ IN INTERV)
		(IF (= I 3) (SETQ J 0) (SETQ J (1+ I)))
		(SETQ FLAG 0)
		(WHILE (= FLAG 0)
			(SETQ X (* (FIX (/ (+ (MIN (NTH I VETE) (NTH J VETE)) IN) INTERV)) INTERV))
			(IF (> X (NTH I VETMAXE))
				(SETQ FLAG 1)
				(PROGN
					(SETQ Y (+ (NTH I VETN) (* (NTH I VETM) (- X (NTH I VETE)))))
					(SETQ PT (LIST X Y))
					(SETQ MALHAE (CONS PT MALHAE))
					(SETQ IN (+ IN INTERV))
				)
			)
		)
		(SETQ I (+ 1 I))
	)
	(SETQ MALHAE (REVERSE MALHAE))
	(SETQ QUANTI (LENGTH MALHAE))
	(SETQ I 0)
	(IF (= ANGX 90) (SETQ ACR (* (/ ALT 2) -1)) (SETQ ACR (/ ALT 2)))
	(SETQ CONTAD 1)
	(WHILE (<= CONTAD (/ QUANTI 2))
		(SETQ J (1+ I))
		(SETQ X (CAR (NTH I MALHAE)))
		(WHILE (/= X (CAR(NTH J MALHAE)))
			 (SETQ J (+ 1 J))
		)
		(COMMAND "LINE" (NTH I MALHAE) (NTH J MALHAE) "")
;       (IF (= ANGX 90) (SETQ V1 "R" V2 "") (SETQ V1 "" V2 "R"))
		(SETQ CY (MAX (CADR (NTH I MALHAE)) (CADR (NTH J MALHAE))))
		(SETQ PX (LIST (+ (CAR (NTH I MALHAE)) ACR) CY))
		(IF (= ANGX 90) 
			(COMMAND "TEXT" "R" PX ANGX (STRCAT ABSC (rtos (CAR(NTH J MALHAE)) 2 0) ESP))
			(COMMAND "TEXT" PX ANGX (STRCAT ESP ABSC (rtos (CAR(NTH J MALHAE)) 2 0)))
		)
		(SETQ CY (MIN (CADR (NTH I MALHAE)) (CADR (NTH J MALHAE))))
		(SETQ PX (LIST (+ (CAR (NTH I MALHAE)) ACR) CY))
		(IF (= ANGX 90) 
			(COMMAND "TEXT" PX ANGX (STRCAT ESP ABSC (rtos (CAR(NTH J MALHAE)) 2 0)))
			(COMMAND "TEXT" "R" PX ANGX (STRCAT ABSC (rtos (CAR(NTH J MALHAE)) 2 0) ESP))
		)
		(SETQ AUX1 NIL AUX2 NIL AUX NIL)
		(SETQ AUX1 (MEMBER (NTH (1+ I) MALHAE) MALHAE))
		(IF (/= I 0)
			(PROGN
				(SETQ PAR (NTH (1- I) MALHAE))
				(SETQ AUX (REVERSE MALHAE))
				(SETQ AUX2 (REVERSE (MEMBER PAR AUX)))
				(SETQ MALHAE (APPEND AUX2 AUX1))
			)
			(PROGN 
				(SETQ MALHAE AUX1)
			)
		)
		(SETQ AUX1 NIL AUX2 NIL AUX NIL)
		(IF (= J 1)
			(SETQ MALHAE (MEMBER (NTH J MALHAE) MALHAE))
			(PROGN
				(SETQ J (1- J))
				(IF (< (1+ J) (LENGTH MALHAE))
					(PROGN
					(SETQ AUX1 (MEMBER (NTH (1+ J) MALHAE) MALHAE))
					(SETQ PAR (NTH (1- J) MALHAE))
					(SETQ AUX (REVERSE MALHAE))
					(SETQ AUX2 (REVERSE (MEMBER PAR AUX)))
					(SETQ MALHAE (APPEND AUX2 AUX1))
					)
				)
			)
		)
	(SETQ CONTAD (1+ CONTAD))
	)
	(SETQ I 0)
	(WHILE (/= I 4)
		(SETQ IN INTERV)
		(IF (= I 3) (SETQ J 0) (SETQ J (1+ I)))
		(SETQ FLAG 0)
		(WHILE (= FLAG 0)
			(SETQ Y (* (FIX (/ (+ (MIN (NTH I VETN) (NTH J VETN)) IN) INTERV)) INTERV))
			(IF (> Y (NTH I VETMAXN))
				(SETQ FLAG 1)
				(PROGN
				(SETQ X (/ (+ (- (* (NTH I VETM) (NTH I VETE)) (NTH  I VETN)) Y) (NTH I VETM)))
				(SETQ PT (LIST X Y))
				(SETQ MALHAN (CONS PT MALHAN))
				(SETQ IN (+ IN INTERV))
				)
			)
		)
		(SETQ I (+ 1 I))
	)
	(SETQ MALHAN (REVERSE MALHAN))
	(SETQ VERI MALHAN)
	(SETQ QUANTI (LENGTH MALHAN))
	(SETQ I 0)
	(IF (= ANGY 180) (SETQ ACR (* (/ ALT 2) -1)) (SETQ ACR (/ ALT 2)))
	(SETQ CONTAD 1)
	(WHILE (<= CONTAD (/ QUANTI 2))
		(SETQ J (1+ I))
		(SETQ Y (CADR (NTH I MALHAN)))
		(WHILE (/= Y (CADR(NTH J MALHAN)))
			 (SETQ J (+ 1 J))
		)
		(COMMAND "LINE" (NTH I MALHAN) (NTH J MALHAN) "")
		(SETQ CX (MAX (CAR (NTH I MALHAN)) (CAR (NTH J MALHAN))))
		(SETQ PY (LIST CX (+ (CADR (NTH I MALHAN)) ACR)))
;        (COMMAND "TEXT" "R" PY ANGY (strcat ORDE (rtos (CADR(NTH J MALHAN)) 2 0)))
		(IF (= ANGY 180)
			(COMMAND "TEXT" PY ANGY (strcat ESP ORDE (rtos (CADR(NTH J MALHAN)) 2 0)))
			(COMMAND "TEXT" "R" PY ANGY (strcat ORDE (rtos (CADR(NTH J MALHAN)) 2 0) ESP))
		)
		(SETQ CX (MIN (CAR (NTH I MALHAN)) (CAR (NTH J MALHAN))))
		(SETQ PY (LIST CX (+ (CADR (NTH I MALHAN)) ACR)))
;        (COMMAND "TEXT" PY ANGY (strcat ORDE (rtos (CADR(NTH J MALHAN)) 2 0)))
		(IF (= ANGY 180)
			(COMMAND "TEXT" "R" PY ANGY (strcat ORDE (rtos (CADR(NTH J MALHAN)) 2 0) ESP))
			(COMMAND "TEXT" PY ANGY (strcat ESP ORDE (rtos (CADR(NTH J MALHAN)) 2 0)))
		)
		(SETQ AUX1 NIL AUX2 NIL AUX NIL)
		(SETQ AUX1 (MEMBER (NTH (1+ I) MALHAN) MALHAN))
		(IF (/= I 0)
			(PROGN
				(SETQ PAR (NTH (1- I) MALHAN))
				(SETQ AUX (REVERSE MALHAN))
				(SETQ AUX2 (REVERSE (MEMBER PAR AUX)))
				(SETQ MALHAN (APPEND AUX2 AUX1))
			)
			(PROGN 
			(SETQ MALHAN AUX1)
			)
		)
		(SETQ AUX1 NIL AUX2 NIL AUX NIL)
		(IF (= J 1)
			(SETQ MALHAN (MEMBER (NTH J MALHAN) MALHAN))
			(PROGN
				(SETQ J (1- J))
				(IF (< (1+ J) (LENGTH MALHAN))
					(PROGN
						(SETQ AUX1 (MEMBER (NTH (1+ J) MALHAN) MALHAN))
						(SETQ PAR (NTH (1- J) MALHAN))
						(SETQ AUX (REVERSE MALHAN))
						(SETQ AUX2 (REVERSE (MEMBER PAR AUX)))
						(SETQ MALHAN (APPEND AUX2 AUX1))
					)
				)
			)
		)
	(SETQ CONTAD (1+ CONTAD))
	)

        (acet-error-restore)
  
	(SETVAR "osmode" OSA)
	(setvar "cmdecho" 1)
	(setvar "modemacro" "lisphob")
	
	(princ)
)
