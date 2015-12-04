function [ C ] = csv_import( file_name )
%Import CSV File
%   Detailed explanation goes here



fid = fopen(file_name,'r');
C = textscan(fid, repmat('%s',1,50), 'delimiter',',', 'CollectOutput',true);
C = C{1};
fclose(fid);


end

