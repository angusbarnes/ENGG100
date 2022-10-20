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
% it sets out the matrices

Time = data(:,1);
North = data(:,2);
East = data(:,3);
Elev = data(1:1027,4);

ComCoords = [North East]; %Combining Coordinates

distances = [];   % This calculates the difference in each coordinate
for i = 2:1028    % It exports it in an array 
     d1 = ComCoords(i,:);
     d2 = ComCoords(i-1,:);
    D3 = norm(d1-d2);
    distances(end+1) = D3;
end

% to find the cumulative distance of the whole ride
B = cumsum(distances);
B(1,1027)     % final value for combined distance in x y plane.

% this inputs the data into a (2,1027) matrix with difference in
% coordinates and also the elevation.
distances = distances';
Grade = [distances Elev];

angleofelevation = [];   % this section calcualtes the angle of elevation or grade between
for k = 1:1027  % each coordinate.
    E1 = Grade(k,1);
    E2 = Grade(k,2);
    Egrade = atan(E2/E1);
    angleofelevation(end+1) = Egrade;
end

% plotting the elevation grade vs tInterval
TimeInterval = 1:1027;
plot(TimeInterval,angleofelevation,'r')

title('Elevation grade')
xlabel('Time interval')
ylabel('Angle of Elevation')
xlim([0 1027])
  


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