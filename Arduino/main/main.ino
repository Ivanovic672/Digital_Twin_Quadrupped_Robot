#include "communication.h"
#include "IMU.h"
#include "servo_response.h"

// Time variables
unsigned long loop_timestamp_0;
int sample_time = 10; // (ms)
int delay_until_start = 1100; // (ms)
int loops = 0;

// Flag Simulation Started
bool is_simulation_started = false;

// Simulation Outputs (Actuators):
// Back Left Leg:
message_float q_bl[3];
// Back Right Leg:
message_float q_br[3];
// Front Left Leg:
message_float q_fl[3];
// Front Right Leg:
message_float q_fr[3];
// Simulation Inputs (IMU):
message_float IMU_from_simulation[6];


// UI Outputs (IMU Filtered):
message_float IMU_filtered_to_UI[6];
// UI Inputs (User Orders)
char user_order;


void setup() {
  
  // Serial Communication with Simulation at Simscape Multibody
  Serial.begin(115200);
  // Serial Communication with IU through Bluetooth
  Serial1.begin(9600);
  
  // Initializes Simscape Servos at 0
  for (int i = 0; i < 3; i++) {
    
    // Back Left Leg:
    q_bl[i].number = 0.0;
    
    // Back Right Leg:
    q_br[i].number = 0.0;
    
    // Front Left Leg:
    q_fl[i].number = 0.0;

    // Front Right Leg:
    q_fr[i].number = 0.0;
  }

  // Initializes IMU Messages at 0
  for (int i = 0; i < 6; i++) {
    
    // IMU Signals From Simscape
    IMU_from_simulation[i].number = 0.0;

    // IMU Signals To IU
    IMU_filtered_to_UI[i].number = 0.0;
  }
}

void loop() {
  
  // Initial loop timestamp
  loop_timestamp_0 = millis();

  // First Step: Read from Simulation and UI
  simulation_get_data_IMU(IMU_from_simulation, &is_simulation_started);
  UI_get_user_orders(&user_order);
  
  // If simulation has already started
  if (is_simulation_started) {

    // Second Step: Complementary Filter IMU
    get_IMU_filtered(IMU_from_simulation, IMU_filtered_to_UI);

    // Configures an offset delay in order to prepare robot at simulation
    if(loops < delay_until_start / sample_time) {
      loops++;
    } else {
      
      // Third Step: Calculate Servo Response Based on User Instruction (Path Generating through Inverse Kinematics)
      calculate_servo_response(&user_order, q_bl, q_br, q_fl, q_fr);
      
      // Fourth Step: Adds the Effect of Stability Algorithm to Servo Response (Based on IMU Signals)
      calculate_balanced_servo_response(IMU_filtered_to_UI, q_bl, q_br, q_fl, q_fr);
    }
    
    // Fifth Step: Write Servo Response and UI Signals
    simulation_write_actuators(q_bl, q_br, q_fl, q_fr); 
    UI_write_IMU_data(IMU_filtered_to_UI);
  }
  
  // Sixth Step: Delay Until Match Sample Time
  if (millis() - loop_timestamp_0 < sample_time) {
    delay(sample_time - (millis() - loop_timestamp_0));
  }
}
