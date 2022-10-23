
data = get_data_from_file("data/data_sample_1.gpx");
% | Time | Northing | Easting | Elevation |

distances = interval_distance(data, 0);
% Distances between consecutive points