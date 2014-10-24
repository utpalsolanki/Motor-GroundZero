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
#define trigPinG         A0
#define echoPinG         A1
#define trigPinH         A2
#define echoPinH         A3

#define HIGHER_CUTOFF_H  12
#define LOWER_CUTOFF_H   70
#define HIGHER_CUTOFF_G  12
#define LOWER_CUTOFF_G   70

#define MOTOR_OFF        0
#define MOTOR_ON_AUTO    1
#define MOTOR_ON_TIMER   2
#define MOTOR_ON_MANUAL  3

int motorState;
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
  
  pinMode(trigPinG, OUTPUT);
  pinMode(echoPinG, INPUT);
  pinMode(trigPinH, OUTPUT);
  pinMode(echoPinH, INPUT);

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
  motorState = MOTOR_OFF;
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
      if(motorState == MOTOR_OFF)
      {
        motor();      
      }
    }
    else if(readSignal=='/')
    {
      if(motorState == MOTOR_OFF)
      {
        motorState = MOTOR_ON_MANUAL;
        turnMotorOn(); 
      }
      else
      {
        Serial.println("Motor already ON");
      }
    }
    else if(readSignal=='\\')
    {
      if(motorState != MOTOR_OFF)
      {
        motorState = MOTOR_OFF;
        turnMotorOff(); 
      }
      else
      {
        Serial.println("Motor already OFF");
      }
    }
    else if(readSignal=='[')
    {
      //get_GLevel();
      Serial.print(avgGLevel());
      Serial.println(" cm");
    }
    else if(readSignal==']')
    {
      //get_HLevel();
      Serial.print(avgHLevel());
      Serial.println(" cm");
    }
    else if(readSignal=='T')
    {
      Serial.println(millis());
    }
    else if(readSignal=='#')
    {
      if(motorState==MOTOR_OFF)
      {
        run_Auto();
      }
      else
      {
        Serial.println("Motor already ON");
      }
    }
    else if(readSignal=='M')
    {
      giveMotorStatus();
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
  motorState = MOTOR_ON_TIMER;
  
  m1=minit-1;  // copying time value
  s1=second;
  
    for(minit=m1;minit>0;minit--)
    {
      for(second=59;second>=0;second--)
      {
          time_display_running();
          check_UART();
          if(motorState == MOTOR_OFF)
            return;
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
        if(motorState == MOTOR_OFF)
          return;
      }
      else
      {
          digitalWrite(BUZZER,LOW);
          delay(500);
          digitalWrite(BUZZER,HIGH);
          delay(500);
          check_UART();
          if(motorState == MOTOR_OFF)
            return;
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
  delay(100);  
  
  motorState = MOTOR_OFF;
}
void turnMotorOn()
{
  digitalWrite(BUZZER,LOW);
  delay(200);
  digitalWrite(BUZZER,HIGH);
  delay(200);
  digitalWrite(BUZZER,LOW);
  delay(200);
  digitalWrite(BUZZER,HIGH);
  delay(200);
  
  digitalWrite(10,LOW);
  delay(100);  
  Serial.println("Motor ON");
}
void turnMotorOff()
{
  digitalWrite(BUZZER,LOW);
  delay(200);
  digitalWrite(BUZZER,HIGH);
  delay(200);
  digitalWrite(BUZZER,LOW);
  delay(200);
  digitalWrite(BUZZER,HIGH);
  delay(200);

  digitalWrite(BUZZER,LOW);
  delay(200);
  digitalWrite(BUZZER,HIGH);
  delay(200);
  digitalWrite(BUZZER,LOW);
  delay(200);
  digitalWrite(BUZZER,HIGH);
  delay(200);

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
  digitalWrite(trigPinG, LOW);   // Added this line
  delayMicroseconds(2);         // Added this line
  digitalWrite(trigPinG, HIGH);

  delayMicroseconds(10);        // Added this line
  digitalWrite(trigPinG, LOW);
  duration = pulseIn(echoPinG, HIGH);
  distance = (duration/2) / 29.1;
 
  Serial.print(distance);
  Serial.println(" cm");
}
/***********************************************************************
Function : get_Glevel
***********************************************************************/
void get_HLevel() 
{
  long duration, distance;
  digitalWrite(trigPinH, LOW);   // Added this line
  delayMicroseconds(2);         // Added this line
  digitalWrite(trigPinH, HIGH);

  delayMicroseconds(10);        // Added this line
  digitalWrite(trigPinH, LOW);
  duration = pulseIn(echoPinH, HIGH);
  distance = (duration/2) / 29.1;
 
  Serial.print(distance);
  Serial.println(" cm");
}
/***********************************************************************
Function : get_Glevel
***********************************************************************/
long ret_GLevel() 
{
  long duration, distance;
  digitalWrite(trigPinG, LOW);   // Added this line
  delayMicroseconds(2);         // Added this line
  digitalWrite(trigPinG, HIGH);

  delayMicroseconds(10);        // Added this line
  digitalWrite(trigPinG, LOW);
  duration = pulseIn(echoPinG, HIGH);
  distance = (duration/2) / 29.1;
  
  return distance; 
}
/***********************************************************************
Function : get_Glevel
***********************************************************************/
long ret_HLevel() 
{
  long duration, distance;
  digitalWrite(trigPinH, LOW);   // Added this line
  delayMicroseconds(2);         // Added this line
  digitalWrite(trigPinH, HIGH);

  delayMicroseconds(10);        // Added this line
  digitalWrite(trigPinH, LOW);
  duration = pulseIn(echoPinH, HIGH);
  distance = (duration/2) / 29.1;
 
  return distance;
}
/***********************************************************************
Function : ret_Glevel_avg
***********************************************************************/
long avgGLevel()
{
  long take1,take2,take3;
  take1 = ret_GLevel();
  delay(200);
  take2 = ret_GLevel();
  delay(200);
  take3 = ret_GLevel();

  return long(((take1 + take2 + take3)/3));
}
/***********************************************************************
Function : ret_Hlevel_avg
***********************************************************************/
long avgHLevel()
{
  long take1,take2,take3;
  take1 = ret_HLevel();
  delay(200);
  take2 = ret_HLevel();
  delay(200);
  take3 = ret_HLevel();

  return long(((take1 + take2 + take3)/3));

}
/***********************************************************************
Function : run_Auto()
***********************************************************************/
void run_Auto()
{
  Serial.println("Auto Started");
  if((avgHLevel() > HIGHER_CUTOFF_H)  &&  (avgGLevel() < LOWER_CUTOFF_G))
  {
    turnMotorOn();
    motorState=MOTOR_ON_AUTO;
    unsigned long auto_max_interval = millis();
    
    while((avgHLevel() > HIGHER_CUTOFF_H)  &&  (avgGLevel() < LOWER_CUTOFF_G))
    {
      check_UART();
      if(motorState == MOTOR_OFF)
      {
        Serial.println("Auto abort");
        return;
      }
      if(millis() - auto_max_interval > (60000*20))
      {
        Serial.println("Auto timedout");
        break;
      }
      delay(1000);
    }
    turnMotorOff();
    motorState=MOTOR_OFF;
    Serial.println("Auto finish");
  }
  else
  {
    Serial.println("Auto level error");
    return;
  }
  
}
/***********************************************************************
Function : run_Auto()
***********************************************************************/
void giveMotorStatus()
{
  switch(motorState) 
  {
    case MOTOR_OFF:
      Serial.println("Motor OFF");
      break;
    case MOTOR_ON_AUTO:
      Serial.println("Motor AUTO-ON");
      break;
    case MOTOR_ON_TIMER:
      Serial.println("Motor TIMER-ON");
      break;
    case MOTOR_ON_MANUAL:
      Serial.println("Motor MANUAL-ON");
      break;
    default:
      Serial.println("Motor UNKNOWN");
      break;
  }
}
