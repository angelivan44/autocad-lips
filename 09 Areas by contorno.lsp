; Calcula las areas en los puntos indicados o en objetos seleccionados

; Programa desarrollado por Mario
; http

;|Este es un lisp en formato original, se puede ver el código fuente, la intención, es de que el código fuente
; pueda ser modificado y adaptado a la necesidad de cada usuario, lo único que siempre se solicita en estos
; casos es de que siempre se haga referencia al autor del mismo (es decir que no se modifique la autoría del lisp),
; salvo que este se modifique ampliamente, si se construye un nuevo programa tomando como partes un lisp publicado,
; se debería de hacer el comentario de que parte del nuevo programa esta basado en el autor original.|;

; Programa 
; ConstrucGeek 2008

; Inicio de actualización de esta version (7.2):  - 13 Octubre 2007
; Ultima actualización: 7.3 - 17 Octubre 2007 - 08:10 AM

;-----------------------------------------------------------------------------------------------------------------

; Cargar las funciones ActiveX (Visual Lisp)
(vl-load-com)
(setq AcadObj (vlax-get-acad-object))
(setq AcadDocument (vla-get-activedocument AcadObj))
(setq mspace (vla-get-modelspace AcadDocument))


; Función principal: Comando
  (defun c:ax()
    ;Verificar existencia del archivo acetutil.fas;arx
	(VerificarAcetutilTemp)
    
	(setq ExisteEntidades (entnext)) ;Buscar entidades en el dibujo
	(if (not (null ExisteEntidades)) ;Si existen
	  (progn ;Corra el programa
	    
	  	  ;Declaración de variables
		  (InicializarVariables)
	    	
		  ;Cuerpo
		  (Main)
			
		  ;Restablecer las variables a su estado original
		  (RestablecerVariables)		
		  
		  (acet-error-restore)
	  )
	  (acet-ui-message "Para hallar areas debe de existir entidades en el dibujo." "No se encontraron entidades" (+ (+ 0 48) 0))
	)
	(princ)
  )


; Funciones complementarias============================================================
;======================================================================================

(defun VerificarAcetutilTemp()
  (if (findfile "ai_utils.lsp")
    (if (null ai_abort)
        (if (= "not" (load "ai_utils" "not"))
            (exit)
        )
    )
    (exit)
  )
)



(defun InicializarVariables()
  
  (acet-error-init(list (list "cmdecho" 0  "osmode" 0 "DIMZIN" 1) T ))
  ;Guardamos los valores de las variables de AutoCAD para restablecerlas luego

  (setq cmd (getvar "cmdecho"))
  (setq osa (getvar "osmode"))
  (setq supr (getvar "DIMZIN"))
  

  (if (/= (getvar "Clayer") "__AX-ConstrucGeek__")
  	(setq CapaActual (getvar "Clayer"))
	(setq CapaActual "0")
  )
  
  (setq hp1 (getvar "HPANG"))
  (setq hp2 (getvar "HPBOUND"))
  (setq hp3 (getvar "HPDOUBLE"))
  (setq hp4 (getvar "HPNAME"))
  (setq hp5 (getvar "HPSCALE"))
  (setq hp6 (getvar "HPSPACE"))
    
  (setq NombreUltEntIn  (cdr (assoc 5 (entget (entlast))))) ;Tomar el nombre de la ultima entidad creada

  (setq Pin 0)
  (setq UBT 0)
  (setq AREA 0)
  (setq AreaHallada 0)
  (setq InsertoTexto 0)

  ;Variable para resumir la ruta de ubicacion en el registro de AX
  (setq ClaveAX "HKEY_CURRENT_USER\\Software\\Construcgeek.com\\AreasX.Lsp\\")
  (SETVAR "modemacro" "HOB-JD")
     
  ;Descripción por defecto
  (setq TextoDescripcion "")
  (setq metroc "")
         
  ;Verificamos en el registro de windows y los valores del cuadro de diálogo Opciones de AX
  ;================================================================================================================================
  ;Verificamos el numero de decimales
  (setq numDecimalesDef (vl-registry-read (strcat ClaveAX "Opciones") "Número de decimales"))
  (if (null numDecimalesDef)(setq numDecimalesDef 2)) ;Si no esta almacenado en el registro: Nro de decimales por defecto

  ;Verificamos el color del achurado
  (setq colAchuradoDef (vl-registry-read (strcat ClaveAX "Opciones") "Color de sombreado"))
  (if (null colAchuradoDef)(setq colAchuradoDef "136")) ;Si no esta almacenado en el registro: Color 136
  (setq colAchurado colAchuradoDef)

  ;Verificamos la escala de sombreado por defecto
  (setq eSombreadoDef (vl-registry-read (strcat ClaveAX "Opciones") "Escala de sombreado"))
  (if (null eSombreadoDef)
      (setq eSombreadoDef 0.01)
      (setq eSombreadoDef (atof eSombreadoDef))
  )

  ;Verificamos la altura de texto a insertar por defecto
  (setq hTextoDef (vl-registry-read (strcat ClaveAX "Opciones") "Altura de texto por defecto"))
  (if (null hTextoDef)(setq hTextoDef 0.2)(setq hTextoDef (atof hTextoDef)))

  ;Verificamos si se generan los sombreados
  (setq GenSombreadoDEF (vl-registry-read (strcat ClaveAX "Opciones") "Generar el sombreado"))
  (if (null GenSombreadoDEF)(setq GenSombreadoDEF "1")) ;Si se generan
  
  ;Verificamos el nombre del sombreado por defecto
  (setq NomSombreadoDEF (vl-registry-read (strcat ClaveAX "Opciones") "Nombre del sombreado"))
  (if (null NomSombreadoDEF)(setq NomSombreadoDEF "Solid"))
  
  ;Verificamos si se retiene el achurado
  (setq RetAchuradoDEF (vl-registry-read (strcat ClaveAX "Opciones") "Retener el sombreado"))
  (if (null RetAchuradoDEF)(setq RetAchuradoDEF "0"))

  ;Verificamos si se retienen los contornos
  (setq RetConfornoDEF (vl-registry-read (strcat ClaveAX "Opciones") "Retener el contorno"))
  (if (null RetConfornoDEF)(setq RetConfornoDEF "0"))
  
   
  ;Crea la capa por defecto de los objetos temporales
  (CrearCapa "__AX-ConstrucGeek__")
  
      
  (setq Msg "\nIndique un punto interno del área o [Seleccionar objeto/Opciones]<terminar>: ")
  
)

