 % Calibrate the scale parameter and wheel track of the robot
 % also calibrate the camera.
addpath("../simulator/"); % Add the simulator to the MATLAB path.
pb = piBotSim("floor.jpg");

% Start by placing your robot at the start location
pb.place([2.5;2.5], 0.6421);

pb = PiBot("192.168.50.1"); % Use this command instead if using PiBot.

% Create a window to visualise the robot camera
figure;
camAxes = axes();

% First, get the current camera frame
img = pb.getImage();
imshow(img, "Parent", camAxes); % Check the video

% attempt to detect and measure the landmark using the arucoDetector
% CALL DETECTOR HERE