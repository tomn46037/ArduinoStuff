// Motor A 
int dir1PinA = 13;
int dir2PinA = 12; 
int speedPinA = 10;

// motor B 
int dir1PinB = 11;
int dir2PinB = 8; 
int speedPinB = 9;

unsigned long time; 
int speed; 
int dir; 

void setup () 
{
  pinMode (dir1PinA, OUTPUT); 
  pinMode (dir2PinA, OUTPUT); 
  pinMode (speedPinA, OUTPUT); 
  pinMode (dir1PinB, OUTPUT); 
  pinMode (dir2PinB, OUTPUT); 
  pinMode (speedPinB, OUTPUT); 
  
  time = millis (); 
  speed = 0; 
  dir = 1;
} 

void loop () 
{
  analogWrite (speedPinA, speed); 
  analogWrite (speedPinB, 255 - speed);

  // set direction 
  if (1 == dir) 
  {
    digitalWrite (dir1PinA , LOW); 
    digitalWrite (dir2PinA, HIGH); 
    digitalWrite (dir1PinB, HIGH); 
    digitalWrite (dir2PinB, LOW);
  } 
  else 
  {
    digitalWrite (dir1PinA, HIGH); 
    digitalWrite (dir2PinA, LOW); 
    digitalWrite (dir1PinB, LOW); 
    digitalWrite (dir2PinB, HIGH);
  } 

  if (millis () - time> 5000) 
  {
    time = millis (); 
    speed += 20; 
    if (speed> 100) {speed = 0;}

    if (1 == dir) 
    {dir = 0;} 
    else 
    {dir = 1;}
  }
}

