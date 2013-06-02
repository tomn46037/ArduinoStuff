//Copied from SainSmart
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <L3G4200D.h>

LiquidCrystal_I2C lcd7(0x27,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd6(0x26,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd5(0x25,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd4(0x24,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd3(0x23,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd2(0x22,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd1(0x21,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd0(0x20,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display


int c = 1;


// Gyro 
L3G4200D gyro;

// Accelerometer
#define Register_ID 0
#define Register_2D 0x2D
#define Register_X0 0x32
#define Register_X1 0x33
#define Register_Y0 0x34
#define Register_Y1 0x35
#define Register_Z0 0x36
#define Register_Z1 0x37

int ADXAddress = 0xA7 >> 1;  // the default 7-bit slave address
int reading = 0;
int val=0;
int X0,X1,X_out;
int Y0,Y1,Y_out;
int Z1,Z0,Z_out;
double Xg,Yg,Zg;


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

// Compass

#define addressCompass 0x1E //0011110b, I2C 7bit address of HMC5883


void setup()
{

  
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
  lcd7.print("Initializing BMP085..");

  // Init the Baro sensor
  bmp085Calibration();

  lcd7.setCursor(0,1);
  lcd7.print("Init Gyro..     ");

  gyro.enableDefault();

  lcd7.setCursor(0,1);
  lcd7.print("Init Accel..     ");

  Wire.beginTransmission(ADXAddress);
  Wire.write(Register_2D);
  Wire.write(8);                //measuring enable
  Wire.endTransmission();     // stop transmitting

  lcd7.setCursor(0,1);
  lcd7.print("Init Compass..     ");

  //Put the HMC5883 IC into the correct operating mode
  Wire.beginTransmission(addressCompass); //open communication with HMC5883
  Wire.write(0x02); //select mode register
  Wire.write(0x00); //continuous measurement mode
  Wire.endTransmission();

  lcd7.setCursor(0,1);
  lcd7.print("Done with Init..");

}

void loop()
{
  delay(100);

  // Gyro
  gyro.read();

  lcd0.clear();
  lcd7.clear();
  lcd7.setCursor(0,0);

  lcd7.setCursor(0,1);
  lcd7.print((int)gyro.g.x);

  lcd7.setCursor(5,1);
  lcd7.print((int)gyro.g.y);

  lcd7.setCursor(10,1);
  lcd7.print((int)gyro.g.z);

  //Accel
  //--------------X
  Wire.beginTransmission(ADXAddress); // transmit to device
  Wire.write(Register_X0);
  Wire.write(Register_X1);
  Wire.endTransmission();
  Wire.requestFrom(ADXAddress,2); 
  if(Wire.available()<=2)   
  {
    X0 = Wire.read();
    X1 = Wire.read(); 
    X1=X1<<8;
    X_out=X0+X1;   
  }

  //------------------Y
  Wire.beginTransmission(ADXAddress); // transmit to device
  Wire.write(Register_Y0);
  Wire.write(Register_Y1);
  Wire.endTransmission();
  Wire.requestFrom(ADXAddress,2); 
  if(Wire.available()<=2)   
  {
    Y0 = Wire.read();
    Y1 = Wire.read(); 
    Y1=Y1<<8;
    Y_out=Y0+Y1;
  }
  //------------------Z
  Wire.beginTransmission(ADXAddress); // transmit to device
  Wire.write(Register_Z0);
  Wire.write(Register_Z1);
  Wire.endTransmission();
  Wire.requestFrom(ADXAddress,2); 
  if(Wire.available()<=2)   
  {
    Z0 = Wire.read();
    Z1 = Wire.read(); 
    Z1=Z1<<8;
    Z_out=Z0+Z1;
  }
  //
  Xg=X_out/256.0;
  Yg=Y_out/256.0;
  Zg=Z_out/256.0;

  lcd7.setCursor(0,0);
  lcd7.print(Xg);

  lcd7.setCursor(5,0);
  lcd7.print(Yg);

  lcd7.setCursor(10,0);
  lcd7.print(Zg);

  //Compass
  int x,y,z; //triple axis data

  //Tell the HMC5883 where to begin reading data
  Wire.beginTransmission(addressCompass);
  Wire.write(0x03); //select register 3, X MSB register
  Wire.endTransmission();
  
 
  //Read data from each axis, 2 registers per axis
  Wire.requestFrom(addressCompass, 6);
  if(6<=Wire.available()){
    x = Wire.read()<<8; //X msb
    x |= Wire.read(); //X lsb
    z = Wire.read()<<8; //Z msb
    z |= Wire.read(); //Z lsb
    y = Wire.read()<<8; //Y msb
    y |= Wire.read(); //Y lsb
  }

  lcd0.setCursor(0,1);
  lcd0.print(x);

  lcd0.setCursor(5,1);
  lcd0.print(y);

  lcd0.setCursor(10,1);
  lcd0.print(z);



  if ( c%100 ) {  
    temperature = bmp085GetTemperature(bmp085ReadUT());
    pressure = bmp085GetPressure(bmp085ReadUP());

    lcd1.clear();
    lcd1.setCursor(0,0);
    lcd1.print("Temp: ");
    lcd1.print(temperature*.1, DEC);
    lcd1.print(" deg C");
  
    lcd1.setCursor(0,1);
    lcd1.print("Baro: ");
    lcd1.print(pressure*0.0002952998016471232, DEC);
    lcd1.print(" Inches");
  }
}



// Baro stuff..
// Stores all of the bmp085's calibration values into global variables
// Calibration values are required to calculate temp and pressure
// This function should be called at the beginning of the program
void bmp085Calibration()
{
  ac1 = bmp085ReadInt(0xAA);
  ac2 = bmp085ReadInt(0xAC);
  ac3 = bmp085ReadInt(0xAE);
  ac4 = bmp085ReadInt(0xB0);
  ac5 = bmp085ReadInt(0xB2);
  ac6 = bmp085ReadInt(0xB4);
  b1 = bmp085ReadInt(0xB6);
  b2 = bmp085ReadInt(0xB8);
  mb = bmp085ReadInt(0xBA);
  mc = bmp085ReadInt(0xBC);
  md = bmp085ReadInt(0xBE);
}

// Calculate temperature given ut.
// Value returned will be in units of 0.1 deg C
short bmp085GetTemperature(unsigned int ut)
{
  long x1, x2;
  
  x1 = (((long)ut - (long)ac6)*(long)ac5) >> 15;
  x2 = ((long)mc << 11)/(x1 + md);
  b5 = x1 + x2;

  return ((b5 + 8)>>4);  
}

// Calculate pressure given up
// calibration values must be known
// b5 is also required so bmp085GetTemperature(...) must be called first.
// Value returned will be pressure in units of Pa.
long bmp085GetPressure(unsigned long up)
{
  long x1, x2, x3, b3, b6, p;
  unsigned long b4, b7;
  
  b6 = b5 - 4000;
  // Calculate B3
  x1 = (b2 * (b6 * b6)>>12)>>11;
  x2 = (ac2 * b6)>>11;
  x3 = x1 + x2;
  b3 = (((((long)ac1)*4 + x3)<<OSS) + 2)>>2;
  
  // Calculate B4
  x1 = (ac3 * b6)>>13;
  x2 = (b1 * ((b6 * b6)>>12))>>16;
  x3 = ((x1 + x2) + 2)>>2;
  b4 = (ac4 * (unsigned long)(x3 + 32768))>>15;
  
  b7 = ((unsigned long)(up - b3) * (50000>>OSS));
  if (b7 < 0x80000000)
    p = (b7<<1)/b4;
  else
    p = (b7/b4)<<1;
    
  x1 = (p>>8) * (p>>8);
  x1 = (x1 * 3038)>>16;
  x2 = (-7357 * p)>>16;
  p += (x1 + x2 + 3791)>>4;
  
  return p;
}

// Read 1 byte from the BMP085 at 'address'
char bmp085Read(unsigned char address)
{
  unsigned char data;
  
  Wire.beginTransmission(BMP085_ADDRESS);
  Wire.write(address);
  Wire.endTransmission();
  
  Wire.requestFrom(BMP085_ADDRESS, 1);
  while(!Wire.available())
    ;
    
  return Wire.read();
}

// Read 2 bytes from the BMP085
// First byte will be from 'address'
// Second byte will be from 'address'+1
int bmp085ReadInt(unsigned char address)
{
  unsigned char msb, lsb;
  
  Wire.beginTransmission(BMP085_ADDRESS);
  Wire.write(address);
  Wire.endTransmission();
  
  Wire.requestFrom(BMP085_ADDRESS, 2);
  while(Wire.available()<2)
    ;
  msb = Wire.read();
  lsb = Wire.read();
  
  return (int) msb<<8 | lsb;
}

// Read the uncompensated temperature value
unsigned int bmp085ReadUT()
{
  unsigned int ut;
  
  // Write 0x2E into Register 0xF4
  // This requests a temperature reading
  Wire.beginTransmission(BMP085_ADDRESS);
  Wire.write(0xF4);
  Wire.write(0x2E);
  Wire.endTransmission();
  
  // Wait at least 4.5ms
  delay(5);
  
  // Read two bytes from registers 0xF6 and 0xF7
  ut = bmp085ReadInt(0xF6);
  return ut;
}

// Read the uncompensated pressure value
unsigned long bmp085ReadUP()
{
  unsigned char msb, lsb, xlsb;
  unsigned long up = 0;
  
  // Write 0x34+(OSS<<6) into register 0xF4
  // Request a pressure reading w/ oversampling setting
  Wire.beginTransmission(BMP085_ADDRESS);
  Wire.write(0xF4);
  Wire.write(0x34 + (OSS<<6));
  Wire.endTransmission();
  
  // Wait for conversion, delay time dependent on OSS
  delay(2 + (3<<OSS));
  
  // Read register 0xF6 (MSB), 0xF7 (LSB), and 0xF8 (XLSB)
  Wire.beginTransmission(BMP085_ADDRESS);
  Wire.write(0xF6);
  Wire.endTransmission();
  Wire.requestFrom(BMP085_ADDRESS, 3);
  
  // Wait for data to become available
  while(Wire.available() < 3)
    ;
  msb = Wire.read();
  lsb = Wire.read();
  xlsb = Wire.read();
  
  up = (((unsigned long) msb << 16) | ((unsigned long) lsb << 8) | (unsigned long) xlsb) >> (8-OSS);
  
  return up;
}





