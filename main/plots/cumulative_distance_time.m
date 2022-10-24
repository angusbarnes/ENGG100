% This File Was Assigned To: James Kirby
% This File Was Developed By: James Kirby

% Generate the Cumulative distance vs time graph
function cumulative_distance_time(data)
    distance = cumsum(interval_distance(data, 1));
    
    % The first time value is a reference and so this array is larger than
    % the cumulative distance array. Simply disregard this reference value
    % to make arrays the same shape
    time = data(2:end, 1);

    plot(time/3600, distance/1000);
    title("Cumulative Distance VS. Time")
    xlabel("Time (h)")
    ylabel("Cumulative Distance (m)")
end