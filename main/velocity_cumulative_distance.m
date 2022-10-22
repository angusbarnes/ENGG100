% This file is assigned to: James
% This code does..... FILL IN DESCRIPTION HERE

function velocity_cumulative_distance(data)   %Generate function and input the array to pull from
    cumdis = cumsum(interval_distance(data, 1));
    velocities = calculate_velocities(data);
    plot(cumdis / 1000, velocities*3.6);
end