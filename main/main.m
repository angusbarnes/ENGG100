% This is the main high level submission file
% We are allowed up to 10 LOC for this file
% This ensures we split code effectively between
% other external files
persistantDataPath = pwd + "\..\data\";
%filename = persistantDataPath + input('Data File Name');
test = XMLParser('sample.xml');
test.Parse();