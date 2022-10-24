% This file was developed by collating various group member's code and
% integrating them for efficiency
% Developers: Angus Barnes, Ethan McKay, James Kirby
% Edited By: Angus Barnes

function times = interval_time(data)
    % Get intervals between each time point in list of times
    time = data(:,1);
    time = time - circshift(time, 1);
    times = time(2:end);
end