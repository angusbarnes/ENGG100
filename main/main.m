% This is the main high level submission file
% We are allowed up to 10 LOC for this file
% This ensures we split code effectively between
% other external files

%filename = persistantDataPath + input('Data File Name');
gpxParser = XMLParser('data_sample_1.gpx');
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

master_table(:,1) = times;
master_table(:,2:3) = coords;
master_table(:,4) = elevations;

velocity(master_table)
f = gcf;
exportgraphics(f,'barchart.png','Resolution',300)

save_plot(@()velocity(master_table), "testexport.png")

function save_plot(func, filename)
    func()
    f = gcf;
    exportgraphics(f,filename,'Resolution',300)
end