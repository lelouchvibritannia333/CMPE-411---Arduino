#include <Wire.h>  // only to allow to include twi.h
extern "C" {
#include "utility/twi.h"
}

byte addr =33;  // address of your I2C slave I Hate You HoneyWell
int PwnPinA = 9;      // PWM connected to PWM pin 9
int PwnPinB = 10;      // PWM connected to PWM pin 10
int AtoDPin = 15;   // Connect to Analog 15
int gitgui;

void setup()
{
  Serial.begin(9600);
}

void loop()
{
 
  
  
}

void SetPinLow(int pin)
{

  pinMode(pin, OUTPUT); // set pin to Output

  digitalWrite(pin, LOW); 
  
}

void SetPinHigh(int pin)
{

  pinMode(pin, OUTPUT); // set pin to Output

  digitalWrite(pin, HIGH); 
  
}

void AtoD()
{

  int angval = 0;
  pinMode(AtoDPin, INPUT);  // sets the digital pin 7 as input

  angval = analogRead(AtoDPin);   // read the input pin
  Serial.println(angval);

}

void PWMB()
{

  int incomingByte = 0;
  int usenumber = 0;
  int val = 0; // variable to store the read value
  int count = 2;
  int temp;

  pinMode(PwnPinB, OUTPUT); 
 // Must set a pin for input or output before use
 // Set pin for output
  
  while(count >= 0)
  {
    if (Serial.available() > 0)
    {
    incomingByte = Serial.read();
    usenumber = incomingByte - 48;
    temp = count;
    while(temp > 0)
    {
    usenumber = usenumber * 10;
    temp--;
    }
    val = val + usenumber;
    count --;
    }
  }
  
  Serial.print("Writing: ");
  Serial.println(val);
  analogWrite(PwnPinB, val );   // analogRead values go from 0 to 1023, analogWrite values from 0 to 255
  val = 0;
  count = 2;

}

void PWMA()
{

  int PwnPinA = 9;      // LED connected to digital pin 9
  int incomingByte = 0;
  int usenumber = 0;
  int val = 0; // variable to store the read value
  int count = 2;
  int temp;

  pinMode(PwnPinA, OUTPUT);
  // Must set a pin for input or output before use
  // Set pin for output
   
  while(count >= 0)
  {
    if (Serial.available() > 0)
    {
    incomingByte = Serial.read();
    usenumber = incomingByte - 48;
    temp = count;
    while(temp > 0)
    {
    usenumber = usenumber * 10;
    temp--;
    }
    val = val + usenumber;
    count --;
    }
  }
  
  Serial.print("Writing: ");
  Serial.println(val);
  analogWrite(PwnPinA, val );   // analogRead values go from 0 to 1023, analogWrite values from 0 to 255
  val = 0;
  count = 2;
  
} 

int compass()
{
  
  byte data[2];
  int i, headingValue,repeat;
  twi_init();
  delay(10); // to enable twi to be initiated correctly
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
  return headingValue;
  
} 


