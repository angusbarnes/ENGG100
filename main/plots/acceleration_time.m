% File Was Assigned To: Ritankar Biswanghri
% File Was Developed By: Ritankar Biswanghri
% Integrated and Edited By: Angus Barnes

function acceleration_time(data)
    % Create the tangential acceleration vs time graph
    
    % Calculate velocities across ride without including elevation changes
    % - as specified in the project spec for challenge problem 1
    distances = interval_distance(data, 0);
    times = interval_time(data);
    velocity = distances./times;
    
    % Acceleration varies rapidly as riding is an oscillating activity. Any
    % time the foot in no pushing on the pedal there will be deceleration.
    % Coupled with the GPS noise, this graph looked like pure noise. Taking
    % every 5th data point makes this graph presentable and interperatable.
    
    % Get the differences in consecutive velocity magnitudes
    velocity_deltas = velocity(1:5:end) - circshift(velocity(1:5:end), 1);
    
    % Fix the error causes by circshift for the first value
    velocity_deltas(1) = velocity (1);

    % Acceleration = dv/dt
    acceleration = velocity_deltas ./ times(1:5:end);

    % Plot with some further smoothing applied
    plot(data(1:5:end,1)/3600,movmean(acceleration, Settings.GentleSmooth()));
    title("Graph of Tangential Acceleration")
    ylabel('Tangential Acceleration (m/s^2)')
    xlabel('Time (h)')
end