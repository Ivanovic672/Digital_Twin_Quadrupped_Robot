#include "kinematics.h"
#include <Arduino.h>

// Total Steps for each movement
float total_forward_steps = 18.0;
float total_lateral_steps = 18.0;

// Declares dimensions for robot legs:
float L1 = 0.042;
float L2 = 0.10;
float L3 = 0.10;

// Offset for q2 & q3 (in radians)
float q2_offset = 60.0 * (PI / 180.0);
float q3_offset = - 112.0 * (PI / 180.0);

// Initial positions for each leg
float pos_0[3] = {-L1, (float) (L3*cos(0.0)*sin(-q2_offset)*sin(-q3_offset)-L2*cos(0.0)*cos(-q2_offset)-L3*cos(0.0)*cos(-q2_offset)*cos(-q3_offset)-L1*sin(0.0)), 0.0};

// Step displacements
float lateral_displacement = 0.05;
float forward_displacement = 0.10;
float step_height = 0.05;

// "Force" applied into the ground to advance
float step_force = 12.0 * PI / 180.0;


// Function which calculates the next instantaneous position to reach
void calculate_next_position(float* position_to_reach, path* robot_path) {

  // Update current step
  robot_path->current_step += (1.0 / total_forward_steps);

  // Declares current step of movement as a more legible var for calculations
  float t = 0.0;

  // Margin of 10% to finish the current (first or second legs to move) path
  if (robot_path->current_step > 0.0 && robot_path->current_step <= 1.1) {
    t = robot_path->current_step;
  } else {
    t = robot_path->current_step - 1.1;
  }
  if (t > 1.0) {
    t = 1.0;
  }
  
  // Calculate position to reach:
  position_to_reach[0] = pow(1 - t, 3) * robot_path->P0[0] + 3 * t * pow(1 - t, 2) * robot_path->P1[0] + 3 * pow(t, 2) * (1 - t) * robot_path->P2[0] + pow(t, 3) * robot_path->P3[0]; // X for left legs (for right legs --> -X)
  position_to_reach[1] = pow(1 - t, 3) * robot_path->P0[1] + 3 * t * pow(1 - t, 2) * robot_path->P1[1] + 3 * pow(t, 2) * (1 - t) * robot_path->P2[1] + pow(t, 3) * robot_path->P3[1]; // Y for left legs (for right legs --> +Y)
  position_to_reach[2] = pow(1 - t, 3) * robot_path->P0[2] + 3 * t * pow(1 - t, 2) * robot_path->P1[2] + 3 * pow(t, 2) * (1 - t) * robot_path->P2[2] + pow(t, 3) * robot_path->P3[2]; // Z for left legs (for right legs --> +Z)
  

  // If A path and B path has been completed --> Finish path
  if (robot_path->current_step >= 2.2) {
    robot_path->is_moving = false;
    robot_path->current_step = 0.0;
    robot_path->movement_type = 'N';
    robot_path->P0[0] = robot_path->P1[0] = robot_path->P2[0] = robot_path->P3[0] = 0.0;
    robot_path->P0[1] = robot_path->P1[1] = robot_path->P2[1] = robot_path->P3[1] = 0.0;
    robot_path->P0[2] = robot_path->P1[2] = robot_path->P2[2] = robot_path->P3[2] = 0.0;
  }
}


