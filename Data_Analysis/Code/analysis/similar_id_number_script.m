%Assign NBA player ID number to fandual data


    %Split player first and last names into separate columns
    playernames = im_reg_sea_trad.PLAYER_NAME;

    for i = 1:length(playernames)
        
        temp = strsplit(playernames{i});
        
        
        if length(temp) == 2
        
            playernames2(i,:) = temp;
        
        elseif length(temp) > 2
            
            playernames2(i,:) = {temp{1,1},temp{1,3}};
            
        else
            
            playernames2(i,:) = {temp{1,1}};
        end
        
        
    end


    %find player names and transfer player id number from traditional
    %spreadsheet to fanduel spreadsheet

    for i = 1:length(im_fanduel.last_name)
        
        %Look for similar last names
        compare_lastname = strcmpi(im_fanduel.last_name(i), playernames2(:,2));
        row_lastname = find(compare_lastname == 1);
        
        %Look for similar first names
        compare_firstname = strcmpi(im_fanduel.first_name(i), playernames2(:,1));
        row_firstname = find(compare_firstname == 1);
        
        %Look for similar team names
        compare_team = strcmpi(im_fanduel.team(i), im_reg_sea_trad.TEAM_ABBREVIATION);
        row_team = find(compare_team == 1);
        
        %Compare all three comparisons and take the most common row number
        rows = [row_lastname; row_firstname; row_team];
        row_trad = mode(rows);
        
        im_fanduel.id(i) = 0; %Check to make sure number was changed correctly
        im_fanduel.id(i) = im_reg_sea_trad.PLAYER_ID(row_trad); %Change number in im_fandual player id number to number used in im_reg_sea_trad

        
    
    end