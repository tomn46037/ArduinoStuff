// Adafruit Motor shield library
// copyright Adafruit Industries LLC, 2009
// this code is public domain, enjoy!

#include <AFMotor.h>
#include <Servo.h> 

// DC motor on M2
AF_DCMotor motor(2);
AF_DCMotor motor3(3);

// DC hobby servo
Servo servo1;
Servo servo2;

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("Motor party!");
  
  // turn on servo
  servo1.attach(9);
  servo2.attach(10);

   
  // turn on motor #2
  motor.setSpeed(200);
  motor.run(RELEASE);
  motor3.setSpeed(200);
  motor3.run(RELEASE);
}

int i;

// Test the DC motor, stepper and servo ALL AT ONCE!
void loop() {
  motor.run(FORWARD);
  motor3.run(FORWARD);
  for (i=0; i<255; i++) {
    servo1.write(i);
    servo2.write(i);
    motor.setSpeed(i);  
    motor3.setSpeed(255-i);  
     delay(3);
 }
 
  for (i=255; i!=0; i--) {
    servo1.write(i-255);
    servo2.write(i-255);
    motor.setSpeed(i);  
    motor3.setSpeed(255-i);  
    delay(3);
 }
 
  motor.run(BACKWARD);
  motor3.run(BACKWARD);
  for (i=0; i<255; i++) {
    servo1.write(i);
    servo2.write(i);
    motor.setSpeed(i);  
    motor3.setSpeed(255-i);  
    delay(3);
 }
 
  for (i=255; i!=0; i--) {
    servo1.write(i-255);
    servo2.write(i-255);
    motor.setSpeed(i);  
    motor3.setSpeed(255-i);  
    delay(3);
 }
}
