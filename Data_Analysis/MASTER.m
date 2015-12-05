%Master script
    ccc
    
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION A
%This section imports and cleans up data in preparation for analysis

%Naming variables
    % sc - scoring
    % im - import
    % ex - export
    % ...




%SECTION A.1
    %Import data from spreadsheets in tables
    im_vars = import_vars('vars.csv');
    im_fanduel = import_fanduel('fanduel.csv');
    im_reg_sea_player_adv = import_adv('reg_sea_player_adv.csv');
    im_reg_sea_player_def = import_def('reg_sea_player_def.csv');
    im_reg_sea_player_trad = import_trad('reg_sea_player_trad.csv');
    im_reg_sea_team_opp = import_team_opp('reg_sea_team_opp.csv');
    im_reg_sea_team_trad = import_team_trad('reg_sea_team_trad.csv');




    
%SECTION A.3    
    %Define fanduel scoring
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

 
%SECTION A.4    
    %Assign NBA player ID number to fandual data
    
    %Split player first and last names into separate columns from
    %traditional file
    tempnames = im_reg_sea_player_trad.PLAYER_NAME;

    for i = 1:length(tempnames)

        temp2 = strsplit(tempnames{i});

        if length(temp2) == 2

            player_names(i,:) = temp2;

        elseif length(temp2) > 2

            player_names(i,:) = {temp2{1,1},temp2{1,3}};

        else

            player_names(i,:) = {temp2{1,1}};
        end
    end

    %find player names and transfer player id number from traditional
    %spreadsheet to fanduel spreadsheet
    for i = 1:length(im_fanduel.last_name)
        
        %Look for similar last names
        compare_lastname = strcmpi(im_fanduel.last_name(i), player_names(:,2));
        row_lastname = find(compare_lastname == 1);
        
        %Look for similar first names
        compare_firstname = strcmpi(im_fanduel.first_name(i), player_names(:,1));
        row_firstname = find(compare_firstname == 1);
        
        %Look for similar team names
        compare_team = strcmpi(im_fanduel.team(i), im_reg_sea_player_trad.TEAM_ABBREVIATION);
        row_team = find(compare_team == 1);
        
        %Compare row numbers from last names, first names and team names. Take the most common row number
        rows = [row_lastname; row_firstname; row_team];
        row_trad = mode(rows);
        
        im_fanduel.id(i) = 0; %Check to make sure number was modified
        im_fanduel.id(i) = im_reg_sea_player_trad.PLAYER_ID(row_trad); %Change number in im_fandual player id number
                                                                %to number used in im_reg_sea_trad    
    end

        
%     %player last and first names as a table from traditional csv     
%     player_name = cell2table(player_names,'VariableNames',{'first_name' 'last_name'});

        
%SECTION A.5
    %Assign team ID from NBA.com number to fandual data in new columns

    %Create two empty single column tables in fandual table
    temp1 = cell2table(cell(length(im_fanduel.id),1));
    temp1.Properties.VariableNames = {'team_id'};
    
    temp2 = cell2table(cell(length(im_fanduel.id),1));
    temp2.Properties.VariableNames = {'opp_id'};
    
    im_fanduel = [im_fanduel(:,1:8) temp1 im_fanduel(:,9) temp2 im_fanduel(:,10:12)];
    
    %create a temporary file to hold team names, abbreviations and id
    %numbers
    temp3 = cell2table(cell(length(im_reg_sea_team_trad.TEAM_ID),1));
    temp3.Properties.VariableNames = {'team_abbrev'};
    
    temp2 = [im_reg_sea_team_trad(:,1:2) temp3];
     

    for i = 1:length(im_reg_sea_team_trad.TEAM_ID)
        
        %Assigne team abbreviations to temp table
        compare_team_name = strcmpi(temp2.TEAM_NAME(i), im_vars.team);
        row_team = find(compare_team_name == 1);
        temp2.team_abbrev(row_team) = im_vars.team_abbrev(i);

        %Find row numbers for team name
        compare_team_name2 = strcmpi(temp2.team_abbrev(row_team), im_fanduel.team);
        row_team_name = find(compare_team_name2 == 1);
        
        %Find row numbers for opponent name
        compare_opp_name = strcmpi(temp2.team_abbrev(row_team), im_fanduel.opponent);
        row_opp_name = find(compare_opp_name == 1);
        
        %Assign team number for team name
        for j = 1:length(row_team_name)
            
            im_fanduel.team_id(row_team_name(j)) = {temp2.TEAM_ID(row_team)};
            
        end
        
        %Assign team number for opponent name 
        for j = 1:length(row_opp_name)
            
            im_fanduel.opp_id(row_opp_name(j)) = {temp2.TEAM_ID(row_team)};
        
        end 
    end

    %create table with team names, team abbreviations and team id numbers    
    team_names = temp2;



%SECTION A.2
    %Define variables
    positions = im_vars.position(1:5); %Player Positions
    teams_playing_num = im_vars.num_teams_playing(1); %Number of teams playing
    
    
    teams_playing = [cell2table(cell(im_vars.teams_playing(1:teams_playing_num,1)))]; %Teams playing abbreviations
    teams_playing.Properties.VariableNames = {'team_abbrev'};

    %Create two empty single column tables in fandual table
    temp2 = cell2table(cell(height(teams_playing),1));
    temp2.Properties.VariableNames = {'team_id'};
     
    teams_playing = [teams_playing temp2];
    
    %Assign team number for opponent name 
    for j = 1:height(teams_playing)
        
        compare_team_name = strcmpi(teams_playing.team_abbrev(j), team_names.team_abbrev);
        row_team_name = find(compare_team_name == 1);
        teams_playing.team_id(j) = {team_names.TEAM_ID(row_team_name)};

    end 





%SECTION A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION B
%This section




















%SECTION B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION C
%This section



%SECTION C.4
    %Variables to delete from workspace
    clear i...
          compare_lastname...
          compare_firstname...
          compare_team...
          row_lastname...
          row_firstname...
          row_team...
          rows...
          row_trad...
          temp...
          temp1...
          temp2...
          temp3...
          tempnames...
          playernames...
          player_names...
          compare_opp_name...
          compare_team_name...
          compare_team_name2...
          j...
          row_opp_name...
          row_team_name...

      
%SECTION C.5
    %Export workspace variables to .mat file
    save(['/Users/ccm/Documents/Fantasy_Basketball/Data_Export/ex_workspace_variables'])


%SECTION C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%