void inverse_kinematics(float* position_to_reach, path* robot_path, message_float* q_bl, message_float* q_br, message_float* q_fl, message_float* q_fr) {

  // Declares position as x, y, z:
  float x = position_to_reach[0];
  float y = position_to_reach[1];
  float z = position_to_reach[2];

  // Factor D (intermediate):
  float D = (pow(x, 2) + pow(y, 2) + pow(z, 2) - pow(L1, 2) - pow(L2, 2) - pow(L3, 2)) / (2 * L2 * L3);

  // Check if position is reachable
  if (abs(D) < 1) {

    // Reconvert angles to radians before calculations
    for (int i = 0; i < 3; i++) {
      q_fl[i].number *= PI / 180.0;
      q_fr[i].number *= PI / 180.0;
      q_bl[i].number *= PI / 180.0;
      q_br[i].number *= PI / 180.0;
    }
  
    // If A path has not been completed yet --> Complete A path
    if (robot_path->current_step <= 1.1) {
   
      // q3 (knee):
      q_fl[2].number = atan(sqrt(1 - pow(D, 2)) / D) + q3_offset;
      if (D < 0) { 
        q_fl[2].number += PI; // Force elbow down in case it is neccesary
      }
      q_br[2].number = - q_fl[2].number;
      // In case forward movement (U)
      if (robot_path->movement_type == 'U') {
        q_bl[2].number = - (step_force);
        q_fr[2].number = + (step_force);
      } else {
        // In case back movement (D)
        if (robot_path->movement_type == 'D') {
          q_bl[2].number = + (step_force);
          q_fr[2].number = - (step_force);
        } else {
          // In case lateral movement (R or L)
          q_bl[2].number = 0.0;
          q_fr[2].number = 0.0;
        }
      }

      
      // q2 (hip Y):  
      q_fl[1].number = -((-atan(z / -sqrt(pow(x, 2) + pow(y, 2) - pow(L1, 2))) + atan(L3 * sin(q_fl[2].number - q3_offset) / (-L2 - L3 * cos(q_fl[2].number - q3_offset)))) + q2_offset);
      q_br[1].number = - q_fl[1].number;
      // In case forward movement (U)
      if (robot_path->movement_type == 'U') {
        q_bl[1].number = - (1.5 * step_force);
        q_fr[1].number = + (1.5 * step_force);
      } else {
        // In case back movement (D)
        if (robot_path->movement_type == 'D') {
          q_bl[1].number = + (1.5 * step_force);
          q_fr[1].number = - (1.5 * step_force);
        } else {
          // In case lateral movement (R or L)
          q_bl[1].number = 0.0;
          q_fr[1].number = 0.0;
        }
      }

    
      // q1 (hip X):
      q_fl[0].number = -atan(-y / x) - atan(sqrt(pow(x, 2) + pow(y, 2) - pow(L1, 2)) / L1);
      q_br[0].number = q_fl[0].number;
      // In case left movement (L)
      if (robot_path->movement_type == 'L') {
        q_bl[0].number = - (1.0 * step_force);
        q_fr[0].number = - (1.0 * step_force);
      } else {
        // In case right movement (R)
        if (robot_path->movement_type == 'R') {
          q_fl[0].number = -q_fl[0].number;
          q_br[0].number = q_fl[0].number;
          q_bl[0].number = - (1.0 * step_force);
          q_fr[0].number = - (1.0 * step_force);
        } else {
          // In case forward movements (U or D)
          q_bl[0].number = 0.0;
          q_fr[0].number = 0.0;
        }
      }

      
    } else {
      
      // If B path has not been completed yet --> Complete B path
      if (robot_path->current_step > 1.1 && robot_path->current_step <= 2.2) {
        
        // q3 (knee):
        q_bl[2].number = atan(sqrt(1 - pow(D, 2)) / D) + q3_offset;
        // Force elbow down in case it is neccesary
        if (D < 0) {
          q_bl[2].number += PI;
        }
        q_fr[2].number = -q_bl[2].number;
        // In case forward movement (U)
        if (robot_path->movement_type == 'U') {
          q_br[2].number = + (step_force);
          q_fl[2].number = - (step_force);
        } else {
          // In case back movement (D)
          if (robot_path->movement_type == 'D') {
            q_br[2].number = - (step_force);
            q_fl[2].number = + (step_force);
          } else {
            // In case lateral movement (R or L)
            q_br[2].number = 0.0;
            q_fl[2].number = 0.0;
          }
        }
        
        
        // q2 (hip Y):
        q_bl[1].number = -((-atan(z / -sqrt(pow(x, 2) + pow(y, 2) - pow(L1, 2))) + atan(L3 * sin(q_bl[2].number - q3_offset) / (-L2 - L3 * cos(q_bl[2].number - q3_offset)))) + q2_offset);
        q_fr[1].number = - q_bl[1].number;
        // In case forward movement (U)
        if (robot_path->movement_type == 'U') {
          q_br[1].number = + (1.5 * step_force);
          q_fl[1].number = - (1.5 * step_force);
        } else {
          // In case back movement (D)
          if (robot_path->movement_type == 'D') {
            q_br[1].number = - (1.5 * step_force);
            q_fl[1].number = + (1.5 * step_force);
          } else {
            // In case lateral movement (R or L)
            q_br[1].number = 0.0;
            q_fl[1].number = 0.0;
          }
        }

       
        // q1 (hip X):
        q_bl[0].number = -atan(-y / x) - atan(sqrt(pow(x, 2) + pow(y, 2) - pow(L1, 2)) / L1);
        q_fr[0].number = q_bl[0].number;
        // In case left movement (L)
        if (robot_path->movement_type == 'L') {
          q_br[0].number = + (1.0 * step_force);
          q_fl[0].number = + (1.0 * step_force);
        } else {
          // In case right movement (R)
          if (robot_path->movement_type == 'R') {
            q_bl[0].number = -q_fl[0].number;
            q_fr[0].number = q_fl[0].number;
            q_fl[0].number = - (1.0 * step_force);
            q_br[0].number = - (1.0 * step_force);
          } else {
            // In case forward movements (U or D)
            q_br[0].number = 0.0;
            q_fl[0].number = 0.0;
          }
        }
        
 
      } else {
        // There must be a little delay before changing path in order to let time the robot reach the lastest position
        q_fl[0].number = q_fl[1].number = q_fl[2].number = 0.0;
        q_br[0].number = q_br[1].number = q_br[2].number = 0.0;
        q_bl[0].number = q_bl[1].number = q_bl[2].number = 0.0;
        q_fr[0].number = q_fr[1].number = q_fr[2].number = 0.0;
      }
    }

    // Convert angles to degrees
    for (int i = 0; i < 3; i++) {
      q_fl[i].number *= 180.0 / PI;
      q_fr[i].number *= 180.0 / PI;
      q_bl[i].number *= 180.0 / PI;
      q_br[i].number *= 180.0 / PI;
    }
  }
}


