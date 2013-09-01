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


 
#define DirectionPin1MotorA 13
#define DirectionPin2MotorA 12
#define PwmPinMotorA 10

#define DirectionPin1MotorB 11
#define DirectionPin2MotorB 8
#define PwmPinMotorB 9


#define SerialSpeed 9600
#define BufferLength 16
#define LineEnd 0xa
 
char inputBuffer[BufferLength];
 
void setup()
{
  // motor pins must be outputs
  pinMode(PwmPinMotorA, OUTPUT);
  pinMode(PwmPinMotorB, OUTPUT);
  pinMode(DirectionPin1MotorA, OUTPUT);
  pinMode(DirectionPin2MotorA, OUTPUT);
  pinMode(DirectionPin1MotorB, OUTPUT);
  pinMode(DirectionPin2MotorB, OUTPUT);
 
  Serial.begin(SerialSpeed); 
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
    case 'wf':
      Serial.println("Forward AB");
      // motor A forwards
      analogWrite(PwmPinMotorA, value);
      analogWrite(PwmPinMotorB, value);
      digitalWrite(DirectionPin1MotorA, HIGH);
      digitalWrite(DirectionPin2MotorA, LOW);
      digitalWrite(DirectionPin1MotorB, HIGH);
      digitalWrite(DirectionPin2MotorB, LOW);
      break;
    case 'vr':
      Serial.println("Reverse AB");
      // motor A forwards
      analogWrite(PwmPinMotorA, value);
      analogWrite(PwmPinMotorB, value);
      digitalWrite(DirectionPin1MotorA, LOW);
      digitalWrite(DirectionPin2MotorA, HIGH);
      digitalWrite(DirectionPin1MotorB, LOW);
      digitalWrite(DirectionPin2MotorB, HIGH);
      break;
    case 'fa':
      Serial.println("Forward A");
      // motor A forwards
      analogWrite(PwmPinMotorA, value);
      digitalWrite(DirectionPin1MotorA, HIGH);
      digitalWrite(DirectionPin2MotorA, LOW);
      break;
    case 'ra':
      Serial.println("Reverse A");
      // motor A reverse
      analogWrite(PwmPinMotorA, value);
      digitalWrite(DirectionPin1MotorA, LOW);
      digitalWrite(DirectionPin2MotorA, HIGH);
      break;
    case 'fb':
      Serial.println("Forward B");
      // motor B forwards
      analogWrite(PwmPinMotorB, value);
      digitalWrite(DirectionPin1MotorB, HIGH);
      digitalWrite(DirectionPin2MotorB, LOW);
      break;
    case 'rb':
      Serial.println("Reverse B");
      // motor B reverse
      analogWrite(PwmPinMotorB, value);
      digitalWrite(DirectionPin1MotorB, LOW);
      digitalWrite(DirectionPin2MotorB, HIGH);
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
