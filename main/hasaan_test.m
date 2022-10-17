
data = get_data_from_file('data_sample_1.gpx');

speed = velocity(data);
data(:,5) = speed;

