% This File Was Assigned To: Angus Barnes
% This File Was Developed By: Angus Barnes
% This file abstracts the creation a master data table to simplify top
% level routine

function table = create_master_table(results)

    % Preallocate for speed. The master table will contain all important
    % information recorded from the GPX files including Time, Northing,
    % Easting and Elevation
    master_table = zeros(results.dataCount, 4);

    % Filter through all parsed XML tags for relevant information -> Provide handling
    % method to parse the contained data into matlab types
    % The filter API is provided in the XMLParser class found in
    % helpers/XMLParser.m
    % The filter routine simply returns a list of values contained within
    % the specified tag types
    times = results.filter('time', XMLParser.TIME_HANDLING_METHOD);
    elevations = results.filter('ele', XMLParser.NUMERICAL_HANDLING_METHOD);
    coords = convert(results.filter('coords', XMLParser.COORDINATE_HANDLING_METHOD));
    
    % Insert collected values into a master table
    % | Time (s) | Northing (m) | Easting (m) | Elevation (m) |
    master_table(:,1) = times;
    master_table(:,2:3) = coords;
    master_table(:,4) = elevations;
    
    % If there is multiple location values for the same point in time,
    % filter out these and keep only the latest position value for that
    % point in time. It gets a bit ugly but it does the job
    previous_time = -1;
    output_table = zeros(size(master_table)); % Preacllocate new table
    insertIndex = 0;

    for row = 1:length(master_table)
        
        time = master_table(row, 1);  

        % If the time exceeds the previous time, good news this is not a
        % repeated point, increase the insert index. If the time is the
        % same, the insert index will not change and this new duplicate
        % time point will be inserted over the top of the old one in the
        % output table
        if time > previous_time
            insertIndex = insertIndex+1;
            previous_time = time;
        elseif time < previous_time
            % Error checking
            disp("There is a notable data consistency issue.")
            disp("The provided file contains timestamps that go backwards in time")
        end
        
        % Copy row to output
        output_table(insertIndex,:) = master_table(row, :);
    end
    
    % Truncate the the filtered table to remove trailing zeros made with
    % pre-allocation
    table = output_table(1:insertIndex, :);

end