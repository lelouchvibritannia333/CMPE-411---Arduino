#include <Wire.h>  // only to allow to include twi.h
extern "C" {
#include "utility/twi.h"
}

byte addr =33;  // address of your I2C slave I Hate You HoneyWell
int PwnPinA = 9;      // PWM connected to PWM pin 9
int PwnPinB = 10;      // PWM connected to PWM pin 10
int AtoDPin = 15;   // Connect to Analog 15
int ProxPin = 7;   // Prox connected to PWM pin 7
int PinSetA = 12;
int PinSetB = 13;

int PinSet = 1;

void setup()
{

  pinMode(PinSetA, OUTPUT); // Lets the pin PWM 12 be set
  pinMode(PinSetB, OUTPUT); // Lets the pin PWM 13 be set
  pinMode(ProxPin, INPUT);  // sets the PWM 7 as input for Prox
  pinMode(AtoDPin, INPUT);  // sets the ana Pin 15 as input for AtoD
  pinMode(PwnPinB, OUTPUT); // Set PWM pin 10 as output for PWM
  pinMode(PwnPinA, OUTPUT); // Set PWM pin 9 as output for PWM
  
  twi_init();
  delay(10); // to enable twi to be initiated correctly
  Serial.begin(9600);
  
}

void loop()
{
  
  // throw compass at him
  // throw atod at him
  // throw prox voltage at him
  
  //compass();
  //AtoD();
  //prox();
  //if (PinSet == 1)
  PO(PinSetA,1);
  PM(PwnPinA,.5);
  
}

void PO(int pin, int power)
{
  
  if (power == 1)
      digitalWrite(pin, HIGH); 
  if (power == 0)
      digitalWrite(pin, LOW);
      
   //PinSet = 0;

}

void AtoD()
{

  int angval = 0;

  angval = analogRead(AtoDPin);   // read the input pin
  Serial.println(angval);

}

void PM(int pin, int duty)
{
  
  // Pin Must Be 9 Or 10
  int val = 0;
  val = duty * 255;
  Serial.print("Writing: ");
  Serial.println(val);
  analogWrite(pin, val );   // analogWrite values from 0 to 255
  
}

void compass()
{
  
  byte data[2];
  int i, headingValue,repeat;
  // Send a "A" command to the HMC6352
  // This requests the current heading data
  byte cmd[1];
  cmd[0] = 0x41;
  // method twi_writeTo from twi.h : send an array of bytes(cmd), length 1 byte (it's the first "1" input), to the slave addressed by addr.
  // The last input "1" is a boolean to make the method wait for the completion of the sending
  // return a indication of successful : 0:success, 1 to 4:error (search in twi.h to precision)
  int res=twi_writeTo(addr, cmd, 1, 1);
  delay(1);  
  // The HMC6352 needs at least a 70us (microsecond) delay
  // after this command.  Using 10ms just makes it safe
  // Read the 2 heading bytes, MSB first
  // The resulting 16bit word is the compass heading in 10th's of a degree
  // For example: a heading of 1345 would be 134.5 degrees
  // method twi_readFrom from twi.h : receive 2 bytes (the "2" input), from the slave addressed by addr, and register in the byte array data
  // return the number of bytes read
  int N=twi_readFrom(addr, data, 2);
  repeat = headingValue; 
  headingValue = data[0] *256 +data[1];  // Put the MSB and LSB together
 // Put the MSB and LSB together
  Serial.print("Current heading: ");
  Serial.print(int (headingValue / 10));     // The whole number part of the heading
  Serial.print(".");
  Serial.print(int (headingValue % 10));     // The fractional part of the heading
  Serial.println(" degrees");
  delay(1000);
  
} 

void prox()

{
  int val = 0;
  int count = 0;
  pinMode(ProxPin, INPUT);  // sets the digital pin 7 as input
  val = digitalRead(ProxPin);   // read the 7 input pin
  /*
  if (val == HIGH)
    {
    Serial.print("High.\n");
    count++;
    }
  else
    Serial.print("Low.\n");
    
    val = LOW;
   //delay(500);
   */
   Serial.print("Prox Voltage: ");
   Serial.println(val);

}


