data SEGMENT
    ; PGCD AVEC REPRESENTATION SUR 16 BITS 
    ; INITIALISATION DU VARIABLES
    a dw ? 
    b dw ? 
    
    Tab dw 48,12,24,36,0 ;doit se terminer avec 0
    message_1 db 'fin du calcule du PGCG $'    
    cx2 dw ? 
    samedi db 'samedi, $' 
    dimanche db   'dimanche, $'
    lundi db   'lundi, $'
    mardi db   'mardi, $'
    mercredi db 'mercredi, $'
     vendredi db 'vendredi, $'
    jeudi db 'jeudi, $'
    str db ' Tab= $'
    str2 db ' PGCD= $'
    
    
   
ENDS   

stack SEGMENT
    
    DB    128    dup(0)
ENDS


code SEGMENT  
    
    PGCD_I PROC
        POP CX ; SAUVGARDER IP DANS CX
        POP a; valeur de DX
        POP b; valeur de BX
        REPETER: 
                      
            CMP a , 0
            JE FIN
            XOR DX,DX
            
            MOV AX, b
            
            DIV a ;b/a ==> DX := n1 % n2 CONTIENT LE RESTE, AX := n1 / n2 CONTIENT LE QUOTIENT
            MOV AX, a ; b := a 
            MOV b,AX
            MOV a, DX ; a := rest 
            
            JMP REPETER
        FIN: 
            
            PUSH b  ;resultat dans b
            PUSH CX ; RETOURNER LE IP AU DEBUT DU PILE 
        RET
    PGCD_I ENDP  
    
         
;;;;;;;;;;;;;;;;;;;;;;; PROCEDURE POUR AFFICHER LES NBR A 8 BITS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                         
         DISP PROC       ;pour les nbr a 8 bits 
           MOV DL,BH      ; les valeurs sont dans bh et bl 
           ADD DL,30H     ; 
           MOV AH,02H     ; 
           INT 21H
           MOV DL,BL      ; BL Part 
           ADD DL,30H     ; 
           MOV AH,02H     ; 
           INT 21H
           RET
           DISP ENDP      ; 
         

;;;;;;;;;;;;;;;;;;;;;;;;;; PROCEDURE POUR AFFICHER TABLEAU ;;;;;;;;;;;;;;;;;;;;;;;;;;
         
         
         AFFICHER_TAB PROC  
            
    call LENGTH ; la taille du tableau est dans bx  
   
    mov a, bx ; la taille du tableau est dans a
    
    lea si , tab 
    
    again:
    cmp a,0
    je exit3   
       
      mov ax,[si] 
       
      
      call PRINT
      
       
      MOV DL,','    ; pour afficher une vergule
        MOV AH,02H
        INT 21H 
       add si,2     ; on ajout 2 cas la taille est a 16 bits
       dec a
    jmp again 
    exit3:
     ret       
          AFFICHER_TAB  ENDP                        
;;;;;;;;;;;;;;;;;;;;;;;;; AUTRE PROCEDURE QUI AFFICHE LES NBR A 16 BITS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

         
         PRINT PROC     ;pour les nbr a 16 bit     
     
    ;initialize count
    mov cx,0
    mov dx,0
    label1:
        ; si ax egale a zero
        cmp ax,0
        je print1     
         
        ;initialiser bx a 10
        mov bx,10       
         
        ; avoir le dernier digit
        div bx                 
         
        
        push dx             
         
        
        inc cx             
         
        
        xor dx,dx
        jmp label1
    print1:
        
        cmp cx,0
        je exit1
         
        
        pop dx
         
        
        add dx,48
         
        
        mov ah,02h
        int 21h
         
        
        dec cx
        jmp print1
      exit1:
ret
PRINT ENDP

;;;;;;;;;;;;;;;;;;;;;;;;; PROCEDURE QUI CALCULE PGCD D'UN TABLEAU ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    PGCD_IN PROC  
        POP CX2 ; SAUVGARDER IP DANS CX2
        
        lea si, tab
         
        mov bx,[si]  ; premier valeur dans bx
        cmp BX,0
        je fin1
        
        boucle:
        
        inc si
        mov dx,[si]   ; valeur suivante dans bl
        cmp dx,0
        je fin1   
        PUSH BX       ; VALEUR 1 DANS BX
        PUSH DX       ;VALEUR 2 DANS DX 
        
        call PGCD_I    ; PGCD ENTRE LES VALEURS DE BX ET DX
        POP BX
        jmp boucle 
        
        fin1: 
        PUSH BX 
        PUSH DX
        PUSH CX2 ;
        ret         
        PGCD_IN ENDP

;;;;;;;;;;;;;;;;;;;;;; UNE PROCEDURE QUI CALCULE LA TAILLE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
   LENGTH PROC 
    
        xor BX,BX           ; initialiser BX a 0 
        mov si,offset Tab 
        mov DX,[si]
        cmp DX,0
        je fin2
        
        boucle2:
        inc BX             ; BX CONTIENT LA TAILLE
        add si,2           ;POUR PARCOURIR LE TABLEAU
        mov DX,[si]        ; VALEURS SUIVANTE DANS DX 
        cmp DX,0
        je fin2 
        jmp boucle2 
        
        fin2: 
            ret
            
    LENGTH ENDP    

