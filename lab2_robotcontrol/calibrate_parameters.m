% Calibrate the scale parameter and wheel track of the robot
% addpath("../simulator/"); % Add the simulator to the MATLAB path.
% pb = piBotSim("floor.jpg");

pb = PiBot("192.168.50.1"); % Use this command instead if using PiBot.

scale_parameter = 0.0;
wheel_track = 0.0; 

% 初始值（模拟器）
% pb.place([0, 0], 0);
% K = place(A,B,p) p：闭环系统配置的极点poles（稳定、响应速度、振荡）

u = 0.5; % m/s
t = 2;   % seconds

% 运行
pb.setVelocity([u, u], t);
pb.stop();


pb.setVelocity([u, -u], t); % 使机器人以相反的速度移动
pb.stop();



save('calibrated_params.mat', 'scale_parameter', 'wheel_track');

% need to measure the actual displacement
% s_d_actual
% w_d_actual
