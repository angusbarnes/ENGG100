function intervals = interval_distance(data)
% the code above creates the function for velocity, and gets the input values

   easting = data(:, 3);
   northing = data(:, 2);
   elevation = data(:, 4);
    
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
    
    intervals = total_dist;
    %the code above plots the graph 
end