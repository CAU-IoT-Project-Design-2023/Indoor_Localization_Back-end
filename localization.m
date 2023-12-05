% Step 0: Data load
clear;

rate = 100; % Sampling rate = 100 Hz
deltaT = 1/100;

filename = 'sensor_data.xls';

% A reference vector used for showing orientations
ref.v = [0, 1, 0];
ref.q = quaternion(0, ref.v(1), ref.v(2), ref.v(3));

% Read a gyro and accel data from an excel file 
gyro = xlsread(filename, 'Gyroscope'); 
gyro(:, 1) = []; % The first column in the data is a timestamp

accel = xlsread(filename, 'Linear Accelerometer'); 
accel(:, 1) = []; 

% Step 1: Orientation relative to a previous body frame
orientation = struct();
for i = 1:length(gyro)
    % Estimate a rotation vector from the gyroscrope reading
    theta = deltaT * norm(gyro(i, :));
    v = gyro(i, :) / norm(gyro(i, :));

    % Estimate a rotation quaternion from the rotation vector
    v = sin(theta/2) * v;
    orientation(i).q = quaternion(cos(theta/2), v(1), v(2), v(3));    
end

% Rotate the reference vector to the previous body frame
rotV = zeros(length(orientation), 3);
for i = 1:length(orientation)
    q = orientation(i).q * ref.q * quatinv(orientation(i).q);
    v = q.compact;
    rotV(i, :) = v(2:4);
end

%plot3(rotV(:, 1), rotV(:, 2), rotV(:, 3), 'o')

%Step 2: Orienation relative to an initial body frame
for i = 1:length(orientation)
    if i == 1
        orientation(i).q2i = orientation(i).q;
    else
        % Integrate quaternions
        orientation(i).q2i = orientation(i - 1).q2i * orientation(i).q;
    end
end

% Rotate the reference vector to the initial body frame
rotV = zeros(length(orientation), 3);
for i = 1:length(orientation)
    q = orientation(i).q2i * ref.q * quatinv(orientation(i).q2i);
    v = q.compact;
    rotV(i, :) = v(2:4);
%     rotV(i, :) = quatrotate(quatinv(orientation(i).q2i), ref.v);
end

%plot3(rotV(:, 1), rotV(:, 2), rotV(:, 3), 'o')

%Step 3: Gesture tracking using accel
velocity = zeros(length(accel), 3);
position = zeros(size(velocity));

for i = 1:length(accel)
    if i == 1
        velocity(i, :) = accel(i, :) * deltaT;
        position(i, :) = 1 / 2 * accel(i, :) * deltaT^2;
    else
        velocity(i, :) = velocity(i - 1, :) + accel(i, :) * deltaT;
        position(i, :) = position(i - 1, :) + velocity(i - 1, :) * deltaT...
            + 1 / 2 * accel(i, :) * deltaT^2;
    end
end

%plot3(position(:, 1), position(:, 2), position(:, 3))

view([-2.49 2.11])

%Step 4: Gesture tracking using accel & gyro
velocity = zeros(length(accel), 3);
position = zeros(size(velocity));

for i = 1:length(accel)
    if i == 1
        velocity(i, :) = accel(i, :) * deltaT;
        position(i, :) = 1 / 2 * accel(i, :) * deltaT^2;
    else
        q = quaternion(0, accel(i, 1), accel(i, 2), accel(i, 3));
        rotA = orientation(i - 1).q2i * q * quatinv(orientation(i - 1).q2i);
        rotA = rotA.compact;
        rotA = rotA(2:4);

        velocity(i, :) = velocity(i - 1, :) + rotA * deltaT;
        position(i, :) = position(i - 1, :) + velocity(i - 1, :) * deltaT...
            + 1 / 2 * rotA * deltaT^2;
    end
end

%plot3(position(:, 1), position(:, 2), position(:, 3))

xlim([-0.50 1.07])
ylim([-1.000 0.014])
zlim([-0.300 0.300])
disp(position(i, 1) - position(1, 1))
disp(position(i, 2) - position(1, 2))
disp(position(i, 3) - position(1, 3))