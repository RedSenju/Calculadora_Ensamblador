;---------------------------------Inicio de macros-----------------------------------------------

clean     macro                 ;Inicia macro para limpiar pantalla 
    
          mov ah,0fh            ;Funcion 0F (lee modo de video)
          int 10h               ;de la INT 10H a AH.
          mov ah,0h             ;Funcion 0 (selecciona modo de video) de la INT 10H a AH
          int 10h               ;las 4 instrucciones limpian la pantalla. 
           
          endm                  ;Termina macro para limpiar pantalla
 
print     macro mensaje         ;Inicia macro para imprimir cadena de caracteres en pantalla
    
          mov dx,offset mensaje ;asigna el OFFSET mensaje a DX (DS:DX)
          mov ah,09h            ;Funcion 09 (mensaje en pantalla) de la INT 21H a AH
          int 21h               ;muestra mensaje en pantalla   
           
          endm                  ;Termina macro para cadena de caracteres en pantalla

c_eco     macro                 ;Inicia macro para guardar caracter con eco      
    
	      mov AH,01H            ;Funcion 01 (lee el teclado con eco) de la INT 21H a AH	
	      int 21H               ;guarda caracter ascii leido desde el teclado mostrando eco
	       
          endm                  ;Termina macro para guardar caracter con eco

s_eco     macro                 ;Inicia macro para guardar caracter sin eco  
    
	      mov	AH,07H	        ;Funcion 07 (lee el teclado sin eco) de la INT 21H a AH	
	      int	21h             ;guarda caracter ascii leido desde el teclado sin mostrar eco
	       
          endm                  ;Termina macro para guardar caracter sin eco

printchar macro                 ;Inicia macro para imprimir un solo caracter en pantalla
    
	      mov AH,02H            ;Funcion 02 (desplegar dato en pantalla) de la INT 21H a AH
  	      int 21H               ;de la INT 21H a AH                                   
  	       
          endm                  ;Termina macro para imprimir un solo caracter en pantalla

backspace macro                 ;Inicia macro para borrar un caracter
    
		  mov DL,08H 			;Asigna 08H (tecla borrar) a dl
  		  printchar   			;Invoca al macro "printchar"
  		  mov DL,20H 			;Asgina 20H (tecla espacio) a dl
  		  printchar  			;Invoca al macro "printchar"
  		  mov DL,08H 			;Asigna 08H (tecla borrar) a dl
  		  printchar   			;Invoca al macro "printchar"   
  		   
          endm      			;Termina macro para borrar un caracter

mback     macro                 ;Inicia macro para regresar al menu principal
          
          CMP AL, 1h            ;Compara si lo que esta en AL es igual a 1h
          JE  callmenu          ;Si es igual, salta a la etiqueta PRINCIPAL
          CMP AL, 2h            ;Compara si lo que esta en AL es igual a 2h
          JE  FIN               ;Si es igual, salta a la etiqueta PRINCIPAL
           
          endm                  ;Termina macro para regresar al menu principal

;---------------------------------Fin de macros---------------------------------------------------       
               
         .MODEL SMALL           ;Define modelo de memoria 
       
         .STACK                 ;Define area de pila
       
         .DATA                  ;Define area de datos
                  

MenuP    DB 09, 'MENU', 13, 10, 'Calculadora de: +,-,*,/', 13, 10, ;\
         DB 13, 10, '1) Suma', 13, 10,                           ; |
         DB '2) Resta', 13, 10,                                  ; |- Se define la variable MenuP
         DB '3) Multiplicacion', 13, 10,                         ; |
         DB '4) Division', 13, 10,
         DB 13, 10, 168, 'Que operacion desea hacer?: $'         ;/  
       
Opcion   DB 0                                                    ;Se define la variable "Opcion"
 
Vacio    DB 13, 10, '$'                                          ;Define la variable "Vacio"

;------------------------------|Ingreso de numeros y resultado|----------------------------------- 
     
