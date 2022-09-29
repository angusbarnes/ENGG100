% The main data file parser.
% Will read GPX file into usable format
% Assigned to: Angus B
classdef XMLParser
   properties
      filename
   end
   methods
       function obj = XMLParser(filename)
           obj.filename = filename;
       end

       function tree = Parse(obj)
           tree = {"Test": 33};
       end
   end
end
