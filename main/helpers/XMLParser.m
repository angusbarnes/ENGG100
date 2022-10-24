% This File Was Assigned To: Angus Barnes
% This File Was Developed By: Angus Barnes
% This is an implementation of a basic linear parser. 
% This is an agnostic XML parser and will parse any XML File
% It provides and API to filter and retrieve data based on tag names

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

        % This is the object contructor
        function obj = XMLParser(filename)
            obj.filename = filename;
        end
        
        % The structure should be a tree
        % This can be implemented using a cell array of
        % custom Node data types.
        % Nodes can reference other subnodes or be a single value
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
            
            % This is an obj.Advance() call. Because MATLAB is so
            % poorly implemented to handle procedural programing
            % it is not performance friendly to call
            % functions at high frequency (in this case 100,000+
            % times). Instead I just copy pasted obj.Advance
            % locally everywhere it is needed
            obj.index = obj.index + 1;
            if ~(obj.index > obj.EOF)
                obj.currentChar = obj.chars(obj.index);
            end


            % Like most things, MATLAB has a very poor implementation 
            % of class objects. Some instance reassignment is required
            % to self reference class values internally. We cannot
            % modify instance values in-place
            % TLDR: There be demons ahead
            while obj.index <= length(obj.chars)

                % If we find a '<' it means we have found a tag
                if obj.currentChar == '<'
                    % The previous expression must be finished if we are
                    % starting a new tag collection
                    obj = obj.EndExpression();

                    % Collect all the proceeding characters until we hit a
                    % closing '>'. This is will be a tag name and will be
                    % appened to the token list
                    obj = obj.CollectNode('>');
                
                % If we still have characters left to parse but we are not
                % currently collecting a tag, append those characters to
                % the currently collected expresion. This will be added to
                % the token list when EndExpression gets called
                elseif obj.currentChar ~= ""
                    obj.expr(obj.exprIndex) = obj.currentChar;
                    obj.exprIndex = obj.exprIndex + 1;
                end
                
                % obj.Advance() -> Move to next character
                obj.index = obj.index + 1;
                if ~(obj.index > obj.EOF)
                    obj.currentChar = obj.chars(obj.index);
                end
            end
        end

        function obj = CollectNode(obj, delimiter)

            % Uses slightly more memory than necessary but massively
            % improves parser speed. Dynamic vector allocation
            % is slow. This pre-allocates ~900 bytes of memory
            % for the tag data which should never causes RAM
            % limit issues on modern machines
            % Measured speed improvement of ~200%
            tagData = blanks(XMLParser.TOKEN_MAX_LENGTH);
            
            % obj.Advance() -> Move to next character
            obj.index = obj.index + 1;
            if ~(obj.index > obj.EOF)
                obj.currentChar = obj.chars(obj.index);
            end
            
            i = 1;

            % Move through and consume all characters stored within this
            % node until the delimiter is hit
            while obj.currentChar ~= delimiter
                % The list will dynamically extend if necessary
                % TOKEN_MAX_LENGTH is therefore a soft limit
                
                % If there is arguments in this XML tag, collect them
                % and insert them as new nodes in the output
                 if obj.currentChar == '"'

                    % Recursively call this function to collect tag meta
                    % data which is contained in " "
                    obj = obj.CollectNode('"');
                    
                    % obj.Advance() -> Move to next character
                    obj.index = obj.index + 1;
                    if ~(obj.index > obj.EOF)
                        obj.currentChar = obj.chars(obj.index);
                    end
                 else
                    tagData(i) = obj.currentChar; 
                    i = i + 1;
                    
                    % This is an obj.Advance() Call
                    obj.index = obj.index + 1;
                    if ~(obj.index > obj.EOF)
                        obj.currentChar = obj.chars(obj.index);
                    end
                 end
            end

            % The Pre-allocation causes trailing whitespace
            % strip() removes this in order to simplify
            % downfield processing and reduce RAM load
            value = strip(tagData);
            
            % Hacky poor quality way of keeping count of how many
            % coordinate values have been collected, agnostic of their
            % contained coordinates
            if strcmp(value,'trkpt lat= lon=')
                obj.dataCount = obj.dataCount + 1;
            end

            obj.nodes(end+1) = Node(value);            
        end

        % Function is used to add collected expression to token list and
        % reset currently collected expression value to be empty
        function obj = EndExpression(obj)
            
            if isempty(obj.expr)
                return
            end
            
            obj.nodes(end+1) = Node(strip(obj.expr));
            obj.expr = blanks(XMLParser.TOKEN_MAX_LENGTH);
            obj.exprIndex = 1;
        end
        
        % This function was used intenally to advance the read head
        % In the production ready code this was removed. It turns out that
        % MATLAB's refusal to implement zero-cost abstractions was costing
        % performance dearly. Calling this function turned out to be 40%
        % slower in runtime than when the code inside it was copy pasted
        % over the top of everywhere it was called. This makes the code far
        % messier and harder to read, but drastically improved performance
        function obj = Advance(obj)
            obj.index = obj.index + 1;
            if ~(obj.index > obj.EOF)
                obj.currentChar = obj.chars(obj.index);
            end
        end
        
        % Whilst it is considererd good architecture in conventional languages
        % using an append function like this resulted in a speed
        % decrease of 6000%. This is curious, so I left the code here.
        % I believe this is due to matlabs first class object
        % implementation. Something about this code results in the array
        % obj.nodes being copied in memory to a new address every time this
        % was called, which was about 15,000 times. This is an inherent
        % limitation of the MATLAB compiler design as it is optimised for
        % other use cases
        function obj = Append(obj, node)
            obj.nodes(end + 1) = node;
        end
        
        % Hard coding filter routines is not good architecture for
        % a general XML parser. But given time constraints and string performance
        % limitations of MATLAB, it will be sufficient for our usecase
        function list = filter(obj, name, method)
            list = [];
            
            if method == XMLParser.TIME_HANDLING_METHOD
                
                % The first time value in the GPX file is a metadata tag
                % This gives us reference from which all other time values
                % can be measured
                epoch = -1;
                epochDay = -1;
                list = zeros(obj.dataCount, 1);
                listIndex = 1;
                
                % Find all time nodes and calculate time since epoch for
                % that node
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
                            
                            % We do not want to record the first time as
                            % this is the reference time
                            % Skip the rest of the loop
                            continue 
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
            
            % Hard coded routine to retrieve a numerical value stored
            % within a tag node
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

            % Hard coded routine to extract coordinate values from Trkpt
            % Nodes
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
