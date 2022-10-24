% Provides a simple interface for adding and remocing plotting functions to
% save to file. List is a cell array of function_handle and filename
% pairings
function list = get_plot_list() 
    list = {
                @velocity_cumulative_distance, "graphs_output/VelocityCumulativeDistance.png" ; 
                @spatial_plot, "graphs_output/3dPlot.png";
                @acceleration_time, "graphs_output/AccelerationTime.png"; 
                @cumulative_distance_time, "graphs_output/CumulativeDistanceTime.png";
                @elevation_time, "graphs_output/ElevationTime.png";
                @power_generation, "graphs_output/PowerGeneration.png";
                @velocity_time, "graphs_output/VelocityTime.png"
            };
end