Num1     DB 13, 10, 'Ingrese el primer numero: $', 13, 10   ;Se define la variable "Num1"

Num2     DB 13, 10, 'Ingrese el segundo numero: $', 13, 10  ;Se define la variable "Num2" 

Resul    DB 13, 10, 'El resultado es: $', 13, 10            ;Se define la variable "Resul"

Back     DB 13, 10, 168, 'Desea continuar?', 13, 10         ;Se define la variable "Back"
         DB 13, 10, '1) Si     2)No   :$', 13, 10           ;
      
;-----------------------------------------|Titulos|-----------------------------------------------
  
TSuma    DB '1.- Suma $', 13, 10                            ;Se define la variable "TSuma"

TResta   DB '2.- Resta $', 13, 10                           ;Se define la variable "TResta"

TMulti   DB '3.- Multiplicacion $', 13, 10                  ;Se define la variable "TMulti"

TDiv     DB '4.- Division $', 13, 10 

;-----------------------------------------|Valores|-----------------------------------------------

                                                          
Valor1   DW 0                                               ;Se define la variable "Valor1" 

Valor2   DW 0                                               ;Se define la variable "Valor2"

tentimes DW 10                                              ;Se define la variable "tentimes" inicializado en 10
   
         .CODE                                                ;Define area de codigo
         
;--------------------------------/|Direccionamiento de datos|\------------------------------------                 

begin    proc far                ;Inicio del procedimiento "begin"
    
         MOV AX,@DATA            ;Asigna la direccion de datos a AX
         MOV DS,AX               ;Asigna Ax a DS

;-------------------------------------/|Menu principal|\------------------------------------------
       
callmenu:                       ;Etiqueta "callmenu"
 
         clean                   ;Invoca a la macro "clean"
	     call showMenu           ;Llama al proceso "showMenu"
         c_eco                   ;Invoca a la macro "c_eco"
        
option1:                        ;Etiqueta "option1"

	     cmp	AL,'1'              ;Compara si lo que esta en AL es igual a '1'
	     jne	option2             ;Si no es igual, salta a la etiqueta "option2" 
	     clean
         call addProc            ;Si es igual llama al proceso "addProc"
         jmp  callmenu           ;Salta a la etiqueta "callmenu" si no es igual
                                ;a '1','2','3','4','5'.

option2:                        ;Etiqueta "option2" 
     
         cmp	AL,'2'              ;Compara si lo que esta en AL es igual a '2'
	     jne	option3             ;Si no es igual, salta a la etiqueta "option3"
	     clean 
         call  subProc           ;Si es igual llama al proceso "subProc"
         jmp  callmenu           ;Salta a la etiqueta "callmenu" si no es igual
                                ;a '1','2','3','4','5'.
        
option3:                        ;Etiqueta "option3"

	     cmp	AL,'3'              ;Compara si lo que esta en AL es igual a '3'
	     jne	option4            ;Si no es igual, salta a la etiqueta "option4"
	     clean
         call  mulProc           ;Si es igual llama al proceso "mulProc"
         jmp  callmenu           ;Salta a la etiqueta "callmenu" si no es igual
                                ;a '1','2','3','4','5'.
                                
option4: 

         cmp AL, '4'
         jne    callmenu
         clean
         call   divProc
         jmp    callmenu       

begin    endp                    ;termina la ejecucion del programa 
   
showBack proc                   ;Inicia el procedimiento "showBack"
    
         print back             ;Invoca al macro "print" y envia como argumento a "back"
         ret                    ;Regresa a la etiqueta que lo llamo
         clean                  ;Llama al macro "clean"
         
showBack endp                   ;Fin del procedimiento "showBack"


showMenu proc                   ;Inicia proceso "showMenu"
    
	     print Menup             ;Invoca a la macro "print" y envia como argumento a "mainHeader"	    
	     ret                     ;Regresa a la etiqueta que lo llamo
	     clean                   ;Invoca a la macro 
	    
showMenu endp                   ;Termina proceso "showMenu"
       
