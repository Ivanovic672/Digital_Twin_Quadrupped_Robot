#ifndef SERVO_RESPONSE_H
#define SERVO_RESPONSE_H

#include "communication.h"

// Function which calculates the corresponding response (through inverse kinematics) in order to follow user orders
void calculate_servo_response(char* user_order, message_float* q_bl, message_float* q_br, message_float* q_fl, message_float* q_fr);

// Function which guarantee the stability of the quadrupped robot
void calculate_balanced_servo_response(message_float* IMU_filtered_to_UI, message_float* q_bl, message_float* q_br, message_float* q_fl, message_float* q_fr);

#endif
