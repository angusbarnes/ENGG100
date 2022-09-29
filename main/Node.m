classdef Node
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        ChildNodes = [];
    end
    
    methods
        function obj = Node(name)
            %NODE Construct an instance of this class
            %   Detailed explanation goes here
            obj.Name = name;
        end

        function string = str(obj)
            string = obj.Name;
        end
    end
end

