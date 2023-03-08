
data SEGMENT
	; PGCD AVEC REPRESENTATION SUR 8 BITS 
    ; INITIALISATION DU VARIABLES
    n1    DB    8
    n2    DB    28
    
    Tab db 6,12,24,36,2,0 ;doit se terminer avec 0
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
    
    ancien_ip dw ? 
    ancien_cs dw ? 
    
   
ENDS   

stack SEGMENT
    
    DB    128    dup(0)
ENDS


code SEGMENT  
;;;;;;;;;;;;;;;;;;;;;; PROCEDURE QUI CALCULE LE PGCD ENTRE 2 VAR ;;;;;;;;;;;;;;;    
    PGCD_I PROC
        POP CX ; SAUVGARDER IP DANS CX
        POP BX;  LES VALEURS SONT DANS BH ET BL 
        REPETER: 
                      
            CMP BL, 0
            JE FIN
            
            MOV AL, BH
            MOV AH, 0 ; INITIALISER AX
            DIV BL ; AH := n1 % n2 CONTIENT LE RESTE, AL := n1 / n2 CONTIENT LE QUOTIENT
            MOV BH, BL ; n1 := n2
            MOV BL, AH ; n2 := n1 % n2
            
            JMP REPETER
        FIN:
            PUSH BX
            PUSH CX ; RETOURNER LE IP AU DEBUT DU PILE 
        RET
    PGCD_I ENDP  
    
         
;;;;;;;;;;;;;;;;;;;;;;;; PROCEDURE QUI AFFICHE UN NBR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

         
         DISP PROC        ;DISP = DISPLAY
           MOV DL,BH      ; LES VALEURS SONT DANS BH ET BL 
           ADD DL,30H     
           MOV AH,02H     
           INT 21H
           MOV DL,BL      ; BL  
           ADD DL,30H     
           MOV AH,02H     
           INT 21H
           RET
           DISP ENDP       
         

;;;;;;;;;;;;;;;;;;;;;;;;; PROCEDUER QUI QFFICHE UN TABLEAU;;;;;;;;;;;;;;;;;;;;;;;;;;;
         
         
         AFFICHER_TAB PROC  
            
    call LENGTH ; la taille du tableau est dans bh  
    xor cx,cx
    mov cl, bh ; la taille du tableau est dans cx 
    lea si , tab 
    
    again:
       
      mov ah,0 
      mov al,[si] 
      mov dl , 10 
      div dl ; ax/dl
      mov bl,ah ; modulo dans bh
      mov bh, al ; quotient dans bl 
      
      call Disp 
       
      MOV DL,','    ; POUR AFFICHER ',' 
        MOV AH,02H
        INT 21H 
       inc si 
       
    loop again 
    
            
          AFFICHER_TAB  ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;; PROCEDURE QUI CALCULE PGCD D'UN TABLEAU ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    PGCD_IN PROC  
        POP CX2 ; SAUVGARDER IP DANS CX2
        
        lea si, tab
         
        mov bh,[si]  ; premier valeur dans bh
        cmp bh,0
        je fin1
        
        boucle:
        inc si
        mov bl,[si]   ; valeur suivante dans bl
        cmp bl,0
        je fin1   
        PUSH BX
        
        call PGCD_I
        
        jmp boucle 
        
        fin1: 
        PUSH BX
        PUSH CX2 ;
        ret         
        PGCD_IN ENDP

;;;;;;;;;;;;;;;;;;;;;;;;; PROCEDURE QUI CALCULE LA TAILLE DU TABLEAU ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
   LENGTH PROC 
    
        xor bh,bh ; pour initialiser bh a 0    
        mov si,offset Tab 
        mov bl,[si]
        cmp bl,0
        je fin2
        
        boucle2:
        inc bh       ; la taille dans bh 
        inc si
        mov bl,[si]
        cmp bl,0
        je fin2 
        jmp boucle2 
        
        fin2: 
            ret
            
    LENGTH ENDP    

;;;;;;;;;;;;;;;;;;;;; MACRO POUR DEPLACER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

 
 
 goto macro x,y 
        mov ah,02h 
    mov bh, 00h
    mov dl,x
    mov dh,y
    int 10h
 endm      
 
;;;;;;;;;;;;;;;;;;;; MACRO POUR AFFICHER UN CARACTER ;;;;;;;;;;;;;;;;;;;;;;; 

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
        
        ; DEPLACER VERS LA FIN DU 1er LIGNE 
	    
        goto 60,1 
    
        
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
        MOV AL,DL     ; JOUR DANS DL
        AAM
        MOV BX,AX
        CALL DISP
        
        afficherChar '/'                                  
        
        ;;;;;;;;;;;;;;;;;;;;; afficher mois  ;;;;;;;;;;  
                     
        MONTH:
        MOV AH,2AH    ; To get System Date
        INT 21H
        MOV AL,DH     ; MOIS DANS DH
        AAM
        MOV BX,AX
        CALL DISP

        afficherChar '/'      
        
        ;;;;;;;;;;;;;;;;;;;;; afficher annee ;;;;;;;;;;
        
        YEAR:
        MOV AH,2AH    ; To get System Date
        INT 21H
        ADD CX,0F830H ; ,
        MOV AX,CX     
        AAM
        MOV BX,AX
        CALL DISP 
       
       
        
        ;;;;;;;;;;;;;;;;;;;; deplacer vers deuxiem ligne ;;;;;;;;;;;;
        
         goto 73,2
    
    heure:
      
        MOV AH,2CH    ; To get System Date
        INT 21H
        MOV AL,CH     ; HEURE DANS CH
        AAM
        MOV BX,AX  
        CALL DISP
        afficherChar ':'
    
     minutes: 
      MOV AH,2CH    ; To get System Date
        INT 21H
        MOV AL,CL     ; MINUTE DANS CL
        AAM
        MOV BX,AX  
        CALL DISP
          
    ;;;;;;;;;;;;;;;;;;;; deplacer vers 3eme ligne ;;;;;;;;;;;;;;;;;;
        
         goto 3,3 
              
    call  LENGTH  
    
    afficherChar 'N' 
        afficherChar '='
    MOV DL,bh    ;
    ADD DL , 48
        MOV AH,02H
        INT 21H 
    
    ;;;;;;;;;;;;;;;;;;;; deplacer vers mileu de 3eme ligne ;;;;;;;;;;;;;;;;
    
      goto 35 ,3
    LEA DX ,str
    MOV AH,09H
        INT 21H 
    
    call AFFICHER_TAB   ; afficher le tableau
        
    ;;;;;;;;;;;;;;;;;;;;;; deplacer vers mileu de 4eme ligne ;;;;;;;;;;;;;;;;
    
    goto 35 , 4
    LEA DX ,str2
    MOV AH,09H
    INT 21H 
    
    call PGCD_IN       ; afficher le PGCD
    
    POP BX             ; PGCD DANS BH 
        
       ;;;;;;;;;;;;;;;;;; AFFICHAGE DU PGCD ;;;;;;;;;;;;;           
        mov ah,02h    
	    mov dl, bh                 
	    add dl,48
	    int 21h
                
       exit:
        MOV AH, 4ch ; exit 
        INT 21h 
                
    
ENDS
END start

; add your code here

ret




