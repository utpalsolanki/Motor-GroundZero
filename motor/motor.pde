/***********************************************************************
The MIT License (MIT)

Copyright (c) 2014 Utpal

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

***********************************************************************/
#include <IRremote.h>
#include <LiquidCrystal.h>

#define RECV_PIN	6
#define RELAY_PIN 	10
#define BUZZER 		9
#define trigPin         A0
#define echoPin         A1

int minit;
int second;
unsigned long int levelInterval;

IRrecv irrecv(RECV_PIN);
decode_results results;
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

/***********************************************************************
Function : Void Setup
***********************************************************************/
void setup()
{

  Serial.begin(9600);
  
  pinMode(RELAY_PIN, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(BUZZER,OUTPUT);
  
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  digitalWrite(10,HIGH);
  digitalWrite(BUZZER,HIGH);

  delay(500);
  
  irrecv.enableIRIn(); // Start the receiver

  lcd.begin(16, 2);
  lcd.print("Set your time");
  lcd.setCursor(0, 1);
  lcd.print("using Ch+ Ch- ");

  levelInterval = millis();
  delay(2000);
  minit=0;
  second=0;

  time_display();
  Serial.println("System started");
  
}
/***********************************************************************
Function : Void Loop
***********************************************************************/
int on = 0;
unsigned long last = millis();
void loop() 
{
   check_UART();
   check_TSOP();
   if((millis() - levelInterval) > 2000)
   {
     get_GLevel();
     levelInterval = millis();
   }

}
void check_UART()
{
  if(Serial.available()>0)
  {
    unsigned char readSignal = Serial.read();
    if(readSignal=='>')
    {
      minit++;
      time_display();
      delay(100);
      digitalWrite(BUZZER,LOW);
      delay(50);
      digitalWrite(BUZZER,HIGH);
      Serial.print(minit);
      Serial.println(" min");
    }
    else if(readSignal=='<')
    {
      minit--;
      if(minit <= 0)
        minit = 0;
        
      time_display();
      delay(100);
      digitalWrite(BUZZER,LOW);
      delay(50);
      digitalWrite(BUZZER,HIGH);      
      Serial.print(minit);
      Serial.println(" min");
    }
      
    else if(readSignal=='^')
    {
      motor();      
    }
    else if(readSignal=='/')
    {
      turnMotorOn(); 
    }
    else if(readSignal=='\\')
    {
      turnMotorOff(); 
    }
    else if(readSignal=='[')
    {

    }
    else if(readSignal==']')
    {

    }
    else if(readSignal=='#')
    {

    }
    else if(readSignal=='M')
    {
      turnMotorOff(); 
    }
    else
    {
      Serial.println("Unknown command");
    }
      
  }   
}
void check_TSOP()
{
    if(irrecv.decode(&results))
  {
    if(results.value==0x208F7)
    {
      minit++;
      time_display();
      delay(100);
      digitalWrite(BUZZER,LOW);
      delay(50);
      digitalWrite(BUZZER,HIGH);
      
      irrecv.resume();
    }
    else if(results.value==0x2F00F)
    {
      minit--;
      time_display();
      delay(100);
      digitalWrite(BUZZER,LOW);
      delay(50);
      digitalWrite(BUZZER,HIGH);
      
      irrecv.resume();
    }
      
    else if(results.value==0x2C837)
    {
      motor();
      irrecv.resume();
    }
    else
    {
       irrecv.resume();
    }
      
  }   
}
/***********************************************************************
Function : Void time_display
***********************************************************************/
void time_display()
{
  lcd.clear();
  lcd.print(" ");
  lcd.print(minit);
  lcd.print(":00");
}
/***********************************************************************
Function : Void time_display_running
***********************************************************************/
void time_display_running()
{
  lcd.clear();
  lcd.print(" ");
  lcd.print(minit);
  lcd.print(":");
  lcd.print(second);
  lcd.setCursor(0, 1);
  lcd.print("time left");
  
  Serial.print(minit);
  Serial.print(":");
  Serial.print(second);
  Serial.println(" left");
}
/***********************************************************************
Function : Void motor
***********************************************************************/
void motor()
{
  
  int m1;
  int s1;
  
  lcd.clear();
  lcd.print("Motor will start");
  Serial.println("Motor will start within a moment");
  lcd.setCursor(0, 1);
  lcd.print("within a moment");
  delay(1000);
  digitalWrite(BUZZER,LOW);
  delay(200);
  digitalWrite(BUZZER,HIGH);
  delay(800);
  
  digitalWrite(BUZZER,LOW);
  delay(200);
  digitalWrite(BUZZER,HIGH);
  delay(800);
  
  digitalWrite(BUZZER,LOW);
  delay(200);
  digitalWrite(BUZZER,HIGH);
  delay(800);
  
  digitalWrite(BUZZER,LOW);
  delay(200);
  digitalWrite(BUZZER,HIGH);
  
      
  
  digitalWrite(10,LOW);  // motor is now On , relay on
  delay(500);
  
  Serial.println("Motor ON");
  
  m1=minit-1;  // copying time value
  s1=second;
  
    for(minit=m1;minit>0;minit--)
    {
      for(second=59;second>=0;second--)
      {
          time_display_running();
          check_UART();
          delay(1000);
      }  
    }
    
    for(second=59;second>=0;second--)
    {
      time_display_running();
      if(second>10)
      {
        delay(1000);
        check_UART();
      }
      else
      {
          digitalWrite(BUZZER,LOW);
          delay(500);
          digitalWrite(BUZZER,HIGH);
          delay(500);
          check_UART();
      }      
    }
    
    
    
    digitalWrite(10,HIGH);
    delay(200);
    burst();
    lcd.clear();
    lcd.print("Motor off");
    
    Serial.println("Motor OFF");
    
    digitalWrite(BUZZER,LOW);
    delay(1500);
    digitalWrite(BUZZER,HIGH);
    delay(1000);
    
    lcd.clear();  
    lcd.print("Set your time");
    lcd.setCursor(0, 1);
    lcd.print("using Ch+ Ch- ");
    delay(2000);
    minit=0;
    second=0;
}
/***********************************************************************
Function : Void burst
***********************************************************************/
void burst(){
  digitalWrite(10,HIGH);
  delay(10);
  digitalWrite(10,LOW);
  delay(10);
  digitalWrite(10,HIGH);
  delay(10);
  digitalWrite(10,LOW);
  delay(10);
  digitalWrite(10,HIGH);
  delay(10);
  digitalWrite(10,LOW);
  delay(10);
  digitalWrite(10,HIGH);
  delay(10);
  digitalWrite(10,LOW);
  delay(10);
  digitalWrite(10,HIGH);
  delay(10);  
  digitalWrite(10,LOW);
  delay(10);
  digitalWrite(10,HIGH);
  delay(10);  
  digitalWrite(10,LOW);
  delay(10);
  digitalWrite(10,HIGH);
  delay(100);  
}
void turnMotorOn()
{
  digitalWrite(10,LOW);
  delay(100);  
  Serial.println("Motor ON");
}
void turnMotorOff()
{
  burst();
  delay(100);  
  Serial.println("Motor OFF");
}
/***********************************************************************
Function : get_Glevel
***********************************************************************/
void get_GLevel() 
{
  long duration, distance;
  digitalWrite(trigPin, LOW);   // Added this line
  delayMicroseconds(2);         // Added this line
  digitalWrite(trigPin, HIGH);

  delayMicroseconds(10);        // Added this line
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = (duration/2) / 29.1;
 
  Serial.print(distance);
  Serial.println(" cm");
}
