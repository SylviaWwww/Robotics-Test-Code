% Calculate the scale parameter and wheel track of the robot
% pamameters need to be measured:
% pose_after
% pose_after_turn

pb = PiBot("192.168.50.1"); % Use this command instead if using PiBot.

scale_parameter = 0.0;
wheel_track = 0.0; 


u = 0.5; % m/s
t = 2;   % seconds

% theory displacement
s_d_theory = u*t;

% actual displacement
pose_after = 0;
s_d_actual = norm(pose_after(1:2)); % 计算实际位移（欧几里得距离）
% norm 范数：对于一个二维向量 [x; y]，norm([x; y]) 计算的是从原点 (0, 0) 到点 (x, y) 的欧几里得距离。

scale_parameter = s_d_actual / s_d_theory;

% ================= 校准 wheel_track：通过旋转运动

pb.setVelocity([u, -u], t); % 使机器人以相反的速度移动
pb.stop();

% 实际位移（模拟器）
pose_after_turn = 0; % 测量转动后的位姿
w_d_actual = norm(pose_after_turn(1:2)); % 计算实际位移

% scale_parameter 影响
u_actual = scale_parameter * u; % 实际速度

wheel_track = 2 * u_actual * t / w_d_actual;
% θ = q * t
% q = (vr - vl) / T = 2 * u / T
% θ = 2 * u * t / T
% T = 2ut / θ
fprintf('scale parameter = %.2f\n', scale_parameter);
fprintf('wheel_track = %.2f\n', wheel_track);
% save('calibrated_params.mat', 'scale_parameter', 'wheel_track');