;Principal
;======================================================================================
(defun Main()
  (while (not (null Pin))
  (initget "Seleccionar Decimales Hatch Insertar HTexto Opciones Color")
  (setq Pin (getpoint msg))

        (Cond
		;Se indicó un punto en pantalla
		((EQ (type Pin) 'LIST)
			(command "_-boundary" "_a" "_o" "_r" "_i" "_n" "" "" Pin "")
			(setq NombreBOtEnt(cdr (assoc 5 (entget (entlast))))) ;Obtenemos el nombre de la ultima entidad creada
			(setq TipoBOtEnt (cdr (assoc 0 (entget (entlast)))))
		 	(setq ent (entlast))
		   		   
			;Si este nombre coincide con el almacenado al inicio del comando significa que no se ha creado ningun contorno
		   	;por lo tanto no se llevan cabo las acciones
		   	(if (and (/= NombreBOtEnt NombreUltEntIn) (/= "HATCH" (cdr (assoc 0 (entget (entlast))))))
				 (progn
				   (HallarArea ent)
				   (if (= GenSombreadoDEF "1")
				   	   (SombrearObjeto ent)
				   )
				 )
				 (acet-ui-message (strcat "El punto que a indicado no se encuentra en el interior de una área cerrada, ó debe de aproximarse mas a ella." "\nIndique un punto en el interior de un contorno válido.") "Indique un punto interno válido" (+ (+ 0 64) 0))
			 )
	    )

		;Si se indico la opcion "Objeto"
	    ((= Pin "Seleccionar")
			(setq EntObjeto (ENTSEL "\nSeleccione las entidades polilínea a obtener el área: "))
		 		(if (not (null EntObjeto))
			    	(progn
		 				(HallarArea (car EntObjeto))
		 				(if (= GenSombreadoDEF "1")
				   	   		(SombrearObjeto (car EntObjeto))
				   		)
			    	) ;Progn
			 	) ;If
		)

		;Opcion "Insertar Texto"
		 ((= PIN "Insertar")
		  (if (/= Area 0)
			(progn
			  	  (setq UBT (GETPOINT "\nUbicación del texto de área:"))
			  	 
			  		(if (not (null UBT))
					  (progn
						  (setvar "Clayer" CapaActual)
						  (setq TextoAreaI (vla-AddText mspace (STRCAT "Area = " (RTOS AREA 2 NUMDECIMALESDEF) " m2") (vlax-3d-point (trans UBT 1 0)) HTEXTODEF))
						  (setq MSG "\nIndique un punto interno del área o [Seleccionar objeto/Opciones]<terminar>: ")
						  (command "_-layer" "_S" "__AX-ConstrucGeek__" "")
					   )
				    )
			  	 (setq InsertoTexto 1) ;Se inserto un texo
			  	 (setq AREA 0)
			)
			(acet-ui-message (strcat "Para poder insertar un texto con el área debe de" "\nhallar una nueva área de un contorno válido.") "Halle una área nueva" (+ (+ 0 64) 0))
		  	)
		 )


		;Si se indico la opcion "oPciones"
		 ((OR (= PIN "Opciones") (= PIN "Decimales")(= PIN "Color")(= PIN "Hatch")(= PIN "HTexto"))
		      (Opciones)
		 )
	 

		 ;Se presionó enter y no se ha hallado ninguna aerea hasta el momento
		 ((and (null pin) (= AREA 0))
		  (progn
		   	(setq Pin nil)
		    (if (= InsertoTexto 1) ;Si se inserto un texto al finalizar tambien se deben de borrar los objetos de sombreado
			    (BorrarObjetos)
			    (BorrarCapa) ;Si no solo borrar la capa temporal
			)
		  )
		  (princ)
	    )
		
 	 	;Se presionó enter y se ha hallado aerea 		
		((and (null pin) (/= AREA 0))
		  (progn
	       	(CambiarTexto)
	       	(BorrarObjetos)
		  )
	    )
	  );Cond
    );While
);Defun



(defun HALLARAREA (EntArea)

  	(SETQ ObjArea (vlax-ename->vla-object EntArea))
  	(if (vlax-property-available-p ObjArea 'Area)
	  (progn
	  	(setq AREAHALLADA (vlax-get-property objArea "Area"))
	    (setq AREA (+ AREA AREAHALLADA))
		(setq PRINA (STRCAT "\n\nArea hallada = " (RTOS AREAHALLADA 2 NUMDECIMALESDEF) " m2;  Acumulada = " (RTOS AREA 2 NUMDECIMALESDEF) " m2"))
		(setq PRINTOTAL (STRCAT "\n\nArea Acumulada = " (RTOS AREA 2 NUMDECIMALESDEF) " m2"))
		(PRINC PRINA)
		(setq MSG "\nIndique un punto interno del área o [Seleccionar objeto/Insertar texto área/Opciones]<cambiar texto>: ")
	  )
	  (acet-ui-message (strcat "El objeto seleccionado no contiene un área." "\nSeleccione un objeto del cual se pueda obtener su área." ) "Seleccione un objeto válido" (+ (+ 0 64) 0))
	)
)



(Defun SombrearObjeto (EntSomb)
  	(setq TIPOOBJETO (CDR (ASSOC 0 (ENTGET EntSomb))))
	;Filtramos los objetos permitidos
	(If (or (= TIPOOBJETO "LWPOLYLINE")(= TIPOOBJETO "ELLIPSE")(= TIPOOBJETO "CIRCLE")(= TIPOOBJETO "REGION"))
	  	(progn
			;(command "-hatch" "O" "S" (strcat (rtos (car Pin) 2 3)"," (rtos (cadr pin) 2 3)) "N" "P" "ansi31" eSombreadoDef "0" "S" EntSomb "")
		  	(command "_hatch" NomSombreadoDEF eSombreadoDef "0" EntSomb "")
			(command "_change" "_l" "" "_p" "_c" colAchuradoDef "")
		)
	 )
)


(defun CAMBIARTEXTO()
  (setq ENT (ENTSEL "\nSeleccione el texto o atributo a cambiar la medida <Mostrar>: "))
  (if (not (null ent))
	(progn
		(setq TIPOOBJETO (CDR (ASSOC 0 (ENTGET (CAR ENT)))))
	  
		(COND
		  	((or (= TIPOOBJETO "TEXT") (= TIPOOBJETO "MTEXT"))
				(setq NENT (CAR ENT))
				(setq ENTTEXTSEL (vlax-ename->vla-object NENT))
				(setq TEXTO (vla-get-TextString ENTTEXTSEL))
			 
				(cond
				  ((wcmatch TEXTO "*=*")
					(setq UBI= (VL-STRING-POSITION (ASCII "=") TEXTO))
				  )
				  ((wcmatch TEXTO "*:*")
					(setq UBI= (VL-STRING-POSITION (ASCII ":") TEXTO))
				  )
				  ((and (not (wcmatch TEXTO "*=*"))(not(wcmatch TEXTO "*:*")))
				   (setq UBI= nil)
				  )
				)
			  	
				(if (not (null UBI=))
				  (progn
					    (setq DespuesDeIgual (SUBSTR TEXTO (+ UBI= 2) (strlen texto)))
					    (if (wcmatch DespuesDeIgual " *")
					  		(setq TEXTODESCRIPCION (strcat (SUBSTR TEXTO 1 (+ UBI= 1)) " "))
						  	(setq TEXTODESCRIPCION (SUBSTR TEXTO 1 (+ UBI= 1)))
						)
				    		(if (wcmatch DespuesDeIgual "* m*")
					  		(setq metroc " m2")
						  	(progn
		  				    		(if (wcmatch DespuesDeIgual "*m*")
					  				(setq metroc "m2")
						  			(setq metroc "")
								)
							)
						)

				  )
				  (setq TEXTODESCRIPCION "" metroc "")
				)
								
						
				(vla-put-TextString ENTTEXTSEL (strcat TEXTODESCRIPCION (rtos AREA 2 NUMDECIMALESDEF) metroc))
				
			)

	  		((= TIPOOBJETO "INSERT")
			  	(SETQ ObjBloque (vlax-ename->vla-object (car ENT)))
			    	(if (equal (vlax-get-property objBloque "HasAttributes") :vlax-true)
	    				(progn
						(setq UBIATRIBUTO (CADR ENT))
						(command "_-ATTEDIT" "" "" "" "" UBIATRIBUTO "" "_v" "_R" (RTOS AREA 2 NUMDECIMALESDEF) "_n")
					 )
				  	 (acet-ui-message "El bloque seleccionado no tiene atributos." "Error de selección" (+ (+ 0 64) 0))
			    	)
			)
	  
		  	((AND (/= TIPOOBJETO "TEXT") (/= TIPOOBJETO "MTEXT")(/= TIPOOBJETO "INSERT"))
			 	(acet-ui-message "Debe de seleccionar un TEXTO O ATRIBUTO para reemplazarlo por el área hallada." "Error de selección" (+ (+ 0 64) 0))
		    	(CAMBIARTEXTO)
			)
	 	)	  
	 )
    
	(progn
		(setq PRINTOTAL (STRCAT "\n\nArea = " (RTOS AREA 2 NUMDECIMALESDEF) " m2"))
		(princ PRINTOTAL)
	)
    
  ) ;If
);Defun 



(defun CrearCapa(NombreCapa)
  (setq NombreCapaObj (vl-catch-all-apply 'vla-add (list (vla-get-layers AcadDocument) NombreCapa)))
  ;(vla-put-color NombreCapaObj colAchuradoDef)
  (vla-put-color NombreCapaObj "30")
  (command "_-layer" "_S" NombreCapa "") 
)


(defun CrearCapaPerman(NombreCapa ColorCapa)
  (setq NombreCapaObjPerman (vl-catch-all-apply 'vla-add (list (vla-get-layers AcadDocument) NombreCapa)))
  (vla-put-color NombreCapaObjPerman ColorCapa)
  (command "_-layer" "_S" NombreCapa "") 
)

													  
(defun BORRAROBJETOS ()

  (IF (= RetAchuradoDef "0") ;Si se ha elegido no retener el sombreado despues de arear
    (progn
		(setq conj (ssget "x" (list (cons 8 "__AX-ConstrucGeek__") (cons 0 "HATCH"))))
  		(if (not (null conj))(command "_Erase" conj ""))
    )   
  ) ;IF
  

  (IF (= RetConfornoDEF "0") ;Si se ha elegido no retener el contorno despues de arear
    (progn
		(setq conj (ssget "x" (list (cons 8 "__AX-ConstrucGeek__") (cons 0 "REGION"))))
  		(if (not (null conj))(command "_Erase" conj ""))
    )
  )
  

  (IF (and (= RetAchuradoDef "0")(= RetConfornoDEF "0"))
  	(BorrarCapa)
  	(BuscarYCambiarCapa "SombreadoAreas" colAchuradoDef)
  )
  
) ;Defun



(Defun BuscarYCambiarCapa(NombreCapaBusCrear ColorCapa)
	(setq CapaSombreadoAreas (tblsearch "LAYER" NombreCapaBusCrear T)) ;Buscamos la capa
	(if (null CapaSombreadoAreas) ;Si no existe la capa "SombreadoAreas" la creamos
		(crearCapaPerman NombreCapaBusCrear ColorCapa)
	)
	(setq conj (ssget "x" (list (cons 8 "__AX-ConstrucGeek__")))) ;Cambiamos los achurados a la nueva capa creada
	(if (not (null conj))(command "_change" conj "" "_p" "_LA" NombreCapaBusCrear ""))
	(BorrarCapa)
)


; (defun BorrarCapa();(NombreCapa)
;   (setvar "Clayer" CapaActual)
;   (vla-delete NombreCapaObj)
;   (princ "3")
; )

(defun BorrarCapa () 
	(setvar "Clayer" CapaActual)
	(if (vl-catch-all-error-p (vl-catch-all-apply 'vla-delete (list (vl-catch-all-apply 'vla-item (list (vla-get-layers AcadDocument) "__AX-ConstrucGeek__"))))) 
		nil ; name cannot be purged or doesn't exist 
		T ; name purged 
	) 
) 


 ;Crear el archivo temporal de definición de cuadros de diálogo
(defun Crear_CuadroDialogoOpciones ( / fn Cuadro1A Cuadro1B Cuadro2 Cuadro3A Cuadro3B Cuadro4)

  (setq fname (vl-filename-mktemp "Ax.dcl"))
  (setq fn (open fname "w"))

  (setq Cuadro1A "dlg_AreasX : dialog {
	  label = \"AreasX 7.3\";
	  : boxed_column {
		label=\"Areas\";
	    : column {
	    	: edit_box { key = \"txtNumeroDecimales\"; fixed_height = true; allow_accept = true; fixed_width = true; alignment = center; label = \"Número de decimales     \"; mnemonic = \"N\";}
	      	: edit_box { key = \"txtAlturaTexto\"; fixed_height = true; allow_accept = true; fixed_width = true; alignment = center; label = \"Altura del texto a insertar\"; mnemonic = \"A\";}
	     }	     
	     spacer;
	  } 
	  
	  
	  : boxed_column {
	    label= \"Sombreado \";
	    
	    : toggle {
	    	label = \"Aplicar sombreados\";
	       	key = \"chkSombrearAreas\";
	       	mnemonic = \"S\";
	       	fixed_width = true;
	    }

     	
     	: edit_box { key = \"txtNomSombreado\"; fixed_height = true; allow_accept = true; fixed_width = true; alignment = center; label = \"Nombre del sombreado  \"; mnemonic = \"o\";}
 	    
	    spacer;
 	    : row {
	    	: edit_box { key = \"txtEscalaHatch\"; fixed_height = true; allow_accept = true; fixed_width = true; alignment = center; label = \"Escala  \"; mnemonic = \"E\";}	       
	  		: text {label = \"Color\"; key = \"lblColor\";}
	  		
			: image_button {
		  		key = \"imagenColor\";
		  		color = 0;
		  		fixed_height = true;
		  		fixed_width = true;
		  		width = 9.3;
		  		height = 1.5;
			}
     	    }
     	    spacer;
     	}" )
     	     
     (setq Cuadro1B	"
	: boxed_column {
	 label= \"Terminado el areado \";
        : toggle {
	    	label = \"Retener los contornos\";
	       	key = \"chkRetContorno\";
	       	mnemonic = \"c\";
	       	fixed_width = true;
	    }

     	spacer;
     	
	   : toggle {
	    	label = \"Retener el sombreado\";
	       	key = \"chkRetSombreado\";
	       	mnemonic = \"R\";
	       	fixed_width = true;
	    }
		spacer;   
	  }

	  spacer_1; 
	   
	  : row {
	  	fixed_width=true;
	  	alignment = centered;
	    : button { fixed_width=true; is_default=true; key=\"accept\"; label= \"Aceptar\";  mnemonic = \"A\"; }    
	    : button { fixed_width=true; is_cancel=true; key=\"cancel\"; label= \"Cancelar\";  mnemonic = \"C\"; }    
	    : button { fixed_width=true; is_cancel=false; key=\"Acerca\"; label= \"Acerca...\";  mnemonic = \"r\"; }    
	  }
	  spacer; 	  
	}" )
  

  	(setq Cuadro2 "dlg_GruposParam : dialog {
    	label = \"Configuración de Grupos de parámetros\";
    	spacer;

      	: column {
      		: text {label=\" Grupo de parámetros actual:\";}
      		: text {key=\"lblGrupoParamActual\"; label=\"\"; alignment=left;}
      	}
      	spacer_1;

    	: boxed_column {
    		label=\"Grupos de parámetros \";

    		: row {
    			: list_box {
    	  			label = \"\";
	  				key = \"listaGrupos\";
	  				height = 10;
	  				width=40;
	  				multiple_select = false;
				}
				: column {
	      			fixed_height=true;
	      			alignment=top;
	     			: button {width=7; key=\"cmdActual\"; is_default=false; label= \"Actual\";mnemonic = \"c\";}
	     			: button {width=7; key=\"cmdNuevo\"; is_default=true; label= \"Nuevo...\";mnemonic = \"N\";}
	     			: button {width=7; key=\"cmdEditar\"; is_default=false; label= \"Editar...\";mnemonic = \"E\";}
	     			: button {width=7; key=\"cmdEliminar\"; is_default=false; label= \"Eliminar\";mnemonic = \"l\";}	     			
	     			: row {
	     				: button {width=7; key=\"cmdImportar\"; is_default=false; label= \"<...\";mnemonic = \"<\";}
	     				: button {width=7; key=\"cmdExportar\"; is_default=false; label= \">...\";mnemonic = \">\";}	     				
	     			}
				}
  			}
             
  			spacer;

  			: row {
	  			: text_part { key=\"lblDescripcion\"; label=\" Descripción: \"; }
	  			: text_part { key=\"DescripcionGrupo\"; label=\"\";}
  			}
  			
	 		spacer_1;

   		} //Boxed_Column
   
   		spacer;
   
   		: row {
     		fixed_width=true;
     		alignment=right;
	   
    		: button {
      	  		fixed_width=true;
      	  		key=\"accept2\";
      	  		is_default=true;
          		label= \"Aceptar\";
          		mnemonic = \"A\";
    		}
    		: button {
      	  		fixed_width=true;
      	  		is_cancel=true;
      	  		key=\"cancel2\";
      	  		label= \"Cancelar\";
      	  		mnemonic = \"C\";
    		}
    	}
    	spacer;
 	}" )

  (setq Cuadro3 "dlg_NuevoGrupoParam : dialog {
    	label = \"Nuevo Grupo de parámetros\";
    	spacer;

		: column {
			fixed_widht = true;
			children_alignment=true;
    		: edit_box { key = \"txtNombreNuevoGrupo\"; allow_accept = false; width = 50; fixed_width = true; alignment = right; label = \" Nombre:       \"; mnemonic = \"N\";}
    		: edit_box { key = \"txtDescripcionNuevoGrupo\"; allow_accept = true;   width = 50; fixed_width = true; alignment = right; label = \" Descripción: \"; mnemonic = \"D\";}
    		spacer_1;
		}
   		
    	spacer;
  
  		: row {
     		fixed_width=true;
     		alignment=right;
	   
		    : button {
      			fixed_width=true;
      			key=\"accept3\";
      			is_default=true;
      			label= \"Aceptar\";
      			mnemonic = \"A\";
    		}
    		: button {
      			fixed_width=true;
      			is_cancel=true;
      			key=\"cancel3\";
      			label= \"Cancelar\";
      			mnemonic = \"C\";
    		}
  		}
  		spacer; 
	}" )
	
	
	(setq Cuadro4A "dlg_ParametrosGrupo : dialog {
    	label = \"Definición de Parámetros de sombreado del Grupo\";
   		
    	spacer;
    	
    	: column {
      		: edit_box { key = \"txtNombreNuevoGrupo\"; allow_accept = false; width = 60; fixed_width = true; alignment = left; label = \" Nombre:       \"; mnemonic = \"N\";}
    		: edit_box { key = \"txtDescripcionNuevoGrupo\"; allow_accept = false;   width = 60; fixed_width = true; alignment = left; label = \" Descripción: \"; mnemonic = \"D\";}
    		spacer;
      	}
      	
    	spacer_1;

    	: boxed_column {
      		label=\"Parámetros de sombreado del Grupo \";
    	
    		: row {
    			: list_box {
    	  			label = \"\";
	  				key = \"listaParametros\";
	  				height = 10;
	  				width=42;
	  				multiple_select = false;
				}
				: column {
	      			fixed_height=true;
	      			alignment=top;
	     			spacer_1;
	     			: button {width=7; key=\"cmdAgregarParametro\"; is_default=true; label= \"Agregar...\";mnemonic = \"g\";}
	     			: button {width=7; key=\"cmdEditarParametro\"; is_default=false; label= \"Editar...\";mnemonic = \"E\";}
	     			: button {width=7; key=\"cmdQuitarParametro\"; is_default=false; label= \"Quitar\";mnemonic = \"Q\";}
	     			: button {width=7; key=\"cmdMuestraParametro\"; is_default=false; label= \"Muestra...\";mnemonic = \"M\";}
				}
    		}     
    		spacer_1;
    		   	   		
    		: row {
  				fixed_width=true;
     			alignment=Left;
     			     			
	  			: text_part {
	    			key=\"descripcionArea\";
	    			label=\"                                                      \";
	  			}
  			}

  			spacer;
  
  			: row {
    			fixed_width=true;
     			alignment=Left;
     	
	  			: text_part {
	    			key=\"patronAchurado\";
	    			label=\"                                                     \";
	  			}
  			}
  			spacer;")
  
  	(setq Cuadro4B ": row {
    			fixed_width=true;
     			alignment=Left;
     	
	  			: text_part {
	    			key=\"CapaAchurado\";
	    			label=\"                                                      \";
	  			}
  			}
 			spacer_1;
 		}
 		spacer_1;   
  
  		: row {
     		fixed_width=true;
     		alignment=right;
	   
		    : button {
      			fixed_width=true;
      			key=\"accept4\";
      			is_default=true;
      			label= \"Aceptar\";
      			mnemonic = \"A\";
    		}
    		: button {
      			fixed_width=true;
      			is_cancel=true;
      			key=\"cancel4\";
      			label= \"Cancelar\";
      			mnemonic = \"C\";
    		}
  		}
  		spacer; 
	}" )


  (setq Cuadro5 "dlg_AgregarParamGrupo : dialog {
   	label = \"Agregar parámetros de sombreado\";

    spacer_1;
    : text_part {key=\"lblDescripArea\"; label=\" Descripción del área:\";}	  
    : edit_box { key = \"txtDescripArea\"; fixed_height = true; allow_accept = true; width = 40; alignment = center; label = \"\"; mnemonic = \"D\";}
    
    spacer_1;
    : text_part {key=\"lblPatronSombre\"; label=\" Nombre del patrón de sombreado:\";}	  
    : edit_box { key = \"txtPatronSombre\"; fixed_height = true; allow_accept = true; width = 40; alignment = center; label = \"\"; mnemonic = \"P\";}

    spacer_1;
    : text_part {key=\"lblNombreCapa\"; label=\" Nombre de la capa a cambiar el sombreado:\";}	  
    : edit_box { key = \"txtNombreCapa\"; fixed_height = true; allow_accept = true; width = 40; alignment = center; label = \"\"; mnemonic = \"N\";}
    
    spacer_1;
      
  	: row {
    	fixed_width=true;
     	alignment=right;
	   
    	: button {
      		fixed_width=true;
      		key=\"accept5\";
      		is_default=true;
      		label= \"&Aceptar\";
    	}
    	: button {
      		fixed_width=true;
      		is_cancel=true;
      		key=\"cancel5\";
      		label= \"&Cancelar\";
    	}
  	}
  	spacer;
	}")
    
	
	(setq Cuadro6 "dlg_ImportarParam : dialog {
    	label = \"Importar grupo de parámetros\";

    	spacer_1;
    	: text {label=\" El Grupo de parámetros que se desea importar ya existe.\";}
    	spacer_1;

    	: boxed_radio_column {
    		fixed_width=true;
     		alignment=left;     	
     		label=\" Confirme lo que desea hacer\";
    		
     		: radio_button {label = \" Eliminar el Grupo de parámetros existente e importar el seleccionado.\";key = \"optEliminar\"; }
			: radio_button {label = \" Reemplazar los parámetros existentes y agregar los nuevos.\";key = \"optReemplazar\"; }
			: radio_button {label = \" Solo agregar los parámetros que no existan en el Grupo existente.\";key = \"optAgregar\"; }
			: radio_button {label = \" Dejar de importar el Grupo seleccionado.\";key = \"optDejar\"; }
    	}
    	spacer_1;
      
  		: row {
     		fixed_width=true;
     		alignment=right;
	   
    		: button {
      			fixed_width=true;
      			key=\"accept6\";
      			is_default=true;
      			label= \"&Aceptar\";
    		}
  		}

  		spacer;
	}")


     
	(setq Cuadro7  "dlg_Acerca: dialog {
    	label = \"Acerca de AreasX\";

		:paragraph {
    		spacer_1;
    		: text {label=\" Programa AreasX, Versión 7.3, Comando: AX\";}
    		spacer_1;
    		: text {label=\" Lisp Desarrollado por Mario Torres P. 1999-2007\";}
    		: text {label=\" Web: hob\";}
    		: text {label=\" Inicio de actualización de esta versión: 17 Octubre 2007\";}
    		: text {label=\" Ultima actualización: 17 Octubre 2007 - 08:10 AM\";}
    	}
    
  		spacer_1;       
  		: row {
     		fixed_width=true;
     		alignment=right;
			
    		: button {
      			fixed_width=true;
      			width=13;
      			key=\"accept7\";
      			is_default=true;
      			label= \"&Aceptar\";
    		}
  		}
  		
  		
  	spacer;
	}")


	(write-line Cuadro1A fn)(write-line Cuadro1B fn)(write-line Cuadro2 fn)(write-line Cuadro3 fn)(write-line Cuadro4A fn)(write-line Cuadro4B fn)(write-line Cuadro5 fn)(write-line Cuadro6 fn)(write-line Cuadro7 fn)
	(close fn)

);defun



;CUADRO DE DIALOGO OPCIONES (PRINCIPAL)
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
(defun Opciones()
	(crear_CuadroDialogoOpciones)
 	(setq ind (LOAD_DIALOG fname));(Cargar_CuadroOpciones)
 	(if (not (new_dialog "dlg_AreasX" ind))(exit))
 	(valoresOpciones)
 	(accionesOpciones)
 	(START_DIALOG)

 	(UNLOAD_DIALOG ind)

 	(vl-file-delete fname)
   
 	(princ)
)

(defun valoresOpciones ()
  ; Se define los valores por defecto.
  
  (SET_TILE "txtNumeroDecimales" (ITOA numDecimalesDef))
  (MODE_TILE "txtNumeroDecimales" 2)
  
  (SET_TILE "txtAlturaTexto" (Rtos hTextoDef))
  (MODE_TILE "txtAlturaTexto" 3)
  
  (SET_TILE "chkSombrearAreas" GenSombreadoDEF)
  
  (SETQ ACTDESOM (- 1 (atoi GenSombreadoDEF))) (MODE_TILE "txtNomSombreado" ACTDESOM) (MODE_TILE "txtEscalaHatch" ACTDESOM) (MODE_TILE "imagenColor" ACTDESOM) (MODE_TILE "lblColor" ACTDESOM) (MODE_TILE "chkRetSombreado" ACTDESOM) 
  
  
  (SET_TILE "txtNomSombreado" NomSombreadoDEF)
  
  (SET_TILE "txtEscalaHatch" (Rtos eSombreadoDef))
  
  (MODE_TILE "txtEscalaHatch" 3)
  (SET_TILE "chkRetContorno" RetConfornoDEF)
  
  (SET_TILE "chkRetSombreado" RetAchuradoDEF)
   
  (setq ancho (DIMX_TILE "imagenColor") alto(DIMY_TILE "imagenColor"))
  (START_IMAGE "imagenColor")
  (FILL_IMAGE 0 0 ancho alto (atoi colAchuradoDef))
  (END_IMAGE)

)


(defun accionesOpciones()
    
  (ACTION_TILE "imagenColor" "(SeleccionarColor)")

  ;(ACTION_TILE "chkRetSombreado" "(SETQ ACTDES (- 1 (atoi $Value)))(ActivarDesactivarPatrones)")
  (ACTION_TILE "chkSombrearAreas" "(SETQ ACTDESOM (- 1 (atoi $Value))) (MODE_TILE \"txtNomSombreado\" ACTDESOM) (MODE_TILE \"txtEscalaHatch\" ACTDESOM) (MODE_TILE \"imagenColor\" ACTDESOM) (MODE_TILE \"lblColor\" ACTDESOM) (MODE_TILE \"chkRetSombreado\" ACTDESOM) ")
    
  (ACTION_TILE "accept" "(chequearErr) (IF erroresChek () (Aceptar))")
  (ACTION_TILE "cancel" "(DONE_DIALOG)")
  (ACTION_TILE "Acerca" "(acercade)")
)



(defun SeleccionarColor()
  (setq colAchurado (acad_colordlg (ATOI colAchurado)))
 
  (if (null colAchurado)
      (setq colAchurado colAchuradoDef)
      (progn
	 	(setq colAchurado (ITOA colAchurado))
	 	(START_IMAGE "imagenColor")
  	 	(FILL_IMAGE 0 0 ancho alto (ATOI colAchurado))
  	 	(END_IMAGE)
      )
  )
)


(Defun chequearErr()
  (SETQ erroresChek nil)
  ;Numero de decimales
  (if (< (ATOI (GET_TILE "txtNumeroDecimales")) 0)
    (progn
      (SETQ erroresChek T)
      (acet-ui-message "El número de decimales para las areas no puede ser menor que 0." "Error en los decimales para areas" (+ (+ 0 64) 0))
      (MODE_TILE "txtNumeroDecimales" 2)
    )
  )
  
  (if (<= (ATOF (GET_TILE "txtAlturaTexto")) 0)
    (progn
      (SETQ erroresChek T)
      (acet-ui-message "La altura del texto a insertar no puede ser 0 ó menor que 0." "Error en la altura de texto" (+ (+ 0 64) 0))
      (MODE_TILE "txtAlturaTexto" 2)
    )
  )
    
  (if (<= (ATOF (GET_TILE "txtEscalaHatch")) 0)
    (progn
      (SETQ erroresChek T)
      (acet-ui-message "La escala del achurado no puede ser 0 ó menor que 0." "Error en la escala de achurado" (+ (+ 0 64) 0))
      (MODE_TILE "txtEscalaHatch" 2)
    )
  )
     
)



(defun aceptar()

  (SETQ NUMDECIMALESDEF (ATOI (GET_TILE "txtNumeroDecimales")))
  (VL-REGISTRY-WRITE (strcat ClaveAX "Opciones") "Número de decimales" NUMDECIMALESDEF)
  
  (SETQ HTEXTODEF (ATOF (GET_TILE "txtAlturaTexto")))
  (VL-REGISTRY-WRITE (strcat ClaveAX "Opciones") "Altura de texto por defecto" (rtos HTEXTODEF 2 3))
  
  (setq GenSombreadoDEF (GET_TILE "chkSombrearAreas"))
  (VL-REGISTRY-WRITE (strcat ClaveAX "Opciones") "Generar el sombreado" GenSombreadoDEF)  
  
  (SETQ NomSombreadoDEF (GET_TILE "txtNomSombreado"))
  (VL-REGISTRY-WRITE (strcat ClaveAX "Opciones") "Nombre del sombreado" NomSombreadoDEF)
  
  (setq ESOMBREADODEF (ATOF (GET_TILE "txtEscalaHatch")))
  (VL-REGISTRY-WRITE (strcat ClaveAX "Opciones") "Escala de sombreado" (rtos ESOMBREADODEF 2 3))

  (setq RetConfornoDEF (GET_TILE "chkRetContorno"))
  (VL-REGISTRY-WRITE (strcat ClaveAX "Opciones") "Retener el contorno" RetConfornoDEF)
    
  (setq RetAchuradoDEF (GET_TILE "chkRetSombreado"))
  (VL-REGISTRY-WRITE (strcat ClaveAX "Opciones") "Retener el sombreado" RetAchuradoDEF)
  
  (setq colAchuradoDef colAchurado)
  (VL-REGISTRY-WRITE (strcat ClaveAX "Opciones") "Color de sombreado" colAchuradoDef)
  
  (DONE_DIALOG 1)
)

;Cuadro de mensaje tipo Visual Basic
(defun Msgbox (Mensaje Titulo Tipo Icono BotonDefecto / Respuesta)
  
  (setq acet-id (acet-ui-message  Mensaje Titulo (+ (+ Tipo Icono) BotonDefecto)))
   
  (cond 
	((= acet-id 1) (setq Respuesta "OK"))
	((= acet-id 2) (setq Respuesta "CANCEL"))
	((= acet-id 3) (setq Respuesta "ABORT"))
	((= acet-id 4) (setq Respuesta "RETRY"))
	((= acet-id 5) (setq Respuesta "IGNORE"))
	((= acet-id 6) (setq Respuesta "YES"))
	((= acet-id 7) (setq Respuesta "NO"))
	((= acet-id 8) (setq Respuesta "CLOSE"))
	((= acet-id 9) (setq Respuesta "HELP"))
	;(t nil)
	)
)


(defun RESTABLECERVARIABLES ()
	(SETVAR "HPANG" HP1)
	(SETVAR "HPBOUND" HP2)
	(SETVAR "HPDOUBLE" HP3)
	(SETVAR "HPNAME" HP4)
	(SETVAR "HPSCALE" HP5)
	(SETVAR "HPSPACE" HP6)
	(SETVAR "osmode" OSA)
	(SETVAR "DIMZIN" SUPR)
)


(defun acercade()
	(if (not (new_dialog "dlg_Acerca" ind))(exit))
	(ACTION_TILE "accept7" "(DONE_DIALOG)")
	(START_DIALOG)
	(princ)
)


(setq MODEACT (getvar "MODEMACRO"))

(PRINC "\nPrograma AreasX")
(PRINC "\nVersión 7.3")
(PRINC "\nLisp Desarrollado. - 1999 - 2007")
(PRINC "\nUltima actualización 17/10/2007")
(PRINC "\nHalla areas a partir de objetos.")
(PRINC "\nNombre de comando: AX")
(setvar "modemacro" "lisphob")
(PRINC)