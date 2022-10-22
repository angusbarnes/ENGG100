% This is the main high level submission file
% We are allowed up to 10 LOC for this file
% This ensures we split code effectively between
% other external files
addpath(genpath('helpers'))
%filename = persistantDataPath + input('Data File Name');
gpxParser = XMLParser('data/data_sample_1.gpx');
results = gpxParser.Parse();

% Ethan is sample 1?

% Get time in seconds since hourly UTC Epoch
% This would not handle rides that exceed 24 hours in length.
% The first time is read from the metadata tag of the GPX file
% This function returns all results as time elapsed in seconds since
% that reference point.
% Because of how GPS technologies tend to 'stabilise' as connected duration
% increases, the initial time stamps may have repeated times
master_table = zeros(results.dataCount, 6);

times = results.filter('time', XMLParser.TIME_HANDLING_METHOD);

% Get elevations in meters above see level
% The generic NUMERICAL HANDLING METHOD will attempt to parse any number
% stored inside the request tag name
elevations = results.filter('ele', XMLParser.NUMERICAL_HANDLING_METHOD);

coords = convert(results.filter('coords', XMLParser.COORDINATE_HANDLING_METHOD));

master_table(:,1) = times;
master_table(:,2:3) = coords;
master_table(:,4) = elevations;

previous_time = -1;
output_table = zeros(size(master_table));
insertIndex = 0;
for row = 1:length(master_table)
    time = master_table(row, 1);
    
         
    if time > previous_time
        insertIndex = insertIndex+1;
        previous_time = time;
    elseif time < previous_time
        disp("There is a notable data consistency issue.")
        disp("The provided file contains timestamps that go backwards in time")
    end

    output_table(insertIndex,:) = master_table(row, :);
end

% Truncate the the filtered table to remove trailing zeros made with
% pre-allocation
output_table = output_table(1:insertIndex, :);

distances = interval_distance(output_table, 1);
times = interval_time(output_table);
vels = calculate_velocities(output_table);
cums = cumsum(interval_distance(output_table, true));
velocity_cumulative_distance(output_table);

function save_plot(func, filename)
    func(); % Invoke the plotting function passed by the function handle 'func'
    f = gcf; % Get access to the current graphics handle
    exportgraphics(f,filename,'Resolution',600); % save the graphics to a file
end