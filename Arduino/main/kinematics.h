#ifndef KINEMATICS_H
#define KINEMATICS_H

#include "communication.h"

// Declares variables for path
struct path {  
  bool is_moving;       // Flag that indicates if the movement has or not finished
  float current_step;   // Indicates the current step of the path
  float P0[3];          // P0 from Bezier spline for left legs (for right legs --> [-P0[0], P0[1], P0[2]])
  float P1[3];          // P1 from Bezier spline for left legs (for right legs --> [-P1[0], P1[1], P1[2]])
  float P2[3];          // P2 from Bezier spline for left legs (for right legs --> [-P2[0], P2[1], P2[2]])
  float P3[3];          // P3 from Bezier spline for left legs (for right legs --> [-P3[0], P3[1], P3[2]])
  char movement_type;   // Type of movement, based on user order: "U" (Up - forward), "D" (Down - back), "R" (Right - right), "L" (Left - left), "N" No movement
};

// Function which calculates the next instantaneous position to reach
void calculate_next_position(float* position_to_reach, path* robot_path);

// Function which resolves the inverse kinematics in order to reach the next position
void inverse_kinematics(float* position_to_reach, path* robot_path, message_float* q_bl, message_float* q_br, message_float* q_fl, message_float* q_fr);

// Function which determines the next movement to be followed by the quadrupped robot based on the order received by user
void determine_next_path(path* robot_path, char* user_order);

#endif
