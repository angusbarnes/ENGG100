function table = create_master_table(results)

    % Preallocate for speed
    master_table = zeros(results.dataCount, 4);

    % Filter parsed XML tags for relevant information -> Provide handling
    % method to parse the contained data into matlab types
    times = results.filter('time', XMLParser.TIME_HANDLING_METHOD);
    elevations = results.filter('ele', XMLParser.NUMERICAL_HANDLING_METHOD);
    coords = convert(results.filter('coords', XMLParser.COORDINATE_HANDLING_METHOD));
    
    % Insert collected values into a master table
    % | Time (s) | Northing (m) | Easting (m) | Elevation (m) |
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
    table = output_table(1:insertIndex, :);

end