#ifndef COMMUNICATION_H
#define COMMUNICATION_H

#include <stdint.h>

// Union Structure for Serial Communication with Simulation and UI
typedef union{
  float number;
  uint8_t bytes[4];
} message_float;

// Functions for Serial Communication with Simulation at Simscape Multibody
void simulation_get_data_IMU(message_float* IMU_from_simulation, bool* is_simulation_started);
void simulation_write_actuators(message_float* q_bl, message_float* q_br, message_float* q_fl, message_float* q_fr);

// Functions for Serial Communication with UI through Bluetooth
void UI_get_user_orders(char* user_order);
void UI_write_IMU_data(message_float* IMU_filtered_to_UI);

#endif
