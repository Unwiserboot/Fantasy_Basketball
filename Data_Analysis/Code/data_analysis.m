ccc

%import data from spreadsheets (im)
im_regular_season_advanced = csv_import('regular_season_advanced_data.csv');
im_regular_season_traditional = csv_import('regular_season_traditional_data.csv');
im_regular_season_defensive = csv_import('regular_season_defensive_data.csv');
im_fanduel = csv_import('fanduel_data.csv');
im_variables = readtable('variables.xlsx');
im_abbreviations = readtable('data_abbreviations.xlsx');




%variables
positions = im_abbreviations.Position; %Player Positions
teams = im_abbreviations.Team; %All NBA Teams abbreviations
number_teams_playing = im_variables.number_of_teams(1); %Number of teams playing
teams_playing = im_variables.teams_playing(1:number_teams_playing); %Teams playing abbreviations


%%
%fanduel scoring (sc)
sc_three_point = im_variables.three_point_shot(1); %3 pointer = 3pts.
sc_two_point = im_variables.two_point_shot(1); %2 pointer = 2pts.
sc_free_throw = im_variables.free_throw(1); %Free throw = 1 pt.
sc_rebounds = im_variables.rebounds(1); %rebounds = 1.2 pts.
sc_assists = im_variables.assists(1); %assists = 1.5 pts.
sc_steals = im_variables.steals(1); %steals = 2 pts.
sc_blocked_shots = im_variables.blocked_shots(1); %blocked shots = 2 pts.
sc_turnovers = im_variables.turnovers(1); %turnovers = -1 pt.
%%






%Files to delete
clear i files


