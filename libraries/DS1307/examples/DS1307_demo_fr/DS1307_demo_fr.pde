/*
 * Sketch de lecture et programmation via port serie pour horloge RTC I2C DS1307
 *
 * Librairie DS1307 fournie par mattt et D. Sjunnesson et corrigée par bricofoy.
 * Voir DS1307.h pour plus de détails
 *
 * Exemple sous licence GNU GPL
 *
 * (c) bricofoy 2012
 *
 */



// compatibilité entre arduino 1.0 en anciennes versions
#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif

#include <Wire.h>
#include <DS1307.h>

void setup() {
  Serial.begin(9600);
  usage();
  lecture_RTC();
}


// explication de l'utilisation
void usage() {
  Serial.println("\nUSAGE : u U r R h[00-23]m[00-59]s[00-59]j0[1-7]D[01-31]M[01-12]A[00-49]");
  Serial.println("\nEXEMPLE : h09m35j03 regle l'heure sur 09h35 et jour de la semaine 3 (mardi).");
  Serial.println("\nCommandes : h** : heure, m** : minutes, s** : secondes, j0* : jour de la semaine");
  Serial.println("            M** : mois,  A** : annee,   D** : jour de la date.");
  Serial.println("            r stoppe l'horloge, R la demarre. ");
  Serial.println("            u ou U affichent ce message, tout autre caractere affiche l'heure.");
}

// fonction de lecture de l'heure dans le DS1307
void lecture_RTC() {
	  Serial.print("\nHeure actuelle : ");
	  Serial.print(RTC.get(DS1307_HR,true)); //read the hour and also update all the values by pushing in true
	  Serial.print(":");
	  Serial.print(RTC.get(DS1307_MIN,false));//read minutes without update (false)
	  Serial.print(":");
	  Serial.print(RTC.get(DS1307_SEC,false));//read seconds
	  Serial.print(" ");                 // some space for a more happy life
	  Serial.print(RTC.get(DS1307_DOW,false));
	  Serial.print(" ");
	  Serial.print(RTC.get(DS1307_DATE,false));//read date
	  Serial.print("/");
	  Serial.print(RTC.get(DS1307_MTH,false));//read month
	  Serial.print("/");
	  Serial.println(RTC.get(DS1307_YR,false)); //read year
}

// paramétrage de l'horloge
void ecriture_RTC() {
      char valeur=0;
      char commande=0;

      commande = Serial.read();
      delay(50);				//delai pour permettre la bonne lecture du port série.
      valeur=byte((Serial.read()-48)*10); 	//-48 car la valeur ascii du 0 est 48, celle du 1 est 49, etc.
      delay(50);					//et*10 car on lit d'abord les dizaines
      valeur+=byte((Serial.read()-48));		//lecture des unités

      switch (commande) {
	case 'h' :
	  RTC.set(DS1307_HR,valeur);
	  Serial.print("champ heures regle sur ");
	  Serial.println(valeur,DEC);
	  break;
	case 'm' :
	  RTC.set(DS1307_MIN,valeur);
	  Serial.print("champ minutes regle sur ");
	  Serial.println(valeur,DEC);
	  break;
	case 's' :
	  RTC.set(DS1307_SEC,valeur);
	  Serial.print("champ secondes regle sur ");
	  Serial.println(valeur,DEC);
	  break;
	case 'D' :
	  RTC.set(DS1307_DATE,valeur);
	  Serial.print("champ date regle sur ");
	  Serial.println(valeur,DEC);
	  break;
	case 'j' :
	  RTC.set(DS1307_DOW,valeur);
	  Serial.print("champ jour regle sur ");
	  Serial.println(valeur,DEC);
	  break;
	case 'M' :
	  RTC.set(DS1307_MTH,valeur);
	  Serial.print("champ mois regle sur ");
	  Serial.println(valeur,DEC);
	  break;
	case 'A' :
	  RTC.set(DS1307_YR,valeur);
	  Serial.print("champ annee regle sur ");
	  Serial.println(valeur,DEC);
	  break;
	case 'u' :
	case 'U' :
	  usage();
	  break;
	case 'r' :
	  RTC.stop();
	  Serial.println("Horloge stoppee");
	  break;
	case 'R' :
	  RTC.start();
	  Serial.println("Horloge lancee");
	  break;
	default :
	  break;
      }
      lecture_RTC();
}

void loop() {
   if (Serial.available()) {
     ecriture_RTC();
    }
}


