function regseatrad = import_trad(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   REGSEATRAD = IMPORTFILE(FILENAME) Reads data from text file FILENAME
%   for the default selection.
%
%   REGSEATRAD = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from
%   rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   regseatrad = importfile('reg_sea_trad.csv', 2, 428);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2015/12/04 12:21:18

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [1,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36]);
rawCellColumns = raw(:, [2,4]);


%% Create output variable
regseatrad = table;
regseatrad.PLAYER_ID = cell2mat(rawNumericColumns(:, 1));
regseatrad.PLAYER_NAME = rawCellColumns(:, 1);
regseatrad.TEAM_ID = cell2mat(rawNumericColumns(:, 2));
regseatrad.TEAM_ABBREVIATION = rawCellColumns(:, 2);
regseatrad.AGE = cell2mat(rawNumericColumns(:, 3));
regseatrad.GP = cell2mat(rawNumericColumns(:, 4));
regseatrad.W = cell2mat(rawNumericColumns(:, 5));
regseatrad.L = cell2mat(rawNumericColumns(:, 6));
regseatrad.W_PCT = cell2mat(rawNumericColumns(:, 7));
regseatrad.MIN = cell2mat(rawNumericColumns(:, 8));
regseatrad.FGM = cell2mat(rawNumericColumns(:, 9));
regseatrad.FGA = cell2mat(rawNumericColumns(:, 10));
regseatrad.FG_PCT = cell2mat(rawNumericColumns(:, 11));
regseatrad.FG3M = cell2mat(rawNumericColumns(:, 12));
regseatrad.FG3A = cell2mat(rawNumericColumns(:, 13));
regseatrad.FG3_PCT = cell2mat(rawNumericColumns(:, 14));
regseatrad.FTM = cell2mat(rawNumericColumns(:, 15));
regseatrad.FTA = cell2mat(rawNumericColumns(:, 16));
regseatrad.FT_PCT = cell2mat(rawNumericColumns(:, 17));
regseatrad.OREB = cell2mat(rawNumericColumns(:, 18));
regseatrad.DREB = cell2mat(rawNumericColumns(:, 19));
regseatrad.REB = cell2mat(rawNumericColumns(:, 20));
regseatrad.AST = cell2mat(rawNumericColumns(:, 21));
regseatrad.TOV = cell2mat(rawNumericColumns(:, 22));
regseatrad.STL = cell2mat(rawNumericColumns(:, 23));
regseatrad.BLK = cell2mat(rawNumericColumns(:, 24));
regseatrad.BLKA = cell2mat(rawNumericColumns(:, 25));
regseatrad.PF = cell2mat(rawNumericColumns(:, 26));
regseatrad.PFD = cell2mat(rawNumericColumns(:, 27));
regseatrad.PTS = cell2mat(rawNumericColumns(:, 28));
regseatrad.PLUS_MINUS = cell2mat(rawNumericColumns(:, 29));
regseatrad.DD2 = cell2mat(rawNumericColumns(:, 30));
regseatrad.TD3 = cell2mat(rawNumericColumns(:, 31));
regseatrad.CFID = cell2mat(rawNumericColumns(:, 32));
regseatrad.CFPARAMS = cell2mat(rawNumericColumns(:, 33));
regseatrad.VarName36 = cell2mat(rawNumericColumns(:, 34));

