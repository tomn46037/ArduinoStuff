// Mostly stolen from the Internet.

// Confirmed - this does work with the crappy
// motor driver from Ebay.

// fw = forward
// rv = reverse
// af = A motor forward
// ar = A motor reverse
// bf = B motor forward
// br = B motor reverse

// each should be followed by a value or nothing.
// Value is dumped into the PWM output.
// If it's blank - it will be a 0 - thus = stop.

#include <AFMotor.h>
#include <Servo.h>

// DC motor on M2
AF_DCMotor motor(2);
AF_DCMotor motor1(3);

// DC hobby servo
Servo servo1;
Servo servo2;


#define SerialSpeed 9600
#define BufferLength 16
#define LineEnd 0xa
 
char inputBuffer[BufferLength];
 
void setup()
{
  Serial.begin(SerialSpeed); 
  
  // turn on servo
  servo1.attach(9);
  servo2.attach(10);

    // turn on motor #2
  motor.setSpeed(0);
  motor.run(RELEASE);
  motor1.setSpeed(0);
  motor1.run(RELEASE);

}
 
// process a command string
void HandleCommand(char* input, int length)
{
  Serial.print("Input: ");
  Serial.println(input);
  if (length < 2) { // not a valid command
    Serial.println("Line too short!");
    return;
  }
  int value = 0;
  // calculate number following command
  if (length > 2) {
    value = atoi(&input[2]);
  }
  int* command = (int*)input;
  Serial.print("Value: ");
  Serial.println(value);
  // check commands
  // note that the two bytes are swapped, ie 'RA' means command AR
  switch(*command) {
   case 'RB':
      Serial.println("BRAKE AB");
      // motor A forwards
      motor.run(BRAKE);
      motor1.run(BRAKE);
     break;
   case 'og':
      Serial.println("GO AB");
      // motor A forwards
      motor.run(FORWARD);
      motor1.run(FORWARD);
     break;
     case 'er':
      Serial.println("RELEASE AB");
      // motor A forwards
      motor.run(RELEASE);
      motor1.run(RELEASE);
     break;
     case 'wf':
      Serial.println("Forward AB");
      // motor A forwards
      motor.run(FORWARD);
      motor1.run(FORWARD);
      
      motor.setSpeed(value);
      motor1.setSpeed(value);
      break;
    case 'vr':
      Serial.println("Reverse AB");
      motor.run(BACKWARD);
      motor1.run(BACKWARD);
      
      motor.setSpeed(value);
      motor1.setSpeed(value);
      break;
    case 'fa':
      Serial.println("Forward A");
      // motor A forwards
      motor.run(FORWARD);
      
      motor.setSpeed(value);
      break;
    case 'ra':
      Serial.println("Reverse A");
      // motor A reverse
      motor.run(BACKWARD);
      
      motor.setSpeed(value);
      break;
    case 'fb':
      Serial.println("Forward B");
      // motor B forwards
      motor1.run(FORWARD);
      
      motor1.setSpeed(value);
      break;
    case 'rb':
      Serial.println("Reverse B");
      // motor B reverse
      motor1.run(BACKWARD);
      
      motor1.setSpeed(value);
      break;
    default:
      Serial.println("Invalid command!");
      break;
  }  
} 
 
void loop()
{ 
  // get a command string form the serial port
  int inputLength = 0;
  do {
    while (!Serial.available()); // wait for input
    inputBuffer[inputLength] = Serial.read(); // read it in
  } while (inputBuffer[inputLength] != LineEnd && ++inputLength < BufferLength);
  inputBuffer[inputLength] = 0; //  add null terminator
  HandleCommand(inputBuffer, inputLength);
}
