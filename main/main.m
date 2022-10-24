
% NOTICE: There is a Settings.m file in this directory that has some
% settings which can be tweaked. They have been initialised to values we
% determined to be optimal. If needed, enabling the 
% Settings.FriendlyInspect option will pause the program after every plot
% is shown to allow for direct interaction with the plot. Once the plot is
% closed, the program will then proceed. MATLAB Will need to restarted
% before running the program to avoid it freezing. This is not a bug with
% our code but rather MATLAB's horrific implementation of code caching and
% object instantiation.

% Add the folder containing helper functions to the MATLAB envrionement at
% runtime. This helps to keep the file tree clean and prevented environment
% naming clashes in the prototyping stage of this project
addpath(genpath('helpers'))
addpath(genpath('plots'))

% The data samples recorded by our group are located in the data
% sub-directory. To access them you need to provide the full relative path
% eg; "data/ride_1.gpx"
% THIS MUST BE WRAPPED IN QUOTES WHEN INPUT TO TERMINAL
filename = input('Relative Path To Data File: ');

% ===> THIS IS NOT A MATLAB BUILT IN <=== %
% We wrote the XMLParser class from scratch using only two low level IO
% functions. You can view this Parser Class in the file hierarchy at: 
% ---> helpers/XMLParser.m 
results = XMLParser(filename).Parse();
table = create_master_table(results);

% Run and save outputs from all plotting functions as detailed in the
% 'get_plot_list.m' file
PlotManager.Plot(get_plot_list(), table)
clear all; % Clean up mess left behind by plotting functions in memory