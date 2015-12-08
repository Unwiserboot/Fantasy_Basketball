%Master script
    ccc
    
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION A
%This section imports and cleans up data in preparation for analysis

%Naming variables





%SECTION A.1
    %Import data from spreadsheets in tables  
    import{1,2} = import_vars('vars.csv');
    import{1,1} = 'vars';
    import{2,2} = import_fanduel('fanduel.csv');
    import{2,1} = 'fanduel'; 
    import{3,2} = import_adv('reg_sea_player_adv.csv');
    import{3,1} = 'reg_sea_player_adv'; 
    import{4,2} = import_def('reg_sea_player_def.csv');
    import{4,1} = 'reg_sea_player_def';
    import{5,2} = import_trad('reg_sea_player_trad.csv');
    import{5,1} = 'reg_sea_player_trad';
    import{6,2} = import_team_trad('reg_sea_team_trad.csv');
    import{6,1} = 'reg_sea_team_trad';
    import{7,2} = import_team_opp('reg_sea_team_opp.csv');
    import{7,1} = 'reg_sea_team_opp';
    import{8,2} = import_team_opp('reg_sea_team_opp_forward.csv');
    import{8,1} = 'reg_sea_team_opp_forward';
    import{9,2} = import_team_opp('reg_sea_team_opp_center.csv');
    import{9,1} = 'reg_sea_team_opp_center';
    import{10,2} = import_team_opp('reg_sea_team_opp_guard.csv');
    import{10,1} = 'reg_sea_team_opp_guard';
    
    %Make all table variables lower case
    for i = 1:length(import)
         
        %rename variable names to lowercase
        import{i,2}.Properties.VariableNames = lower(import{i,2}.Properties.VariableNames);        
    end

    
%SECTION A.2    
    %Define fanduel scoring
    scoring = cell2table(cell(1,10));
    scoring.Properties.VariableNames = {'salary_cap','average_per_player','three_point','two_point',...
                                                'free_throw','rebounds','assists','blocked_shots','steals','turnovers'};
    scoring.salary_cap = import{1,2}.salary_cap(1);
    scoring.average_per_player = import{1,2}.average_per_player(1);
    scoring.three_point = import{1,2}.three_point_shot(1);
    scoring.two_point = import{1,2}.two_point_shot(1);
    scoring.free_throw = import{1,2}.free_throw(1);
    scoring.rebounds = import{1,2}.rebounds(1);
    scoring.assists = import{1,2}.assists(1);
    scoring.blocked_shots = import{1,2}.blocked_shots(1);
    scoring.steals = import{1,2}.steals(1);
    scoring.turnovers = import{1,2}.turnovers(1);

 
%SECTION A.3    
    %Assign NBA player ID number to fandual data
    
    %Split player first and last names into separate columns from
    %traditional file
    temp = import{5,2}.player_name;

    for i = 1:length(temp)

        temp1 = strsplit(temp{i});

        if length(temp1) <= 2

            player_names(i,:) = temp1;

        elseif length(temp1) > 2

            player_names(i,:) = {temp1{1,1},temp1{1,end}};

        end
    end

    %find player names and transfer player id number from traditional
    %spreadsheet to fanduel spreadsheet
    for i = 1:length(import{2,2}.lastname)
        
        %Look for similar last names
        compare_lastname = strcmpi(import{2,2}.lastname(i), player_names(:,2));
        row_lastname = find(compare_lastname == 1);
        
        %Look for similar first names
        compare_firstname = strcmpi(import{2,2}.firstname(i), player_names(:,1));
        row_firstname = find(compare_firstname == 1);
        
        %Look for similar team names
        compare_team = strcmpi(import{2,2}.team(i), import{5,2}.team_abbreviation);
        row_team = find(compare_team == 1);
        
        %Compare row numbers from last names, first names and team names. Take the most common row number
        rows = [row_lastname; row_firstname; row_team];
        row_trad = mode(rows);
        
        temp6 = import{2,2}.Properties.VariableNames;
        temp6{1,1} = 'player_id';
        import{2,2}.Properties.VariableNames = temp6;
        
        import{2,2}.player_id(i) = 0; %Check to make sure number was modified
        
        %output message if no data is available for a player, usually a new
        %player
        if isnan(row_trad) == 1
             
            display(['No data available for' import{2,2}.firstname(i) import{2,2}.lastname(i)])
            
        else
            
             import{2,2}.player_id(i) = import{5,2}.player_id(row_trad); %Change number in im_fandual player id number
                                                                    %to number used in im_reg_sea_trad    
                                                                    
        end
      
    end

        
