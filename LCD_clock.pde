#include <LiquidCrystal.h>

// Connections:
// rs (LCD pin 4) to Arduino pin 12
// rw (LCD pin 5) to Arduino pin 11
// enable (LCD pin 6) to Arduino pin 10
// LCD pin 15 to Arduino pin 13
// LCD pins d4, d5, d6, d7 to Arduino pins 5, 4, 3, 2
LiquidCrystal lcd(12, 11,10, 5, 4, 3, 2);

int power_pin = 13; //extra power

//time vars
long total_seconds; 
long seconds = 0; //s
long minutes = 0; //min
long hours   = 0; //hr
long days = 0; //days
long time_reset = 0; //time that it reset (when it gets to 24hrs)
long begin_time = 0; //for testing purposes

//recieved time vars
int time[3] = {0,0,0}; //seconds minutes hours

void setup()
{
  pinMode(power_pin,OUTPUT);
  digitalWrite(power_pin,HIGH);
  delay(1000);
  Serial.begin(9600);
  lcd.begin(2,16);              // rows, columns.  use 2,16 for a 2x16 LCD, etc.
  lcd.clear();                  // start with a blank screen
}

void loop() {
 checkSerial();
 
 lcd.setCursor(4,0); //set cursor so text is centered when printed
 
 //Print current time
 if (hours < 10) { //leading zero if needed
   lcd.print("0");
 }
 lcd.print(hours/1);
 lcd.print(":");
 if (minutes < 10) { //leading zero if needed
   lcd.print("0");
 }
 lcd.print(minutes/1);
 lcd.print(":");
 if (seconds < 10) { //leading zero if needed
   lcd.print("0");
 }
 lcd.print(seconds/1);
 
 //Calculate time things
 long total_seconds = begin_time + ((millis()/1000)-time_reset); //seconds elapsed
 hours = total_seconds / (60*60);
 total_seconds = total_seconds - (60*60*hours); //left over time
 minutes = total_seconds / 60;
 seconds = total_seconds-(minutes*60);
 
 if (hours == 24) { //end of the day
   days++; //add on a day
   time_reset = (86400)*days; 
 }
 
}

void checkSerial() {
  if (Serial.available() > 0) { //when there is data
   begin_time = 0; //this assumes you dont increment mid-flow
   time_reset = millis()/1000;
   char val; //recieved data
   while (val != 'E') { //while end not recieved
   if (Serial.available() > 0) { //look for data
   val = Serial.read(); //read said data
    if (val == 's') {
      begin_time++;
    }
    if (val == 'm') { 
      begin_time = begin_time + 60;
    }
    if (val == 'h') { 
      begin_time = begin_time + 3600;
    } 
   }
   }
  }
      
}
