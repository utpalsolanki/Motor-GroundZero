
#include <IRremote.h>
#include <LiquidCrystal.h>
int RECV_PIN = 6;
int RELAY_PIN = 10;
int minit;
int second;
int BUZZER = 9;

IRrecv irrecv(RECV_PIN);
decode_results results;
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);


void setup()
{
  pinMode(RELAY_PIN, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(BUZZER,OUTPUT);
  digitalWrite(10,HIGH);
  digitalWrite(BUZZER,HIGH);
  delay(500);
  
  irrecv.enableIRIn(); // Start the receiver

  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("Set your time");
  lcd.setCursor(0, 1);
  lcd.print("using Ch+ Ch- ");
  delay(2000);
  minit=0;
  second=0;
  time_display();
}

int on = 0;
unsigned long last = millis();

void loop() {
  
 
  
  while(irrecv.decode(&results)){
    if(results.value==0x208F7){
      minit++;
      time_display();
      delay(100);
      digitalWrite(BUZZER,LOW);
      delay(50);
      digitalWrite(BUZZER,HIGH);
      
      irrecv.resume();
    }
    else if(results.value==0x2F00F){
      minit--;
      time_display();
      delay(100);
      digitalWrite(BUZZER,LOW);
      delay(50);
      digitalWrite(BUZZER,HIGH);
      
      irrecv.resume();
    }
      
    else if(results.value==0x2C837){
      motor();
      irrecv.resume();
    }
    else{
       irrecv.resume();
    }
      
  }   
}

void time_display(){
  lcd.clear();
  lcd.print(" ");
  lcd.print(minit);
  lcd.print(":00");
}
void time_display_running(){
  lcd.clear();
  lcd.print(" ");
  lcd.print(minit);
  lcd.print(":");
  lcd.print(second);
  lcd.setCursor(0, 1);
  lcd.print("time left");
}

void motor(){
  
  int m1;
  int s1;
  
  lcd.clear();
  lcd.print("Motor will start");
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
  
  m1=minit-1;  // copying time value
  s1=second;
  
    for(minit=m1;minit>0;minit--){
       
        for(second=59;second>=0;second--){
          time_display_running();
          delay(1000);
          
        }
        
        
    }
    
     for(second=59;second>=0;second--){
          time_display_running();
          if(second>10){
          delay(1000);
          }
          else{
              digitalWrite(BUZZER,LOW);
              delay(500);
              digitalWrite(BUZZER,HIGH);
              delay(500);     
          }      
        }
    
    
    
    digitalWrite(10,HIGH);
    delay(200);
    burst();
    lcd.clear();
    lcd.print("Motor off");
    digitalWrite(BUZZER,LOW);
              delay(2000);
              digitalWrite(BUZZER,HIGH);
              
    delay(6000);
    
  lcd.clear();  
  lcd.print("Set your time");
  lcd.setCursor(0, 1);
  lcd.print("using Ch+ Ch- ");
  delay(2000);
  minit=0;
  second=0;
  //time_display();
    
    
}

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
