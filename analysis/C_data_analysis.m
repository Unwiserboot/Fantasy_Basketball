%C_data_analysis
    %run this script after running B_import to clean up the data and analyze it    
    clearvars -except import_orig
    clc
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION A
    %This section cleans up data in preparation for analysis

%SECTION A.1
    %save original import data
    import = import_orig;
    
%SECTION A.1    
    %create variables from import data
    import_scoring = import{1,2}(1,1:10);
    import_positions = import{1,2}.position(1:5);
    import_teams = unique(import{2,2}.team);

    
%SECTION A.2
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
    
%SECTION A.3    
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
        
%SECTION A.4
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
    

    
%SECTION A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION B
%This section collects and organizes data in analysis_players{2,2}.

%SECTION B.1
    %organize players with relevant data
    num_players = height(import{2,2});
    analysis_players = cell(5,3);
        
    temp = array2table(zeros(num_players,5));
    temp.Properties.VariableNames = {'injury_rating', 'opp_team_fp_allowed',...
                                     'opp_team_position_fp_allowed','minutes'...
                                     'price_per_fp'};
    analysis_players{2,2} =[import{2,2}(:,[1:5,7, 9:12]) temp];
    analysis_players{2,1} = 'All Players';
    analysis_players{1,2} = 'Data';
    analysis_players{1,3} = 'Ratings';
    clear temp
    
%SECTION B.2
    %Calculate opponent team fantasy points allowed by team and 
    %player position
    analysis_team

    %assign opposing team fp allowed to specific players
    for i = 1:num_players
        
        %transfer opposing team rating
        compare_team_id = eq(analysis_teams{2,2}.team_id, analysis_players{2,2}.opp_id(i));
        row_team = find(compare_team_id == 1);
        analysis_players{2,2}.opp_team_fp_allowed(i) = analysis_teams{2,2}.total_fp_allowed(row_team);
        
        %transfer opposing team fantasy points for a specific position
        analysis_players{2,2} = opp_position(analysis_teams, analysis_players{2,2}, row_team, i);       
    end
    
    clear i row_team compare_team_id temp     
    
%SECTION B.3
    %assign rating for injuries
    %1 - good to play
    %2 - out of game
    
    for i = 1:num_players
        if strcmp(import{2,2}.injuryindicator(i), 'O') == 1 
            analysis_players{2,2}.injury_rating(i) = 2;
            
        elseif strcmp(import{2,2}.injuryindicator(i), 'IR') == 1
            analysis_players{2,2}.injury_rating(i) = 2;
        
        elseif strcmp(import{2,2}.injuryindicator(i), 'NA') == 1
            analysis_players{2,2}.injury_rating(i) = 2;
        
        else 
            analysis_players{2,2}.injury_rating(i) = 1;
        end
    end
    
    clear i
    
%SECTION B.4
    %calculate price per fantasy point    
    analysis_players{2,2}.price_per_fp = analysis_players{2,2}.salary./analysis_players{2,2}.fppg;
    
%SECTION B.5
    %assigne minutes per game   
    analysis_players{2,2}.minutes = comp_trans(num_players, import{5,2}.player_id, analysis_players{2,2}.player_id, import{5,2}.min);
   
%SECTION B.6
    %...
      

%SECTION B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION C
%This section organizes player data and ranks them in preparation for
%lineup optimization 
   
%SECTION C.1    
    %pick top three starters among all positions

    %Select players and create new cell for analysis
    %Salary above $8000 and uninjured
    analysis_players{3,1} = 'Pick Top Three';
    row = find(analysis_players{2,2}.salary >= 8000 & analysis_players{2,2}.injury_rating == 1);
    num_rows = length(row);
    analysis_players{3,2} = analysis_players{2,2}(row,:);

    %Variables to compare
    temp = array2table(zeros(num_rows,3));
    temp.Properties.VariableNames = {'total', 'minutes', 'opp_team_position'};

    analysis_players{3,3} = [analysis_players{3,2}(:,[1, 3:4]) temp];

    %incorporate opposing team position fantasy points allowed rating
    analysis_players{3,3}.opp_team_position = comp_trans_opp_pos(num_rows, analysis_teams{1,2}.team_id, analysis_players{3,2}.opp_id, analysis_teams{1,2}, analysis_players{3,2}.position);

    %Calcualte variable ratings
    analysis_players{3,3}.minutes = variable_rating(analysis_players{3,2}.minutes);

    %calculate player rating
    analysis_players{3,3}.total = sum(analysis_players{3,3}{:,[5:end]},2);

    clear num_rows temp row


%SECTION C.2    
    %Fill out the six remaining positions on the lineups
    
    %Select players and create new cell for analysis
    %Salary below $8000 and uninjured
    analysis_players{4,1} = 'Remaining Six';
    row = find(analysis_players{2,2}.salary < 8000 & analysis_players{2,2}.injury_rating == 1);
    num_rows = length(row);
    analysis_players{4,2} = analysis_players{2,2}(row,:);
    
    %Variables to compare
    temp = array2table(zeros(num_rows,3));
    temp.Properties.VariableNames = {'total', 'minutes', 'opp_team_position'};

    analysis_players{4,3} = [analysis_players{4,2}(:,[1, 3:4]) temp];

    %incorporate opposing team position fantasy points allowed rating
    analysis_players{4,3}.opp_team_position = comp_trans_opp_pos(num_rows, analysis_teams{1,2}.team_id, analysis_players{4,2}.opp_id, analysis_teams{1,2}, analysis_players{4,2}.position);

    %Calcualte variable ratings
    analysis_players{4,3}.minutes = variable_rating(analysis_players{4,2}.minutes);

    %calculate player rating
    analysis_players{4,3}.total = sum(analysis_players{4,3}{:,[5:end]},2);

    clear temp row num_rows num_players
      

      

%SECTION C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%