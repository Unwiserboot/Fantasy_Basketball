function [ analysis_players ] = opp_position_rating(analysis_teams, analysis_players, row_team_name, i)
%SECTION C.1
%Assigne opponent position team rating to each player

    if strcmp(analysis_players.position(i), 'PF') == 1

        analysis_players.opp_team_position_rating(i) = analysis_teams{1,2}.forward_rating(row_team_name);

    elseif strcmp(analysis_players.position(i), 'C') == 1

        analysis_players.opp_team_position_rating(i) = analysis_teams{1,2}.center_rating(row_team_name);

    elseif strcmp(analysis_players.position(i), 'PG') == 1

        analysis_players.opp_team_position_rating(i) = analysis_teams{1,2}.guard_rating(row_team_name);

    elseif strcmp(analysis_players.position(i), 'SG') == 1

        analysis_players.opp_team_position_rating(i) = analysis_teams{1,2}.guard_rating(row_team_name);

    elseif strcmp(analysis_players.position(i), 'SF') == 1

        analysis_players.opp_team_position_rating(i) = analysis_teams{1,2}.forward_rating(row_team_name);  

    end
end

