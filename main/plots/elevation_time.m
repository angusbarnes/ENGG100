
% This file is assigned to: Ethan Mackay
% This file was developed by: Ethan Mackay

% This code creates two plots on one graph
% Create plot for elevation over time and elevation grade over time
function elevation_time(data)
    
    % get all the distance intervals and elevations
    % Doesn't include elevation in distance calculation
    distances = interval_distance(data, 0);
    elevations = data(:, 4);

    % Get differences
    elevations = elevations - circshift(elevations, 1);

    % Apply a six point moving average to the calculate grades to give some
    % smoothing to the graph. Without this the graph looks very challenging
    % to read as the elevation values can be quite noisy. This may be due
    % to the imprecise nature of using a phone GPS
    elevations = movmean(elevations(2:end)./distances, Settings.GentleSmooth()) * 100;
    
    grid on;
    hold on;
    yyaxis right;
    
    % Plot Time (h) vs Elevation (m)
    plot(data(:,1)/3600,data(:, 4))
    
    % Scale y axis to make graph neat
    maximum = max(data(:, 4))*1.10;
    ylim([-maximum maximum])
    
    title('Elevation grade')
    xlabel('Time (h)')
    ylabel('Elevation (m)')
    
    yyaxis left;
    
    % Plot Time(h) vs elevation grade
    plot(data(2:end,1)/3600,elevations,'r')
    
    % Make graph neat
    ylim([-10 10])
    
    ylabel('Elevation Grade (%)')
    hold off;
end