;-----------------------------------------/|Suma|\------------------------------------------------
Suma:                           ;Inicio de la etiqueta "Suma"
 
addProc  proc                    ;Inicio del procedimiento "addProc"
    
         clean                   ;Invoca a la macro "clean"
         print TSuma             ;Invoca a la macro "print" y envia como argumento "TSuma"
         call inputNum           ;llama al proceso "inputNum"
         mov ax,Valor1           ;Asigna "Valor1" a ax
         add ax,Valor2           ;Asigna "Valor2" a ax
         push ax                 ;Guarda ax en la pila
         print Resul             ;Llama a la macro "print" y envia como argumento "Resul"
         pop ax                  ;Guarda ax en la pila
         call intTochar          ;llama al proceso "intTochar" 
        
         print Back              ;Invoca a la macro "print" y envia como argumento "Back"
         call DeseaContinuar     ;llama al proceso "DeseaContinuar"
         ret                     ;Regresa a la etiqueta que lo llamo
        
addProc  endp
       
;----------------------------------------./|Resta|\------------------------------------------------
   Resta:    
 subProc proc                   ;Inicia proceso "subProc" 
    
         print TResta                ;Invoca al macro "print" y envia como argumento a "TResta"
  
         call inputNum               ;Llama al proceso "inputNum"   

    ;// OPERACION DE RESTA 
    
         mov  ax, Valor1              ;Asigna Valor1 a ax
    
         JNS  SinMenos                ;Salta a "SinMenos" si no tiene signo
         neg  Valor2                  ;Niega "Valor2" 
    
SinMenos:                   ;Inicio de la etiqueta "SinMenos"
    
         sub  ax, Valor2              ;Realizamos la resta
         mov  cx, ax                  ; Movemos el resultado a CX para preservar el valor original para mostrarlo luego
         push ax                     ; Guardamos el resultado en la pila para imprimirlo después
         print Resul                 ;Invoca a la macro "print" y envia como argumento a "Resul"
         pop  ax                      ;Almacena ax en la pila
         call intTochar              ;Llama al procedimiento "intTochar"
    
         print Back                  ;Invoca a la macro "print" y envia como argumento a "Back"
         call DeseaContinuar         ;Llama al procedimiento "DeseaContinuar"
      
         ret                         ;Regresa al proceso que lo llamo
    
subProc  endp                    ;Termina el proceso "subProc"

;------------------------------------/|Multiplicacion|\--------------------------------------------

Multiplicacion:                 
mulProc  proc                    ;Inicia proceso "mulProc"
    
         print TMulti            ;Invoca al macro "print" y envia como argumento a "TMulti"

         call inputNum           ;Llama al proceso "inputNum"   

        ;// OPERACION DE MULTIPLICACION 
        
         mov ax,Valor1           ;Mueve el contenido de "Valor1" en ax
         cwd                     ;Extiende a AX en DX
         imul Valor2             ;Multiplica ax por Valor2
         mov bx,100              ;Seteamos 100 para manejar decimales
         idiv bx                 ;Dividimos ax entre 100 para ajustar decimales
        
         push ax                 ;Guarda ax
         print Resul             ;Invoca al macro "print" y envia como argumento a "Resul"
         pop ax                  ;Restaura ax
         call intTochar          ;Llama al proceso "intTochar"
        
         print Back              ;Invoca a la macro "print" y envia como argumento a "Back"
         call DeseaContinuar     ;Llama al procedimiento "DeseaContinuar"
         ret                     ;Regresa a la etiqueta que lo llamo      
        
 mulProc endp                   ;Termina proceso "mulProc"


;--------------------------------------/|Division|\----------------------------------------------

Division:
divProc proc 
    
         clean
         print TDiv
         
    
divProc endp 

;------------------------------------/|Procedimiento|\----------------------------------------------
        