;;;;;;;;;;;;;;;;;;;;;;;; MACRO POUR DEPLACER ;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
 
 goto macro x,y 
        mov ah,02h 
    mov bh, 00h
    mov dl,x
    mov dh,y
    int 10h
 endm      
 
;;;;;;;;;;;;;;;;;;;;;; MACRO POUR AFFICHER UN CARACTERE ;;;;;;;;;;;;;;;;;;;;; 

 afficherChar macro x 
          MOV DL,x
        MOV AH,02H    
        INT 21H 
    endm 
;;;;;;;;;;;;;;;;;;;;; programme principale ;;;;;;;;;;;;;;;;;;;;;;;;;;;    
     start:
        MOV AX, data
        MOV DS, AX
        MOV ES, AX
        
        MOV AX, stack
        MOV SS, AX
        
        ;;;;;;;;;;;;;;;;;;; deplacer vers fin du 1er ligne;;;;;;;;;
	    
        goto 60,1 
    
        ;;;;;;;;;;;;;;; pour afficher le jour d semaine ;;;;;;;;
         
        MOV AH,2AH    ; To get System Date
        INT 21H 
        
        AAM       
        CMP AL , 06h
        JE j1  
       
        
       
        CMP AL ,00h
        JE j2  
        
        
        
        CMP AL , 01h 
        JE j3
         
        
        
        CMP AL ,02h 
        JE j4
        
        
        
        CMP AL , 03h
        JE j5 
       
            
        
        
        CMP AL ,04h
        JE j6 
       
           
                  
        CMP AL , 05h 
        JE j7
        
          
        j1:
         LEA DX , samedi
        jmp fn 
        
        j2: 
        LEA DX , dimanche
        jmp fn 
        
        j3: 
         LEA DX , lundi
        jmp fn
        
        j4: 
         LEA DX , mardi
        jmp fn  
        
        j5:  
         LEA DX , mercredi
         jmp fn
         
        j6: 
         LEA DX , jeudi
         jmp fn 
         
        j7: 
         LEA DX , vendredi
             
        fn:  
        MOV AH,09H
        INT 21H 
        
        ;;;;;;;;;;;;;;;;;;;;; afficher jour ;;;;;;;;;;
        
        DAY:
        MOV AH,2AH    ; To get System Date
        INT 21H
        MOV AL,DL     ; Day is in DL
        AAM
        MOV BX,AX
        CALL DISP
        
        afficherChar '/'                                  
        
        ;;;;;;;;;;;;;;;;;;;;; afficher mois  ;;;;;;;;;;  
                     
        MONTH:
        MOV AH,2AH    ; To get System Date
        INT 21H
        MOV AL,DH     ; Month is in DH
        AAM
        MOV BX,AX
        CALL DISP

        afficherChar '/'      
        
        ;;;;;;;;;;;;;;;;;;;;; afficher annee ;;;;;;;;;;
        
        YEAR:
        MOV AH,2AH    ; To get System Date
        INT 21H
        ADD CX,0F830H ; To negate the effects of 16bit value,
        MOV AX,CX     ; since AAM is applicable only for AL (YYYY -> YY)
        AAM
        MOV BX,AX
        CALL DISP 
       
       
        
        ;;;;;;;;;;;;;;;;;;;; deplacer vers deuxiem ligne ;;;;;;;;;;;;
        
         goto 73,2
    
    heure:
      
        MOV AH,2CH    ; To get System Date
        INT 21H
        MOV AL,CH     ; Month is in DH
        AAM
        MOV BX,AX  
        CALL DISP
        afficherChar ':'
    
     minutes: 
      MOV AH,2CH    ; To get System Date
        INT 21H
        MOV AL,CL     ; Month is in DH
        AAM
        MOV BX,AX  
        CALL DISP
          
    ;;;;;;;;;;;;;;;;;;;; deplacer vers 3eme ligne ;;;;;;;;;;;;;;;;;;
        
         goto 3,3 
              
    call  LENGTH  
    
    afficherChar 'N' 
        afficherChar '='
    MOV DL,bl    ;
    ADD DL , 48
        MOV AH,02H
        INT 21H 
    
    ;;;;;;;;;;;;;;;;;;;; deplacer vers mileu de 3eme ligne ;;;;;;;;;;;;;;;;
    
      goto 35 ,3
    LEA DX ,str
    MOV AH,09H
        INT 21H 
    
    call AFFICHER_TAB
        
    ;;;;;;;;;;;;;;;;;;;;;; deplacer vers mileu de 4eme ligne ;;;;;;;;;;;;;;;;
    
    goto 35 , 4
    LEA DX ,str2
    MOV AH,09H
    INT 21H 
    
    call PGCD_IN 
    
    POP BX
    POP AX
        
       ;;;;;;;;;;;;;;;;;; AFFICHAGE DU PGCD ;;;;;;;;;;;;;           
       call PRINT 
                
       exit:
        MOV AH, 4ch ; exit 
        INT 21h 
                
    
ENDS
END start