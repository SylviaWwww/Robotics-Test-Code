function drive_circle(pb, radius)
% DRIVE_CIRCLE send a sequence of commands to the pibot to make it drive in a circle.

% pb is the pibot instance to send commands
% radius is the radius of the circle to drive
    u = 0.25;
    q = u / radius;

    T = 2 * pi * radius / u;

    [wl, wr] = inverse_kinematics(u, q);
    wheel_velocities = [wl,-wr];

    fprintf("Drive circle r=%.2f: wl=%.2f, wr=%.2f, T=%.2f s\n", radius, wl, wr, T);

    pb.setVelocity(wheel_velocities, T);

end