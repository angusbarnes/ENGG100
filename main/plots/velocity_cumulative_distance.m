% This file is assigned to: James Kirby
% This file was developed by: Jame Kirby, Ethan Mackay

% Plot velocity vs cumulative distance
function velocity_cumulative_distance(data)
    cumdis = cumsum(interval_distance(data, 1));
    velocities = calculate_velocities(data);

    % Distance (km) vs Velocity (kmh)
    plot(cumdis / 1000, velocities*3.6);
end