inputNum proc                   ;Inicia proceso "inputNum" 
        
         print Vacio             ;Invoca a la macro "print" y envia como argumento a "Vacio"
         
	     print Num1              ;Invoca al macro "print" y envia como argumento a "Num1"
         call getdigit           ;Llama al proceso "getdigit"

         call toInt              ;Llama al proceso "toInt"
         mov Valor1,ax           ;Asigna ax a Valor1
              
         push bx                 ;Almacena bx en la pila

	     print Num2              ;Invoca al macro "print" y envia como argumento a "Num2"
         call getdigit           ;Llama al proceso "getdigit"
              
        ;JUNTA EL FORMATO DE AMBOS NUMEROS
         pop dx                  ;Restaura dx
         cmp bh,dh               ;Compara bh con dh
         jg  first               ;Salta a "first" si es mayor
         mov bh,dh               ;Asigna dh a bh  
        
first:                          ;Etiqueta "first"
              
         call toInt              ;Llama al proceso "toInt"
         mov Valor2,ax

	     ret                     ;Regresa a la etiqueta que lo llamo 
	    
inputNum endp                   ;Termina proceso "inputNum"

toInt    proc                      ;Inicia proceso "toInt"
    
         mov ax,0                ;Limpia ax
         mov dx,0                ;Limpia dx
         mov dl,ch               ;Copia ch a dl
         shr dl,4                ;Mueve los bits de dl 4 a la derecha
         add ax,dx               ;Suma dx a ax
         mul tenTimes            ;Multiplica por 10 ax
         mov dl,ch               ;Copia ch a dl
         shl dl,4                ;Mueve los bits de dl 4 a la izquierda
         shr dl,4                ;Mueve los bits de dl 4 a la derecha
         add ax,dx               ;Suma dx a ax
         mul tenTimes            ;Multiplica por 10 ax
         mov dl,cl               ;Copia cl a dl
         shr dl,4                ;Mueve los bits de fl 4 a la derecha
         add ax,dx               ;Suma dx a ax
         mul tenTimes            ;Multiplica por 10 ax
         mov dl,cl               ;Copia cl a dl
         shl dl,4                ;Mueve los bits de dl 4 a la izquierda
         shr dl,4                ;Mueve los bits de dl 4 a la derecha
         add ax,dx               ;Suma dx a ax
         test bl,1               ;Comprueba bl con 1
         jz toIntEnd             ;Si es zero salta a toIntEnd
         not ax                  ;Niega a ax
         add ax,1                ;Suma 1 a ax     
        
tointEnd:                       ;Etiqueta "tointEnd"
    
         ret                     ;Regresa a la etiqueta que lo llamo

toInt    endp                      ;Termina proceso "toInt"

intTochar proc               ;Inicia proceso "intTochar"
  
         cmp ax,0                ;Compara con 0 ax,
         jg  noNegat             ;Si es mayor salta a noNegat
         jz  noNegat             ;Si es cero, salta a noNegat
         not ax                  ;Complemento de ax
         add ax,1                ;Suma 1 a ax
         push ax                 ;Guarda ax en la pila
         mov dl,'-'              ;Mueve el caracter '-' a dl
         printchar               ;Invoca al macro "printchar"
         pop ax                  ;Restaura ax
        
noNegat:                        ;Etiqueta "noNegat"
         cmp ax,10000            ;Compara con 10000
         jl  okRange             ;Si es menor esta en el rango,
         ret                     ;Regresa al proceso que lo llamo
        
okRange:                        ;Etiqueta "okRange"
         mov cx,4                ;Mueve 4 a cx
  
convertir:                      ;Etiqueta "convertir"  

         mov dx, 0               ;Limpia dx
         div tenTimes            ;divide ax entre 10
         or dl,030h              ;Convierte dl en ASCII agregando 30h 
         push dx                 ;Guarda dx
         loop convertir          ;Salta a convertir si cx no es cero
  
         ;Primer caracter puede ser cero, ese no se imprime
         pop dx                  ;Restaura el primer caracter
         cmp dl,030h             ;Compara con 30h
         je  cerofirst           ;Si es igual, salta a cerofirst
         printchar               ;Invoca al macro "printchar"

