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
;Ce programme � pour objectif de convertir une valeur analogique en num�rique � l'aide du CAN
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
									;les instructions (programme) seront stock�es
	
	GOTO PROG_PRINCIPAL

;*************************************************************************************************
;							     				    	                                         *	
;							Mettre le programme entre l'�tiquett PROG-PRINCIPAL et END           *
;							     				    	                                         *
;*************************************************************************************************

;*************************************************************************************************
;							     				    	                                         *	
;	La d�claration de variables, les macros et autres doit �tre plac�e avant l'�tiquette         *
;	PROG-PRINCIPAL						     				    	                             *
;*************************************************************************************************


PROG_PRINCIPAL
;******************* CONFIG DE ADCON 0*******************************
;aller en bank0	
	BSF  STATUS,RP0
	BSF	STATUS,RP1
;Mise de la valeur de ADCON0
	MOVLW 0b01000101;mise sur RA0 pour la conversion
	MOVWF ADCON0
	nop
;******************* CONFIG DE ADCON 1*******************************
;Mise de la valeur de ADCON1
	MOVLW 0b00001110
;aller en bank1
	BSF  STATUS,RP0
	BCF	STATUS,RP1
	MOVWF ADCON1
;TRISC en sortie
	MOVLW 0b00000000
	MOVWF TRISC
	MOVLW 0b11111111
;******************* LANCEMENT ET ATTENTE DE LA CONVERSION*******************************
;aller en bank0	
	BCF  STATUS,RP0
	BCF	STATUS,RP1
;Lancement conversion et attente de la fin de la conversion 
ConversionBegin
	BSF ADCON0,2
EndConversion
	BTFSC ADCON0,2
;	GOTO EndConversion
;D�placement du r�sultat de la conversion au port C
	MOVF ADRESH,W
	MOVWF PORTC
	GOTO ConversionBegin 

	END 
