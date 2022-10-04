% This is the main high level submission file
% We are allowed up to 10 LOC for this file
% This ensures we split code effectively between
% other external files
persistantDataPath = pwd + "\..\data\";
%filename = persistantDataPath + input('Data File Name');
tic
test = XMLParser('data_sample_2.gpx');
result = test.Parse();

nodes = result.nodes;

% for i = 1:length(nodes)
%     value = nodes(i).Name;
%     if strcmp(value, "time")
%         disp(str(nodes(i+1)))
%     elseif strcmp(value, "ele")
%         disp(str(nodes(i+1)))
%     elseif strcmp(value, "trkseg")
%         disp(str(nodes(i+1)))
%     end
% end

% Get time in seconds since hourly UTC Epoch
times = result.filter('time', XMLParser.TIME_HANDLING_METHOD);

% Get elevations in meters above see level
elevations = result.filter('ele', XMLParser.NUMERICAL_HANDLING_METHOD);
disp(times)
disp(elevations)