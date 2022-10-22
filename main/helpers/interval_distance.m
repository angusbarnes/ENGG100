function intervals = interval_distance(data, include_elevation)
    x_coords = data(:,3);
    y_coords = data(:, 2);
    elevations = data(:, 4);

    x_coords = x_coords - circshift(x_coords, 1);
    y_coords = y_coords - circshift(y_coords, 1);

    distances = [];
    if include_elevation
        elevations = elevations - circshift(elevations, 1);
        distances = sqrt(x_coords.^2 + y_coords.^2 + elevations.^2);
    else
        distances = sqrt(x_coords.^2 + y_coords.^2);
    end
    
    intervals = distances(2:end);
end