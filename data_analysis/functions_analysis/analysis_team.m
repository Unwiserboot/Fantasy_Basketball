%SECTION B.1
    %Calculate opponent difficulty by team and position
    

    %final output file for team analysis 
    num_teams = height(import{7,2});
    analysis_teams = cell(5,2);
    analysis_teams{1,1} = 'opposing team rating';
    analysis_teams{2,1} = 'opposing team fantasy points';
    analysis_teams{3,1} = 'opposing team forward fantasy points';
    analysis_teams{4,1} = 'opposing team center fantasy points';
    analysis_teams{5,1} = 'opposing team guard fantasy points';
    
    analysis_teams{1,2} = cell2table(cell(height(import{7,2}),2));
    analysis_teams{1,2}.Properties.VariableNames = {'team_id', 'team_name'};
    temp8 = array2table(zeros(num_teams,4));
    temp8.Properties.VariableNames = {'team_rating','forward_rating','center_rating','guard_rating'};
    analysis_teams{1,2} = [analysis_teams{1,2} temp8];
    analysis_teams{1,2}.team_id = team_names.team_id;
    analysis_teams{1,2}.team_name = team_names.team_name;
    
    analysis_teams{2,2} = cell2table(cell(height(import{7,2}),2));
    analysis_teams{2,2}.Properties.VariableNames = {'team_id', 'team_name'};
    temp8 = array2table(zeros(length(unique(import{7,2}.team_id)),9));
    temp8.Properties.VariableNames = {'total', 'opp_blocks', 'opp_assists', 'opp_turnovers',...
                                      'opp_steals', 'opp_free_throw', 'opp_rebounds',...
                                      'opp_3pt', 'opp_2pt'}; 
                                      
                                  
    analysis_teams{2,2} = [analysis_teams{2,2} temp8];
    
    analysis_teams{2,2}.team_id = team_names.team_id;
    analysis_teams{2,2}.team_name = team_names.team_name;
    analysis_teams{3,2} = analysis_teams{2,2};
    analysis_teams{4,2} = analysis_teams{2,2};
    analysis_teams{5,2} = analysis_teams{2,2};

   
    temp_multiplier = [scoring.blocked_shots;... %blocks
                       scoring.assists;...       %assists
                       scoring.turnovers;...     %turnovers
                       scoring.steals;...        %steals
                       scoring.free_throw;...    %free throw
                       scoring.rebounds;...      %rebounds
                       scoring.three_point;...   %3 pts 
                       scoring.two_point];       %2 pts  

                     
    
    
    %Metrics to analyze   
    for n = 1:4 %Number of team data files to analyze
    
        temp5 = import{n+6,2}.(8) - import{n+6,2}.(11); %opponent 2 pts made        
        
        %[importrow importcolumn metricindex metrictype analysisindex]
        data = {import{n+6,2}.(23) 4;...%opponent blocks
                import{n+6,2}.(20) 5;...%opponent assists
                import{n+6,2}.(21) 6;...%opponent turnovers
                import{n+6,2}.(22) 7;...%opponent steals
                import{n+6,2}.(14) 8;...%opponent free throw made                
                import{n+6,2}.(19) 9;...%opponent rebounds
                import{n+6,2}.(11) 10;...%opponenet 3pts mad
                temp5 11};                          %opponent 2 pts made      
        
               
        for i = 1:num_teams
            
            total = 0;
            for j = 1:length(temp_multiplier)
            
                compare_team_id = eq(import{n+6,2}.team_id(i), analysis_teams{n+1,2}.team_id);
                row_team_name = find(compare_team_id == 1);
                analysis_teams{n+1,2}.(data{j,2})(row_team_name) = data{j,1}(i)*temp_multiplier(j);
                
                total = total + data{j,1}(i)*temp_multiplier(j);              
            end
  
            analysis_teams{n+1,2}.total(i) = total;            
        end        
        
        analysis_teams{1,2}.(n+2) = team_rating(analysis_teams{n+1,2}.total);
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   