function power_generation(data)
    
    distances = interval_distance(data, 0);
    elevations = data(:, 4);
    elevations = elevations - circshift(elevations, 1);
    elevation_grade = elevations(2:end)./distances;
    elevation_grade(isnan(elevation_grade)) = 0;
    
    velocities = calculate_velocities(data);
    
    Fg=9.81*sin(atan(elevation_grade))*(70+8);
    
    
    Fr=9.81*cos(atan(elevation_grade))*(70+8)*0.0020;
    
    Fa=0.5*0.408*1.225*(velocities).^2;
    
    power = (Fa + Fg + Fr) .* (velocities / (1 - 0.045));
    
    hold on
    plot(data(2:end, 1)/3600, movmean(power,10));
    
    yline(mean(power), Color=[1 0 0]);
    disp(mean(power))
    hold off
end