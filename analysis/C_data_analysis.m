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
    
%SECTION A.2    
    %create variables from import data
    import_scoring = import{1,2}(1,1:10);
    import_positions = import{1,2}.position(1:5);
    import_teams = unique(import{2,2}.team);
    
%SECTION A.3
    %make team abbreviation in fandual table the same as NBA.com data
    %need to check for incorrect abbreviation in fanduel spreadsheet on a
    %given night
    for i = 1:2
        compare_abbrev = strcmpi(import{2,2}.(i+8), 'NO'); %New Orleans
        row = find(compare_abbrev == 1);
        import{2,2}.(i+8)(row) = {'NOP'};

        compare_abbrev = strcmpi(import{2,2}.(i+8), 'PHO'); %Phonenix
        row = find(compare_abbrev == 1);
        import{2,2}.(i+8)(row) = {'PHX'};
        
        compare_abbrev = strcmpi(import{2,2}.(i+8), 'SA'); %San Antonio
        row = find(compare_abbrev == 1);
        import{2,2}.(i+8)(row) = {'SAS'};
        
        compare_abbrev = strcmpi(import{2,2}.(i+8), 'NY'); %New York
        row = find(compare_abbrev == 1);
        import{2,2}.(i+8)(row) = {'NYK'};
        
        compare_abbrev = strcmpi(import{2,2}.(i+8), 'GS'); %Golden State
        row = find(compare_abbrev == 1);
        import{2,2}.(i+8)(row) = {'GSW'};

        compare_abbrev = strcmpi(import{2,2}.(i+8), 'SA'); %San Antonio
        row = find(compare_abbrev == 1);
        import{2,2}.(i+8)(row) = {'SAS'};
    end
    
    clear i row compare_abbrev
    
    
%SECTION A.4    
    %replace fanduel player id number with nba.com player id number
        
    %split player first and last names from reg_sea_player_trad
    %into separate columns 
    temp = import{5,2}.player_name;
    
    %separate first and last names from NBA player data
    for i = 1:length(temp)

        temp1 = strsplit(temp{i});

        if length(temp1) > 2
            
            %throw away middle name  
            player_names(i,:) = {temp1{1,1},temp1{1,end}};
        else

            player_names(i,:) = temp1;          
        end
    end
    
    import_nodata = 0; %initialize variable
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
        
        %output message if no data is available for a player, usually a new
        %player or coming back from injury
        if isempty(row_lastname) == 1 & isempty(row_firstname) == 1  %no first or last name identified          
            display(['No data available for' import{2,2}.firstname(i) import{2,2}.lastname(i)])
            import_nodata = import_nodata+1;
            import{2,2}.player_id(i) = import_nodata; %assigne dummy player id for players with no data
        
        elseif length(find(rows == row_trad)) == 1 %address scenario where team name and player name do not agree
            display(['No data available for' import{2,2}.firstname(i) import{2,2}.lastname(i)])
            import_nodata = import_nodata+1;
            import{2,2}.player_id(i) = import_nodata; %assigne dummy player id for players with no data
        
        else            
            import{2,2}.player_id(i) = import{5,2}.player_id(row_trad); %Change number in im_fandual player id
                                                                        %to id from im_reg_sea_trad                                                               
        end      
    end
    
    %check for duplicate player ids and output message
    unique_ids = unique(import{2,2}.player_id);
    num_unique = size(unique_ids,1);
    num_players = size(import{2,2}.player_id,1);
    
    if num_players == num_unique
    else
        
        error('There are duplicate player ID numbers')
    end
   
    clear temp i player_names row_lastname row_firstname row_trad row_team rows...
          compare_firstname compare_lastname num_players num_unique unique_ids...
          compare_team temp1
        
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
      
%SECTION A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION B
%This section collects data from various spread sheets and organizes it in analysis_players{2,2}.

