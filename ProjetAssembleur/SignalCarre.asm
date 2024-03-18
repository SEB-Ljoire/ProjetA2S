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
;       - Tous les programmes doivent être sauvegardés avec un nom explicite                     *
;       - Tous les programmes divent être dûment commentés.                                      *
;       - Créer un sous répertoire pour chaque nouveau programme pour plus de clarté.            *
;       Par exemples: C:Projet\PROG_PIC\Signal-carré                                             *
;                                                                                                *
;       - Ne pas modifier la mise en page et la taille des caractÃ¨res.                          *
;       - Tous les programmes doivent avoir la même présentation (copier_coller ou sauvegarder   *
;           ce fichier sous un autre nom)                                                        *
;       - Ne pas oublier de respecter les champs (colonnes) :                                    *
;           - Premier   : Etiquette                                                              *
;           - Deuxième  : Instruction                                                            *
;           - Troisième : Opérande(s)                                                            *
;           - Quatrième : ;Commentaire                                                           *                                                                              
;   Les champs peuvent être séparés par un ou plusiers espaces (ou tabulation(s)                 *                                                                                   *
;------------------------------------------------------------------------------------------------*
;                                                                                                *
;NOM :                                                                                           *
;Date :                                                                                          *
;Trinôme :                                                                                       *
;                                                                                                *
;*************************************************************************************************
CPT   EQU	H'20'
    

    List p=16F876A              ; Spécifie le type de PIC utilisé pour le compilateur
    Include "p16f876a.inc"      ; Inclut le fichier d'en-tête pour le PIC16F876A
    

;*************************************************************************************************
;                                                                                                *  
;                           Vecteur de démarage aprés RESET                                      *
;                                                                                                *
;*************************************************************************************************


    org 0x000                        ;Cette directive précise l'adresse à partir de laquelle
                                    ;les instructions (programme) seront stockées
    
    GOTO PROG_PRINCIPAL

;*************************************************************************************************
;                                                                                                *  
;                           Mettre le programme entre l'étiquett PROG-PRINCIPAL et END           *
;                                                                                                *
;*************************************************************************************************

;*************************************************************************************************
;                                                                                                *  
;   La déclaration de variables, les macros et autres doit être placée avant l'étiquette         *
;   PROG-PRINCIPAL                                                                               *
;*************************************************************************************************


PROG_PRINCIPAL
    BSF  STATUS,RP0
	BCF STATUS,RP1            ; Sélectionne le registre banque 1 pour accéder à la configuration des ports
    CLRF TRISB               ; Configure le bit 0 du port C (RC0) en mode sortie
    BCF  STATUS,RP0            ; Retour à la banque de registres 0 pour les opérations normales

BOUCLE   
    BSF  PORTB,2
    MOVLW D'255'
	MOVWF		CPT   ; Met le bit 0 du port C à l'état haut (allume la LED/connecté à RC0)
DELAIS_LOOP
    DECFSZ		CPT,1                   ; Décrémente la valeur dans W
                ; Vérifie si le bit Zéro (Z) du registre STATUS est actif (W=0)
    GOTO DELAIS_LOOP           ; Si W n'est pas encore 0, continue la boucle
    BCF  PORTB,2               ; Met le bit 0 du port C à l'état bas (éteint la LED/connecté à RC0)
    MOVLW D'255'               ; Charge le registre W avec la valeur 255 (base du délai)
	MOVWF		CPT                ; Appelle à nouveau la routine de délai pour contrôler la durée de l'état bas
DELAIS_LOOP2
    DECFSZ		CPT,1                   ; Décrémente la valeur dans W
    GOTO DELAIS_LOOP2           ; Si W n'est pas encore 0, continue la boucle               ; Boucle indéfiniment, générant ainsi un signal carré
	GOTO BOUCLE

END                             ; Indique la fin du programme