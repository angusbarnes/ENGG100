% The main data file parser.
% Will read GPX file into usable format
% Assigned to: Angus B

% Use standard linear file parser pattern
% Should be content agnostic
% Handling specific fields can be done down the line
% This parser should be able to handle any XML file
classdef XMLParser
    % Class variables
    properties
        filename
        nodes = [Node("ROOT")]
    end
    properties (Access = protected)
        currentChar char
        collectedNode Node
        chars
        index {mustBeNumeric} = 0
        EOF {mustBeNumeric}
        
        expr = blanks(XMLParser.TOKEN_MAX_LENGTH)
        exprIndex = 1

        nodeIndex = 1
    end

    properties (Constant)
        TOKEN_MAX_LENGTH = 2000;
        TIME_HANDLING_METHOD = 'TIME_FORMAT';
        COORDINATE_HANDLING_METHOD = 'COORD';
        NUMERICAL_HANDLING_METHOD = 'NUMBER';
        DO_NOT_FORMAT = 'NULL_FORMAT';
    end
    methods
        function obj = XMLParser(filename)
            obj.filename = filename;
        end
        
        % The structure should be a tree
        % This can be implemented using a cell array of
        % custom Node data types.
        % A Nodes can reference other subnodes or be a single value
        function obj = Parse(obj)
            fileHandle = fopen(obj.filename, 'r');
            
            % Soft error on invalid Fid and return a null node
            if fileHandle == -1
                disp('Invalid File Name Provided To Parser')
                tree = {};
                return
            end
            
            % Read all chars to EOF marker
            obj.chars = fread(fileHandle);
            obj.EOF = length(obj.chars);
            
            % We must advance the read head to the first character
            % before looping
            obj = obj.Advance(); 
            
            % Like most things, MATLAB has a very poor implementation 
            % of class objects. Some instance reassignment is required
            % to self reference class values internally. We cannot
            % modify instance values in-place
            % TLDR: There be demons ahead
            while obj.index <= length(obj.chars)
                if obj.currentChar == '<'
                    obj = obj.EndExpression();
                    obj = obj.CollectNode('>');
%                     disp(str(obj.collectedNode))
                elseif obj.currentChar ~= ""
                    obj.expr(obj.exprIndex) = obj.currentChar;
                    obj.exprIndex = obj.exprIndex + 1;
                end
                obj = obj.Advance();
            end
        end

        function obj = CollectNode(obj, delimiter)

            % Uses slightly more memory than necessary but massively
            % improves parser speed. Dynamic vector allocation
            % is slow. This pre-allocates 2000 bytes of memory
            % for the tag data which should never causes RAM
            % limit issues on modern machines
            % Measured speed improvement of ~200%
            tagData = blanks(XMLParser.TOKEN_MAX_LENGTH);

            obj = obj.Advance(); % Skip opening delimeter
            
            i = 1;
            while obj.currentChar ~= delimiter
                % The list will dynamically extend if necessary
                % TOKEN_MAX_LENGTH is therefore a soft limit
                
                % If there is arguments in this XML tag, collec them
                % and insert them as new nodes in the output
                 if obj.currentChar == '"'
                    obj = obj.CollectNode('"');
                    obj = obj.Advance();
                 else
                    tagData(i) = obj.currentChar; 
                    i = i + 1;
                    obj = obj.Advance();
                 end
            end

            % The Pre-allocation causes trailing whitespace
            % strip() removes this in order to simplify
            % downfield processing and reduce RAM load
            obj.collectedNode = Node(strip(tagData));
            
            obj = obj.Append(Node(strip(tagData)));            
        end

        function obj = EndExpression(obj)
            
            if isempty(obj.expr)
                return
            end
            
            obj = obj.Append(Node(strip(obj.expr)));
            obj.expr = blanks(XMLParser.TOKEN_MAX_LENGTH);
            obj.exprIndex = 1;
        end
        
        % MATLAB's hair brained syntax makes this look weird
        % This simply modifies this objects index value in-place
        function obj = SetIndexToEnd(obj)
            obj.index = obj.EOF + 1;
        end

        function obj = Advance(obj)
            obj.index = obj.index + 1;

            if obj.index > obj.EOF
                obj.currentChar = -1;
            else
                obj.currentChar = obj.chars(obj.index);
            end
        end

        function obj = Append(obj, node)
            obj.nodes(end + 1) = node;
        end

        function obj = PrintNodes(obj)
            for i = 1:length(obj.nodes)
                disp(str(obj.nodes(i)));
            end
        end

        function list = filter(obj, name, method)
            list = [];
            if strcmp(method, XMLParser.TIME_HANDLING_METHOD)
                for i = 1:length(obj.nodes)
                    if strcmp(obj.nodes(i).Name,'time')
                        node =obj.nodes(i+1);
                        minutes = str2double(node.Name(15:16));
                        seconds = str2double(node.Name(18:19));
                        list(end+1) = minutes*60 + seconds;
                    end
                end
            elseif strcmp(method, XMLParser.NUMERICAL_HANDLING_METHOD)
                for i = 1:length(obj.nodes)
                    if strcmp(obj.nodes(i).Name,'ele')
                        node =obj.nodes(i+1);
                        number = str2double(node.Name);
                        list(end+1) = number;
                    end
                end
            end
        end
    end
end