cerofirst:                      ;Etiqueta "cerofirst"

         ;segundo caracter
         pop dx                  ;Restaura el segundo caracter
         printchar               ;Invoca al macro "printchar"

         mov cl,bh               ;Mueve cl a bh
         test cl,0ffh            ;Comprueba cl con 0ffh
                                ;Si es cero no hay decimales
        
         pop dx                  ;Restaura dx
         cmp dx, '0'             ;Compara dx con '0' (30h)
         je SinPunto             ;Salta a "SinPunto" si es igual
         push dx                 ;Restaura dx
        
         mov dl,'.'              ;Mueve el caracter '.' a dl
         printchar               ;Invoca al macro "printchar"
         jmp decimalPrint        ;Salta a "decimalPrint"
        
SecDec:                         ;Inicio de la etiqueta "SecDec"
         mov dl,'.'              ;Mueve el caracter '.' a dl
         printchar               ;Invoca al macro "printchar"
         mov dl, '0'             ;Asigna '0' a dl
         printchar               ;Invoca a la macro "printchar"
         pop dx                  ;Restaura dx
         printchar               ;Invoca a la macro "printchar"
         jmp noDecimal           ;SAlta a "noDecimal"
         
SinPunto:                       ;Inicio de la etiqueta "SinPunto"   

         pop dx                  ;Restaura dx
         cmp dx, '0'             ;Compara dx con '0' (30h)
         je noDecimal            ;Salta a "noDecimal" si es igual
         push dx                 ;Almacena dx en la pila
         jmp SecDec              ;Salta a "SecDec"

decimalPrint:                   ;Etiqueta "decimalPrint"
 
         mov cx, 3               ;Asigna 3 a cx
         pop dx                  ;Restaura dx
         cmp dx, '9'             ;Compara dx con '9' (39h)
         jg Termina              ;Salta a "Termina" si es mayor
         cmp cx, 0               ;Compara cx con 0
         jl Termina              ;Salta a "Termina" si es menor
SegDec:                         ;Inicio de la etiqueta "SegDec"
         cmp dx, '0'             ;Compara dx con '0' (30h)
         je DecCero              ;Salta a "DecCero" si es igual
         cmp dl, 24h             ;Compara dl con 24h
         je Termina              ;Salta a "Termina" si es igual
         printchar               ;Invoca al macro "printchar" 
         jcxz Termina            ;Salta a "Termina" si cx es cero 
        
DecCero:                        ;Inicio de la etiqueta "DecCero"   

         loop  decimalPrint      ;Imprime hasta que cx sea 0 
        
         pop dx                  ;Restaura dx
        
         cmp dl, 24h             ;Compara dl con 24h ($)
         je Termina              ;Salta a "Termina" si es igual
        
         cmp dx, '9'             ;Compara dx con '9' (39h)
         jle Incremento          ;Salta a "Incremento" si es menor o igual
        
         cmp dx, '0'             ;Compara dx con '0' (30h)
         jge Incremento          ;Salta a "Incremento" si es mayor o igual
        
         cmp dx, '0'             ;Compara dx con '0' (30h)
         jl NoIncremento         ;Salta a "NoIncremento" si es menor
        
         cmp dx, '9'             ;Compara dx con '9' (39h)
         jg NoIncremento         ;Salta a "NoIncremento" si es mayor 
        
Incremento:                     ;Inicio de la etiqueta "Incremento"
 
         mov cx, 1               ;Asigna 1 a cx
         push dx                 ;Almacena dx en la pila
        
