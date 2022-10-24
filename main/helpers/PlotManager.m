% Simple Class that provides a method to save plots to a file
classdef PlotManager
    % Static methods are accessible without a reference to a specific
    % instance
    methods (Static)
        function Plot(plots_to_generate, data_table)
            % Loop through all the plots in the plot list
            for i = 1:length(plots_to_generate)
                % Get function handle to plotting method
                func_handle = plots_to_generate{i, 1};
                % Get matching filename
                filename = plots_to_generate{i, 2};
                % Save the plot
                PlotManager.save_plot(func_handle, filename, data_table)
            end
        end

        function save_plot(func, filename, args)
            func(args); % Invoke the plotting function passed by the function handle 'func'
            f = gcf; % Get access to the current graphics handle
            f.Position(3:4) = Settings.PlotDimension;

            exportgraphics(f,filename,'Resolution', Settings.PlotResolution); % save the graphics to a file
            if Settings.FriendlyInspect == true
                waitfor(f);
            end
            close all;
        end
    end

end