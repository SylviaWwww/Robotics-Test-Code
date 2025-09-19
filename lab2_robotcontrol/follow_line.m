% Calibrate the scale parameter and wheel track of the robot
%addpath("../simulator/"); % Add the simulator to the MATLAB path.
%pb = piBotSim("floor_spiral.jpg");

% Start by placing your robot at the start of the line
%pb.place([2.5;2.5], 0.6421);

addpath("arucoDetector\")
addpath("arucoDetector\dictionary\")
addpath("arucoDetector\include\")

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
    [marker_nums, landmark_centres, marker_corners] = detectArucoPoses(img, marker_length, cameraParams, arucoDict);
    
    if ~isempty(landmark_centres)
        display(landmark_centres)
        xr = landmark_centres(:,1);  % x坐标
        yr = landmark_centres(:,2);  % y坐标
        %-----------------------------------------------------------------
        % 初始化图像窗口和坐标轴范围
        if ~exist('fig_initialized','var')
            figure;
            axis([-2 2 -2 2]);   % x, y 范围固定到 [-2, 2]
            axis equal;          % 保持比例
            hold on;
            grid on;             % 显示网格方便看
            fig_initialized = true;
        end
        %-----------------------------------------------------------------

        % 清空旧点，避免残留
        cla;
        % 一次性画出所有点
        plot(xr, yr, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
    
        % 如果还想在每个点旁边标注对应的id
        for k = 1:length(marker_nums)
            text(xr(k), yr(k), sprintf('ID:%d', marker_nums(k)), ...
                 'Color','yellow','FontSize',10, 'FontWeight','bold');
        end
    end

    % 标注 ID
    % for i = 1:numel(marker_nums)
    %     text(xr(i), yr(i), sprintf('  id=%d', marker_nums(i)), ...
    %          'VerticalAlignment','bottom','FontWeight','bold');
    % end

    % 视图范围（可选）
    pad = 0.1;  % 额外留白
    xlim([min(xr)-pad, max(xr)+pad]);
    ylim([min(yr)-pad, max(yr)+pad]);

    drawnow;
    % Get the image and crop
    gray_img = rgb2gray(img);
    bin_img = ~imbinarize(gray_img, 0.4);

    % 第二步把灰度图的左右上下裁剪，这样只会留中心的白点，也就是小车需要跟随的点
    roi = bin_img(end-40:end-20, :);
    roi(:, 1:15) = 0;
    roi(:, end-15:end) = 0;

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
    q = -0.4 * line_centre;
    % Drive forward as soon as the dot is roughly in view
    if abs(line_centre) > 0.1
        u = 0.05;
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

