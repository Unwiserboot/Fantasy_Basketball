%SECTION B.1
    %Calculate opponent team fantasy points allowed by team and 
    %player position

    %final output file for team analysis 
    num_teams = height(import{7,2});
    analysis_teams = cell(5,2);
    analysis_teams{1,1} = 'opposing team rating';
    analysis_teams{2,1} = 'opposing team fantasy points';
    analysis_teams{3,1} = 'opposing team forward fantasy points';
    analysis_teams{4,1} = 'opposing team center fantasy points';
    analysis_teams{5,1} = 'opposing team guard fantasy points';
    
    analysis_teams{1,2} = import{6,2};
    analysis_teams{1,2}(:,[3:end]) = [];   
    temp = array2table(zeros(num_teams,4));
    temp.Properties.VariableNames = {'team_rating','forward_rating','center_rating','guard_rating'};
    analysis_teams{1,2} = [analysis_teams{1,2} temp];
    
    analysis_teams{2,2} = import{6,2};
    analysis_teams{2,2}(:,[3:end]) = []; 
    
    temp = array2table(zeros(num_teams,9));
    temp.Properties.VariableNames = {'total_fp_allowed', 'opp_blocks', 'opp_assists', 'opp_turnovers',...
                                      'opp_steals', 'opp_free_throw', 'opp_rebounds',...
                                      'opp_3pt', 'opp_2pt'}; 
                                      
    analysis_teams{2,2} = [analysis_teams{2,2} temp];
    
    for i = 1:3
    
        analysis_teams{i+2,2} = analysis_teams{2,2};   
    end
   
    temp_multiplier = [import_scoring.blocks;...        %blocks
                       import_scoring.assists;...       %assists
                       import_scoring.turnovers;...     %turnovers
                       import_scoring.steals;...        %steals
                       import_scoring.free_throw;...    %free throw
                       import_scoring.rebounds;...      %rebounds
                       import_scoring.three_point;...   %3 pts 
                       import_scoring.two_point];       %2 pts  
    
    %Metrics to analyze   
    for n = 1:4 %Number of team data files to analyze
    
        temp = import{n+6,2}.opp_fgm - import{n+6,2}.opp_fg3m; %opponent 2 pts made        
        
        %[datacolumn ]
        data = {import{n+6,2}.opp_blk 4;...  %opponent blocks
                import{n+6,2}.opp_ast 5;...  %opponent assists
                import{n+6,2}.opp_tov 6;...  %opponent turnovers
                import{n+6,2}.opp_stl 7;...  %opponent steals
                import{n+6,2}.opp_ftm 8;...  %opponent free throw made                
                import{n+6,2}.opp_reb 9;...  %opponent rebounds
                import{n+6,2}.opp_fg3m 10;...%opponenet 3pts mad
                temp 11};                      %opponent 2 pts made      
                   
        for i = 1:num_teams %calculate opponent fantasy points allowed by team
            
            total = 0;
            for j = 1:length(temp_multiplier)
                
                %compare team id for analysis_teams and import file
                compare_team_id = eq(import{n+6,2}.team_id(i), analysis_teams{n+1,2}.team_id);
                
                %find similar row
                row_team = find(compare_team_id == 1);
                
                %export data point to analysis_teams
                analysis_teams{n+1,2}.(data{j,2})(row_team) = data{j,1}(i)*temp_multiplier(j);
                
                total = total + data{j,1}(i)*temp_multiplier(j);              
            end
  
            analysis_teams{n+1,2}.total_fp_allowed(row_team) = total;            
        end        
        
        analysis_teams{1,2}.(n+2) = team_rating(analysis_teams{n+1,2}.total_fp_allowed);
    end
    
    clear num_teams temp i temp_multiplier n j data total
    