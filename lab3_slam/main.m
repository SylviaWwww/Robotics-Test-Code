% Always begin by using addpath
% You can always test your algorithm in simulator
% addpath("../simulator")

% Add the ARUCO detector
% Check the example in the folder
addpath("../lab2_robotcontrol/arucoDetector")
addpath("../lab2_robotcontrol/arucoDetector/include")
addpath("../lab2_robotcontrol/arucoDetector/dictionary")
addpath("../lab2_robotcontrol/arucoDetector/dictionary")
addpath("../lab1_kinematics")

% Load parameters
load("../lab2_robotcontrol/cameraParameters.mat");
load("../lab2_robotcontrol/arucoDetector/dictionary/arucoDict.mat");
marker_length = 0.070;

% Initialize the pibot connection
% pb = Pibot('192.168.50.1');

% Simulator stuff
addpath("../simulator/");
pb = piBotSim("floor_course.jpg");
pb.place([1;1], 0);
SINGLE_STEP = true;          % run exactly one control/sense step for follow line sim


% Initialise your EKF class
EKF = ekf_slam();

while(true)
    
    % line follow module
    
    % measure landmarks
    % This is the function you'll use. Check the file for more details.
    %  [~,~,~] = detectArucoPoses(image, marker_length, cameraParams, arucoDict);
    
    % Simulator code! comment out for the real pibot
    marks = pb.measureLandmarks()
    % Follow the line from lab2
    % out = follow_line_step(pb, cameraParams, arucoDict, marker_length, true);  % <- single step
    follow_line_step_sim


   % run EKF functions
    
    % plot estimates
end
