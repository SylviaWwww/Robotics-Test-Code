function new_state = integrate_kinematics(state, dt, lin_velocity, ang_velocity)
%INTEGRATE_KINEMATICS integrate the kinematics of the robot

%   state is the current state, and has the form [x;y;theta]
%   dt is the length of time for which to integrate
%   lin_velocity is the (forward) linear velocity of the robot
%   ang_velocity is the angular velocity of the robot

%   new_state is the state after integration, also in the form [x;y;theta]
    x = state(1);
    y = state(2);
    theta = state(3);

    EPSILON = 1e-6;

    if abs(ang_velocity) < EPSILON
        x_new = x + lin_velocity * cos(theta) * dt;
        y_new = y + lin_velocity * sin(theta) * dt;
        theta_new = theta;
    else
        R = lin_velocity / ang_velocity;
        delta_theta = ang_velocity * dt;

        x_new = x + R * (sin(theta + delta_theta) - sin(theta));
        y_new = y - R * (cos(theta + delta_theta) - cos(theta));
        theta_new = theta + delta_theta;
    end

    % Normalize theta to [-pi, pi]
    theta_new = atan2(sin(theta_new), cos(theta_new));

    new_state = [x_new; y_new; theta_new];
end