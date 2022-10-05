% This file is assigned to: Ethan
% This code does..... FILL IN DESCRIPTION HERE

data = get_data_from_file('data_sample_1.gpx');


% LEAVE THESE AT THE BOTTOM OF YOUR FILE
% DONT WORRY ABOUT CHANGING THEM
function output = get_times(master_table)
    output = master_table(:, 1);
end

function output = get_coords(master_table)
    output = master_table(:, 2:3);
end

function output = get_elevations(master_table)
    output = master_table(:, 4);
end