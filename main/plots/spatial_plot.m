% This file is assigned to: Angus Nash
% This file was developed by: Angus Nash
% Integrated and Edited By: Angus Barnes

% Create Spatial Plot graph
function spatial_plot(data)
    
    % Get local copies of the coordinate information
    x_coords = data(:, 3);
    y_coords = data(:, 2);
    z_coords = data(:,4); % This is elevation data
    
    % Find the origin value (The coordinate at which the ride started)
    x_offset = x_coords(1);
    y_offset = y_coords(1);
    z_offset = z_coords(1);
    
    % Make every coordinate relative to the first coordinate
    x_coords = x_coords - x_offset;
    y_coords = y_coords - y_offset;
    z_coords = z_coords - z_offset;
    
    hold on

    % Plot all path points
    plot3(x_coords, y_coords, z_coords)
    plot3(0,0, z_coords(1), MarkerSize=12,Marker=".")
    
    % Some manual adjustment to see picture better
    zlim([-100, 100])
    view([45 24])
    
    legend("Path","Starting Point")
    
    zlabel("Elevation (m)")
    ylabel("Relative Northing (m)")
    xlabel("Relative Easting (m)")
    title("3D Plot of Ride")
    hold off
end