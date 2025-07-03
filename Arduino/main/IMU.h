#ifndef IMU_H
#define IMU_H

#include "communication.h"

void get_IMU_filtered(message_float* IMU_from_simulation, message_float* IMU_filtered_to_UI);

#endif
