% This file was developed by collating various group member's code and
% integrating them for efficiency
% Developers: Angus Barnes, Hassan Farache, Ethan McKay
% Edited By: Angus Barnes

function intervals = interval_distance(data, include_elevation)
    x_coords = data(:,3);
    y_coords = data(:, 2);
    elevations = data(:, 4);
    
    % Get difference between consecutive coordinate points
    x_diffs = x_coords - circshift(x_coords, 1);
    y_diffs = y_coords - circshift(y_coords, 1);

    distances = []; % May be redundant but I don't trust MATLAB's runtime 
                    % heap allocation optimisation. Code is measurably
                    % slower when this variable is implicity declared
                    % through its use inside the if statement below

    % Simple if statement to allow this function to calculate distance both
    % with or without elevation included
    if include_elevation
        elevations = elevations - circshift(elevations, 1);
        distances = sqrt(x_diffs.^2 + y_diffs.^2 + elevations.^2);
    else
        distances = sqrt(x_diffs.^2 + y_diffs.^2);
    end
    
    % The first value is removed as it is nonsense caused by the value
    % wrapping from circshift --> There should be one less interval than
    % location data points 
    % (X,Y) --- (X, Y) --- (X,Y) <- Two intervals for 3 data points
    intervals = distances(2:end);
end