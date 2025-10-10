%% follow_line_step_sim.m
% Script version of the line follower + ArUco detection, styled like the original.
% Expects (from caller): pb, cameraParams (or cameraParameters), arucoDict, marker_length.
% Optional (from caller): SINGLE_STEP (logical), FLS_KP, FLS_DEADBAND, FLS_UFAST, FLS_USLOW.
% Produces (in caller):   out struct with wl, wr, done, marker_ids, landmark_centres, roi, unique_ids.

% -------------------- setup & defaults (non-intrusive) --------------------
if ~exist('cameraParams','var') && exist('cameraParameters','var')
    cameraParams = cameraParameters;
end
if ~exist('marker_length','var'), marker_length = 0.075; end
if ~exist('SINGLE_STEP','var'),  SINGLE_STEP = false;    end

% control params (match original defaults, but overridable)
if ~exist('FLS_KP','var'),        FLS_KP = 0.4; end
if ~exist('FLS_DEADBAND','var'),  FLS_DEADBAND = 0.10; end
if ~exist('FLS_UFAST','var'),     FLS_UFAST = 0.10; end
if ~exist('FLS_USLOW','var'),     FLS_USLOW = 0.05; end

% If pb/camera params not provided, try to mimic the original setup (best effort)
if ~exist('pb','var') || isempty(pb)
    try
        addpath("arucoDetector\")
        addpath("arucoDetector\dictionary\")
        addpath("arucoDetector\include\")
        pb = PiBot('192.168.50.1');
    catch
        % fallback to simulator if real robot is unavailable
        if ~exist('piBotSim','file')
            addpath("../simulator/");
        end
        pb = piBotSim("floor_course.jpg");
        pb.place([2.5;1.5], 0);
    end
end
if ~exist('cameraParams','var')
    try, load("cameraParams.mat"); end
end
if ~exist('arucoDict','var')
    try, load("arucoDict.mat"); end
end

% (optional) camera window like original
if ~exist('camAxes','var') || ~isgraphics(camAxes)
    figure; camAxes = axes();
end

% landmark scatter figure like original
if ~exist('fig_initialized','var')
    figure;
    axis([-2 2 -2 2]); axis equal; hold on; grid on;
    fig_initialized = true;
end

if ~exist('all_ids___fls','var'), all_ids___fls = []; end

% ----------------------------- main loop ----------------------------------
while true
    % First, get the current camera frame
    img = pb.getImage();

    % detect any visible landmarks and record their ids
    [marker_nums, landmark_centres, marker_corners] = detectArucoPoses(img, marker_length, cameraParams, arucoDict); %#ok<ASGLU>

    if ~isempty(landmark_centres)
        display(landmark_centres)
        xr = landmark_centres(:,1);  % x坐标
        yr = landmark_centres(:,2);  % y坐标

        % 清空旧点，避免残留
        cla;
        % 一次性画出所有点
        plot(xr, yr, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);

        % 如果还想在每个点旁边标注对应的id
        for k = 1:length(marker_nums)
            text(xr(k), yr(k), sprintf('ID:%d', marker_nums(k)), ...
                 'Color','yellow','FontSize',10, 'FontWeight','bold');
        end

        % 视图范围（可选）
        pad = 0.1;  % 额外留白
        xlim([min(xr)-pad, max(xr)+pad]);
        ylim([min(yr)-pad, max(yr)+pad]);

        all_ids___fls = [all_ids___fls; marker_nums(:)]; %#ok<AGROW>
    end

    drawnow;

    % Get the image and crop (use same band as original, but bounds-safe)
    gray_img = rgb2gray(img);
    bin_img  = ~imbinarize(gray_img, 0.4);  % keep original threshold

    H = size(bin_img,1);
    r1 = max(1, H-40);   % end-40
    r2 = max(1, H-20);   % end-20
    roi = bin_img(r1:r2, :);

    roi(:, 1:15)       = 0;
    roi(:, end-15:end) = 0;

    % If you have reached the end of the line, stop
    if ~any(roi(:))
        pb.setVelocity(0, 0);
        out = struct('wl',0,'wr',0,'done',true, ...
                     'marker_ids',marker_nums, ...
                     'landmark_centres',landmark_centres, ...
                     'unique_ids',unique(all_ids___fls), ...
                     'roi',roi);
        assignin('caller','out',out);
        break
    end

    % Find the centre of the line to follow
    [~, c] = find(roi == 1);
    if isempty(c)
        % gentle nudge forward to re-acquire (keeps style simple)
        u = FLS_USLOW; q = 0;
        [wl, wr] = inverse_kinematics(u, q);
        pb.setVelocity(wl, wr);
        out = struct('wl',wl,'wr',wr,'done',false, ...
                     'marker_ids',marker_nums, ...
                     'landmark_centres',landmark_centres, ...
                     'unique_ids',unique(all_ids___fls), ...
                     'roi',roi);
        assignin('caller','out',out);
        if SINGLE_STEP, break; else, continue; end
    end

    x_mean    = mean(c);
    W         = size(roi, 2);
    x_center  = W / 2;
    line_centre = (x_mean - x_center) / x_center;

    % If x is negative, spin left. If x is positive, spin right (original logic)
    q = -FLS_KP * line_centre;

    % Drive forward as soon as roughly centred (original logic)
    if abs(line_centre) > FLS_DEADBAND
        u = FLS_USLOW;
    else
        u = FLS_UFAST;
    end

    % Lab1的函数
    [wl, wr] = inverse_kinematics(u, q);

    % --- tiny spin-proof clamp (keeps behavior but prevents pure rotation) ---
    if (wl < 0) || (wr < 0)
        q = 0.6 * q;                             % shrink turn a bit
        [wl, wr] = inverse_kinematics(u, q);
        if (wl < 0) || (wr < 0)
            q = 0.6 * q;                         % shrink again if needed
            [wl, wr] = inverse_kinematics(u, q);
        end
    end
    % -------------------------------------------------------------------------

    pb.setVelocity(wl, wr);

    % expose per-step info like our step script does
    out = struct('wl',wl,'wr',wr,'done',false, ...
                 'marker_ids',marker_nums, ...
                 'landmark_centres',landmark_centres, ...
                 'unique_ids',unique(all_ids___fls), ...
                 'roi',roi);
    assignin('caller','out',out);

    % single-step mode for calling from main
    if SINGLE_STEP
        break
    end
end

% Save the trajectory of the robot to a file (sim only)
% pb.saveTrail();
