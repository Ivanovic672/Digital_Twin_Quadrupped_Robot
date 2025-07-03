#include "IMU.h"
#include <Arduino.h>
#include <Math.h>

// Access sample time
extern int sample_time;

// Declares filtered angles from previous loop
float previous_roll = 0.0;
float previous_pitch = 0.0;
float previous_yaw = 0.0;

// Function Which Adds A Digital Complementary Filter To IMU Signals
void get_IMU_filtered(message_float* IMU_from_simulation, message_float* IMU_filtered_to_UI) {

  // Declares a factor (alpha) that describes the reliability of the accelerometer and gyroscope from IMU (typically between 0.9 - 1)
  // High alpha: more reliability of the gyroscope
  // Low alpha: more reliability of the accelerometer
  float alpha = 0.95;

  // Demux IMU Signals Input
  float a_x = IMU_from_simulation[0].number;
  float a_y = IMU_from_simulation[1].number;
  float a_z = IMU_from_simulation[2].number;
  float w_x = IMU_from_simulation[3].number;
  float w_y = IMU_from_simulation[4].number;
  float w_z = IMU_from_simulation[5].number;
  
  // Declares and calculates angles from accelerometer
  float roll_from_accel;
  if (a_x == 0.0 && a_z == 0) {
    roll_from_accel = 0;
  } else {
    roll_from_accel = atan(a_y/sqrt(pow(a_x,2) + pow(a_z,2)));
  }
  float pitch_from_accel;
  if (a_y == 0.0 && a_z == 0) {
    pitch_from_accel = 0;
  } else {
    pitch_from_accel = atan(-a_x/sqrt(pow(a_y,2) + pow(a_z,2)));
  }

  // Convert sample time to seconds (from ms)
  float dt = sample_time / 1000.0;

  // Declares and calculates angles from gyroscope
  float roll_from_gyro = previous_roll + w_x * dt;
  float pitch_from_gyro = previous_pitch + w_y * dt;
  float yaw_from_gyro = previous_yaw + w_z * dt;
  
  // Declares and calculates filtered angles for current loop
  float roll = alpha * roll_from_gyro + (1 - alpha) * roll_from_accel;;
  float pitch = alpha * pitch_from_gyro + (1 - alpha) * pitch_from_accel;
  float yaw = yaw_from_gyro;

  // Write at pointer IMUFilteredToIU
  IMU_filtered_to_UI[0].number = roll;
  IMU_filtered_to_UI[1].number = pitch;
  IMU_filtered_to_UI[2].number = yaw;
  IMU_filtered_to_UI[3].number = w_x;
  IMU_filtered_to_UI[4].number = w_y;
  IMU_filtered_to_UI[5].number = w_z;

  // Update roll, pitch and yaw for following loop
  previous_roll = roll;
  previous_pitch = pitch;
  previous_yaw = yaw;
}
