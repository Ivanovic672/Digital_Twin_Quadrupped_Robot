
// Time variables
unsigned long loop_timestamp_0;
int sample_time = 10; // (ms)

// Estructura Union
typedef union{
  float number;
  uint8_t bytes[4];
} message;


// Variables Union (Inputs):
message q1_ref;
message q2_ref;
message q3_ref;

// Variables Union (Outputs):
message q1_pos;
message q2_pos;
message q3_pos;


// Functions Headers
void serial_receive();
void serial_send();


void setup() {
  // Set up serial communication
  Serial.begin(115200);
  
  // Initializes inputs
  q1_ref.number = 0;
  q2_ref.number = 0;
  q3_ref.number = 0;
}

void loop() {

  // Initial loop timestamp
  loop_timestamp_0 = millis();
  
  // Serial receive
  if (Serial.available() >= 14) {
    serial_receive();
  }

  // Set output
  q1_pos.number = q1_ref.number;
  q2_pos.number = q2_ref.number;
  q3_pos.number = q3_ref.number;

  // Serial send
  serial_send();

  // Delay until match sample time
  if (millis() - loop_timestamp_0 < sample_time) {
    delay(sample_time - (millis() - loop_timestamp_0));
  }
}


void serial_receive(){

  while (Serial.available() >= 18) {

    // Declares 4 var as buffers
    message buff_1, buff_2, buff_3;

    // Check header from message
    if (Serial.peek() == 'A') {
      
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
      
      // If no errors at terminator
      if (Serial.read() == '\n') {
        q1_ref = buff_1;
        q2_ref = buff_2;
        q3_ref = buff_3;
      }
    } else {
      // Dismiss invalid byte
      Serial.read(); 
    }
  }
}


void serial_send() {
  
  // Write header
  Serial.write('S');
  
  // Write q1_pos message
  for(int i=0; i<4; i++){
    Serial.write(q1_pos.bytes[i]);
  }
  
  // Write q2_pos message
  for(int i=0; i<4; i++){
    Serial.write(q2_pos.bytes[i]);
  }
  
  // Write q3_pos message
  for(int i=0; i<4; i++){
    Serial.write(q3_pos.bytes[i]);
  }
  
  // Write terminator
  Serial.write('\n');
}
