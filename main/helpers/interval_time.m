function times = interval_time(data)
    time = data(:,1);
    time = time - circshift(time, 1);

    times = time(2:end);
end