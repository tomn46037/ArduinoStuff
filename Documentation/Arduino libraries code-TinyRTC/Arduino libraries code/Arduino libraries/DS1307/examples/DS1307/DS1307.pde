#include <WProgram.h>
#include <Wire.h>
#include <DS1307.h>

int rtc[7];
int ledPin =  13;
void setup()
{
  DDRC|=_BV(2) |_BV(3);  // POWER:Vcc Gnd
  PORTC |=_BV(3);  // VCC PINC3
  pinMode(ledPin, OUTPUT);  
  Serial.begin(9600);

  RTC.stop();
  RTC.set(DS1307_SEC,1);
  RTC.set(DS1307_MIN,57);
  RTC.set(DS1307_HR,17);
  RTC.set(DS1307_DOW,2);
  RTC.set(DS1307_DATE,18);
  RTC.set(DS1307_MTH,1);
  RTC.set(DS1307_YR,10);
  RTC.start();
}

void loop()
{
  RTC.get(rtc,true);

  for(int i=0; i<7; i++)
  {
    Serial.print(rtc[i]);
    Serial.print(" ");
  }
  Serial.println();
	digitalWrite(ledPin, HIGH); 
	delay(500);
	digitalWrite(ledPin, LOW);
	delay(500);
}