NoIncremento:                   ;Inicio de la etiqueta "NoIncremento"

         push dx                 ;Almacena dx en la pila
         cmp cx, 0               ;Compara cx con 0
         je Termina              ;Salta a "Termina" si es igual
         pop dx                  ;Restaura dx
         cmp dx, '0'             ;Compara dx con '0' (30h)
         JGE SegDec              ;Salta a "SegDec" si es mayor o igual
         cmp dx, '9'             ;Compara dx con '9' (39h)
         JLE SegDec              ;Salta a "SegDec" si es menor o igual
         push dx                 ;Almacena dx en la pila
         mov cx, 0               ;Asigna 0 a cx 
        
Termina:                        ;Inicio de la etiqueta "Termina"  

noDecimal:                      ;Etiqueta "noDecimal"

         mov cl,2                ;Mueve 2 a cl
         sub cl,bh               ;Resta bh a cl
         test cl,0FFh            ;Comprueba con FFh
         print Vacio             ;Invoca a la macro "print" y envia como argumento "Vacio"  
         print Back              ;Invoca a la macro "print" y envia como argumento "Back"
         call DeseaContinuar     ;Llama al procedimiento "DeseaContinuar"               
         ret                     ;Retorna al proceso que lo llamo
                            
intTochar endp                  ;Termina proceso "intTochar"

getdigit proc near              ;Inicio del procedimiento "getdigit" de tipo cercano
    
         mov bx, 0                   ;Asigna 0 a bx
         mov cx, 0                   ;Asigna 0 a cx
    
initial_state:                  ;Inicio de la etiqueta "initial_state"

         s_eco                       ;Invoca a la macro "s_eco"
         cmp al, 0Dh                 ;Compara al con 0Dh (Enter) 
         jne ne1                     ;Salta a "ne1" si no es igual
         ret                         ;Retorna al proceso que lo llamo
    
ne1:                            ;Inicio de la etiqueta "ne1"

         cmp al, '-'                 ;Compara al con '-' (2Dh)
         je negative                 ;Salta a "negative" si es igual
         cmp al, '.'                 ;Compara al con '.' (2Eh)
         je point_jump               ;Salta a "point_jump" si es igual
         cmp al, '0'                 ;Compara al con '0' (30h)
         jl initial_state            ;Salta a "initial_state" si es menor
         cmp al, '9'                 ;Compara al con  '9' (39h) 
         jg initial_state            ;Salta a "initial_state" si es mayor
         jmp integer                 ;Salta a "integer"
    
integer:                        ;Inicia la etiqueta "interger"

         mov dl, al                  ;Asigna al a dl
         printchar                   ;Invoca a la macro "printchar"
         shl ch, 4                   ;Desplazamiento logico a la izquierda en ch 4 veces
         sub al, 30h                 ;Resta 30h a al
         add ch, al                  ;Suma al a ch
         test ch, 0F0h               ;Compara logicamente 0FH con ch
         jz integer_get              ;Salta a "interger_get" si la bandera cero esta activa
         jmp integer_end             ;Salta a "interger_end"
    
integer_get:                    ;Inicia la etiqueta "interger_get"

         s_eco                       ;Invoca a la macro "s_eco"
         cmp al, 0Dh                 ;Compara al con 0Dh (Enter)
         jne ne3                     ;Salta a "ne3" si no es igual
         ret                         ;Retorna al proceso que lo llamo
    
ne3:                            ;Inicia la etiqueta "ne3"

         cmp al, 08h                 ;Compara al con 08h (Return)
         je integer_return           ;Salta a "interger_return" si es igual
         cmp al, '.'                 ;Compara al con '.' (2Eh)
         je point                    ;Salta a "point" si es igual
         cmp al, '0'                 ;Compara al con '0' (30h)
         jl integer_get              ;Salta a "interger_get" si es menor
         cmp al, '9'                 ;Compara al con '9' (39h)
         jg integer_get              ;Salta a "integer_get" si es mayor
         jmp integer                 ;Salta a "integer"
    
