% addpath("../simulator/"); % Add the simulator to the MATLAB path
% 
% % Create a simulator instance with the circles floor
% pb = piBotSim("floor_circle.jpg");
% 
% 
% % Place the robot at the bottom of a circle
% pb.place([2.5;1.5], 0);

pb = PiBot('192.168.50.1');


% Drive a circle of radius 1m
drive_circle(pb, 0.4);

% % Place the robot at the bottom of another circle
% pb.place([2.5;0.5], 0);
% 
% % Drive a circle of radius 2m
% drive_circle(pb, 2);