// Determine the next movement depending on the order received by user
void determine_next_path(path* robot_path, char* user_order) {

  // Initializes points for all movements
  robot_path->P0[0] = robot_path->P1[0] = robot_path->P2[0] = robot_path->P3[0] = pos_0[0];
  robot_path->P0[1] = robot_path->P3[1] = pos_0[1];
  robot_path->P1[1] = robot_path->P2[1] = pos_0[1] + step_height;
  robot_path->P0[2] = robot_path->P1[2] = robot_path->P2[2] = robot_path->P3[2] = pos_0[2];


  // Depending on the order received by the user
  switch(*user_order) {

    case 'U': // Plane YZ --> Displacement at -Z
      // Update current path for following movement to init
      robot_path->is_moving = true;
      robot_path->current_step = 0.0;
      robot_path->movement_type = 'U';
      robot_path->P2[2] = pos_0[2] - forward_displacement;
      robot_path->P3[2] = pos_0[2] - forward_displacement;
      break;
      
    case 'D': // Plane YZ --> Displacement at +Z
      // Update current path for following movement to init
      robot_path->is_moving = true;
      robot_path->current_step = 0.0;
      robot_path->movement_type = 'D';
      robot_path->P2[2] = pos_0[2] + forward_displacement;
      robot_path->P3[2] = pos_0[2] + forward_displacement;
      break;
      
    case 'R': // Plane XY --> Displacement at +X
      // Update current path for following movement to init
      robot_path->is_moving = true;
      robot_path->current_step = 0.0;
      robot_path->movement_type = 'R';
      robot_path->P2[0] = pos_0[0] - lateral_displacement;
      robot_path->P3[0] = pos_0[0] - lateral_displacement;
      break;
    
    case 'L':
      // Plane XY --> Displacement at -X
      // Update current path for following movement to init
      robot_path->is_moving = true;
      robot_path->current_step = 0.0;
      robot_path->movement_type = 'L';
      robot_path->P2[0] = pos_0[0] - lateral_displacement;
      robot_path->P3[0] = pos_0[0] - lateral_displacement;
      break;
    
    default: // No Movement --> Update path as empty
      robot_path->is_moving = false;
      robot_path->current_step = 0.0;
      robot_path->movement_type = 'N';
      robot_path->P0[0] = robot_path->P1[0] = robot_path->P2[0] = robot_path->P3[0] = 0.0;
      robot_path->P0[1] = robot_path->P1[1] = robot_path->P2[1] = robot_path->P3[1] = 0.0;
      robot_path->P0[2] = robot_path->P1[2] = robot_path->P2[2] = robot_path->P3[2] = 0.0;
      break;  
  }
}
