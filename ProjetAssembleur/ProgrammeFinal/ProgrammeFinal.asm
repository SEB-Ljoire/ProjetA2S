List p=16F876A                  ;indique le pic utilisé. Mettre la référence du PIC utilisé
    Include "p16F876A.inc"          ;indique le fichier de congfiguration du pic
 
;*************************************************************************************************
;                                                                                                *  
;                           Vecteur de démarage aprés RESET                                      *
;                                                                                                *
;*************************************************************************************************
 
 
    org 0x000                        ;Cette directive précise l'adresse à partir de laquelle
    Unite EQU H'20'                             ;les instructions (programme) seront stockées
    Dizaine EQU H'21'
    Centaine EQU H'22'
    NOMBRE EQU H'23'
    CPT1        EQU         H'24'
    CPT2        EQU         H'25'
    GOTO PROG_PRINCIPAL
 
;*************************************************************************************************
;                                                                                                *  
;                           Mettre le programme entre l'étiquett PROG-PRINCIPAL et END           *
;                                                                                                *
;*************************************************************************************************
tempo
    MOVLW  D'255'     ; mettre 255 dans W
    MOVWF  CPT2        ;Copier W dans CPT
BOUCLE_2
    MOVWF  CPT1
BOUCLE_1
    NOP 
    DECFSZ CPT1,1      ;Décrémente tant que CPT n'est pas égale à 0 et le mettre à jour
    GOTO   BOUCLE_1
    DECFSZ CPT2,1      ;Décrémente tant que CPT n'est pas égale à 0 et le mettre à jour
    GOTO   BOUCLE_2
    RETURN


INIT_LCD
    CALL tempo
    BCF PORTB,1
    MOVLW B'00111100'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0
 
    CALL tempo
    BCF PORTB,1
    MOVLW B'00001100'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0
 
    CALL tempo
    BCF PORTB,1
    MOVLW B'00000001'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0
 
    CALL tempo
    BCF PORTB,1
    MOVLW B'00000110'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0
 
RETURN

Config_PORTS
    BSF STATUS,RP0
    BCF STATUS,RP1
; Mise en entree du port servant pour 
    BCF TRISB,4 
; Mise en sortie du port servant pour 
    BCF TRISB,5
    CLRF TRISC
    BCF STATUS,RP0
 
RETURN



CAN
;******************* CONFIG DE ADCON 0*******************************
;aller en bank0 
    BCF  STATUS,RP0
    BCF STATUS,RP1
;Mise de la valeur de ADCON0
    MOVLW B'01000101';mise sur RA0 pour la conversion
    MOVWF ADCON0
    nop
;******************* CONFIG DE ADCON 1*******************************
;Mise de la valeur de ADCON1
    MOVLW B'00001110'
;aller en bank1
    BSF  STATUS,RP0
    BCF STATUS,RP1
    MOVWF ADCON1
;TRISC en sortie
    MOVLW b'00000000'
    MOVWF TRISC
;******************* LANCEMENT ET ATTENTE DE LA CONVERSION*******************************
;aller en bank0 
    BCF  STATUS,RP0
    BCF STATUS,RP1
;Lancement conversion et attente de la fin de la conversion 
ConversionBegin
    BSF ADCON0,2
EndConversion
    BTFSC ADCON0,2
    GOTO EndConversion
;Déplacement du résultat de la conversion au port C
    MOVF ADRESH,W
    MOVWF NOMBRE
RETURN

;;;;;;;;;;;;;;;;;;;;;;;;CALCUL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CBN_To_ASCII
SUB100
    MOVLW D'100'
    SUBWF NOMBRE,1
    BTFSC STATUS,Z
    GOTO  FinConversionCentaine
    BTFSS STATUS,C
    GOTO  Branch
    INCF  Centaine
    GOTO  SUB100

Branch
    ADDWF NOMBRE,1

ConversionDizaine
    MOVLW D'10'
    SUBWF NOMBRE,1
    BTFSC STATUS,Z
    GOTO  FinConvertionDizaine
    BTFSS STATUS,C
    GOTO FinConversionUnite
    INCF Dizaine
    GOTO ConversionDizaine


FinConversionCentaine
    INCF Centaine,1
    GOTO ConversionASCII

 
FinConvertionDizaine
    INCF Dizaine,1
    GOTO ConversionASCII
 
FinConversionUnite
    ADDWF NOMBRE,1
    MOVF NOMBRE,0
    MOVWF Unite
    GOTO ConversionASCII


ConversionASCII
    MOVLW D'48'
    ADDWF Centaine,1
    ADDWF Dizaine,1
    ADDWF Unite,1
RETURN

    
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Affichage_L1
    CALL tempo
    BCF PORTB,1
    MOVLW B'00000010'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0
 
    CALL tempo
    BSF PORTB,1
    MOVF Centaine,W
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0
 
    CALL tempo
    BSF PORTB,1
    MOVF Dizaine,W
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0
 
    CALL tempo
    BSF PORTB,1
    MOVF Unite,W
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A' '
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'L'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0
    
    CALL tempo
    BSF PORTB,1
    MOVLW A'u'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'x'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0
RETURN


    
;*************************************************************************************************
;                                                                                                *  
;   La déclaration de variables, les macros et autres doit être placée avant l'étiquette         *
;   PROG-PRINCIPAL                                                                               *
;*************************************************************************************************
 
 
PROG_PRINCIPAL
;******************* CONFIG DE ADCON 0*******************************
    CALL Config_PORTS
    CALL INIT_LCD
;aller en bank0 
    BCF  STATUS,RP0
    BCF STATUS,RP1
;Initialisation des Valeur des variables
    MOVLW D'00'
    MOVWF Unite
    MOVWF Dizaine
    MOVWF Centaine

    CALL CAN
    CALL CBN_To_ASCII
    CALL Affichage_L1

finfin      NOP
    GOTO    finfin

    
    END