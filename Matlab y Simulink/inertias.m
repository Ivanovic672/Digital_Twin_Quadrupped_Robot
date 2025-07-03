% This script contains all the global inertia params which are loaded in
% order to approximate the simulation to the real robot model

%% Standards:
% - fl: references "front-left"
% - fr: references "front-right"
% - bl: references "back-left"
% - br: references "back-right"


%% Declares PLA Density:
PLA_density = 1.24;                % Density in g/cm^3


%% Declares structs of data:
robot_volumes = struct();
robot_weights = struct();
other_weights = struct();
robot_lengths = struct();


%% Single Volumes:
% Legs:
robot_volumes.foot = 6.10;                         % Volume in cm^3
robot_volumes.tibia = 16.59;                       % Volume in cm^3
robot_volumes.femur_a = 30.79;                     % Volume in cm^3
robot_volumes.femur_b = 40.64;                     % Volume in cm^3
robot_volumes.hip = 33.39;                         % Volume in cm^3
% Body:
robot_volumes.body_fl = 47.00;                     % Volume in cm^3
robot_volumes.body_fr = 47.45;                     % Volume in cm^3
robot_volumes.body_bl = 47.20;                     % Volume in cm^3
robot_volumes.body_br = 47.59;                     % Volume in cm^3
robot_volumes.battery_support_front = 6.26;        % Volume in cm^3
robot_volumes.battery_support_back = 6.26;         % Volume in cm^3
robot_volumes.bottom_support_left= 15.94;          % Volume in cm^3
robot_volumes.bottom_support_right = 15.94;        % Volume in cm^3
robot_volumes.IMU_support = 6.62;                  % Volume in cm^3
robot_volumes.Arduino_support_left = 15.21;        % Volume in cm^3
robot_volumes.Arduino_support_right = 15.21;       % Volume in cm^3
robot_volumes.load_plate = 83.65;                  % Volume in cm^3


%% Single Weights (based only on material):
% Legs:
robot_weights.foot = robot_volumes.foot * PLA_density;                                      % Weight in g
robot_weights.tibia = robot_volumes.tibia * PLA_density;                                    % Weight in g
robot_weights.femur_a = robot_volumes.femur_a * PLA_density;                                % Weight in g
robot_weights.femur_b = robot_volumes.femur_b * PLA_density;                                % Weight in g
robot_weights.hip = robot_volumes.hip * PLA_density;                                        % Weight in g
% Body:
robot_weights.body_fl = robot_volumes.body_fl * PLA_density;                                % Weight in g
robot_weights.body_fr = robot_volumes.body_fr * PLA_density;                                % Weight in g
robot_weights.body_bl = robot_volumes.body_bl * PLA_density;                                % Weight in g
robot_weights.body_br = robot_volumes.body_br * PLA_density;                                % Weight in g
robot_weights.battery_support_front = robot_volumes.battery_support_front * PLA_density;    % Weight in g
robot_weights.battery_support_back = robot_volumes.battery_support_back * PLA_density;      % Weight in g
robot_weights.bottom_support_left = robot_volumes.bottom_support_left * PLA_density;        % Weight in g
robot_weights.bottom_support_right = robot_volumes.bottom_support_right * PLA_density;      % Weight in g
robot_weights.IMU_support = robot_volumes.IMU_support * PLA_density;                        % Weight in g
robot_weights.Arduino_support_left = robot_volumes.Arduino_support_left * PLA_density;      % Weight in g
robot_weights.Arduino_support_right = robot_volumes.Arduino_support_right * PLA_density;    % Weight in g
robot_weights.load_plate = robot_volumes.load_plate * PLA_density;                          % Weight in g


%% Other Elements Weights:
other_weights.servo = 63;               % Weight in g
other_weights.Arduino_Due = 100;        % Weight in g
other_weights.battery = 280;            % Weight in g
other_weights.disk = 5;                 % Weight in g
other_weights.pulley = 50;              % Weight in g
other_weights.servo_heatsink = 40;      % Weight in g
other_weights.bearing = 10;             % Weight in g

other_weights.extras = 360;             % Weight in g (nuts, bolts, belts, rubber...) 
                                        % It is supossed the following distribution:
                                        % 40% body, 15% each leg, 100% in total


