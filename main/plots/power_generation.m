% This file is assigned to: Angus Barnes
% This file was developed by: Angus Barnes

% Generate plot for challenge problem 2
function power_generation(data)
    
    distances = interval_distance(data, 0);
    elevations = data(:, 4);
    elevations = elevations - circshift(elevations, 1);
    elevation_grade = elevations(2:end)./distances;
    elevation_grade(isnan(elevation_grade)) = 0;
    
    velocities = calculate_velocities(data);
    
    % Perform calculatiosn descibed by: https://www.omnicalculator.com/sports/cycling-wattage
    Fg=9.81*sin(atan(elevation_grade))*(70+8);
    Fr=9.81*cos(atan(elevation_grade))*(70+8)*0.0020;
    Fa=0.5*0.408*1.225*(velocities).^2;
    
    power = (Fa + Fg + Fr) .* (velocities / (1 - 0.045));
    
    hold on
    plot(data(2:end, 1)/3600, movmean(power,Settings.AggressiveSmooth()));
    
    % Plot a line for power across the whole ride. Since Wattage is a
    % rate, taking an average over the whole data set will give teh wattage
    % for the whole ride
    yline(mean(power), Color=[1 0 0]);
    title("Power Generation of Ride")
    legend('Instantaneous Power Generation (W)', 'Total Power Generation for Ride (W)', Location='southoutside')
    xlabel("Time (h)")
    ylabel("Power (W)")
    hold off
end