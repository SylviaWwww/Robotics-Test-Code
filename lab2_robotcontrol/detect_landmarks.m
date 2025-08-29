 % Calibrate the scale parameter and wheel track of the robot
 % also calibrate the camera.
addpath("../simulator/"); % Add the simulator to the MATLAB path.
%  pb = piBotSim("floor.jpg");
addpath("include")
addpath("dictionary")
load("arucoDict.mat")
load("cameraParameters.mat")

% Start by placing your robot at the start location

pb = PiBot('192.168.50.1'); % Use this command instead if using PiBot.

% Create a window to visualise the robot camera

iteration = 1;
while true
    img = pb.getImage();
    % name = sprintf('landmark%d.png', iteration);
    % imwrite(img, name);
    num_iteration = sprintf("----------------------------iteration: %d---------------------------------", iteration);
    [marker_nums, landmark_centres, marker_corners] = detectArucoPoses(img, 0.072,cameraParameters, arucoDict);
    disp(num_iteration);
    disp("marker nums:");
    disp(marker_nums);
    disp("landmark centres:");
    disp(landmark_centres);
    disp("marker_corners");
    disp(marker_corners);
    iteration = iteration + 1;
    pause(2);
end
% attempt to detect and measure the landmark using the arucoDetector
% CALL DETECTOR HERE