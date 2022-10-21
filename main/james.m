% This file is assigned to: James
% This code does..... FILL IN DESCRIPTION HERE

% data is a matrix of all data
% There are 6 columns, only the first 4 are important
% The columns (in order) contain:
% Time (seconds) | Northing (y) | Easting (x) | Elevation (m)

%dataArray = get_data_from_file('data_sample_1.gpx'); %Get and generate array from stored data

function vel = test(dataArray)   %Generate function and input the array to pull from
    dataArray = get_data_from_file('data_sample_1.gpx'); %Get and generate array from stored data
    ti = dataArray(1:1027,1);           %Put all time values into their own array for ease of use
    No = dataArray(1:1027,2);           %Put all Northing values into their own array for ease of use
    Ea = dataArray(1:1027,3);           %Put all Easting values into their own array for ease of use
    El = dataArray(1:1027,4);           %Put all Elevation values into their own array for ease of use
    
    tiHours = (ti) ./ (3600);  %Convert seconds to hours for km/h notation

    EaShifted = circshift(Ea, -1);    %Using Circshift function, create a new array by shifting every value in Eastings to the left by one. This will allow for easy difference calculations, and a circular shift will wrap the first value back around.
    EaDifference = Ea - EaShifted;    %Subtract the two arrays to get a absolute difference between each element

    NoShifted = circshift(No, -1);    %Using Circshift function, create a new array by shifting every value in Northings to the left by one. This will allow for easy difference calculations, and a circular shift will wrap the first value back around.
    NoDifference = No - NoShifted;    %Subtract the two arrays to get a absolute difference between each element
    
    ElShifted = circshift(El, -1);    %Using Circshift function, create a new array by shifting every value in Elevation to the left by one. This will allow for easy difference calculations, and a circular shift will wrap the first value back around.
    ElDifference = El - ElShifted;    %Subtract the two arrays to get a absolute difference between each element

    xyDifference = sqrt((NoDifference .^ 2) + (EaDifference .^ 2));   %Apply RHT Trigonometry to determine the 
    xyzDifference = (sqrt((xyDifference .^ 2) + (ElDifference .^ 2))) ./ 1000;  %Same as before, but also converting to km in the same step

    %for i:length(xyzDifference)

    cuDistance = cumsum(xyzDifference)   %Sum all values between points to get a total distance


    vel = xyzDifference ./ tiHours;    %Generate an array of values of the distance between points in three axis and time
    vel(length(Ea)) = 0;        %Make the last value of velocity equal to zero
       
    plot(cuDistance, vel), title('Velocity (km/h) over Cumulative Distance (km)'), xlabel('Cumulative Distance (km)'), ylabel('Velocity (km/h)');

end


% LEAVE THESE AT THE BOTTOM OF YOUR FILE
% DONT WORRY ABOUT CHANGING THEM
%function output = get_times(master_table)
%    output = master_table(:, 1);
%end

% RETURNS A 2 COLUMN LIST OF Northing | Easting pairs
%function output = get_coords(master_table)
%    output = master_table(:, 2:3);
%end

%function output = get_elevations(master_table)
%    output = master_table(:, 4);
%end