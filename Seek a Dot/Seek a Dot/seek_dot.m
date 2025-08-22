close all

addpath('../simulator');
pb = piBotSim("floor_dot.jpg");

% Place the robot somewhere near-ish the dot
pb.place([1.5;2.0], 0);

% pb.setVelocity([50,50], 5);

% Set up a figure to view the robot camera
figure;
cam_axes = axes();

% Write a loop to get your robot to the dot
while true
    % At the start of the loop, get an image
    img = pb.getImage();
%     imshow(img, 'Parent', cam_axes);
    
    % Binarise the image by picking some sensible threshold
    gray_img = rgb2gray(img);
    bin_img = ~imbinarize(gray_img, 0.2);
    imshow(bin_img, 'Parent', cam_axes);
    
    % Check the dot is visible anywhere
    if ~any(bin_img)
        break
    end
    
    % Find the centre of mass of the dot pixels
    [r, c] = find(bin_img == 1);
    centre_of_mass = [mean(c), mean(r)];
    centre_of_mass = (centre_of_mass - [200, 100]) ./ [200, 100];
    
    % If x is negative, spin left. If x is positive, spin right
    q = -0.5*centre_of_mass(1);
    % Drive forward as soon as the dot is roughly in view
    if abs(centre_of_mass(1)) > 0.2
        u = 0.0;
    else
        u = 0.1;
    end
    
    [wl,wr] = inverse_kinematics(u,q);
    if abs(wl)<5
        wl = 5*(wl/abs(wl));
    end
    if abs(wr)<5
        wr = 5*(wr/abs(wr));
    end
    pb.setVelocity(wl,wr);
    
    drawnow;
%     break;
    
end