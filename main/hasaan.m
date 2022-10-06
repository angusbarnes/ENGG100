% This file is assigned to: Hasaan
% This code does..... FILL IN DESCRIPTION HERE

% data is a matrix of all data
% There are 6 columns, only the first 4 are important
% The columns (in order) contain:
% Time (seconds) | Northing | Easting | Elevation (m)

data = get_data_from_file('data_sample_1.gpx');


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