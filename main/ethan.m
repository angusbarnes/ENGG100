% This file is assigned to: Ethan
% This code creates two plots on one graph
% Create plot for elevation over time and elevation grade over time

% data is a matrix of all data
% There are 6 columns, only the first 4 are important
% The columns (in order) contain:
% Time (seconds) | Northing,(lat) (y) | Easting,(long) (x) | Elevation (m)

data = get_data_from_file('data_sample_1.gpx');

x1 = data(:,1);
y1 = data(:,2);
% this is for the first part

Time = data(:,1);
North = data(:,2);
East = data(:,3);
elevation = data(:,4);

for i = 1:(North)
    for j = 1:(East)
distance = cumsum(sqrt( diff(East).^2+diff(North).^2));
    end
end



% LEAVE THESE AT THE BOTTOM OF YOUR FILE
% DONT WORRY ABOUT CHANGING THEM
function output = get_times(master_table)
    output = master_table(:, 1);
end

% RETURNS A 2 COLUMN LIST OF Northing | Easting pairs
function output = get_coords(master_table)
    output = master_table(:, 2:3);
end

function output = get_elevations(master_table)
    output = master_table(:, 4);
end