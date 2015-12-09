function [ rating ] = team_rating( metric)
%Calculate each teams fantasy points allowed
	%metric - data to rank
    %num_teams - number of teams to analyze
    %team_id - team id associated with ranking
    %ranking - file output ranks teams from 1 to 30 for each metric. 30 is
    %easiest for the opponent player and 1 is most difficult.
    num_teams = length(metric);
    rating = zeros(num_teams,1);
    average = mean(metric);
    deviation = std(metric);

    for i = 1:num_teams
        if metric(i) > average && metric(i) < average + deviation

            rating(i) = 1;

        elseif metric(i) > average + deviation && metric(i) < average + 2*deviation            

            rating(i) = 2;

        elseif metric(i) > average + 3*deviation

            rating(i) = 3;

        elseif metric(i) < average && metric(i) > average-deviation

            rating(i) = -1;

        elseif metric(i) > average - 2*deviation && metric(i) < average - deviation

            rating(i) = -2;

        elseif metric(i) < average - 3*deviation

            rating(i) = -3;

        elseif metric(i) == average

            rating(i) = 0;

        end
    end
end

