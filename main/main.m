% Add the folder containing helper functions to the MATLAB envrionement at
% runtime
addpath(genpath('helpers'))

% The data samples recorded by our group are located in the data
% sub-directory. To access them you need to provide the full relative path
% eg; data/data_sample_1.gpx
% THIS MUST BE WRAPPED IN QUOTES WHEN INPUT TO TERMINAL
filename = input('Relative Path To Data File: ');

% THIS IS NOT A MATLAB BUILT IN
% We wrote the XMLParser class from scratch using only two low level IO
% functions. You can view this Parser Class in the file hierarchy at: 
% ---> helpers/XMLParser.m 
gpxParser = XMLParser(filename);
results = gpxParser.Parse();

master_table = create_master_table(results);

power_generation(master_table);

function save_plot(func, filename)
    func(); % Invoke the plotting function passed by the function handle 'func'
    f = gcf; % Get access to the current graphics handle
    exportgraphics(f,filename,'Resolution',600); % save the graphics to a file
end