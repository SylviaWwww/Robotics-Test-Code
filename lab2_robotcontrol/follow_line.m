% Calibrate the scale parameter and wheel track of the robot
%addpath("../simulator/"); % Add the simulator to the MATLAB path.
%pb = piBotSim("floor_spiral.jpg");

% Start by placing your robot at the start of the line
%pb.place([2.5;2.5], 0.6421);

pb = PiBot('192.168.50.1'); % Use this command instead if using PiBot.

% Create a window to visualise the robot camera
figure;
camAxes = axes();

% Add consts
load("cameraParams.mat");
load("arucoDict.mat");
marker_length = 0.075;

% Follow the line in a loop
while true
    
    % First, get the current camera frame
    img = pb.getImage();
    
    % detect any visible landmarks and record their ids
    % [marker_nums, landmark_centres, marker_corners] = detectArucoPoses(img, marker_length, cameraParams, arucoDict);
    
    % Get the image and crop
    % 可能需要调整一下import的文件的位置
    % 第一步拍图片然后裁剪它，并转化成灰度图，并将黑白反转，也就是黑色的line会变成白色
    gray_img = rgb2gray(img);
    bin_img = ~imbinarize(gray_img, 0.2);

    % 第二步把灰度图的左右上下裁剪，这样只会留中心的白点，也就是小车需要跟随的点
    roi = bin_img(end-40:end-20, :);
    roi(:, 1:15) = 0;
    roi(:, end-15:end) = 0;

    % 保存各个图片方便debug
    imshow(roi, 'Parent', camAxes);
    imwrite(img, 'original.png');
    imwrite(gray_img, 'gray.png');
    imwrite(bin_img, 'binary.png');
    imwrite(roi, 'roi.png');


    % If you have reached the end of the line, you need to stop by breaking
    % the loop and print out the ids of any landmarks seen along the way.
    % 如果没有白点了，速度为0
    if ~any(roi)
        pb.setVelocity(0, 0);
        break
    end
    
    % Find the centre of the line to follow
    % 跟随线的中心
    [r, c] = find(roi == 1);
    x_mean = mean(c);
    W = size(roi, 2);
    % x就是白色点对于图片而言靠左还是靠右，靠左就是负
    x_center = W / 2;
    line_centre = (x_mean - x_center) / x_center;
    
    % If x is negative, spin left. If x is positive, spin right (from seekdot./)
    % 判断x的正负，从而知道该往左右调整方向
    q = -0.5 * line_centre;
    % Drive forward as soon as the dot is roughly in view
    if abs(line_centre) > 0.4
        u = 0.2;
    else
        u = 0.1;
    end
    % Lab1的函数
    [wl,wr] = inverse_kinematics(u,q);

    pb.setVelocity(wl,wr);

    % Use the line centre to compute a velocity command (original, from the lab)
    % u = 0.1; % replace with computed values!
    % q = 0.0; % replace with computed values!

   % u = 0.25;
    %q = 0.0;
    
    
    % Compute the required wheel velocities
    %[wl, wr] = inverse_kinematics(u,q);
    
    % Apply the wheel velocities
    %pb.setVelocity(wl,wr);
end


% Save the trajectory of the robot to a file.
% Don't use this if you are using PiBot.
% pb.saveTrail();

