% This file is assigned to: Ethan
% This code creates two plots on one graph
% Create plot for elevation over time and elevation grade over time

% data is a matrix of all data
% There are 6 columns, only the first 4 are important
% The columns (in order) contain:
% Time (seconds) | Northing,(lat) (y) | Easting,(long) (x) | Elevation (m)

function elevation_time(data)
    distances = interval_distance(data, 0);
    elevations = data(:, 4);
    elevations = elevations - circshift(elevations, 1);
    elevations = movmean(elevations(2:end)./distances, 6) * 100;
    
    grid on;
    yyaxis left;
    
    plot(data(2:end,1)/3600,elevations,'r')
    ylim([-10 10])
    
    ylabel('Elevation Grade (%)')
    
    
    yyaxis right;
    plot(data(:,1)/3600,data(:, 4))
    maximum = max(data(:, 4))*1.10;
    ylim([-maximum maximum])
    
    title('Elevation grade')
    xlabel('Time interval')
    ylabel('Elevation (m)')
    hold off;
end