% Script which must be executed in order to simulate and control the
% quadrupped-leg robot Pavlov-Mini:

%% Clear the Workspace and the Command Window:
clear all;
clc;

%% Import all the required data:
inertias;                        % Inertias for the mechanical model
joints;                          % Params for the joints
enviroment;                      % Params for the enviroment


%% Simulation & real-time control
% Simulate the quadrupped-leg robot in Simscape Multibody
model = 'digital_twin_control';                                     % Model name
load_system(model);                                                 % Load model (no run yet)
simIn = Simulink.SimulationInput(model);                            % Set simulation config
simIn = simIn.setModelParameter('StopTime', 'inf');                 % Set stop time at infinite
simIn = simIn.setModelParameter('SimulationMode', 'accelerator');   % Set simulation mode at accelerator
simIn = simIn.setModelParameter('ReturnWorkspaceOutputs', 'off');   % Deactivate workscape outputs
simIn = simIn.setModelParameter('SimscapeLogType', 'none');         % Deactivate logs for Simscape

% Run the simulation
simOut = sim(simIn);
