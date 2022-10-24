% This File Was Assigned To: Angus Barnes
% This File Was Developed By: Angus Barnes
% This file provides a custom Node data type which is used in the
% generalised parser implementation

classdef Node
  
    properties
        Name
        ChildNodes = [];
    end
    
    methods
        function obj = Node(name)
            % Construct an instance of this class
            obj.Name = name;
        end
        
        % Override the class object's default implicit conversion operator
        function string = str(obj)
            string = obj.Name;
        end
    end
end

