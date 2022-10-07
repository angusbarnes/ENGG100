function table = get_data_from_file(filename)
    gpxParser = XMLParser(filename);
    results = gpxParser.Parse();
    
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
    velocity = hasaan(master_table(:,1), master_table(:,3),  master_table(:,2), master_table(:,4));
    master_table(:,5) = velocity;
    master_table(:,1) = times;
    master_table(:,2:3) = coords;
    master_table(:,4) = elevations;

    table = master_table;

end