%% Single Weights (considering other elements):
% Legs:
robot_weights.foot = robot_weights.foot + other_weights.extras * 0.02;                                   % (+2% extra weight)
robot_weights.tibia = robot_weights.tibia + other_weights.extras * 0.015;                                % (+1.5% extra weight)
robot_weights.femur_a = robot_weights.femur_a + other_weights.extras * 0.035;                            % (+3.5% extra weight)
robot_weights.femur_b = robot_weights.femur_b + other_weights.servo ...                                  % (+1 servo, +1 disk, +1 bearing, +1 servo heatsink ...
    + other_weights.disk + other_weights.bearing + other_weights.servo_heatsink ...                      %  +1 pulley, +4% extra weight)
    + other_weights.pulley + other_weights.extras * 0.04;                                   
robot_weights.hip = robot_weights.hip + other_weights.servo + other_weights.disk ...                     % (+1 servo, +1 disk, +1 bearing ...
    + other_weights.bearing + other_weights.extras * 0.04;                                               % +4% extra weight)
% Body:
robot_weights.body_fl = robot_weights.body_fl + other_weights.servo + other_weights.disk ...             % (+1 servo, +1 disk, +1 bearing ...
    + other_weights.bearing + other_weights.extras * 0.05;                                               % +5% extra weight)
robot_weights.body_fr = robot_weights.body_fr + other_weights.servo + other_weights.disk ...             % (+1 servo, +1 disk, +1 bearing ...
    + other_weights.bearing + other_weights.extras * 0.05;                                               % +5% extra weight)
robot_weights.body_bl = robot_weights.body_bl + other_weights.servo + other_weights.disk ...             % (+1 servo, +1 disk, +1 bearing ...
    + other_weights.bearing + other_weights.extras * 0.05;                                               % +5% extra weight)
robot_weights.body_br = robot_weights.body_br + other_weights.servo + other_weights.disk ...             % (+1 servo, +1 disk, +1 bearing ...
    + other_weights.bearing + other_weights.extras * 0.05;                                               % +5% extra weight)
robot_weights.battery_support_front = robot_weights.battery_support_front + ...                          % (+50% battery, +2.5% extra weight)
    other_weights.battery/2 + other_weights.extras * 0.025;      
robot_weights.battery_support_back = robot_weights.battery_support_back + ...                            % (+50% battery, +2.5% extra weight)
    other_weights.battery/2 + other_weights.extras * 0.025;      
robot_weights.bottom_support_left = robot_weights.bottom_support_left + other_weights.extras * 0.02;     % (+2% extra weight)
robot_weights.bottom_support_right = robot_weights.bottom_support_right + other_weights.extras * 0.02;   % (+2% extra weight)
robot_weights.IMU_support = robot_weights.IMU_support + other_weights.extras * 0.02;                     % (+2% extra weight)
robot_weights.Arduino_support_left = robot_weights.Arduino_support_left + ...                            % (+3% extra weight)
    other_weights.Arduino_Due/2 + other_weights.extras * 0.03;      
robot_weights.Arduino_support_right = robot_weights.Arduino_support_right + ...                          % (+3% extra weight)
    other_weights.Arduino_Due/2 + other_weights.extras * 0.03;      
robot_weights.load_plate = robot_weights.load_plate + other_weights.extras * 0.03;                       % (+3% extra weight)


%% Compound Weights:
robot_weights.leg = robot_weights.foot + robot_weights.tibia + ...
    robot_weights.femur_a + robot_weights.femur_b + robot_weights.hip;                        % Weight in g
robot_weights.leg = robot_weights.leg / 1000;                                                 % Weight in kg

robot_weights.body = robot_weights.body_fl + robot_weights.body_fr + ...                        
    robot_weights.body_bl + robot_weights.body_br + robot_weights.battery_support_front ...
    + robot_weights.battery_support_back + robot_weights.bottom_support_left + ...
    robot_weights.bottom_support_right + robot_weights.IMU_support + ...
    robot_weights.Arduino_support_left + robot_weights.Arduino_support_right ...
    + robot_weights.load_plate;                                                               % Weight in g
robot_weights.body = robot_weights.body / 1000;                                               % Weight in kg

robot_weights.total = robot_weights.leg * 4 + robot_weights.body;                             % Weight in kg


%% Robot Lengths:
robot_lengths.L1 = 0.042;          % Length in m (hip)
robot_lengths.L2 = 0.1;            % Length in m (femur)
robot_lengths.L3 = 0.1;            % Length in m (distance from ground to knee: foot + tibia)





