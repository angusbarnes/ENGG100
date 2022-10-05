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
        dataCount = 0;
    end

    % For some reason exposing properties publicly slowed the program
    % to a measurable extent. For this reason, as well as for cleaner code
    % these properties can only be accessed inside this class and its
    % children
    properties (Access = protected)
        currentChar char
        chars
        index {mustBeNumeric} = 0
        EOF {mustBeNumeric}
        
        expr = blanks(XMLParser.TOKEN_MAX_LENGTH)
        exprIndex = 1

        nodeIndex = 1

        
    end

    properties (Constant)

        % Whilst this is an abitrary constant, changing it will require a
        % MATLAB program restart or else the program will hang indefinitely. 
        % There is some strange behaviour in MATLAB and how it handles 
        % compile time caching which I believe is the cause of this issue. 
        % 900-1500 is the best performance range for this value
        TOKEN_MAX_LENGTH = 900;

        % Normally magic constants are bad
        % These simply operate as an options enum and are faster
        % than using matlabs built in enum type, which is slow due to
        % object insantiation costs
        TIME_HANDLING_METHOD = 0x33;
        COORDINATE_HANDLING_METHOD = 0x42;
        NUMERICAL_HANDLING_METHOD = 0x86;
        DO_NOT_FORMAT = 0xFF;
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
            value = strip(tagData);
            
            if strcmp(value,'trkpt lat= lon=')
                obj.dataCount = obj.dataCount + 1;
            end

            obj.nodes(end+1) = Node(value);
            %obj = obj.Append(Node(strip(tagData)));            
        end

        function obj = EndExpression(obj)
            
            if isempty(obj.expr)
                return
            end
            
            obj.nodes(end+1) = Node(strip(obj.expr));
            % obj = obj.Append(Node(strip(obj.expr)));
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
        
        % Whilst good architecture in conventional languages
        % using an append function like this resulted in a speed
        % decrease of 6000%. This is curious, so I left the code here.
        % I believe this is due to matlabs first class object
        % implementation. Something about this code results in the array
        % obj.nodes being copied in memory to a new adress every time this
        % was called, which was about 15,000 times
        function obj = Append(obj, node)
            obj.nodes(end + 1) = node;
        end

        function obj = PrintNodes(obj)
            for i = 1:length(obj.nodes)
                disp(str(obj.nodes(i)));
            end
        end
        
        % Hard coding filter routines is not good architecture for
        % a general XML parser. But given time constraints and string performance
        % limitations of MATLAB, it will be sufficient for our usecase
        function list = filter(obj, name, method)
            list = [];
            

            if method == XMLParser.TIME_HANDLING_METHOD
                epoch = -1;
                epochDay = -1;
                list = zeros(obj.dataCount, 1);
                listIndex = 1;
                for i = 1:length(obj.nodes)
                    if strcmp(obj.nodes(i).Name,'time')
                        node =obj.nodes(i+1);
                        day = str2double(node.Name(9:10));
                        hours = str2double(node.Name(12:13));
                        minutes = str2double(node.Name(15:16));
                        seconds = str2double(node.Name(18:19));
                        time = (hours * 60 + minutes)*60 + seconds;
                        
                        if epoch == -1
                            epoch = time;
                        end
                        
                        % Handle edge case where UTC date changes mid-ride
                        if epochDay == -1
                            epochDay = day;
                            continue % We do not want to record the first time
                                     % Skip the rest of the loop
                        elseif epochDay ~= day
                            epochDay = day;
                            epoch = epoch - 86400;
                        end
                  
                        list(listIndex) = time-epoch;
                        listIndex = listIndex + 1;
                     end
                end
                return
            end


%             if obj.dataCount == -1
%                 count = 0;
%                 for i = 1:length(obj.nodes)
%                     if strcmp(obj.nodes(i).Name, 'time')
%                         count = count + 1;
%                     end
%                 end
%             end

            if method == XMLParser.NUMERICAL_HANDLING_METHOD
                list = zeros(obj.dataCount, 1);
                listIndex = 1;
                for i = 1:length(obj.nodes)
                    if strcmp(obj.nodes(i).Name,name)
                        node =obj.nodes(i+1);
                        number = str2double(node.Name);
                        list(listIndex) = number;
                        listIndex = listIndex + 1;
                    end
                end
            elseif method == XMLParser.COORDINATE_HANDLING_METHOD
                list = zeros(obj.dataCount, 2);
                listIndex = 1;
                for i = 1:length(obj.nodes)
                    if strcmp(obj.nodes(i).Name,'trkpt lat= lon=')
                        latNode = obj.nodes(i-2);
                        longNode = obj.nodes(i-1);
                        lat = str2double(latNode.Name);
                        long = str2double(longNode.Name);
                        list(listIndex, :) = [lat, long];
                        listIndex = listIndex + 1;
                    end
                end
            end
        end
    end
end
