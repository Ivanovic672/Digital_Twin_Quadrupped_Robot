% Script which loads the specifications of the enviroment:
% (Requires inertias.m script to be executed before)

%% Execution Sample Time For Modelled Devices
% While the execution must be continous to simulate closely the real world,
% the devices that will control the robot must be discrete in order to
% aproximate them to real devices
deltaT = 0.001;                         % Sample time in seconds (1 ms)

%% Physical constants:
g = -9.80665;                           % Gravity (m/s^2)

%% Complementary filter params:
comp_filter_alpha = 0.95;

%% Ground
ground = struct();

% Params (rigid, not sliding, immovable):
ground.stiffness = 1e6;                  % Ground stiffness for collision (N/m)          
ground.damping = 500;                    % Ground damping for collision (N/(m/s))
ground.transition_region_width = 1e-3;   % Ground transition region width for collision (m)
ground.static_friction = 0.9;            % Ground static friction
ground.dynamic_friction = 0.8;           % Ground dynamic friction
ground.critical_velocity = 1e-2;         % Ground critical_velocity (m/s)
ground.mass = 1000000;                   % Infinite inertia (Kg)
ground.dimensions = [3, 3, 0.05];        % Ground length, width and height (m)

% Ground inclination
ground.inclination_axis = [1 0 0];      % Axis for ground inclination [X, Y, Z]
ground.inclination_degrees = 4;         % Value of ground inclination in degrees
ground.gap = 1e-5;                      % Gap between solid ground and surface, in order to contrast colors

% Color:
ground.world_color_RGB = [0.47843137 0.8039216 0.64705884];  % Green [R, G, B]
ground.actual_color_RGB = [0.2745, 0.5098, 0.7059];          % Steel blue [R, G, B]
ground.color_opacity = 0.65;                                 % Opacity

%% Surface contact at feet:
foot_contact.radius = 0.004;             % Radius of the surface of contact between foot and ground (m)
% Cloud of points:
foot_contact.cloud_matrix = [0, 0, 0;
                0, -4.5, 0;
                0, 4.5, 0;
                1.375, 0, 0.1;
                1.375, -4.5, 0.1;
                1.375, 4.5, 0.1;
                1.939, 0, 0.2;
                1.939, -4.5, 0.2;
                1.939, 4.5, 0.2;
                2.728, 0, 0.4;
                2.728, -4.5, 0.4;
                2.728, 4.5, 0.4;
                3.323, 0, 0.6;
                3.323, -4.5, 0.6;
                3.323, 4.5, 0.6;
                4.036, 0, 0.9;
                4.036, -4.5, 0.9;
                4.036, 4.5, 0.9;
                4.622, 0, 1.2;
                4.622, -4.5, 1.2;
                4.622, 4.5, 1.2;
                5.276, 0, 1.6;
                5.276, -4.5, 1.6;
                5.276, 4.5, 1.6;
                5.831, 0, 2;
                5.831, -4.5, 2;
                5.831, 4.5, 2;
                6.423, 0, 2.5;
                6.423, -4.5, 2.5;
                6.423, 4.5, 2.5;
                6.928, 0, 3;
                6.928, -4.5, 3;
                6.928, 4.5, 3;
                7.365, 0, 3.5;
                7.365, -4.5, 3.5;
                7.365, 4.5, 3.5;
                7.746, 0, 4;
                7.746, -4.5, 4;
                7.746, 4.5, 4];

% Test surface of contact color:
foot_contact.color = [1 0 0];         % Red [R, G, B]
foot_contact.opacity = 0.35;          % Red opacity


%% Rubber at foot:
rubber = struct();
rubber.stiffness = 5e3;
rubber.damping = 50;
rubber.transition_region_width = 5e-3;


%% Spring and Damper Force between rubber and ground:
spring_damper = struct();
spring_damper.natural_length = 5e-3;
spring_damper.stiffness = 1e3;
spring_damper.damping = 20;


%% Robot frame color:
robot_frame = struct();
robot_frame.color = [1 0 1];
robot_frame.opacity = 1;
robot_frame.height = robot_lengths.L2 + robot_lengths.L3;  % Distance from ground to robot frame in Z Axis.
%robot_frame.initial_position = [-0.25, 0.25, robot_frame.height];
robot_frame.initial_position = [-1.5, 1.5, robot_frame.height];
