%D_lineup_optimization
    %run this script after running C_data_analysis to produce the most optimal lineups
    clc
    clearvars -except import_orig analysis_players analysis_teams import import_nodata import_positions import_scoring import_teams
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION A
    %This section produces possible lineups to consider

%SECTION A.1
     %Create possible combinations of top players players   
    z = 0;
    for i = 1:height(analysis_players{3,3})-2
        temp = [analysis_players{3,2}(i+1:end,[1:2,5:6,9]) analysis_players{3,3}(i+1:end,4) analysis_players{3,2}(i+1:end,8)]; 
        for k = 1:size(temp,1)
            temp2 = [analysis_players{3,2}(i+1+k:end,[1:2,5:6,9]) analysis_players{3,3}(i+1+k:end,4) analysis_players{3,2}(i+1+k:end,8)];            
            for j = 1:size(temp2,1)
                
                fppg_total = analysis_players{3,2}.fppg(i)+temp.fppg(k)+temp2.fppg(j);
                salary_total = analysis_players{3,2}.salary(i)+temp.salary(k)+temp2.salary(j);
                rating_total = analysis_players{3,3}.total(i)+temp.total(k)+temp2.total(j);
                position = strcat(analysis_players{3,2}.position(i), temp.position(k), temp2.position(j));
                teams = strcat(analysis_players{3,2}.team(i), temp.team(k), temp2.team(j));   
                price_per_point = salary_total/rating_total;
                     
                z = z + 1;
                temp_lineups(z,:) = {fppg_total,...
                                     salary_total,...
                                     rating_total,...
                                     price_per_point,...
                                     position,...
                                     teams,...
                                     analysis_players{3,3}.player_id(i),...
                                     temp.player_id(k),...
                                     temp2.player_id(j)};                        
            end
        end     
    end
    
    %Conver to table
    temp_lineups = cell2table(temp_lineups); 
    temp_lineups.Properties.VariableNames = {'fppg',...
                                              'salary',...
                                              'rating',...
                                              'price_per_point',...
                                              'positions',...
                                              'teams',...
                                              'player1',...
                                              'player2',...
                                              'player3',...
                                               };
    
    clear fppg_total salary_total rating_total position teams i j k temp temp2 z price_per_point

%SECTION A.2
    %Delete any combinations that have too many position players
    row_del = zeros(size(temp_lineups,1),1); %rows to delete
    for i = 1:size(temp_lineups,1)

        %incorrect number of player positions
        c = strfind(temp_lineups.positions,import_positions{3,1});
        pg = strfind(temp_lineups.positions,import_positions{1,1});
        pf = strfind(temp_lineups.positions,import_positions{2,1});
        sf = strfind(temp_lineups.positions,import_positions{4,1});
        sg = strfind(temp_lineups.positions,import_positions{5,1});
        
        if length(c{1,1}) > 1
            row_del(i) = i;
            
        elseif length(pg{1,1}) > 2
            row_del(i) = i;
        
        elseif length(pf{1,1}) > 2
            row_del(i) = i;
            
        elseif length(sf{1,1}) > 2
            row_del(i) = i;  
            
         elseif length(sg{1,1}) > 2
            row_del(i) = i;              
        end 
    end
    
    row_del(row_del == 0) = [];
    temp_lineups(row_del,:) = [];
    
    clear row_del c pg sf pf sg i
    
%SECTION A.3   
    %select top rated lineup
    compare = eq(max(temp_lineups.rating),temp_lineups.rating);
    row = find(compare == 1);
    lineup = temp_lineups(row,:);
    
    %select top rated lineup for least amount of money
    compare = eq(min(lineup.salary),lineup.salary);
    row = find(compare == 1);
    analysis_lineup{1,2} = temp_lineups(row,:);
    analysis_lineup{1,1} = 'Possible Lineups';
    
    clear row compare lineup temp_lineups
    
%SECTION A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%SECTION B
    %create the best possible lineup
    