%      player last and first names as a table from traditional csv     
%      player_name = cell2table(player_names,'VariableNames',{'first_name' 'last_name'});

        
%SECTION A.4
    %Assign team ID from NBA.com number to fandual data in new columns

    %Create two empty single column tables in fandual table
    temp3 = array2table(import{2,2}.player_id);
    temp3.Properties.VariableNames = {'team_id'};
    
    temp7 = temp3;
    temp7.Properties.VariableNames = {'opp_id'};
    
    import{2,2} = [import{2,2}(:,1:8) temp3 import{2,2}(:,9) temp7 import{2,2}(:,10:12)];
    
    %create a temporary file to hold team names, abbreviations and id
    %numbers
    temp4 = cell2table(cell(length(import{1,2}.team_abbrev),1));
    temp4.Properties.VariableNames = {'team_abbrev'};
    
    temp2 = [import{6,2}(:,1:2) temp4];
     

    for i = 1:length(import{6,2}.team_id)
        
        %Assigne team abbreviations to temp table
        compare_team_name = strcmpi(temp2.team_name(i), import{1,2}.team);
        row_team = find(compare_team_name == 1);
        temp2.team_abbrev(row_team) = import{1,2}.team_abbrev(i);

        %Find row numbers for team name
        compare_team_name2 = strcmpi(temp2.team_abbrev(row_team), import{2,2}.team);
        row_team_name = find(compare_team_name2 == 1);
        
        %Find row numbers for opponent name
        compare_opp_name = strcmpi(temp2.team_abbrev(row_team), import{2,2}.opponent);
        row_opp_name = find(compare_opp_name == 1);
        
        %Assign team number for team name
        for j = 1:length(row_team_name)
            
            import{2,2}.team_id(row_team_name(j)) = temp2.team_id(row_team);
            %import{2,2}.player_id(i) = import{5,2}.player_id(row_trad);
        end
        
        %Assign team number for opponent name 
        for j = 1:length(row_opp_name)
            
            import{2,2}.opp_id(row_opp_name(j)) = temp2.team_id(row_team);
        
        end 
    end

    %create table with team names, team abbreviations and team id numbers    
    team_names = temp2;



%SECTION A.5
    %Define variables
    variables{1,2} = cell2table(import{1,2}.position(1:5)); %Player Positions
    variables{1,2}.Properties.VariableNames = {'player_positions'};
    variables{1,1} = 'player_positions';
    
    %Identify teams playing
    variables{2,1} = 'teams_playing';
    temp8 = array2table(unique(import{2,2}.team_id));
    temp8.Properties.VariableNames = {'team_id'};
    temp9 = cell2table(cell(height(temp8),1));
    temp9.Properties.VariableNames = {'team_name'};
    variables{2,2} = [temp8 temp9];
    
    %Assign team number for opponent name 
    for j = 1:height(variables{2,2})
        
        compare_team_id = eq(variables{2,2}.team_id(j), team_names.team_id);
        row_team_name = find(compare_team_id == 1);
        variables{2,2}.team_name(j) = {team_names.team_name(row_team_name)};

    end 

    
    
    



%SECTION A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION B
%This section run the prescribed analysis to assist in picking the best NBA
%line up for the given games that night

%SECTION B.1
    %Calculate opponent team difficulty by team and position
    analysis_team

    
    
    
    
    
    
    
    



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
          temp4...
          temp5...
          temp6...
          temp7...
          temp8...
          temp9...
          tempnames...
          playernames...
          player_names...
          compare_opp_name...
          compare_team_name...
          compare_team_name2...
          j...
          row_opp_name...
          row_team_name...
          compare_team_id...
          k...
          n

      
%SECTION C.5
    %Export workspace variables to .mat file
    save(['/Users/ccm/Documents/Fantasy_Basketball/analysis_export/ex_workspace_variables'])


%SECTION C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%