%Master script
    ccc


%run data import script
	import_script


%variables
    positions = im_vars.position; %Player Positions
    tot_teams = im_vars.team; %All NBA Teams abbreviations
    num_teams_playing = im_vars.num_teams_playing(1); %Number of teams playing
    teams_playing = im_vars.teams_playing(1:num_teams_playing); %Teams playing abbreviations

%fanduel scoring (sc)
    sc_three_point = im_vars.three_point_shot(1); %3 pointer = 3pts.
    sc_two_point = im_vars.two_point_shot(1); %2 pointer = 2pts.
    sc_free_throw = im_vars.free_throw(1); %Free throw = 1 pt.
    sc_rebounds = im_vars.rebounds(1); %rebounds = 1.2 pts.
    sc_assists = im_vars.assists(1); %assists = 1.5 pts.
    sc_steals = im_vars.steals(1); %steals = 2 pts.
    sc_blocked_shots = im_vars.blocked_shots(1); %blocked shots = 2 pts.
    sc_turnovers = im_vars.turnovers(1); %turnovers = -1 pt
    sc_salary_cap = im_vars.salary_cap(1); %Fantasy salary cap
    sc_avg_price_per_player = im_vars.average_per_player(1); %Average salary per player


%%
%Ensure players have one id number across all data files
similar_id_number_script
    















%Files to delete
clear i number_teams_playing