%SECTION B.1
    %Calculate needed player positions for a given lineup
   
    positions_needed = cell(size(analysis_lineup{1,2},1),5);
    analysis_lineup{2,2} = cell2table(positions_needed);
    analysis_lineup{2,2}.Properties.VariableNames = {'C',...
                                                  'PG',...
                                                  'PF',...
                                                  'SG',...
                                                  'SF'};
    analysis_lineup{2,1} = 'Needed Player Positions';                                         


    for i = 1:size(analysis_lineup{1,2},1)

        %calculate players at each position
        c = strfind(analysis_lineup{1,2}.positions,import_positions{3,1});
        pg = strfind(analysis_lineup{1,2}.positions,import_positions{1,1});
        pf = strfind(analysis_lineup{1,2}.positions,import_positions{2,1});
        sf = strfind(analysis_lineup{1,2}.positions,import_positions{4,1});
        sg = strfind(analysis_lineup{1,2}.positions,import_positions{5,1});

        analysis_lineup{2,2}.C = abs(length(c{1,1}) - 1);
        analysis_lineup{2,2}.PG = abs(length(pg{1,1}) - 2);
        analysis_lineup{2,2}.PF = abs(length(pf{1,1}) - 2);
        analysis_lineup{2,2}.SG = abs(length(sf{1,1}) - 2);
        analysis_lineup{2,2}.SF = abs(length(sg{1,1}) - 2);
    end

    clear i c pg pf sf sg positions_needed
   

%SECTION B.2
    %Calculate needed player positions for a given lineup    
    
    %Calculate necessary loop requirements for filling out the necessary
    %positions
    for i = 1:6
      position = find(eq(max(analysis_lineup{2,2}{1,:}),analysis_lineup{2,2}{1,:}));  
      
      if position(1) == 1
          loop(i,1) = size(analysis_players{6,4},1);
          loop(i,2) = 6;
          
      elseif position(1) == 2
          loop(i,1) = size(analysis_players{4,4},1);
          loop(i,2) = 4;
          
      elseif position(1) == 3
          loop(i,1) = size(analysis_players{5,4},1);
          loop(i,2) = 5;
      
      elseif position(1) == 4
          loop(i,1) = size(analysis_players{8,4},1);    
          loop(i,2) = 8;
        
      elseif position(1) == 5
          loop(i,1) = size(analysis_players{7,4},1);
          loop(i,2) = 7;
      end
      
      analysis_lineup{2,2}.(position(1)) = analysis_lineup{2,2}.(position(1)) - 1;
        
    end
    
    loop = sortrows(loop,2);
    

%SECTION A.2
    %Calculate possible lineups with remaining players
    z = 0;
    temp_lineups = cell(1,6);
    temp = [analysis_players{loop(1,2),4}(:,1:8)];     
    for a = 1:size(temp,1)
        
        comp = eq(loop(1,2),loop(2,2));
        if comp == 1
            temp1 = [analysis_players{loop(2,2),4}(1+a:end,1:8)]; 
        else
            temp1 = [analysis_players{loop(2,2),4}(:,1:8)];
        end
        
        for b = 1:size(temp1,1)

            comp = eq(loop(2,2),loop(3,2));
            if comp == 1
                temp2 = [analysis_players{loop(3,2),4}(b+1:end,1:8)]; 
            else
                temp2 = [analysis_players{loop(3,2),4}(:,1:8)];
            end 
                
            for c = 1:size(temp2,1)
                    
                comp = eq(loop(3,2),loop(4,2));
                if comp == 1
                    temp3 = [analysis_players{loop(4,2),4}(c+1:end,1:8)]; 
                else
                    temp3 = [analysis_players{loop(4,2),4}(:,1:8)];
                end 
                         
                for d = 1:size(temp3,1)
                   
                    comp = eq(loop(4,2),loop(5,2));
                    if comp == 1
                        temp4 = [analysis_players{loop(5,2),4}(d+1:end,1:8)]; 
                    else
                        temp4 = [analysis_players{loop(5,2),4}(:,1:8)];
                    end
                
                
                    for e = 1:size(temp4,1)
                       
                        comp = eq(loop(5,2),loop(6,2));
                        if comp == 1
                            temp5 = [analysis_players{loop(6,2),4}(e+1:end,1:8)]; 
                        else
                            temp5 = [analysis_players{loop(6,2),4}(:,1:8)];
                        end
                    
                        for f = 1:size(temp5,1)
                            
                            
