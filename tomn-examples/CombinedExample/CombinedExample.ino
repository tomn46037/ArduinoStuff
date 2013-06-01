//Copied from SainSmart
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd7(0x27,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd6(0x26,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd5(0x25,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd4(0x24,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd3(0x23,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd2(0x22,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd1(0x21,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd0(0x20,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display


int c = 1;





// Now we setup for the Barometric Pressure sensor.
#define BMP085_ADDRESS 0x77  // I2C address of BMP085

const unsigned char OSS = 0;  // Oversampling Setting

// Calibration values
int ac1;
int ac2; 
int ac3; 
unsigned int ac4;
unsigned int ac5;
unsigned int ac6;
int b1; 
int b2;
int mb;
int mc;
int md;

// b5 is calculated in bmp085GetTemperature(...), this variable is also used in bmp085GetPressure(...)
// so ...Temperature(...) must be called before ...Pressure(...).
long b5; 

short temperature;
long pressure;




void setup()
{

  // Init the Baro sensor
  bmp085Calibration();
  
  lcd7.init();
  lcd7.init();
  lcd7.backlight();
  lcd7.setCursor(0,0);
  lcd7.print("Display Number 7");
  lcd7.setCursor(2,1);
  lcd7.print("Copied from SainSmart");

  lcd7.setCursor(0,1);
  lcd7.print("Initializing 6      ");

  lcd6.init();  
  lcd6.init();  
  lcd6.backlight();
  lcd6.setCursor(0,0);
  lcd6.print("Display Number 6");
  lcd6.setCursor(2,1);
  lcd6.print("Copied from SainSmart");

  lcd7.setCursor(0,1);
  lcd7.print("Initializing 5      ");

  lcd5.init();
  lcd5.init();
  lcd5.backlight();
  lcd5.setCursor(0,0);
  lcd5.print("Display Number 5");
  lcd5.setCursor(2,1);
  lcd5.print("Copied from SainSmart");

  lcd7.setCursor(0,1);
  lcd7.print("Initializing 4      ");

  lcd4.init();
  lcd4.init();
  lcd4.backlight();
  lcd4.setCursor(0,0);
  lcd4.print("Display Number 4");
  lcd4.setCursor(2,1);
  lcd4.print("Copied from SainSmart");

  lcd7.setCursor(0,1);
  lcd7.print("Initializing 3      ");

  lcd3.init();
  lcd3.init();
  lcd3.backlight();
  lcd3.setCursor(0,0);
  lcd3.print("Display Number 3");
  lcd3.setCursor(2,1);
  lcd3.print("Copied from SainSmart");

  lcd7.setCursor(0,1);
  lcd7.print("Initializing 2      ");

  lcd2.init();
  lcd2.init();
  lcd2.backlight();
  lcd2.setCursor(0,0);
  lcd2.print("Display Number 2");
  lcd2.setCursor(2,1);
  lcd2.print("Copied from SainSmart");

  lcd7.setCursor(0,1);
  lcd7.print("Initializing 1      ");

  lcd1.init();
  lcd1.init();
  lcd1.backlight();
  lcd1.setCursor(0,0);
  lcd1.print("Display Number 1");
  lcd1.setCursor(2,1);
  lcd1.print("Copied from SainSmart");

  lcd7.setCursor(0,1);
  lcd7.print("Initializing 0      ");

  lcd0.init();
  lcd0.init();
  lcd0.backlight();
  lcd0.setCursor(0,0);
  lcd0.print("Display Number 0");
  lcd0.setCursor(2,1);
  lcd0.print("Copied from SainSmart");
  lcd7.setCursor(0,1);
  lcd7.print("Initialiation Done..");

}

void loop()
{
  delay(1000);
  lcd7.clear();
  lcd7.setCursor(0,0);
  lcd7.print("This is a test!");
  
  lcd7.setCursor(10,1);
  lcd7.print(c++, DEC);

  lcd1.clear();
  lcd1.setCursor(0,0);
  lcd1.print("This is a test!");
  
  lcd1.setCursor(10,1);
  lcd1.print(c++, DEC);
  
}