integer_return:                 ;Inicia la etiqueta "integer_return"

         backspace                   ;Invoca a la macro "backspace"
         shr ch, 4                   ;Desplazamiento logico a la derecha en ch 4 veces
         test ch, 00Fh               ;Compara logicamente ch con 00Fh
         jnz integer_get             ;Salta a "integer_get" si no es cero
         test bl, 1                  ;Compara logicamente bl con 1
         jnz negative_get            ;Salta a "negative_get" si no es cero
         jmp initial_state           ;Salta a "initial_state"
    
integer_end:                    ;Inicia la etiqueta "integer_end"

         s_eco                       ;Invoca a la macro "s_eco"
         cmp al, 0Dh                 ;Compara al con 0Dh (Enter)
         jne ne3                     ;Salta a "ne3" si no es igual
         ret                         ;Retorna al proceso que lo llamo
    
point_jump:                     ;Inicia la etiqueta "point_jump"

         jmp point                   ;Salta a "point"
    
negative:                       ;Inicia la etiqueta "negative"

         mov dl, al                  ;Asigna al a dl 
         printchar                   ;Invoca a la macro "printchar"
         mov bl, 1                   ;Asigna 1 a bl
    
negative_get:                   ;Iniciar la etiqueta "negative_get"

         s_eco                       ;Invoca a la macro "s_eco"
         cmp al, 0Dh                 ;Compara al con 0Dh (Enter)
         jne ne2                     ;Salta a "ne2" si no es igual
         ret                         ;Retorna al proceso que lo llamo
    
ne2:                            ;Inicia la etiqueta "ne2"

         cmp al, 08h                 ;Compara al con 08h
         je negative_return          ;Salta a "negative_return" si es igual
         cmp al, '.'                 ;Compara al con '.' (2Eh)
         je point                    ;Salta a "point" si es igual
         cmp al, '0'                 ;Compara al con '0' (30h)
         jl negative_get             ;Salta a "negative_get" si es menor
         cmp al, '9'                 ;Compara al con '9' (39h)
         jg negative_get             ;Salta a "negative_get" si es mayor
         jmp integer                 ;Salta a "integer"
    
negative_return:                ;Inicia la etiqueta "negative_return"

         backspace                   ;Invoca a la macro "backspace"
         mov bl, 0                   ;Asigna 0 a bl
         jmp initial_state           ;Salta a "initial_state"
    
point:                          ;Inicia la etiqueta "point"

         mov dl, '.'                 ;Asigna '.' a dl 
         printchar                   ;Invoca a la macro "printchar"
    
point_get:                      ;Inicia la etiqueta "point_get"

         s_eco                       ;Invoca a la macro "s_eco"
         cmp al, 0Dh                 ;Compara al con 0Dh (Enter)
         jne ne4                     ;Salta a ne4 si no es igual
         ret                         ;Retorna al proceso que lo llamo
    
ne4:                            ;Inicia la etiqueta ne4

         cmp al, 08h                 ;Compara al con 08h (Return)
         je point_return             ;Salta a "point_return" si es igual
         cmp al, '0'                 ;Compara al con '0' (30h)
         jl point_get                ;Salta a "point_get" si es menor
         cmp al, '9'                 ;Compara al con '9'(39h)
         jg point_get                ;Salta a "point_get" si es mayor
         jmp decimal                 ;Salta a "decimal"
         
point_return:                   ;Inicia la etiqueta "point_return"

         backspace                   ;Invoca a la macro "backspace"
         test ch, 0FFh               ;Compara logicamente 0FFh con ch
         jnz to_integer              ;Salta a "to_integer" si no es cero
         test bl, 1                  ;Compara logicamente 1 con bl
         jnz negative_get            ;Salta a "negative_get" si no es cero
         jmp initial_state           ;Salta a "initial_state"
    
to_integer:                     ;Inicia la etiqueta "to_integer"

         jmp integer_return          ;Salta a "integer_return"
    
decimal:                        ;Inicia la etiqueta "decimal"

         mov dl, al                  ;Asigna al a dl
         printchar                   ;Invoca a la macro "printchar"
         sub al, 30h                 ;Resta 30h a al
         add cl, al                  ;Suma al a cl
         shl cl, 4                   ;Desplazamiento logico a la izquierda en cl 4 veces
         add bh, 1                   ;Suma 1 a bh
    