%SECTION B.1
    %organize players with relevant data
    num_players = height(import{2,2});
    analysis_players = cell(8,3);
            
    variables = {'injury_rating',...
                 'home_away',...
                 'min_sea'...
                 'price_per_fp_sea',...
                 'fppg_3g',...
                 'min_3g',...
                 'price_per_fp_3g',...
                 'opp_team_fp_allowed_sea',...
                 'opp_team_position_fp_allowed_sea',...
                 'team_pace_sea',...
                 'opp_pace_sea'};
    temp = array2table(zeros(num_players,length(variables)));                            
    temp.Properties.VariableNames = variables;
                                 
    analysis_players{2,2} =[import{2,2}(:,[1:5,7:12]) temp];
    analysis_players{2,1} = 'All Players';
    analysis_players{1,2} = 'Data';
    analysis_players{1,3} = 'Ratings';
    analysis_players{1,4} = 'Positive Rating';
    
    %delete players for whom there is no data on nba.com
    for i = 1:import_nodata
        
        del(i) = find(import{2,2}.player_id == i);
    end
    analysis_players{2,2}(del,:) = [];
    
    clear temp i del num_players variables
    
%SECTION B.2
    %Calculate opponent team fantasy points allowed by team and 
    %player position
    analysis_team
    num_players = height(analysis_players{2,2});
    
    %assign opposing team fp allowed to each players
    for i = 1:num_players
        
        %transfer opposing team rating
        compare_team_id = eq(analysis_teams{2,2}.team_id, analysis_players{2,2}.opp_id(i));
        row_team = find(compare_team_id == 1);
        analysis_players{2,2}.opp_team_fp_allowed_sea(i) = analysis_teams{2,2}.total_fp_allowed(row_team);
        
        %transfer opposing team fantasy points for a specific position
        analysis_players{2,2} = opp_position(analysis_teams, analysis_players{2,2}, row_team, i);       
    end
    
    clear i row_team compare_team_id temp num_players
    
%SECTION B.3
    %assign rating for injuries
    %1 - good to play
    %2 - out of game
    num_players = height(analysis_players{2,2});
    
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
    analysis_players{2,2}.price_per_fp_sea = analysis_players{2,2}.salary./analysis_players{2,2}.fppg;
    
%SECTION B.5
    %assign minutes per game   
    analysis_players{2,2}.min_sea = comp_trans(import{5,2}.player_id, analysis_players{2,2}.player_id, import{5,2}.min);
   
%SECTION B.6
    %calculate player previous 3 game fppg
    num_players = height(import{11,2});
    temp_multiplier = [import_scoring.blocks,...        %blocks
                       import_scoring.assists,...       %assists
                       import_scoring.turnovers,...     %turnovers
                       import_scoring.steals,...        %steals
                       import_scoring.free_throw,...    %free throw
                       import_scoring.rebounds,...      %rebounds
                       import_scoring.three_point,...   %3 pts 
                       import_scoring.two_point];       %2 pts 
    
    temp = import{11,2}(:,1); %player id
    temp2 = array2table(zeros(num_players,1)); 
    fppg_3g = [temp temp2];
        
    temp_data = [import{11,2}.blk,...                   %blocks
                 import{11,2}.ast,...                   %assists
                 import{11,2}.tov,...                   %turnovers
                 import{11,2}.stl,...                   %steals
                 import{11,2}.ftm,...                   %free throw
                 import{11,2}.reb,...                   %rebounds
                 import{11,2}.fg3m,...                  %3 pts 
                 import{11,2}.fgm - import{11,2}.fg3m]; %2 pts 
     
     for i = 1:num_players         
         
         fppg_3g{i,2} = sum(temp_data(i,:).*temp_multiplier);                 
     end

      
     
     %transfer data to analysis_player{2,2}
     rows =  size(analysis_players{2,2},1);
     for i = 1:rows
        compare = eq(fppg_3g{:,1}, analysis_players{2,2}.player_id(i));
        row = find(compare == 1);
        
        if isempty(row) == 1
            dest_data(i) = 0;
            
        else
            analysis_players{2,2}.fppg_3g(i) = fppg_3g{row,2};
     
        end
     end
    
     clear i rows row dest_data fppg_3g compare temp temp2 temp_data...
           temp_multiplier num_players
    
%SECTION B.7
    %calculate minutes for previous 3 games    
    analysis_players{2,2}.min_3g = comp_trans(import{11,2}.player_id, analysis_players{2,2}.player_id, import{11,2}.min);
    
%SECTION B.8
    %calculate price per fantasy point    
    analysis_players{2,2}.price_per_fp_3g = analysis_players{2,2}.salary./analysis_players{2,2}.fppg_3g;
       
