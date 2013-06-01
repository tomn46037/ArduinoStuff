//Copied from SainSmart
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27,16,2);  // set the LCD address to 0x3F for a 16 chars and 2 line display

int c = 1;

void setup()
{
  lcd.init();                      // initialize the lcd 
  lcd.init();
  // Print a message to the LCD.
  lcd.backlight();
  lcd.setCursor(3,0);
  lcd.print("Hello, world!");
  lcd.setCursor(2,1);
  lcd.print("Copied from SainSmart");
}

void loop()
{
  delay(1000);
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("This is a test!");
  
  lcd.setCursor(10,1);
  lcd.print(c++, DEC);
  
}



