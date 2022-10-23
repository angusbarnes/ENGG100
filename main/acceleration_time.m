
function acceleration_time(data)
    % | Time | Northing | Easting | Elevation |
    
    distances = interval_distance(data, 0);
    % Distances between consecutive points
    
    times = interval_time(data);
    
    velocity = distances./times;
    velocity_deltas = velocity(1:5:end) - circshift(velocity(1:5:end), 1);
    velocity_deltas(1) = velocity (1);
    acceleration = velocity_deltas ./ times(1:5:end);
    plot(data(1:5:end,1)/3600,movmean(acceleration, 5));
end