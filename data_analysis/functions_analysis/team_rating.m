function [ rating ] = team_rating( metricdata, a, num_teams)
%Rank each team from best to work for a given input variable
	%metric - data to rank
    %aa - from the players perspective, determine how to analyze the data
        %1 - want the team to be below average in categories that hurt the 
        %opponene, ex: blocks, opponent turnovers
        %2 - want the team to be above average, ex: opponent blocks,
        %opponent turnovers
    %num_teams - number of teams to analyze
    %team_id - team id associated with ranking
    %ranking - file output ranks teams from 1 to 30 for each metric. 30 is
    %easiest for the opponent player and 1 is most difficult.
    
    rating = zeros(num_teams,1);
    average = mean(metricdata);
    deviation = std(metricdata);
    
    j = 0;
    
    if a == 1
        for i = 1:num_teams
            if metricdata(i) > average && metricdata(i) < average + deviation
                
                rating(i) = -1;
                
            elseif metricdata(i) > average + deviation && metricdata(i) < average + 2*deviation            
            
                rating(i) = -2;
            
            elseif metricdata(i) > average + 3*deviation
            
                rating(i) = -3;
            
            elseif metricdata(i) < average && metricdata(i) > average-deviation
                
                rating(i) = 1;
                
            elseif metricdata(i) > average - 2*deviation && metricdata(i) < average - deviation
            
            
                rating(i) = 2;
            
            elseif metricdata(i) < average - 3*deviation
            
            
                rating(i) = 3;
                
            elseif metricdata(i) == average
                
                rating(i) = 0;
                
            end
        end
    
    elseif a == 2
     
       for i = 1:num_teams
            if metricdata(i) > average && metricdata(i) < average + deviation
                
                rating(i) = 1;
                
            elseif metricdata(i) > average + deviation && metricdata(i) < average + 2*deviation            
            
                rating(i) = 2;
            
            elseif metricdata(i) > average + 3*deviation
            
                rating(i) = 3;
            
            elseif metricdata(i) < average && metricdata(i) > average-deviation
                
                rating(i) = -1;
                
            elseif metricdata(i) > average - 2*deviation && metricdata(i) < average - deviation
            
            
                rating(i) = -2;
            
            elseif metricdata(i) < average - 3*deviation
            
            
                rating(i) = -3;
                
            elseif metricdata(i) == average
                
                rating(i) = 0;
                
            end
       end
end

