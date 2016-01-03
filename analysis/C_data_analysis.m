%C_data_analysis
    %run this script after running B_import to clean up the data and analyze it    
    clearvars -except import_orig
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION A
    %This section cleans up data in preparation for analysis

%SECTION A.1
    %This section holds all variables that can be changed for teh analysis
    
    %VARIABLE 1: Number of players at each position to analyze
    players_to_analize = 15;
    
    %VARIABLE 2: number of top players to consider
    number_top_players = 10;
    
    %VARIABLE 3: number of lineups of top players to create
    number_top_lineups = 10;
    
    %VARIABLE 4: Analysis Multiplier
        %Tier 1: 1
        %Tier 2: 2
    multiplier = [3,... %minutes season
                  2,... %fppg season
                  1,... %opponent position fppg allowed season
                  1,... %Team pace
                  1,... %Opponent pace
                  1,... %Home or away
                  ];
              
                 
                 
%SECTION A.2
    %save original import data
    import = import_orig;
    
%SECTION A.3    
    %create variables from import data
    import_scoring = import{1,2}(1,1:10);
    import_positions = import{1,2}.position(1:5);

      
%SECTION A.4
    %Delete injured players from Fanduel cell
    num_players = height(import{2,2});
    
    for i = 1:num_players
        if strcmp(import{2,2}.injuryindicator(i), 'O') == 1 
            del(i) = i;
            
        elseif strcmp(import{2,2}.injuryindicator(i), 'IR') == 1
            del(i) = i;
        
        elseif strcmp(import{2,2}.injuryindicator(i), 'NA') == 1
            del(i) = i;
        end
    end
    
    del = del(del~=0);
    import{2,2}(del,:) = [];
    
    %Teams playing that night abbreviation
    import_teams = unique(import{2,2}.team);
    
    clear i del

    
%SECTION A.5
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
    
    
%SECTION A.6    
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
        temp1 = strsplit(import{2,2}.lastname{i});
        compare_lastname = strcmpi(temp1(end), player_names(:,2));
        row_lastname = find(compare_lastname == 1);
        
        %Look for similar first names
        temp1 = strsplit(import{2,2}.firstname{i});
        compare_firstname = strcmpi(temp1(1), player_names(:,1));
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
        
%SECTION A.7
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
            
    variables = {'home_away',...
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
    analysis_players{1,4} = 'Players To Consider';
    
    %delete players for whom there is no data on nba.com
    for i = 1:import_nodata
        
        del(i) = find(import{2,2}.player_id == i);
    end
    analysis_players{2,2}(del,:) = [];
    
    clear temp i del num_players variables import_nodata
    
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
    %calculate price per fantasy point    
    analysis_players{2,2}.price_per_fp_sea = analysis_players{2,2}.salary./analysis_players{2,2}.fppg;
    
%SECTION B.4
    %assign minutes per game   
    analysis_players{2,2}.min_sea = comp_trans(import{5,2}.player_id, analysis_players{2,2}.player_id, import{5,2}.min);
   
%SECTION B.5
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
    
%SECTION B.6
    %calculate minutes for previous 3 games    
    analysis_players{2,2}.min_3g = comp_trans(import{11,2}.player_id, analysis_players{2,2}.player_id, import{11,2}.min);
    
%SECTION B.7
    %calculate price per fantasy point    
    analysis_players{2,2}.price_per_fp_3g = analysis_players{2,2}.salary./analysis_players{2,2}.fppg_3g;
       
%Section B.8
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

%Section B.9
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
  
    %Variables to compare selected from analysis_players{2,2}
    variables = {'total',...
                 'min_sea',...
                 'fppg_sea',...
                 'opp_team_fppg_position_sea',...
                 'team_pace_sea',...
                 'opp_pace_sea',...
                 'home_away',...
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
    
    %Home_Away rating
    analysis_players{2,3}.home_away = analysis_players{2,2}.home_away;
    
    %Impliment Point Multiplier
    for i = 1:size(analysis_players{2,3},1)
        
       analysis_players{2,3}{i,[9:end]} = analysis_players{2,3}{i,[9:end]}.* multiplier; 
    end
    
    %calculate player rating total    
    analysis_players{2,3}.total = sum(analysis_players{2,3}{:,[9:end]},2);
    
    %Sort by total rating descending
    analysis_players{2, 3} = sortrows(analysis_players{2, 3},'total','descend');

    clear num_rows temp row variables rating_pace

%SECTION C.2    
    %organize players by position
    
    %Select players and create new cell for analysis
    %Sorted by position
    for j = 1:5
        analysis_players{j+3,1} = import_positions{j};
        row = find(strcmp(analysis_players{2,2}.position, import_positions{j}) == 1);
        analysis_players{j+3,2} = analysis_players{2,2}(row,:);

        row = find(strcmp(analysis_players{2,3}.position, import_positions{j}) == 1);
        analysis_players{j+3,3} = analysis_players{2,3}(row,:);  
    end
    
    clear j row 
     
% %SECTION C.3
    %select top players for lineup analysis
    for j = 1:5
        if height(analysis_players{3+j,3}) > players_to_analize
            analysis_players{3+j,4} = analysis_players{3+j,3}(1:players_to_analize,:);
        
        else 
            analysis_players{3+j,4} = analysis_players{3+j,3}(1:end,:);
        end
    end
        
    clear compare row j players_to_analize

    
% %SECTION C.4
%     %export data to excel file
%     
%     cd('/Users/ccm/Documents/Fantasy_Basketball/export');
%     writetable(analysis_players{2,2},'ex_analysis_players.csv');
%     writetable(analysis_players{4,2},'ex_pg_rating.csv');
%     writetable(analysis_players{5,2},'ex_pf_rating.csv');
%     writetable(analysis_players{6,2},'ex_c_rating.csv');
%     writetable(analysis_players{7,2},'ex_sf_rating.csv');
%     writetable(analysis_players{8,2},'ex_sg_rating.csv');
%     cd('/Users/ccm/Documents/Fantasy_Basketball');
%SECTION C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%