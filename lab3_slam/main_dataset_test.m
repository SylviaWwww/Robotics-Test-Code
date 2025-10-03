% Always begin by using addpath
% You can always test your algorithm in simulator
% addpath("../simulator")

% Add the ARUCO detector
% Check the example in the folder
addpath("../arucoDetector")
addpath("../arucoDetector/include")
addpath("../arucoDetector/dictionary")

% Load parameters
load("arucoDict.mat")
load("cameraParams.mat")
marker_length = 0.070;

% Initialize the pibot connection
pb = Pibot('192.168.50.1');

% Initialise your EKF class
EKF = ekf_slam();

while(true)
    
    % load data from dataset
    
    % measure landmarks
    % This is the function you'll use. Check the file for more details.
    [~,~,~] = detectArucoPoses(image, marker_length, cameraParams, arucoDict);
    
    % run EKF functions
    
    % plot estimates

    % break loop if no more data in dataset
    
end
