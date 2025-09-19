% Calibrate the scale parameter and wheel track of the robot
% addpath("../simulator/"); % Add the simulator to the MATLAB path.
% pb = piBotSim("floor.jpg");

pb = PiBot("192.168.50.1"); % Use this command instead if using PiBot.

scale_parameter = 0.0;
wheel_track = 0.0; 

% How to estimate parameters (such as scale_parameter and wheel_track) 
% from the robot state (q) and control inputs (u).

% scale_parameter = actual displacement / theoretical displacement

% When you set the robot's velocity via code (e.g., using pb.setVelocity(v_left, v_right)),
% these velocity values are "command velocities" — the velocities you want the robot to achieve.
% But due to motor response, wheel slip, mechanical losses, or other factors,
% the actual velocity may differ from the commanded one.
% Therefore, we need a scaling factor to compensate for this difference.
% This scaling factor is the scale_parameter.

% In the calibration process, scale_parameter is essentially a "black-box" parameter.
% It may include the combined effects of wheel radius, motor efficiency, friction, etc.
% In other words, scale_parameter is an empirical value obtained by experiment,
% rather than being directly computed from wheel radius.

% Write your code to compute scale_parameter and wheel_track below.
% HINTS:
% - In simulator: Start by placing your robot (pb.place). Then, drive forward for a known
%   time, and measure the robot position (pb.measure) to compute the
%   velocity. This will let you solve for the scale parameter.
% - For PiBots: Put a mark on the ground and place your robot on the mark.
%   Let it run for a certain time and measure the pose, or let it run for a certain distance and
%   measure the time.
% - Using multiple trials with different speeds is key to your success!

% ================= Calibrate scale_parameter: via straight-line motion

% Initial setup (simulator)
% pb.place([0, 0], 0);
% K = place(A,B,p) p: closed-loop system pole placement

u = 0.5; % m/s
t = 2;   % seconds

% Run forward
pb.setVelocity([u, u], t);
pb.stop();

% Theoretical displacement
s_d_theory = u*t;

% Actual displacement (simulator)
pose_after = pb.measure();
s_d_actual = norm(pose_after(1:2)); % Compute actual displacement (Euclidean distance)
% norm: for a 2D vector [x; y], norm([x; y]) is the Euclidean distance from (0, 0) to (x, y).

scale_parameter = s_d_actual / s_d_theory;

% ================= Calibrate wheel_track: via rotation motion

pb.place([0, 0], 0); % Place robot for rotation measurement

pb.setVelocity([u, -u], t); % Make robot rotate with opposite wheel speeds
pb.stop();

% Actual displacement (simulator)
pose_after_turn = pb.measure(); % Measure pose after rotation
w_d_actual = norm(pose_after_turn(1:2)); % Compute actual displacement

% Effect of scale_parameter
u_actual = scale_parameter * u; % Actual velocity

wheel_track = 2 * u_actual * t / w_d_actual;
% θ = q * t
% q = (vr - vl) / T = 2 * u / T
% θ = 2 * u * t / T
% T = 2ut / θ

save('calibrated_params.mat', 'scale_parameter', 'wheel_track');
