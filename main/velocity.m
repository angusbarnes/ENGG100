% This file is assigned to: Hasaan
% This code does the plotting for the Velocity (Km/h) vs time (h)

function velocity = velocity(data1)
    % the code above creates the function for velocity, and gets the input values

   time = data1(:, 1);
   easting = data1(:, 3);
   northing = data1(:, 2);
   elevation = data1(:, 4);

    t = time ./ (60 * 60);
    % the code above changes time from seconds to hours
    
    x_diff_shifted = circshift(easting,-1);
    x_diff = easting - x_diff_shifted;
    % the code above subtracts the second value of the array from the first
    % in which it creates an array with the difference in x distance

    y_diff_shifted = circshift(northing,-1);
    y_diff = northing - y_diff_shifted;
    % the code above subtracts the second value of the array from the first
    % in which it creates an array with the difference in y distance

    distance_diff = sqrt((y_diff) .^ 2 + (x_diff) .^ 2);
    % the code above uses hypothesus rule to calculate the distance
    % between two points

    ele_diff_shifted = circshift(elevation,-1);
    ele_diff = elevation - ele_diff_shifted;
    % the code above subtracts the second value of the array from the first
    % in which it creates an array with the difference in elevation

    total_dist = sqrt((distance_diff) .^ 2 + (ele_diff) .^ 2);
    % the code above calculates the total distance between each point
    % including the elevation in calculation
    
    total_dist = total_dist ./ 1000;
    %the above code changes distance from m to km
    
    velocity = total_dist ./ t;
    % the code above calculates the velocity
    % which is the distance divided by time

    velocity(length(elevation)) = 0;
    velocity = circshift(velocity, 1);
    % the code above makes the last value of velocity equal to 0
    % this is because shiftdim shifts the whole array
    % meaning that our first value got subtracted from the last value twice

    plot(t, velocity), title('Plot of Velocity (Km/h) as function of time (h)'), xlabel('time (h)'), ylabel('velocity (km/h)');
    %the code above plots the graph
    
end
