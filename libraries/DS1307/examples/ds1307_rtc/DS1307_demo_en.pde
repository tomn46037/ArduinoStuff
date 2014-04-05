/*
 *
 * Read and set through serial port demo sketch for DS1307 I2C rtc clock
 *
 * DS1307 library provided by mattt & D.Sjunnesson, corrected by bricofoy.
 * See DS1307.h for more details.
 *
 * This exemple code is under GNU GPL
 *
 * (c) bricofoy 2012
 *
 */



// This is for compatibility with both arduino 1.0 and previous versions
#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif

#include <Wire.h>
#include <DS1307.h>

void setup() {
  Serial.begin(9600);
  use();
  read_RTC();
}


// use explanation message
void use() {
  Serial.println("\nUSE      : u U r R h[00-23]m[00-59]s[00-59]j0[1-7]D[01-31]M[01-12]A[00-49]");
  Serial.println("\nEXEMPLE  : h09m35d03 set time to 09h35 and day of week 3 (thuesday).");
  Serial.println("\nCommands : h** : hour,  m** : minutes, s** : seconds, d0* : day of week");
  Serial.println("           M** : month,  Y** : year,   D** : day of month.");
  Serial.println("           r stops clock, R starts it. ");
  Serial.println("           u or U shows this message, all other caracter shows time.");
}

// DS1307 time read function
void read_RTC() {
	  Serial.print("\nActual time : ");
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

// set clock values
void write_RTC() {
      char value=0;
      char command=0;

      command = Serial.read();
      delay(50);				//delay to allow good serial port reading
      value=byte((Serial.read()-48)*10); 	//-48 becaus ASCII value for 0 is 48, 1 is 49, etc and *10 because we read tens first
      delay(50);
      value+=byte((Serial.read()-48));		//and then we read units

      switch (command) {
	case 'h' :
	  RTC.set(DS1307_HR,value);
	  Serial.print("hours set to ");
	  Serial.println(value,DEC);
	  break;
	case 'm' :
	  RTC.set(DS1307_MIN,value);
	  Serial.print("minutes set to ");
	  Serial.println(value,DEC);
	  break;
	case 's' :
	  RTC.set(DS1307_SEC,value);
	  Serial.print("seconds set to ");
	  Serial.println(value,DEC);
	  break;
	case 'D' :
	  RTC.set(DS1307_DATE,value);
	  Serial.print("day of month set to ");
	  Serial.println(value,DEC);
	  break;
	case 'd' :
	  RTC.set(DS1307_DOW,value);
	  Serial.print("day of week set to ");
	  Serial.println(value,DEC);
	  break;
	case 'M' :
	  RTC.set(DS1307_MTH,value);
	  Serial.print("month set to ");
	  Serial.println(value,DEC);
	  break;
	case 'Y' :
	  RTC.set(DS1307_YR,value);
	  Serial.print("year set to ");
	  Serial.println(value,DEC);
	  break;
	case 'u' :
	case 'U' :
	  use();
	  break;
	case 'r' :
	  RTC.stop();
	  Serial.println("Clock stopped");
	  break;
	case 'R' :
	  RTC.start();
	  Serial.println("Clock running");
	  break;
	default :
	  break;
      }
      read_RTC();
}

void loop() {
   if (Serial.available()) {
     write_RTC();
    }
}


