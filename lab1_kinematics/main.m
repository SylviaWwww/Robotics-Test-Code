% addpath("../simulator/");
% pb = piBotSim("floor.jpg");
% 
% pb.place([2.5;1.5], 0);

pb = PiBot('192.168.50.1');
% 
u = 0.5;
q = 0;

[wl, wr] = inverse_kinematics(u, q);

% wheel_velocities = [wl,wr];
wheel_velocities = [wl,-wr];

time = 1;

pb.setVelocity(wheel_velocities, time);

% 
% % figure;
% % camAxes = axes();
% % 
% % % Acquiring an image is as simple as calling the getCamera command. The
% % % image you get will depend on the floor image the simulator is using. The
% % % walls of the room will be rendered as pure white.
% % img = pb.getImage();
% % imshow(img, 'Parent', camAxes);


% % Test parameter
% initial_state = [2.5; 1.5; 0];
% pb.place([2.5; 1.5], 0);
% 
% u = 0;  % m/s
% q = 0.5;
% T = pi;
% 
% [wl, wr] = inverse_kinematics(u, q);
% pb.setVelocity([wl, wr], T);
% 
% estimated_state = integrate_kinematics(initial_state, T, u, q);
% 
% theta_change = wrapToPi(estimated_state(3) - initial_state(3));  % [-pi, pi]
% expected_theta_change = pi / 2;
% wheel_track_adjustment = expected_theta_change / theta_change;
% 
% fprintf("expected theta: %.4f rad\n", expected_theta_change);
% fprintf("actual theta: %.4f rad\n", theta_change);
% fprintf("adjustment: %.5f\n", wheel_track_adjustment);
% 
% % dx = estimated_state(1) - initial_state(1);
% % dy = estimated_state(2) - initial_state(2);
% % actual_dist = sqrt(dx^2 + dy^2);
% % expected_dist = u * T;
% % scale_factor_adjustment = actual_dist / expected_dist;
% 
% % fprintf("expected distance: %.3f m\n", expected_dist);
% % fprintf("actual distance: %.3f m\n", actual_dist);
% % fprintf("scale factor adjustment: %.5f\n", scale_factor_adjustment);
% % 
