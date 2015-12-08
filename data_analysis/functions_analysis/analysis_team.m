%SECTION B.1
    %Calculate opponent difficulty by team and position
    

    %final output file for team analysis 
    num_teams = height(import{7,2});
    analysis = cell(5,2);
    analysis{1,1} = 'opposing team rating';
    analysis{2,1} = 'opposing team';
    analysis{3,1} = 'opposing team forward';
    analysis{4,1} = 'opposing team center';
    analysis{5,1} = 'opposing team guard';
    
    analysis{1,2} = cell2table(cell(height(import{7,2}),2));
    analysis{1,2}.Properties.VariableNames = {'team_id', 'team_name'};
    temp8 = array2table(zeros(num_teams,4));
    temp8.Properties.VariableNames = {'team_rating','center_rating','forward_rating','guard_rating'};
    analysis{1,2} = [analysis{1,2} temp8];
    analysis{1,2}.team_id = team_names.team_id;
    analysis{1,2}.team_name = team_names.team_name;
    
    analysis{2,2} = cell2table(cell(height(import{7,2}),2));
    analysis{2,2}.Properties.VariableNames = {'team_id', 'team_name'};
    temp8 = array2table(zeros(length(unique(import{7,2}.team_id)),13));
    temp8.Properties.VariableNames = {'blocks', 'opp_blocks', 'opp_assists',...
                                      'turn_overs','opp_turn_overs','steals',... 
                                      'opp_steals','opp_fta','opp_ftper',... 
                                      'opp_rebounds','rebounds','opp_fga',... 
                                      'opp_fgper'};
                                  
    analysis{2,2} = [analysis{2,2} temp8];
    
    analysis{2,2}.team_id = team_names.team_id;
    analysis{2,2}.team_name = team_names.team_name;
    analysis{3,2} = analysis{2,2};
    analysis{4,2} = analysis{2,2};
    analysis{5,2} = analysis{2,2};
    
    
    
    %Metrics to analyze   
    for n = 1:4
    
        import_files = [7 8 9 10];
        
        %[importrow importcolumn metricindex metrictype analysisindex]
        metrics = [6 2 23 1 3;...               %blocks
                   import_files(n) 2 23 2 4;... %opponent blocks
                   import_files(n) 2 20 2 5;... %opponent assists
                   6 2 21 2 6;...               %turn overs
                   import_files(n) 2 21 1 7;... %opponent turnovers
                   6 2 22 1 8;...               %steals
                   import_files(n) 2 22 2 9;... %opponent steals
                   import_files(n) 2 15 2 10;...%opponent free throw attempt
                   import_files(n) 2 16 2 11;...%opponent free throw percentage
                   import_files(n) 2 19 2 12;...%opponent rebounds
                   6 2 19 1 13;...              %rebounds
                   import_files(n) 2 9 2 14;... %opponenet field goal attempts
                   import_files(n) 2 10 2 15];  %opponent field goal percentage 
                    

        

        for k = 1:size(metrics,1)       

            metric = import{metrics(k,1),2}.(metrics(k,3));

            rating = team_rating(metric, metrics(k,4), num_teams);
            rating = {import{metrics(k,1),2}.team_id rating};
            analysis_file = [2 3 4 5];
            
            %transfer to analysis table
            for i = 1:height(import{metrics(k,1),2})

                compare_team_id = eq(rating{1,1}(i), analysis{analysis_file(n),2}.team_id);
                row_team_name = find(compare_team_id == 1);
                analysis{analysis_file(n),2}.(metrics(k,5))(row_team_name) = rating{1,2}(i);

            end
        end
    end
    

      temp_multiplier = [scoring.blocked_shots;...              %blocks
                         scoring.blocked_shots;... %opponent blocks
                         scoring.assists;... %opponent assists
                         scoring.turnovers;...               %turn overs
                         scoring.turnovers;... %opponent turnovers
                         scoring.steals;...               %steals
                         scoring.steals;... %opponent steals
                         scoring.free_throw;...%opponent free throw attempt
                         scoring.free_throw;...%opponent free throw percentage
                         scoring.rebounds;...%opponent rebounds
                         scoring.rebounds;...              %rebounds
                         2.5;... %opponenet field goal attempts
                         2.5];  %opponent field goal percentage   
    
    
                     
    for j = 1:4
        
        for i = 1:num_teams
            
          compare_team_id = eq(analysis{j+1,2}.team_id(i), analysis{1,2}.team_id);
          row = find(compare_team_id == 1);
          analysis{1,2}.(j+2)(row) = analysis{j+1,2}{i,3:end}*temp_multiplier;  

        end
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   