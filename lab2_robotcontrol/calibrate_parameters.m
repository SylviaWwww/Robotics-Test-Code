% Calibrate the scale parameter and wheel track of the robot
addpath("../simulator/"); % Add the simulator to the MATLAB path.
pb = piBotSim("floor.jpg");

% pb = PiBot("192.168.50.1"); % Use this command instead if using PiBot.

scale_parameter = 0.0;
wheel_track = 0.0; 

% Write your code to compute scale_parameter and wheel_track below.
% HINTS:
% - In simulator: Start by placing your robot (pb.place). Then, drive forward for a known
% time, and measure the robot position (pb.measure) to compute the
% velocity. This will let you solve for the scale parameter.
% - For PiBots: Put a mark on the ground and place your robot on the mark.
% Let it run for certain time and measure the pose, or let it run for certain distance and
% and measure the time.
% - Using multiple trials with different speeds is key to your success!

