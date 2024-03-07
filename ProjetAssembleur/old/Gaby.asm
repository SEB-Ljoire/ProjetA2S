;*************************************************************************************************
;                                                                                                *  
;                 PROGRAMME PERMETTANT DE GENERER UN SIGNAL CARRE SUR LA BROCHE....              *  
;                                                                                                *
;                                                                                                *  
;*************************************************************************************************
;                                                                                                *  
;                   Fichier requis : P16F877A ou P16F877 ou P16F876A ou P16F876                  *  
;                                                                                                *
;------------------------------------------------------------------------------------------------*
;*************************************************************************************************
;                                                                                                *  
;Recommendations:                                                                                *
;       - Tous les programmes doivent �tre sauvegard�s avec un nom explicite                     *
;       - Tous les programmes divent �tre d�ment comment�s.                                      *
;       - Cr�er un sous r�pertoire pour chaque nouveau programme pour plus de clart�.            *
;       Par exemples: C:Projet\PROG_PIC\Signal-carr�                                             *
;                                                                                                *
;       - Ne pas modifier la mise en page et la taille des caractères.                          *
;       - Tous les programmes doivent avoir la m�me pr�sentation (copier_coller ou sauvegarder   *
;           ce fichier sous un autre nom)                                                        *
;       - Ne pas oublier de respecter les champs (colonnes) :                                    *
;           - Premier   : Etiquette                                                              *
;           - Deuxi�me  : Instruction                                                            *
;           - Troisi�me : Op�rande(s)                                                            *
;           - Quatri�me : ;Commentaire                                                           *                                                                              
;   Les champs peuvent �tre s�par�s par un ou plusiers espaces (ou tabulation(s)                 *                                                                                   *
;------------------------------------------------------------------------------------------------*
;                                                                                                *
;NOM :                                                                                           *
;Date :                                                                                          *
;Trin�me :                                                                                       *
;                                                                                                *
;*************************************************************************************************
		CPT   EQU	H'20'
    

    List p=16F876A              ; Sp�cifie le type de PIC utilis� pour le compilateur
    Include "p16f876a.inc"      ; Inclut le fichier d'en-t�te pour le PIC16F876A
    

;*************************************************************************************************
;                                                                                                *  
;                           Vecteur de d�marage apr�s RESET                                      *
;                                                                                                *
;*************************************************************************************************


    org 0x000                        ;Cette directive pr�cise l'adresse � partir de laquelle
                                    ;les instructions (programme) seront stock�es
    
    GOTO PROG_PRINCIPAL

;*************************************************************************************************
;                                                                                                *  
;                           Mettre le programme entre l'�tiquett PROG-PRINCIPAL et END           *
;                                                                                                *
;*************************************************************************************************

;*************************************************************************************************
;                                                                                                *  
;   La d�claration de variables, les macros et autres doit �tre plac�e avant l'�tiquette         *
;   PROG-PRINCIPAL                                                                               *
;*************************************************************************************************


PROG_PRINCIPAL
    BSF  STATUS,RP0            ; S�lectionne le registre banque 1 pour acc�der � la configuration des ports
    BCF  TRISC,0               ; Configure le bit 0 du port C (RC0) en mode sortie
    BCF  STATUS,RP0            ; Retour � la banque de registres 0 pour les op�rations normales

BOUCLE   
    BSF  PORTC,0               ; Met le bit 0 du port C � l'�tat haut (allume la LED/connect� � RC0)
    CALL DELAIS                ; Appelle la routine de d�lai pour contr�ler la dur�e de l'�tat haut
    BCF  PORTC,0               ; Met le bit 0 du port C � l'�tat bas (�teint la LED/connect� � RC0)
    CALL DELAIS                ; Appelle � nouveau la routine de d�lai pour contr�ler la dur�e de l'�tat bas
    GOTO BOUCLE                ; Boucle ind�finiment, g�n�rant ainsi un signal carr�

; Routine de d�lai simple (Ajustez le d�lai en modifiant le contenu de la boucle)
DELAIS
    MOVLW D'255'               ; Charge le registre W avec la valeur 255 (base du d�lai)
	MOVWF		CPT
DELAIS_LOOP
    DECFSZ		CPT,1                   ; D�cr�mente la valeur dans W
                ; V�rifie si le bit Z�ro (Z) du registre STATUS est actif (W=0)
    GOTO DELAIS_LOOP           ; Si W n'est pas encore 0, continue la boucle
    RETURN                     ; Retourne de la routine de d�lai quand W atteint 0

END                             ; Indique la fin du programme