% This example file demonstrates how to operate the robot simulator
addpath("../simulator/"); % Add the simulator to the MATLAB path.

% First, you must instantiate the simulator. You can specify the image to
% use as the floor if you wish.
pb = piBotSim("floor.jpg");

% Use this command if you are using the real PiBot. The address in the
% quotes needs to be replaced by the wlan address shown on you PiBot LED
% display.
% pb = PiBot('192.168.50.1');

% You can place the robot at different positions and orientations in the
% room. Just like in a real-life lab, you are not allowed to place your
% robot while we are testing your code. So do not use the place command
% within the code you are submitting! Also, the real PiBot doens't have
% this function, so remember to delete or comment this when running your
% code on PiBot.
pb.place([2.5;1.5], 0);

% There are a two ways to set wheel velocities
% The first is to set the velocities to apply until a new command is
% received. Be careful though: if you leave your robot to drive without
% stopping it might crash at the side of the room!
pb.setVelocity([40 43]);

% To see what is happening, you must call the robot's simulate() function.
% Some functions, such as getImage() will do this for you.
pb.simulate(5);

% The second way to set the velocity is to provide a duration for the
% command. In this way, the simulator will block until the command is
% finished, much like the real robot.
pb.setVelocity([25 20], 5);
pb.setVelocity([10 -10], 3);
pb.setVelocity([40 40], 2);

% If you want to watch the robot camera stream, you should create a new
% figure and store a reference to the axes in a variable so you don't
% accidentally plot over the simulator view.
figure;
camAxes = axes();

% Acquiring an image is as simple as calling the getCamera command. The
% image you get will depend on the floor image the simulator is using. The
% walls of the room will be rendered as pure white.
img = pb.getImage();
imshow(img, 'Parent', camAxes);

% If you would like to drive while taking pictures, you need to use the
% setVelocity command without specifying a duration. Then you only need to
% call the getImage method, and the simulator will automatically advance.
pb.setVelocity([35 30]);
for i = 1:50
    img = pb.getImage();
    imshow(img, 'Parent', camAxes);
    drawnow;
end