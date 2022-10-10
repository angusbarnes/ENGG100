
data = get_data_from_file('data_sample_1.gpx');

velocity = hasaan(data);
data(:,5) = velocity;