%                             fppg_total = analysis_players{4,2}.fppg(a)+temp.fppg(b)+temp2.fppg(c)+...
%                                        temp3.fppg(d)+temp4.fppg(e)+temp5.fppg(f);
%                             salary_total = analysis_players{4,2}.salary(a)+temp.salary(b)+temp2.salary(c)+...
%                                        temp3.salary(d)+temp4.salary(e)+temp5.salary(f);
%                             rating_total = analysis_players{4,3}.total(a)+temp.total(b)+temp2.total(c)+...
%                                        temp3.total(d)+temp4.total(e)+temp5.total(f);
%                             position = strcat(analysis_players{4,2}.position(a), temp.position(b), temp2.position(c),...
%                                         temp3.position(d),temp4.position(e),temp5.position(f));
%                             teams = strcat(analysis_players{4,2}.team(a), temp.team(b), temp2.team(c),...
%                                         temp3.team(d),temp4.team(e),temp5.team(f));  
% 
%                             fppg_total = fppg_total + temp_lineups{i,1};
%                             salary_total = salary_total + temp_lineups{i,2};
%                             rating_total = rating_total + temp_lineups{i,3};
%                             position = strcat(position, temp_lineups{i,4});
%                             teams = strcat(teams, temp_lineups{i,5});

                            z = z + 1;
%                             temp_lineups(z,:) = [fppg_total,...
%                                                  salary_total,...
%                                                  rating_total,...
%                                                  position,...
%                                                  teams,...
%                                                  temp_lineups(i,6:8),...
                            temp_lineups(z,:) = {temp.player_id(a),...
                                                 temp.player_id(b),...
                                                 temp2.player_id(c),...
                                                 temp3.player_id(d),...
                                                 temp4.player_id(e),...
                                                 temp5.player_id(f)};    
                        end
                    end
                end
            end
        end
    end   
    
    
    
    
    
    
    
    
    
    
%SECTION B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION C
    %This section delete lineups that do not meet necessary restrictions
    
    row_del = zeros(size(temp_lineups,1),1); %rows to delete
    for i = 1:size(temp_lineups,1)

        %incorrect number of player positions
        c = strfind(temp_lineups(i,4),import_positions{3,1});
        pg = strfind(temp_lineups(i,4),import_positions{1,1});
        pf = strfind(temp_lineups(i,4),import_positions{2,1});
        sf = strfind(temp_lineups(i,4),import_positions{4,1});
        sg = strfind(temp_lineups(i,4),import_positions{5,1});
        
        if length(c{1,1}) > 1
            row_del(i) = i;
            
        elseif length(pg{1,1}) > 2
            row_del(i) = i;
        
        elseif length(pf{1,1}) > 2
            row_del(i) = i;
            
        elseif length(sf{1,1}) > 2
            row_del(i) = i;  
            
         elseif length(sg{1,1}) > 2
            row_del(i) = i;              
        end 
        
        
        %delete rows that are above salary cap or below 50,000
        if temp_lineups{i,2} > import_scoring.salary_cap
           row_del(i) = i;
           
        else if temp_lineups{i,2} < 50000
           row_del(i) = i;
            end
        end
        
        %delete rows with more than 4 players from one team
        for j = 1:length(import_teams)
            team = strfind(temp_lineups(i,5),import_teams{j,1});
            
            if length(team{1,1}) > 4
                row_del(i) = i;
            end
        end        
    end
    
    %Delete inelligible rows
    row_del(row_del == 0) = [];
    temp_lineups(row_del,:) = [];
    
    clear temp i j team sg sf pf pg c row_del row 





% %SECTION C.5
    %Export workspace variables to .mat file
    save(['/Users/ccm/Documents/Fantasy_Basketball/export/ex_workspace_variables'])


%SECTION C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
