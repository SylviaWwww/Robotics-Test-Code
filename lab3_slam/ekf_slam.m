classdef ekf_slam < handle
    %EKF_SLAM The EKF algorithm for SLAM
    
    properties
        x = zeros(3,1); % The estimated state vector
        P = zeros(3,3); % The estimated state covariance
        
		% The covariance values provided here are NOT correct!
        sigxy = 0.1; % The covariance of linear velocity
        sigth = 0.01; % The covariance of angular velocity
        siglm = 0.01; % The covariance of landmark measurements
        
        idx2num = []; % The map from state vector index to landmark id.
    end
    
    methods
        function input_velocity(obj, dt, lin_velocity, ang_velocity)
            % Perform the update step of the EKF. This involves updating
            % the state and covariance estimates using the input velocity,
            % the time step, and the covariance of the update step.
            
        end
        
        function input_measurements(obj, measurements, nums)
            % Perform the innovation step of the EKF. This involves adding
            % new (not previously seen) landmarks to the state vector and
            % implementing the EKF innovation equations. You will need the
            % landmark measurements and you will need to be careful about
            % matching up landmark ids with their indices in the state
            % vector and covariance matrix.
            
        end
        
        function add_new_landmarks(obj, y, nums)
            % Add a new (not seen before) landmark to the state vector and
            % covariance matrix. You will need to associate the landmark's
            % id number with its index in the state vector.
            
        end
        
        function [robot, cov] = output_robot(obj)
            % Suggested: output the part of the state vector and covariance
            % matrix corresponding only to the robot.

        end
        
        function [landmarks, cov] = output_landmarks(obj)
            % Suggested: output the part of the state vector and covariance
            % matrix corresponding only to the landmarks.

        end
        
    end
end

 % Jacobians and System Functions
 
function x1 = f(x0,u)
    % integrate the input u from the state x0 to obtain x1.

end

function F = jac_f(x0,u)
    % Given the state x0 and input signal u, compute the Jacobian of f.

end

function y = h(x, idx)
    % Given the state x and a list of indices idx, compute the state
    % measurement y.

end

function H = jac_h(x, idx)
    % Given the state x and a list of indices idx, compute the Jacobian of
    % the measurement function h.

end