;*************************************************************************************************
;							     				    	 										 *	
;	              PROGRAMME PERMETTANT DE GENERER UN SIGNAL CARRE SUR LA BROCHE....			     *	
;																				                 *
;							     				    	                                         *	
;*************************************************************************************************
;							     				    											 *	
;					Fichier requis : P16F877A ou P16F877 ou P16F876A ou P16F876		             *	
;							   				    												 *
;------------------------------------------------------------------------------------------------*
;*************************************************************************************************
;							     				    	                                         *		
;Recommendations:										                                         *
;		- Tous les programmes doivent �tre sauvegard�s avec un nom explicite	                 *
;		- Tous les programmes divent �tre d�ment comment�s.				                         *
;		- Cr�er un sous r�pertoire pour chaque nouveau programme pour plus de clart�. 	         *
;		Par exemples: C:Projet\PROG_PIC\Signal-carr�					                         *
;					                                 											 *
;		- Ne pas modifier la mise en page et la taille des caractères.			                 *
;		- Tous les programmes doivent avoir la m�me pr�sentation (copier_coller ou sauvegarder 	 *
;			ce fichier sous un autre nom)											             *
;		- Ne pas oublier de respecter les champs (colonnes) : 				                     *
;			- Premier   : Etiquette			 				                                     *
;			- Deuxi�me  : Instruction		 				                                     *
;			- Troisi�me : Op�rande(s)						                                     *
;			- Quatri�me : ;Commentaire		 				                                     *				 		  				    								 	
;	Les champs peuvent �tre s�par�s par un ou plusiers espaces (ou tabulation(s)				 *				   				    	                                             *
;------------------------------------------------------------------------------------------------*
;											    												 *
;NOM :		JOIRE RAFFOUX ANDRIANJAFINDRADILO					     				    					                     *
;Date : 	07/03/2024							     				    								 *
;Trin�me : 	5					     				    								 		 *
;Ce programme a pour objectif de faire une conversion du CBN vers DCB
;Etape du programme 
;	0. Cree les variable et copier la fonction carr� pour attendre le temp de la conversion
;	1. Faire passer les CAN utilis� en entr�e analogque (via ADCON 1) FCG3-0 = 0000 et le port s�lectionner en port de sortie.
;	2. Convertir ADCON 0 = 0b 01 
;	3. Convertir ADCON 1
;	4. Traiter les 2 bit de poid faible (ajouter +1 sur adressH si il sont tous les deux � 1)
;	5. R�cup�rer la valeur de ADRESSH dans le work	     				    											 
; 	6. Mettre le r�sultat sur un prot digital
;*************************************************************************************************

	

	List p=16F876A					;indique le pic utilis�. Mettre la r�f�rence du PIC utilis�
	Include "p16F876A.inc"			;indique le fichier de congfiguration du pic

;*************************************************************************************************
;							     				    	                                         *	
;							Vecteur de d�marage apr�s RESET 	                                 *
;							     				    	                                         *
;*************************************************************************************************


	org	0x000						 ;Cette directive pr�cise l'adresse � partir de laquelle
	Unite EQU H'20'								;les instructions (programme) seront stock�es
	Dizaine EQU H'21'
    Centaine EQU H'22'
	NOMBRE EQU H'23'
	GOTO PROG_PRINCIPAL

;*************************************************************************************************
;							     				    	                                         *	
;							Mettre le programme entre l'�tiquett PROG-PRINCIPAL et END           *
;							     				    	                                         *
;*************************************************************************************************
SUB10

	SUBWF NOMBRE,1
	BTFSC STATUS,Z
	GOTO  FinConvertionDizaine
	BTFSS STATUS,C
	GOTO FinConversionUnite
	INCF Dizaine
	GOTO SUB10
;*************************************************************************************************
;							     				    	                                         *	
;	La d�claration de variables, les macros et autres doit �tre plac�e avant l'�tiquette         *
;	PROG-PRINCIPAL						     				    	                             *
;*************************************************************************************************


PROG_PRINCIPAL
;******************* CONFIG DE ADCON 0*******************************
;aller en bank0	
	BCF  STATUS,RP0
	BCF	STATUS,RP1
;Initialisation des Valeur des variables
	MOVLW D'00'
	MOVWF Unite
	MOVWF Dizaine
	MOVWF Centaine 
	MOVLW D'27'
	MOVWF NOMBRE 
;Decrementation pour trouver dizaine
	MOVLW D'10'
	GOTO SUB10

;******************* LANCEMENT ET ATTENTE DE LA CONVERSION*******************************
FinConversionUnite
	ADDWF NOMBRE,1
	MOVF NOMBRE,W
	MOVWF H'20'
	GOTO finprogramme

FinConvertionDizaine
	INCF Dizaine,1
	GOTO finprogramme

finprogramme
nop
;affichage sur le port 
	END 
