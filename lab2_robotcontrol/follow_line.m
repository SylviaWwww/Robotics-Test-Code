% Calibrate the scale parameter and wheel track of the robot
addpath("../simulator/"); % Add the simulator to the MATLAB path.
pb = piBotSim("floor_spiral.jpg");

% Start by placing your robot at the start of the line
pb.place([2.5;2.5], 0.6421);

pb = PiBot("192.168.50.1"); % Use this command instead if using PiBot.

% Create a window to visualise the robot camera
figure;
camAxes = axes();

% Follow the line in a loop
while true
    
    % First, get the current camera frame
    img = pb.getImage();
    imshow(img, "Parent", camAxes); % Check the video
    
    % detect any visible landmarks and record their ids

    % Raw notes:
    % detect any visible landmarks and record their ids
    % detects landmarks before you determine inputs
    % set velocity
    % integrate kinematics
    
    % For the determine inputs part:
    % binarise image (use rgb2grey or imbinarise or something?)
    % crop image
    % Find black pixels
    % Normalise and transform point
    % Then get q and u!

    % Find the centre of the line to follow
    line_centre = 0.0; % replace with correct value
    
    % If you have reached the end of the line, you need to stop by breaking
    % the loop and print out the ids of any landmarks seen along the way.
    end_of_line = false;
    if (end_of_line)
        break;
    end
    
    
    % Use the line centre to compute a velocity command
    u = 0.1; % replace with computed values!
    q = 0.0; % replace with computed values!
    
    
    % Compute the required wheel velocities
    [wl, wr] = inverse_kinematics(u,q);
    
    % Apply the wheel velocities
    pb.setVelocity(wl,wr);
end


% Save the trajectory of the robot to a file.
% Don't use this if you are using PiBot.
pb.saveTrail();
