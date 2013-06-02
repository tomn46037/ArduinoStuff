/*Reads the value from a Real Time Clock (RTC) DS1307 and displays it in the serial monitor
 *
 *Created by D. Sjunnesson 1scale1.com d.sjunnesson (at) 1scale1.com
 *
 *Created with combined information from
 *http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1180908809
 *http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1191209057
 *
 *
 *Big credit to  mattt (please contact me for a more correct name...) from the Arduino forum
 *which has written the main part of the library which I have modified
 *
 *Modified 21-feb-2012 by bricofoy : bugfixes and arduino 1.0 compatibility
 *   bricofoy (at) free (dot) fr
 *
 */


// This is for compatibility with both arduino 1.0 and previous versions
#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif


#include <Wire.h>
#include <DS1307.h> // written by  mattt on the Arduino forum and modified by D. Sjunnesson

#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x20,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display


void setup()
{
  Serial.begin(9600);
 
  lcd.init();
  lcd.init();
  lcd.backlight();
  lcd.clear();

  lcd.print("Initializing..");
  
}

void loop()
{

  delay(1000);
  lcd.clear();
  lcd.setCursor(0,0);

  lcd.print(RTC.get(DS1307_HR,true)); //read the hour and also update all the values by pushing in true
  lcd.print(":");
  lcd.print(RTC.get(DS1307_MIN,false));//read minutes without update (false)
  lcd.print(":");
  lcd.print(RTC.get(DS1307_SEC,false));//read seconds

  lcd.setCursor(0,1);
  lcd.print(RTC.get(DS1307_MTH,false));//read month
  lcd.print("/");
  lcd.print(RTC.get(DS1307_DATE,false));//read date
  lcd.print("/");
  lcd.print(RTC.get(DS1307_YR,false)); //read year
  lcd.println();


}



