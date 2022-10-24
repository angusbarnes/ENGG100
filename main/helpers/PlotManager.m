classdef PlotManager

    methods (Static)
        function Plot(plots_to_generate, data_table)
            for i = 1:length(plots_to_generate)
                func_handle = plots_to_generate{i, 1};
                filename = plots_to_generate{i, 2};
                PlotManager.save_plot(func_handle, filename, data_table)
            end
        end

        function save_plot(func, filename, args)
            func(args); % Invoke the plotting function passed by the function handle 'func'
            f = gcf; % Get access to the current graphics handle
            exportgraphics(f,filename,'Resolution',600); % save the graphics to a file
            close all;
        end
    end

end