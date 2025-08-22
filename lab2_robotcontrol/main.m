pb = PiBot('192.168.50.1');

% If you want to watch the robot camera stream, you should create a new
% figure and store a reference to the axes in a variable so you don't
% accidentally plot over the simulator view.

camAxes = axes();

% Acquiring an image is as simple as calling the getCamera command. The
% image you get will depend on the floor image the simulator is using. The
% walls of the room will be rendered as pure white.
img = pb.getImage();
imshow(img, 'Parent', camAxes);