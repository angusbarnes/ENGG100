% This file is assigned to: Hasaan
% This code does the plotting for the Velocity (Km/h) vs time (h)

function velocity = velocity(data1)
    % the code above creates the function for velocity, and gets the input values

   time = data1(:, 1);
   easting = data1(:, 3);
   northing = data1(:, 2);
   elevation = data1(:, 4);

    t = time ./ 3600;
    % the code above changes time from seconds to hours (as a decimal)

    t1 = t;
    %create a copy of time;
    
    x_shifted = circshift(easting,-1);
    x_diff = easting - x_shifted;
    % the code above subtracts the second value of the array from the first
    % in which it creates an array with the difference in x distance

    y_shifted = circshift(northing,-1);
    y_diff = northing - y_shifted;
    % the code above subtracts the second value of the array from the first
    % in which it creates an array with the difference in y distance

    y_diff = y_diff(1:(end-1));
    x_diff = x_diff(1:(end-1));
    % the code above removes the last column from the matrix
    % the reason for doing so is that when you subtract a - b
    % you end up with one value instead of the original 2
    % based on that, the whole matrix will be smaller by 1
    % so the last value isn't needed, as it is the same as the first.

    distance_diff = sqrt((y_diff) .^ 2 + (x_diff) .^ 2);
    % the code above uses hypothesus rule to calculate the distance
    % between two points

    ele_shifted = circshift(elevation,-1);
    ele_diff = elevation - ele_shifted;
    % the code above subtracts the second value of the array from the first
    % in which it creates an array with the difference in elevation.

    ele_diff = ele_diff(1:(end-1));
    % the code above removes the last column from the matrix
    % the reason for doing so is that when you subtract a - b
    % you end up with one value instead of the original 2
    % based on that, the whole matrix will be smaller by 1
    % so the last value isn't needed, as it is the same as the first.

    total_dist = sqrt((distance_diff) .^ 2 + (ele_diff) .^ 2);
    % the code above calculates the total distance between each point
    % including the elevation in calculation
    
    total_dist = total_dist ./ 1000;
    % the above code changes distance from m to km
    
    t = (circshift(t,-1) - t);
    % the code above gets the average time
    % the reason why average time is used instead of time
    % is that there is 1 less cell in distance than time
    % and we need the time taken to travel between two points
    % not the time for each point (distance represent 2 points)

    t = t(1:(end-1));
    t1 = t1(1:(end-1));
    % the code above removes the last column from the matrix
    % the reason for doing so is that when you subtract a - b
    % you end up with one value instead of the original 2
    % based on that, the whole matrix will be smaller by 1
    % so the last value isn't needed, as it is the same as the first.

    velocity = total_dist ./ t;
    % the code above calculates the velocity
    % which is the distance divided by time
    
    plot(t1, velocity), title('Plot of Velocity (Km/h) as function of time (h)'), xlabel('time (h)'), ylabel('velocity (km/h)'),;
    % the code above plots the graph  

    velocity1 = (1:length(velocity)+1);
    velocity1(1:end-1) = velocity;
    velocity1(length(velocity1)) = 0;
    velocity = velocity1;
    % the code above creates a fake last value
    % this is because the size of the table is bigger than velocity by 1
    % so this last value should make assigning velocity to the table easy
end
