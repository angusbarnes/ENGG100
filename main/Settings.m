classdef Settings
    
    % These can be changed to change the behaviour of the overall program
    properties (Constant)
        % Enable/Disable Friendly Inspection Mode. This will cause each
        % plot to be displayed until it is manually closed, at which point
        % the code will proceed to generate the next graph.
        FriendlyInspect = false;

        % Smoothing Settings. Some plots use these to make the graphs more
        % readable and reduce noise. 
        EnableSmoothing = true; % Apply smoothing at all: true/false
        AggressiveSmoothingFactor = 12; % How much smoothing for extreme cases: 1-20
        GentleSmoothingFactor = 6; % How much smoothing for mild cases: 1-20
        
        % Plot export settings
        PlotResolution = 300;
        PlotDimension = [450, 300];
    end

    methods (Static)
        function smoothFactor = GentleSmooth()
            if Settings.EnableSmoothing
                smoothFactor = Settings.GentleSmoothingFactor;
            else
                smoothFactor = 1;
            end
        end

        function smoothFactor = AggressiveSmooth()
            if Settings.EnableSmoothing
                smoothFactor = Settings.AggressiveSmoothingFactor;
            else
                smoothFactor = 1;
            end
        end
    end

end