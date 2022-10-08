
data = get_data_from_file('data_sample_1.gpx');

function output = get_times(master_table)
    output = master_table(:, 1);
end
function output = get_coords(master_table)
    output = master_table(:, 2:3);
end
function output = get_elevations(master_table)
    output = master_table(:, 4);
end
function output = hasaan(master_table)
    output = master_table(:, 5);
end
