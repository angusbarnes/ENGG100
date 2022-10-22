function cumulative_distance_time(data)
    distance = cumsum(interval_distance(data, 1));
    time = data(2:end, 1);

    plot(time/3600, distance/1000);
end