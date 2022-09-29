% The main data file parser.
% Will read GPX file into usable format
% Assigned to: Angus B
classdef XMLParser

   properties
      Value {mustBeNumeric}
   end
   methods
      function r = roundOff(obj)
         r = round([obj.Value],2);
      end
      
      function r = multiplyBy(obj,n)
         r = [obj.Value]*n;
      end
   end

end
