% This file is assigned to: Angus N
% This code does..... FILL IN DESCRIPTION HERE

% data is a matrix of all data
% There are 6 columns, only the first 4 are important
% The columns (in order) contain:
% Time (seconds) | Northing (y) | Easting (x) | Elevation (m)

%dataArray = get_data_from_file('data_sample_1.gpx'); %Get and generate array from stored data


function A = angusn(dataArray)   %Generate function and input the array to pull from
    dataArray = get_data_from_file('data_sample_1.gpx'); %Get and generate array from stored data
    ti = dataArray(1:end-1,1);           %Put all time values into their own array for ease of use
    No = dataArray(1:end-1,2);           %Put all Northing values into their own array for ease of use
    Ea = dataArray(1:end-1,3);           %Put all Easting values into their own array for ease of use
    El = dataArray(1:end-1,4);           %Put all Elevation values into their own array for ease of use
    

    EaShift = circshift(Ea, -1);    %Using Circshift function, create a new array by shifting every value in Eastings to the left by one. This will allow for easy difference calculations, and a circular shift will wrap the first value back around.
    EaDiff = Ea - EaShift -150.8973540;    %Subtract the two arrays to get a absolute difference between each element

    NoShift = circshift(No, -1);    %Using Circshift function, create a new array by shifting every value in Northings to the left by one. This will allow for easy difference calculations, and a circular shift will wrap the first value back around.
    NoDiff = No - NoShift +34.4174800;    %Subtract the two arrays to get a absolute difference between each element
    
    ElShift = circshift(El, -1);    %Using Circshift function, create a new array by shifting every value in Elevation to the left by one. This will allow for easy difference calculations, and a circular shift will wrap the first value back around.
    ElDiff = El - ElShift +43.0;    %Subtract the two arrays to get a absolute difference between each element

 
    
    Easting= EaDiff./ ti;
    Northing= NoDiff./ ti;
    Elevation= ElDiff ./ ti;
       
    plot3(Easting, Northing, Elevation), title('Easting (km) over Northing(km) over Elevation(m)'), xlabel('Easting (km)'), ylabel('Northing (km)'), zlabel('Elevation (m)');

end