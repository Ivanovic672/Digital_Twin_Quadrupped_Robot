#include "communication.h"
#include <Arduino.h>
#include <stdlib.h>

String float_to_string(float n, int l, int d, boolean z);
char *dtostrf (double val, signed char width, unsigned char prec, char *sout);

// Read Function for Serial Communication with Simulation at Simscape Multibody
void simulation_get_data_IMU(message_float* IMU_from_simulation, bool* is_simulation_started) {
  
  if (Serial.available() >= 12) {
    
    while (Serial.available() >= 12) {

      // Declares 6 vars as buffers
      message_float buff_1, buff_2, buff_3, buff_4, buff_5, buff_6;

      // Check header from message
      if (Serial.peek() == 'M') {

        // Updates flag simulation
        *is_simulation_started = true;
      
        // Extract header
        Serial.read(); 

        // Read first message
        for (int i = 0; i < 4; i++) {
          buff_1.bytes[i] = Serial.read();
        }

        // Read second message
        for (int i = 0; i < 4; i++) {
          buff_2.bytes[i] = Serial.read();
        }

        // Read third message
        for (int i = 0; i < 4; i++) {
          buff_3.bytes[i] = Serial.read();
        }

        // Read fourth message
        for (int i = 0; i < 4; i++) {
          buff_4.bytes[i] = Serial.read();
        }

        // Read fifth message
        for (int i = 0; i < 4; i++) {
          buff_5.bytes[i] = Serial.read();
        }

        // Read sixth message
        for (int i = 0; i < 4; i++) {
          buff_6.bytes[i] = Serial.read();
        }
      
        // If no errors at terminator
        if (Serial.read() == '\n') {
          IMU_from_simulation[0] = buff_1;
          IMU_from_simulation[1] = buff_2;
          IMU_from_simulation[2] = buff_3;
          IMU_from_simulation[3] = buff_4;
          IMU_from_simulation[4] = buff_5;
          IMU_from_simulation[5] = buff_6;
        }

      } else {
        // Dismiss invalid byte
        Serial.read(); 
      }
    }
  }
}


// Write Function for Serial Communication with Simulation at Simscape Multibody
void simulation_write_actuators(message_float* q_bl, message_float* q_br, message_float* q_fl, message_float* q_fr) {
  
  // Write header
  Serial.write('Q');

  // Back Left Leg:
  // Write q1_pos_bl message
  for(int i=0; i<4; i++){
    Serial.write(q_bl[0].bytes[i]);
  }
  // Write q2_pos_bl message
  for(int i=0; i<4; i++){
    Serial.write(q_bl[1].bytes[i]);
  }
  // Write q3_pos_bl message
  for(int i=0; i<4; i++){
    Serial.write(q_bl[2].bytes[i]);
  }

  // Back Right Leg:
  // Write q1_pos_br message
  for(int i=0; i<4; i++){
    Serial.write(q_br[0].bytes[i]);
  }
  // Write q2_pos_br message
  for(int i=0; i<4; i++){
    Serial.write(q_br[1].bytes[i]);
  }
  // Write q3_pos_br message
  for(int i=0; i<4; i++){
    Serial.write(q_br[2].bytes[i]);
  }

  // Front Left Leg:
  // Write q1_pos_fl message
  for(int i=0; i<4; i++){
    Serial.write(q_fl[0].bytes[i]);
  }
  // Write q2_pos_fl message
  for(int i=0; i<4; i++){
    Serial.write(q_fl[1].bytes[i]);
  }
  // Write q3_pos_fl message
  for(int i=0; i<4; i++){
    Serial.write(q_fl[2].bytes[i]);
  }

  // Front Right Leg:
  // Write q1_pos_fr message
  for(int i=0; i<4; i++){
    Serial.write(q_fr[0].bytes[i]);
  }
  // Write q2_pos_fr message
  for(int i=0; i<4; i++){
    Serial.write(q_fr[1].bytes[i]);
  }
  // Write q3_pos_fr message
  for(int i=0; i<4; i++){
    Serial.write(q_fr[2].bytes[i]);
  }
  
  // Write terminator
  Serial.write('\n');
}


// Read Function for Serial Communication with UI through Bluetooth
void UI_get_user_orders(char* user_order) {
  if (Serial1.available()) {
    String data = Serial1.readStringUntil('\n');
    if (data.length() == 1) {
      *user_order = data[0];
    }
  } else {
    *user_order = 'N';
  }
}


// Write Function for Serial Communication with UI through Bluetooth
void UI_write_IMU_data(message_float* IMU_filtered_to_UI) {

  // Set header
  String s = "S,";
  
  // Concat IMU_filtered_to_UI message including commas
  for (int i = 0; i < 6; i++) {
    s.concat(float_to_string(IMU_filtered_to_UI[i].number * 180.0 / PI, 5, 2, false));
    if (i < 5) {s.concat(",");}
  }
  
  // Write Bluetooth Serial
  Serial1.println(s);
}


// Convierte un float en una cadena.
// n -> número a convertir.
// l -> longitud total de la cadena, por defecto 8.
// d -> decimales, por defecto 2.
// z -> si se desea rellenar con ceros a la izquierda, por defecto true.
String float_to_string( float n, int l, int d, boolean z){
  char c[l+1];
  String s;
  
  dtostrf(n,l,d,c);
  s=String(c);
  
  if(z){
    s.replace(" ","0");
  }
  return s;
}


char *dtostrf (double val, signed char width, unsigned char prec, char *sout) {
  char fmt[20];
  sprintf(fmt, "%%%d.%df", width, prec);
  sprintf(sout, fmt, val);
  return sout;
}
