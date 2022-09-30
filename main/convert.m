% converting table of lat-long positions
% into a list of northings and eastings coordinates
%By Hasaan Mohammad Farache

function [north, east] = convert(latitude, longitude)
    %the code above calls in the variable latitude, and longitude
    Long_Zone = 31 + floor(longitude ./ 6 );
    %the code above calculates the longitude zone
    Long_Zone_CM = (6 .* Long_Zone) - 183;
    %the code above calculates the longitude zone
    format long;
    %the code above changes the format into long, so more numbers appear
    Delta_Long = (longitude - Long_Zone_CM) .* (3600 / 10000);
    %the code above calculates the delta longitude
    Lat_Rad = latitude .* (pi/180);
    %the code above changes latitude into radians
    Long_Rad = longitude .* (pi/180);
    %the code above changes longitude into radians
    
    a = 6378137;
    b = 6356752.3142;
    f = 0.00335281066474748;
    f1 = 1/ f;
    mr = sqrt(a*b);
    e = sqrt(1 - (b / a) ^ 2);
    %the code above declares constants
    
    r_curv_1 = a * (1 - e ^ 2) ./ ((1 - (e .* sin(Lat_Rad)) .^ 2) .^ (3/2));
    r_curv_2 = a ./ ((1 - (e .* sin(Lat_Rad)) .^ 2) .^ (1/2));
    %the code above calculates curvature of the coordinate

    A0 = 6367449.146;
    B0 = 16038.42955;
    C0 = 16.83261333;
    D0 = 0.021984404;
    E0 = 0.000312705;
    %the code above declares constants

    Meridional_Arc_S = A0 .* Lat_Rad - B0 .* sin(2 .* Lat_Rad) + C0 .* sin(4 .* Lat_Rad) - D0 .* sin(6 .* Lat_Rad) + E0 .* sin(8 .* Lat_Rad);
    %the code above calculates the meridonal arc

    k0 = 0.9996;
    %the code above declares a constant

    Ki = Meridional_Arc_S .* k0;
    %the code above calculates Ki

    Sin1 = pi / (180*3600);
    %the code above declares a constant

    Kii = r_curv_2 .* sin(Lat_Rad) .* cos(Lat_Rad) .* (Sin1 ^ 2 * k0 * 100000000) / 2;
    %the code above calculates Kii

    e2 = e * e / (1 - e * e);
    %the code above declares a constant

    Kiii = ((Sin1 ^ 4 .* r_curv_2 .* sin(Lat_Rad) .* cos(Lat_Rad) .^ 3) ./ 24) .* (5 - tan(Lat_Rad) .^ 2 + 9 * e2 .* cos(Lat_Rad) .^ 2 + 4 * e2 ^ 2 .* cos(Lat_Rad) .^ 4) * k0 * (10000000000000000);
    %the code above calculates Kiii

    Kiv	= r_curv_2 .* cos(Lat_Rad) .* Sin1 * k0 * 10000;
    %the code above calculates Kiv

    Kv = (Sin1 .* cos(Lat_Rad)) .^ 3 .* (r_curv_2 ./ 6) .* (1 - tan(Lat_Rad) .^ 2 + e2 .* cos(Lat_Rad) .^ 2) * k0 * (1000000000000);
    %the code above calculates Kv

    Raw_Northing = (Ki + Kii .* Delta_Long .* Delta_Long + Kiii .* Delta_Long .^ 4);
    %the code above changes all the calculated variables into raw northing

    add_north = Raw_Northing + 10000000;
    %the code above declares a variable

    northing = add_north(Raw_Northing < 0);
    northing = Raw_Northing(Raw_Northing >= 0);
    %the code above calculates northing
    % adds 100000000 if raw northing is smaller than 0

    easting = 500000 + (Kiv .* Delta_Long + Kv .* Delta_Long .^ 3);
    %the code above calculates the easting by using the previously
    %calculated variables

    north = northing;
    east = easting;
    %the code above declares the output
end