%Section B.9
    %indicate whether home or away
    % 1 - home
    % -1 - away
        
    home = strncmp(analysis_players{2,2}.game, analysis_players{2,2}.team,3);
    rows = find(home == 1);
    analysis_players{2,2}.home_away(rows) = 1;   

    away = strncmp(analysis_players{2,2}.game, analysis_players{2,2}.opponent,3);
    rows = find(away == 1);
    analysis_players{2,2}.home_away(rows) = -1;  

    clear home away rows

%Section B.10
    %team pace season
    
    analysis_players{2,2}.team_pace_sea = comp_trans(import{13,2}.team_id, analysis_players{2,2}.team_id,import{13,2}.pace);
    analysis_players{2,2}.opp_pace_sea = comp_trans(import{13,2}.team_id, analysis_players{2,2}.opp_id,import{13,2}.pace);
    
    


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
    %calculate ratings for all players
    
    %Remove injured players from list
    row = find(analysis_players{2,2}.injury_rating == 2);
    analysis_players{2,2}(row,:) = [];
  
    %Variables to compare selected from analysis_players{2,2}
    variables = {'total',...
                 'min_sea',...
                 'fppg_sea',...
                 'opp_team_fppg_position_sea',...
                 'team_pace_sea',...
                 'opp_pace_sea',...
                  };
    
    num_rows = size(analysis_players{2,2},1);
    temp = array2table(zeros(num_rows,length(variables)));
    temp.Properties.VariableNames = variables;
    analysis_players{2,3} = [analysis_players{2,2}(:,[1:6,9]) temp];
    
    %Calcualte season minutes ratings
    analysis_players{2,3}.min_sea = variable_rating(analysis_players{2,2}.min_sea);

    %Calcualte season ffpg ratings
    analysis_players{2,3}.fppg_sea = variable_rating(analysis_players{2,2}.fppg);
  
    %calculate opposing team position fantasy points allowed rating
    analysis_players{2,3}.opp_team_fppg_position_sea = comp_trans_opp_pos(num_rows, analysis_teams{1,2}.team_id, analysis_players{2,2}.opp_id, analysis_teams{1,2}, analysis_players{2,2}.position);

    %Calculate team/opp pace rating
    rating_pace = team_rating(import{13,2}.pace);
    analysis_players{2,3}.team_pace_sea = comp_trans(import{13,2}.team_id, analysis_players{2,2}.team_id, rating_pace);
    analysis_players{2,3}.opp_pace_sea = comp_trans(import{13,2}.team_id, analysis_players{2,2}.opp_id, rating_pace);    

    
    %calculate player rating total    
    analysis_players{2,3}.total = sum(analysis_players{2,3}{:,[8:end]},2);
    
    %Sort by total rating descending
    analysis_players{2, 3} = sortrows(analysis_players{2, 3},'total','descend');

    clear num_rows temp row variables rating_pace

%SECTION C.2    
    %organize players by position
    
    %Select players and create new cell for analysis
    %Uninjured, sorted by position
    for j = 1:5
        analysis_players{j+3,1} = import_positions{j};
        row = find(strcmp(analysis_players{2,2}.position, import_positions{j}) == 1);
        analysis_players{j+3,2} = analysis_players{2,2}(row,:);

        row = find(strcmp(analysis_players{2,3}.position, import_positions{j}) == 1);
        analysis_players{j+3,3} = analysis_players{2,3}(row,:);  
    end
    
    clear j row 
     
% %SECTION C.3
    %delete players with negative rating
    for j = 1:5
        row = find(analysis_players{3+j,3}.total>=0);
        analysis_players{3+j,4} = analysis_players{3+j,3}(row,:);
    end
    
    
    clear compare row j


    
%SECTION C.4
    %export data to excel file
    
    cd('/Users/ccm/Documents/Fantasy_Basketball/export');
    writetable(analysis_players{2,2},'ex_analysis_players.csv');
    writetable(analysis_players{4,2},'ex_pg_rating.csv');
    writetable(analysis_players{5,2},'ex_pf_rating.csv');
    writetable(analysis_players{6,2},'ex_c_rating.csv');
    writetable(analysis_players{7,2},'ex_sf_rating.csv');
    writetable(analysis_players{8,2},'ex_sg_rating.csv');
    cd('/Users/ccm/Documents/Fantasy_Basketball/analysis');
%SECTION C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%