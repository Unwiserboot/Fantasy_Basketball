function [ analysis_players ] = opp_position(analysis_teams, analysis_players, row_team_name, i)
%SECTION B.1
%Assign opponent position team fantasy points to each player

    if strcmp(analysis_players.position(i), 'PF') == 1
        analysis_players.opp_team_position_fp_allowed_sea(i) = analysis_teams{3,2}.total_fp_allowed(row_team_name);

    elseif strcmp(analysis_players.position(i), 'C') == 1
        analysis_players.opp_team_position_fp_allowed_sea(i) = analysis_teams{4,2}.total_fp_allowed(row_team_name);

    elseif strcmp(analysis_players.position(i), 'PG') == 1
        analysis_players.opp_team_position_fp_allowed_sea(i) = analysis_teams{5,2}.total_fp_allowed(row_team_name);

    elseif strcmp(analysis_players.position(i), 'SG') == 1
        analysis_players.opp_team_position_fp_allowed_sea(i) = analysis_teams{5,2}.total_fp_allowed(row_team_name);

    elseif strcmp(analysis_players.position(i), 'SF') == 1
        analysis_players.opp_team_position_fp_allowed_sea(i) = analysis_teams{3,2}.total_fp_allowed(row_team_name);  
   
    end
end

