#include "servo_response.h"
#include "kinematics.h"
#include <Arduino.h>


// Declares variables for control
// For path (include kinematics.h)
path robot_path = {false, 0.0, {0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, 'N'};

// Position thesholds:
float roll_risky_threshold = 25.0 * PI / 180.0;          // In radians
float pitch_risky_threshold = 20.0 * PI / 180.0;         // In radians

// For speeds:
float roll_speed_risky_threshold = 30.0 * PI / 180.0;    // In radians/s
float pitch_speed_risky_threshold = 30.0 * PI / 180.0;   // In radians/s
float yaw_speed_risky_threshold = 30.0 * PI / 180.0;     // In radians/s

// Define PD Gains for roll and pitch balance control
float Kp_roll = 1.25;
float Kd_roll = -0.25;
float Kp_pitch = 1.25;
float Kd_pitch = -0.25;


// Function which generates the path to be followed by the quadrupped robot and resolves the inverse kinematics
void calculate_servo_response(char* user_order, message_float* q_bl, message_float* q_br, message_float* q_fl, message_float* q_fr) {
  
  // Declares the instantaneous position to reach
  float position_to_reach[3] = {0.0, 0.0, 0.0};

  // Determines if there is a current movement to complete before a new order
  if (robot_path.is_moving) {
    
    // Calculate next instantaneous position to reach
    calculate_next_position(position_to_reach, &robot_path);

    // Resolve inverse kinematics in order to reach the next position
    inverse_kinematics(position_to_reach, &robot_path, q_bl, q_br, q_fl, q_fr);
    
  } else {
    
    // Determine the next movement depending on the order received by user
    determine_next_path(&robot_path, user_order);
  }
}



// Function which includes the stability in case IMU signals surpass some thresholds (risk of fall)
void calculate_balanced_servo_response(message_float* IMU_filtered_to_UI, message_float* q_bl, message_float* q_br, message_float* q_fl, message_float* q_fr) {

  // Declares signals for adding servo balance algorithm
  float balance_q_bl[3];
  float balance_q_br[3];
  float balance_q_fl[3];
  float balance_q_fr[3];

  // Initializes balance signals
  for (int i = 0; i < 3; i++) {
    balance_q_bl[i] = 0.0;
    balance_q_br[i] = 0.0;
    balance_q_fl[i] = 0.0;
    balance_q_fr[i] = 0.0;
  }

  // Demux IMU Signals Input
  float roll = IMU_filtered_to_UI[0].number;
  float pitch = abs(IMU_filtered_to_UI[1].number);
  float yaw = IMU_filtered_to_UI[2].number;
  float w_x = abs(IMU_filtered_to_UI[3].number);
  float w_y = abs(IMU_filtered_to_UI[4].number);
  float w_z = IMU_filtered_to_UI[5].number;

  // Control Scheme: decouple control
  // - Roll is controlled by q3
  // - Pitch is controlled by q1 and q2

  // Control roll:
  if ((roll > roll_risky_threshold)) {
    
    // Calculate left q1 actions for balance
    balance_q_bl[0] = (Kp_roll * roll + Kd_roll * w_x);
    balance_q_fl[0] = -balance_q_bl[0]; // Inverse action
    
  } else {
    
    if ((roll < -roll_risky_threshold)) {
    
      // Calculate right q1 actions for balance
      balance_q_br[0] = -(Kp_roll * roll + Kd_roll * w_x);
      balance_q_fr[0] = -balance_q_br[0]; // Inverse action
    }
  }
  

  // Control pitch:
  if ((pitch > pitch_risky_threshold)) {
    
    // Calculate q2 and q3 actions for balance
    balance_q_bl[1] = -(Kp_pitch * pitch + Kd_pitch * w_y);
    balance_q_bl[2] = -balance_q_bl[1];  // q3 inverse than q2
    balance_q_br[1] = -balance_q_bl[1];  // Inverse action for right legs
    balance_q_br[2] = -balance_q_bl[2];  // Inverse action for right legs
    balance_q_fl[1] = balance_q_bl[1];   // Same action for left legs
    balance_q_fl[2] = balance_q_bl[2];   // Same action for left legs
    balance_q_fr[1] = -balance_q_fl[1];  // Inverse action for right legs
    balance_q_fr[2] = -balance_q_fl[2];  // Inverse action for right legs

    
  }

  // Cancel actions on moving legs (on air) (only for q2 and q3, since q1 can be controlled on air)
  if (robot_path.current_step > 0.0 && robot_path.current_step <= 1.1) {
    balance_q_fl[2] = 0.0;
    balance_q_fl[1] = 0.0;
    balance_q_br[2] = 0.0;
    balance_q_br[1] = 0.0;
  } else {
    if (robot_path.current_step > 1.1 && robot_path.current_step <= 2.2) {
      balance_q_fr[2] = 0.0;
      balance_q_fr[1] = 0.0;
      balance_q_bl[2] = 0.0;
      balance_q_bl[1] = 0.0;
    }
  }
  
  // Depending on the possibility of current movement 
  if (robot_path.is_moving) {
    // Update balance effect at servos
    for (int i = 0; i < 3; i++) {
      q_bl[i].number += (balance_q_bl[i] * 180.0 / PI);
      q_br[i].number += (balance_q_br[i] * 180.0 / PI);
      q_fl[i].number += (balance_q_fl[i] * 180.0 / PI);
      q_fr[i].number += (balance_q_fr[i] * 180.0 / PI);
    }
  } else {
    for (int i = 0; i < 3; i++) {
      q_bl[i].number = (balance_q_bl[i] * 180.0 / PI);
      q_br[i].number = (balance_q_br[i] * 180.0 / PI);
      q_fl[i].number = (balance_q_fl[i] * 180.0 / PI);
      q_fr[i].number = (balance_q_fr[i] * 180.0 / PI);
    }
  }
}
