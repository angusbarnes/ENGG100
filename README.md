# ENGG100

This repository contains code for a first year programming project at university. The subject was meant to familiarise us with programming fundamentals and for some reason they chose MATLAB for this task.

The objective was to read an XML file generated by [Strava](https://www.strava.com/) and interperate the contained information to create various 3D and 2D spatial and kinematics plots to describe various aspects of the ride.

The cruel twist was that we were not allowed to use any of the in-built MATLAB library functions for reading files and manipulating data (Which are literally the only reason someone would choose to write MATLAB in the first place). This resulted in an absolute mess of a project as we fought with this restriction. By far the most impressive part of this project is the semi-generalised XML parser that 'we' (@angusbarnes) built from the ground up. At the time of development, the custom XML parser was able to outperform MATLAB's in-built parser, despite ours being written in MATLAB and MATLAB's being written in C (Go figure... MathWorks tools are painfully slow). This parser was able to be used to read any XML files, requiring only minor tweaks depending on expected data types.

We received a High Distinction for this project and an indicated mark of 95/100. It is worth noting that the only marks lost were on the reporting element of the task, whilst the programming aspect received full marks.

I would never wish the pain of developing a MATLAB code base with a team of inexperienced coders on anyone. The combination of MATLAB's questionable language design coupled with first year naivety led to the perfect storm of confusion and bugs.