decimal_get:                    ;Inicia la etiqueta "decimal_get"

         s_eco                       ;Invoca a la macro "s_eco"
         cmp al, 0Dh                 ;Compara al con 0Dh (Enter)
         jne ne5                     ;Salta a "ne5" si no es igual
         ret                         ;Retorna al proceso que lo llamo
    
ne5:                            ;Inicia la etiqueta "ne5"

         cmp al, 08h                 ;Compara al con 08h
         je decimal_return           ;Salta a "decimal_return" si es igual
         cmp al, '0'                 ;Compara al con '0' (30h)
         jl decimal_get              ;Salta a "decimal_get" si es menor
         cmp al, '9'                 ;Compara al con '9' (39h)
         jg decimal_get              ;Salta a "decimal_get" si es mayor 
         jmp decimal_2               ;Salta a "decimal_2"
    
decimal_return:                 ;Inicia la etiqueta "decimal_return"

         backspace                   ;Invoca a la macro "backspace
         shl cl, 4                   ;Desplazamiento logico a la izquierda en ch 4 veces 
         sub bh, 1                   ;Resta 1 a bh
         jmp point_get               ;salta a "point_get"
    
decimal_2:                      ;Inicia la etiqueta "decimal_2

         mov dl, al                  ;Asigna al a dl
         printchar                   ;Invoca a la macro "printchar"
         sub al, 30h                 ;Resta 30h a al
         add cl, al                  ;Suma al a cl
         add bh, 1                   ;Suma 1 a bh
    
decimal_2_get:                  ;Inicia la etiqueta "decimal_2_get"

         s_eco                       ;Invoca a la macro "s_eco"
         cmp al, 0Dh                 ;Compara al con 0Dh (Enter)
         jne ne6                     ;Salta a "ne6" si no es igual
         ret                         ;Retorna al proceso que lo llamo
    
ne6:                            ;Inicia la etiqueta "ne6"

         cmp al, 08h                 ;Compara al con 08h (Return)
         je decimal_2_return         ;Salta a "decimal_2_return" si es igual
         jmp decimal_2_get           ;Salta a "decimal_2_get
    
decimal_2_return:               ;Inicia la etiqueta "decimal_2_return"

         backspace                   ;Invoca a la macro "backspace"
         shr cl, 4                   ;Desplazamiento logico a la derecha en cl 4 veces
         shl cl, 4                   ;Desplazamiento logico a la izquierda a cl 4 veces
         sub bh, 1                   ;Resta 1 a bh
         jmp decimal_get             ;Salta "decimal_get"
                             
getdigit endp                   ;Fin del procedimiento getdigit

DeseaContinuar proc             ;Inicio del procedimiento "DeseaContinuar"
    
         c_eco                       ;Invoca a la macro "c_eco"
         cmp AL, '1'                 ;Compara al con '1' (31h)
         je continuar                ;Salta a "continuar" si es igual
         cmp AL, '2'                 ;Compara al con '2' (32h)
         je salir                    ;Salta a "salir" si es igual
         jmp DeseaContinuar          ;Si no se ingresa ni '1' ni '2', vuelve a preguntar

continuar:                      ;Inicio de la etiqueta 

         clean                       ;Invoca a la macro "clean"
         jmp callmenu                ;Salta a "callmenu"

salir:                          ;Inicio de la etiqueta "salir

         clean                       ;Invoca a la macro "clean"
         jmp FIN                     ;Salta a "FIN"
         ret                         ;Retorna al proceso que lo llamo
    
DeseaContinuar endp             ;Fin del proceso "DeseaContinuar"

FIN:                            ;Inicio de la etiqueta "FIN"

         mov AH, 4CH                 ;Asigna la funcion 4Ch a AH
         int 21H                     ;Devuelve el control a DOS
    
end begin                       ;Fin del programa