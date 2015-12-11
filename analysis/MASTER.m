%Master script
    %run this script after running python script to analyze nba data and create optimal nba lineup    
    ccc
    
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION A
%This section imports and cleans up data in preparation for analysis

%SECTION A.1
    %import csv data files into matlab and deposit them in import variable
    import_script
    
%SECTION A.2    
    %create scoring variable to hold scoring scheme
    import_scoring = import{1,2};
    import_scoring(:,[11:15]) = [];
    import_scoring([2:end],:) = [];

%SECTION A.3
    %make team abbreviation in fandual table the same as NBA.com data
    %need to check for incorrect abbreviation in fanduel spreadsheet on a
    %given night
    for i = 1:2
        compare_lastname = strcmpi(import{2,2}.(i+8), 'NO'); %New Orleans
        row = find(compare_lastname == 1);
        import{2,2}.(i+8)(row) = {'NOP'};

        compare_lastname = strcmpi(import{2,2}.(i+8), 'PHO'); %Phonenix
        row = find(compare_lastname == 1);
        import{2,2}.(i+8)(row) = {'PHX'};
        
        compare_lastname = strcmpi(import{2,2}.(i+8), 'SA'); %San Antonio
        row = find(compare_lastname == 1);
        import{2,2}.(i+8)(row) = {'SAS'};
        
        compare_lastname = strcmpi(import{2,2}.(i+8), 'NY'); %New York
        row = find(compare_lastname == 1);
        import{2,2}.(i+8)(row) = {'NYK'};
        
        compare_lastname = strcmpi(import{2,2}.(i+8), 'GS'); %Golden State
        row = find(compare_lastname == 1);
        import{2,2}.(i+8)(row) = {'GSW'};

        compare_lastname = strcmpi(import{2,2}.(i+8), 'SA'); %San Antonio
        row = find(compare_lastname == 1);
        import{2,2}.(i+8)(row) = {'SAS'};
    end
    
    clear i row
    
%SECTION A.4    
    %replace fanduel player id number with nba.com player id number
    
        %split player first and last names from reg_sea_player_trad
        %into separate columns 
        temp = import{5,2}.player_name;

        for i = 1:length(temp)

            temp1 = strsplit(temp{i});

            if length(temp1) > 2
                %throw away middle name  
                player_names(i,:) = {temp1{1,1},temp1{1,end}};
                
            else
                
                player_names(i,:) = temp1;          
            end
        end
        
    %transfer player id number from traditional
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
        
        %Compare row numbers from last names, first names and team names. 
        %Take the most common row number
        rows = [row_lastname; row_firstname; row_team];
        row_trad = mode(rows);
        
        %rename variable 1 in fandual data to player_id
        import{2,2}.Properties.VariableNames(1) = {'player_id'};
        
        import{2,2}.player_id(i) = 0; %Check to make sure number was modified
        
        %output message if no data is available for a player, usually a new
        %player
        if isnan(row_trad) == 1
             
            display(['No data available for' import{2,2}.firstname(i) import{2,2}.lastname(i)])
            
        else
            
             import{2,2}.player_id(i) = import{5,2}.player_id(row_trad); %Change number in im_fandual player id
                                                                         %to id from im_reg_sea_trad                                                               
        end      
    end
    
%      player last and first names as a table from traditional csv     
%      player_name = cell2table(player_names,'VariableNames',{'first_name' 'last_name'});

    clear temp i player_names row_lastname row_firstname row_trad row_team rows...
          compare_firstname compare_lastname
        
%SECTION A.5
    %Assign team ID from NBA.com to fandual data in new columns

    %Create two empty single column tables in fandual table
    temp = array2table(import{2,2}.player_id);
    temp.Properties.VariableNames = {'team_id'};
    
    temp1 = temp;
    temp1.Properties.VariableNames = {'opp_id'};
    
    import{2,2} = [import{2,2}(:,1:8) temp import{2,2}(:,9) temp1 import{2,2}(:,10:12)];
    
    for i = 1:height(import{6,2})
        
        %compare team abbrev
        compare_team = strcmpi(import{2,2}.team, import{1,2}.team_abbrev(i)); 
        row_team = find(compare_team == 1);
        
        %compare opp abbrev
        compare_opp = strcmpi(import{2,2}.opponent, import{1,2}.team_abbrev(i));
        row_opp = find(compare_opp == 1);
        
        %compare team name
        compare_nba = strcmpi(import{6,2}.team_name, import{1,2}.team(i)); 
        row_nba = find(compare_nba == 1);
        
        import{2,2}.(9)(row_team) = import{6,2}.team_id(row_nba); %assigne team id
        import{2,2}.(11)(row_opp) = import{6,2}.team_id(row_nba); %assign opp id
        
    end
    
    clear temp temp1 i row_nba row_opp row_team compare_team compare_opp compare_nba
    
%SECTION A.6
    %import data workspace
    import_positions = import{1,2}.position(1:5);


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
    %prepare analysis for lineup optimization
    num_players = height(import{2,2});
    analysis_players = [import{2,2}(:,[1:5,7, 9:12])];
    
    temp = array2table(zeros(num_players,5));
    temp.Properties.VariableNames = {'injury_rating', 'rating_total', 'opp_team_rating',...
                                     'opp_team_position_rating','minutes_rating'};
    analysis_players = [analysis_players temp];
    
    clear temp
    
%SECTION B.1
    %Calculate opponent team fantasy points allowed by team and 
    %player position
    analysis_team

    %assign opposing team analysis to specific players
    for i = 1:num_players
        
        %transfer opposing team rating
        compare_team_id = eq(analysis_teams{1,2}.team_id, analysis_players.opp_id(i));
        row_team = find(compare_team_id == 1);
        analysis_players.opp_team_rating(i) = analysis_teams{1,2}.team_rating(row_team);
        
        %transfer opposing team rating for a specific position
        [analysis_players] = opp_position_rating(analysis_teams, analysis_players, row_team, i);       
    end
    
    clear i row_team compare_team_id temp     
    
%SECTION B.3
    %assign rating for injuries
    %1 - good to play
    %2 - out of game
    
    for i = 1:num_players
        if strcmp(import{2,2}.injuryindicator(i), 'O') == 1 
            analysis_players.injury_rating(i) = 2;
            
        elseif strcmp(import{2,2}.injuryindicator(i), 'IR') == 1
            analysis_players.injury_rating(i) = 2;
        
        elseif strcmp(import{2,2}.injuryindicator(i), 'NA') == 1
            analysis_players.injury_rating(i) = 2;
        
        else 
            analysis_players.injury_rating(i) = 1;
        end
    end
    
    
    
    
    
    
    
    
    


    
%SECTION B.11
    %sum rating for each player 
    
    rating_multiplier = [1];%opponent team position rating
                  
    

%SECTION B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION C
%This section runs lineup optimization
   
      
%SECTION C.5
    %Export workspace variables to .mat file
    save(['/Users/ccm/Documents/Fantasy_Basketball/export/ex_workspace_variables'])


%SECTION C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%