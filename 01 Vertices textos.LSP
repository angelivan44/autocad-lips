(DEFUN C:vt();ESTE programa pica un punto en pantalla y escribe letras consecutivamente, para poligonales 


   (command "-layer" "make" "Tex_Vertices.lsp" "color" "06" "" "")
   (command "-style" "Standard" "romans" 0 "" "" "" "" "")
   (setq num (getvar "userr1"));1
   (setq h (getdist(strcat "\nIngrese altura de texto <"(rtos num 2 3)">:")));1
   (if (= h nil);1
    (setq h num);asigna a h el valor de num
    (setvar "userr1" h);1
    );end

         
    (setq p1 (getpoint(strcat "\nIngrese ubicacion texto inicial (A):")));1
    (command "text" "j" "mc" p1  h 0 "A" "" "")
  
    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (B):")));1  
    (command "text" "j" "mc" p1 h  0 "B"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (C):")));1  
    (command "text" "j" "mc" p1 h  0 "C"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (D):")));1  
    (command "text" "j" "mc" p1 h  0 "D"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (E):")));1  
    (command "text" "j" "mc" p1 h  0 "E"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (F):")));1  
    (command "text" "j" "mc" p1 h  0 "F"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (G):")));1  
    (command "text" "j" "mc" p1 h  0 "G"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (H):")));1  
    (command "text" "j" "mc" p1 h  0 "H"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (I):")));1  
    (command "text" "j" "mc" p1 h  0 "I"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (J):")));1  
    (command "text" "j" "mc" p1 h  0 "J"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (K):")));1  
    (command "text" "j" "mc" p1 h  0 "K"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (L):")));1  
    (command "text" "j" "mc" p1 h  0 "L"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (M):")));1  
    (command "text" "j" "mc" p1 h  0 "M"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (N):")));1  
    (command "text" "j" "mc" p1 h  0 "N"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (O):")));1  
    (command "text" "j" "mc" p1 h  0 "O"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (P):")));1  
    (command "text" "j" "mc" p1 h  0 "P"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (Q):")));1  
    (command "text" "j" "mc" p1 h  0 "Q"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (R):")));1  
    (command "text" "j" "mc" p1 h  0 "R"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (S):")));1  
    (command "text" "j" "mc" p1 h  0 "S"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (T):")));1  
    (command "text" "j" "mc" p1 h  0 "T"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (U):")));1  
    (command "text" "j" "mc" p1 h  0 "U"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (V):")));1  
    (command "text" "j" "mc" p1 h  0 "V"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (W):")));1  
    (command "text" "j" "mc" p1 h  0 "W"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (X):")));1  
    (command "text" "j" "mc" p1 h  0 "X"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (Y):")));1  
    (command "text" "j" "mc" p1 h  0 "Y"  "" "")

    (setq p1 (getpoint(strcat "\nIngrese ubicacion del sgte texto (Z):")));1  
    (command "text" "j" "mc" p1 h  0 "Z"  "" "")

     
  )


