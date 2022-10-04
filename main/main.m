% This is the main high level submission file
% We are allowed up to 10 LOC for this file
% This ensures we split code effectively between
% other external files
persistantDataPath = pwd + "\..\data\";
%filename = persistantDataPath + input('Data File Name');
tic
test = XMLParser('sample.xml');
result = test.Parse();

nodes = result.nodes;

% for i = 1:length(nodes)
%     value = nodes(i).Name;
%     if strcmp(value, "time")
%         disp(str(nodes(i+1)))
%     elseif strcmp(value, "ele")
%         disp(str(nodes(i+1)))
%     elseif strcmp(value, "trkseg")
%         disp(str(nodes(i+1)))
%     end
% end

for i = 1:length(nodes)
    disp(nodes(i).Name)
end