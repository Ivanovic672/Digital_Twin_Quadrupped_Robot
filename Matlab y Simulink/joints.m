% This script contains all the params related to the servos and joints

%% Declares struct:
robot_joints = struct();
robot_tf = struct();
robot_conversions = struct();


%% Angles %%
% Limit angles for each joint
robot_joints.q_limits = [-90.0, 90.0];  % Angles in degrees (°)

% The effective range is between [-82.5, 82.5] degrees but, since -90 and
% 90 degrees are strictly reachable, the range will consider 180 degrees.
% For the physical prototype, it should be considered the no lineality for
% values close to -90 or 90.

% Angles offset for simulation (in the real prototype, this will be set
% physically, not by computer)
robot_joints.q1_offset = 0;           % Angle in degrees (°)
robot_joints.q2_offset = -60;         % Angle in degrees (°)
robot_joints.q3_offset = 112;         % Angle in degrees (°)


%% Speed %%
% Max servos speed
robot_joints.servo_max_v = 60/0.14;     % Speed in degrees per second (°/s)


%% Transfer Functions for Modelling Joint
s = tf('s');

% Physical Servo:
robot_tf.t_98 = (165 * 0.98) / (robot_joints.servo_max_v);    % Time in s
robot_tf.w_n = 4.6 / robot_tf.t_98;                           % Frequency in rad/s
robot_tf.fact_amort = 0.85;
robot_tf.physical_tf = (robot_tf.w_n^2) / ...
    (s^2 + 2 * robot_tf.fact_amort * robot_tf.w_n * s + robot_tf.w_n^2);

% Bessel Filter for PWM:
[robot_tf.zf, robot_tf.pf, robot_tf.kf] = besself(2,5*2*pi,'low');
[robot_tf.bf, robot_tf.af] = zp2tf(robot_tf.zf, robot_tf.pf, robot_tf.kf);
robot_tf.bessel_filter = tf(robot_tf.bf, robot_tf.af);


%% Data Conversions
% PCA9685 Conversion Aproximation
robot_conversions.steps_to_degrees = 143/82.5;
robot_conversions.steps_offset = 307;
robot_conversions.degress_to_DC = 0.035/143;

% DC to Rad Conversion at joint
robot_conversions.DC_offset = -0.075;
robot_conversions.DC_to_rad = (pi * 165/180) / 0.07;
