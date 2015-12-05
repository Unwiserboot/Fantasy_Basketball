
%script reduced number of players in by teams playing that night


j = 0;
    for k = 1:length(im_fanduel.id) %run through length of table
    
        if ismember(im_fanduel.team(k), teams_playing) == 1 %if team name is in list of teams playing, pull that row of data
            
            fanduel_reduced(j+1,:) = im_fanduel(k,:);
            j = length(fanduel_reduced.id);
            
        end   
    end
