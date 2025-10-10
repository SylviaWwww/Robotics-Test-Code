% Always begin by using addpath
% You can always test your algorithm in simulator
% addpath("../simulator")

% Add the ARUCO detector
% Check the example in the folder
addpath("../lab2_robotcontrol/arucoDetector")
addpath("../lab2_robotcontrol/arucoDetector/include")
addpath("../lab2_robotcontrol/arucoDetector/dictionary")
addpath("../lab2_robotcontrol/arucoDetector/dictionary")

% Load parameters
load("../lab2_robotcontrol/cameraParameters.mat");
load("../lab2_robotcontrol/arucoDetector/dictionary/arucoDict.mat");
marker_length = 0.070;

% Initialize the pibot connection
% pb = Pibot('192.168.50.1');

addpath("../simulator/");
pb = piBotSim("floor.jpg");
pb.place([2.5;1.5], 0);

% Initialise your EKF class
EKF = ekf_slam();

while(true)
    
    % line follow module
    
    % measure landmarks
    % This is the function you'll use. Check the file for more details.
    [~,~,~] = detectArucoPoses(image, marker_length, cameraParams, arucoDict);
    
    % run EKF functions
    
    % plot estimates
    
end
