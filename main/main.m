% Add the folder containing helper functions to the MATLAB envrionement at
% runtime. This helps to keep the file tree clean and prevented environment
% naming clashes in the prototyping stage of this project
addpath(genpath('helpers'))
addpath(genpath('plots'))

% The data samples recorded by our group are located in the data
% sub-directory. To access them you need to provide the full relative path
% eg; data/data_sample_1.gpx
% THIS MUST BE WRAPPED IN QUOTES WHEN INPUT TO TERMINAL
filename = input('Relative Path To Data File: ');

% ===> THIS IS NOT A MATLAB BUILT IN <=== %
% We wrote the XMLParser class from scratch using only two low level IO
% functions. You can view this Parser Class in the file hierarchy at: 
% ---> helpers/XMLParser.m 
results = XMLParser(filename).Parse();
table = create_master_table(results);

PlotManager.Plot(get_plot_list(), table)
clear;