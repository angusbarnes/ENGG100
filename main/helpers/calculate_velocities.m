% This file is assigned to: Angus Barnes
% This file was developed by: Angus Barnes, Hasaan Farache
function velocities = calculate_velocities(data)
    times = interval_time(data);
    distances = interval_distance(data,true);
    velocities = distances ./ times;
end