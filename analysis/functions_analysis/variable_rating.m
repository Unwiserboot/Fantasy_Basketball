function [ rating ] = variable_rating( metric)
%SECTION B.1, analysis_team.m 
%rate teams on fantasy points allowed based on distance from the mean
%a higher number is better for the player on the opposing team
	%metric - data to rank
    rows = length(metric);
    rating = zeros(rows,1);
    average = mean(metric);
    deviation = std(metric);

    for i = 1:rows
        if metric(i) > average && metric(i) < average + deviation

            rating(i) = 1;

        elseif metric(i) > average + deviation && metric(i) < average + 2*deviation            

            rating(i) = 2;
                    
        elseif metric(i) > average + 2*deviation

            rating(i) = 3;

        elseif metric(i) < average && metric(i) > average-deviation

            rating(i) = -1;

        elseif metric(i) > average - 2*deviation && metric(i) < average - deviation

            rating(i) = -2;

        elseif metric(i) < average - 2*deviation

            rating(i) = -3;

        elseif metric(i) == average

            rating(i) = 0;

        end
    end
end

