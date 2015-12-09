function [ analysis_players ] = opp_position_rating(analysis_teams, analysis_players, import, row_team_name, i)
%Assigne opponent position team rating to a player
%   Detailed explanation goes here


    if strcmp(import{2,2}.position(1), 'PF') == 1

        analysis_players.opp_team_position_rating(i) = analysis_teams{1,2}.forward_rating(row_team_name);

    elseif strcmp(import{2,2}.position(1), 'C') == 1

        analysis_players.opp_team_position_rating(i) = analysis_teams{1,2}.center_rating(row_team_name);

    elseif strcmp(import{2,2}.position(1), 'PG') == 1

        analysis_players.opp_team_position_rating(i) = analysis_teams{1,2}.guard_rating(row_team_name);

    elseif strcmp(import{2,2}.position(1), 'SG') == 1

        analysis_players.opp_team_position_rating(i) = analysis_teams{1,2}.guard_rating(row_team_name);

    elseif strcmp(import{2,2}.position(1), 'SF') == 1

        analysis_players.opp_team_position_rating(i) = analysis_teams{1,2}.forward_rating(row_team_name);  

    end

end

