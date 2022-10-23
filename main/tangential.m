% %Question6%

%Define variables%

Easting = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]; %m

Northing = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]; %m

t = 0:0.1:5; %s

 

%Calculate acceleration%

a_tangential = ((Easting.^2+Northing.^2).^(1/2))./t; %m/s^2

 

%Plotting%

plot(t,a_tangential)

xlabel('Time (s)')

ylabel('Tangential Acceleration (m/s^2)')

title('Tangential Acceleration vs. Time')

axis([0 5 0 5])

grid on

 

% %Challenge Problem 2% %

% %Generate a radial acceleration (m/s²) vs. time graph. Also include this graph in your report.% %

% % Base the acceleration on Easting and Northing coordinates only.% %

 

%Define variables%

Easting = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]; %m

Northing = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]; %m

t = 0:0.1:5; %s


%Calculate acceleration%

a_radial = -((Easting.^2+Northing.^2).^(1/2))./t.^2; %m/s^2

 

%Plotting%

plot(t,a_radial)

xlabel('Time (s)')

ylabel('Radial Acceleration (m/s^2)')

title('Radial Acceleration vs. Time')

axis([0 5 -5 0])

grid on

 

% %Challenge Problem 3% %

% %Generate a radial and tangential acceleration (m/s²) vs. time graph. Also include this graph in your report.% %

% % Base the acceleration on Easting and Northing coordinates only.% %

 

%Define variables%

Easting = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]; %m

Northing = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]; %m

t = 0:0.1:5; %s

 

%Calculate acceleration%

a_tangential = ((Easting.^2+Northing.^2).^(1/2))./t; %m/s^2

a_radial = -((Easting.^2+Northing.^2).^(1/2))./t.^2; %m/s^2

 

%Plotting%

plot(t,a_tangential,t,a_radial)

xlabel('Time (s)')

ylabel('Acceleration (m/s^2)')

title('Radial and Tangential Acceleration vs. Time')

legend('Tangential Acceleration','Radial Acceleration')

axis([0 5 -5 5])

grid on
