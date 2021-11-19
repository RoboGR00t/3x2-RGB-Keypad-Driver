#include <Arduino.h>

#define RED D5
#define GREEN D6
#define BLUE D7

#define C1 D0
#define C2 D1
#define C3 D2


#define R1 D4
#define R2 D8



int col_stat_1 = 1;
int col_stat_2 = 0;


void setup() {
  pinMode(RED,OUTPUT);
  pinMode(GREEN,OUTPUT);
  pinMode(BLUE,OUTPUT);

  pinMode(C1,INPUT);
  pinMode(C2,INPUT);
  pinMode(C3,INPUT);

  pinMode(R1,OUTPUT);
  pinMode(R2,OUTPUT);

  analogWrite(RED,183);
  analogWrite(GREEN,68);
  analogWrite(BLUE,207);

  digitalWrite(R1,HIGH);
  digitalWrite(R2,LOW);

  Serial.begin(9600);
  Serial.write(0);

  analogWrite(RED,255);
  analogWrite(GREEN,255);
  analogWrite(BLUE,255);

}

void loop() {


  if(!col_stat_1){
    if(!digitalRead(C1)){
      Serial.write(1);
      delay(200);
    }
    if(!digitalRead(C2)){
      Serial.write(2);
      delay(200);
    }
    if(!digitalRead(C3)){
      Serial.write(3);
      delay(200);
    }
  }
  if(!col_stat_2){
    if(!digitalRead(C1)){
      Serial.write(4);
      delay(200);
    }
    if(!digitalRead(C2)){
      Serial.write(5);
      delay(200);
    }
    if(!digitalRead(C3)){
      Serial.write(6);
      delay(200);
    }
  }

  delay(10);

  col_stat_1 = !col_stat_1;
  col_stat_2 = !col_stat_2;

  digitalWrite(R1,col_stat_1);
  digitalWrite(R2,col_stat_2);

  while(Serial.available()>0){

      if(Serial.read() == 255){
        analogWrite(RED,Serial.read()+3);
      }
      if(Serial.read() == 254){
        analogWrite(GREEN,Serial.read()+3);
      }
      if(Serial.read() == 253){
        analogWrite(BLUE,Serial.read()+3);
      }

    }

}
