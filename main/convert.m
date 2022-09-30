% converting table of lat-long positions
% into a list of northings and eastings coordinates
%By Hasaan Mohammad Farache

function [north, east] = convert(latitude, longitude)
    Long_Zone = 31 + floor(longitude ./ 6 );
    Long_Zone_CM = (6 .* Long_Zone) - 183;
    format long;
    Delta_Long = (longitude - Long_Zone_CM) .* (3600 / 10000);
    Lat_Rad = latitude .* (pi/180);
    Long_Rad = longitude .* (pi/180);
    
    a = 6378137;
    b = 6356752.3142;
    f = 0.00335281066474748;
    f1 = 1/ f;
    mr = sqrt(a*b);
    e = sqrt(1 - (b / a) ^ 2);

    
    r_curv_1 = a * (1 - e ^ 2) ./ ((1 - (e .* sin(Lat_Rad)) .^ 2) .^ (3/2));
    r_curv_2 = a ./ ((1 - (e .* sin(Lat_Rad)) .^ 2) .^ (1/2));
    
    A0 = 6367449.146;
    B0 = 16038.42955;
    C0 = 16.83261333;
    D0 = 0.021984404;
    E0 = 0.000312705;

    Meridional_Arc_S = A0 .* Lat_Rad - B0 .* sin(2 .* Lat_Rad) + C0 .* sin(4 .* Lat_Rad) - D0 .* sin(6 .* Lat_Rad) + E0 .* sin(8 .* Lat_Rad);
    
    k0 = 0.9996;
    
    Ki = Meridional_Arc_S .* k0;
    
    Sin1 = pi / (180*3600);

    Kii = r_curv_2 .* sin(Lat_Rad) .* cos(Lat_Rad) .* (Sin1 ^ 2 * k0 * 100000000) / 2;
    e2 = e * e / (1 - e * e);

    Kiii = ((Sin1 ^ 4 .* r_curv_2 .* sin(Lat_Rad) .* cos(Lat_Rad) .^ 3) ./ 24) .* (5 - tan(Lat_Rad) .^ 2 + 9 * e2 .* cos(Lat_Rad) .^ 2 + 4 * e2 ^ 2 .* cos(Lat_Rad) .^ 4) * k0 * (10000000000000000);
    Kiv	= r_curv_2 .* cos(Lat_Rad) .* Sin1 * k0 * 10000;
    Kv = (Sin1 .* cos(Lat_Rad)) .^ 3 .* (r_curv_2 ./ 6) .* (1 - tan(Lat_Rad) .^ 2 + e2 .* cos(Lat_Rad) .^ 2) * k0 * (1000000000000);
    Raw_Northing = (Ki + Kii .* Delta_Long .* Delta_Long + Kiii .* Delta_Long .^ 4);
    
    add_north = Raw_Northing + 10000000;
    northing = add_north(Raw_Northing < 0);
    northing = Raw_Northing(Raw_Northing >= 0);
  
    easting = 500000 + (Kiv .* Delta_Long + Kv .* Delta_Long .^ 3);
    north = northing;
    east = easting;
    
end