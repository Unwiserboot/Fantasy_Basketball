%D_lineup_optimization
    %run this script after running C_data_analysis to produce the most optimal lineups
    clc
    clearvars -except import_orig analysis_players analysis_teams import import_nodata import_positions import_scoring import_teams
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION A
    %This section produces possible lineups to consider
    number_top_three = 10;
    number_bot_six = 55;
%SECTION A.1
    %Create possible combinations of top ten players players   
    z = 0;
    top_players = analysis_players{2,3}(1:number_top_three,:);
    for i = 1:height(top_players)-2
        temp = [top_players(i+1:end,[1:2,5:8])]; 
        for k = 1:size(temp,1)
            temp2 = [top_players(i+k+1:end,[1:2,5:8])];
            for j = 1:size(temp2,1)
                
                fppg_total = top_players.fppg(i)+temp.fppg(k)+temp2.fppg(j);
                salary_total = top_players.salary(i)+temp.salary(k)+temp2.salary(j);
                rating_total = top_players.total(i)+temp.total(k)+temp2.total(j);
                position = strcat(top_players.position(i), temp.position(k), temp2.position(j));
                teams = strcat(top_players.team(i), temp.team(k), temp2.team(j));   
                price_per_point = salary_total/rating_total;
                     
                z = z + 1;
                temp3(z,:) = {fppg_total,...
                                     salary_total,...
                                     rating_total,...
                                     price_per_point,...
                                     position,...
                                     teams,...
                                     top_players.player_id(i),...
                                     temp.player_id(k),...
                                     temp2.player_id(j)};                        
            end
        end     
    end
    
    %Conver to table
    temp3 = cell2table(temp3); 
    temp3.Properties.VariableNames = {'fppg',...
                                              'salary',...
                                              'rating',...
                                              'price_per_point',...
                                              'positions',...
                                              'teams',...
                                              'player1',...
                                              'player2',...
                                              'player3',...
                                               };
    
    
%SECTION A.2
    %Delete any combinations that have too many position players
    row_del = zeros(size(temp3,1),1); %rows to delete
    for i = 1:size(temp3,1)

        %incorrect number of player positions
        c = strfind(temp3.positions,import_positions{3,1});
        pg = strfind(temp3.positions,import_positions{1,1});
        pf = strfind(temp3.positions,import_positions{2,1});
        sf = strfind(temp3.positions,import_positions{4,1});
        sg = strfind(temp3.positions,import_positions{5,1});
        
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
    temp3(row_del,:) = [];
    temp3 = sortrows(temp3,'rating','descend');
    

    
%SECTION A.3   
    analysis_lineup{1,2} = temp3(1:number_top_three,:);
    analysis_lineup{1,1} = 'Line Up Number 1';

    clear top players fppg_total salary_total temp3 rating_total position teams i j k temp temp2 z price_per_point pg pf sf sg top_players c row_del
    
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
    positions_needed = cell(number_top_three,5);
    analysis_lineup{2,2} = cell2table(positions_needed);
    analysis_lineup{2,2}.Properties.VariableNames = {'C',...
                                                  'PG',...
                                                  'PF',...
                                                  'SG',...
                                                  'SF'};
    analysis_lineup{2,1} = 'Needed Player Positions';                                         

    for i = 1:size(analysis_lineup{1,2},1)

        %calculate players at each position
        c = strfind(analysis_lineup{1,2}.positions{i},import_positions{3,1});
        pg = strfind(analysis_lineup{1,2}.positions{i},import_positions{1,1});
        pf = strfind(analysis_lineup{1,2}.positions{i},import_positions{2,1});
        sf = strfind(analysis_lineup{1,2}.positions{i},import_positions{4,1});
        sg = strfind(analysis_lineup{1,2}.positions{i},import_positions{5,1});

        analysis_lineup{2,2}.C{i} = abs(length(c) - 1);
        analysis_lineup{2,2}.PG{i} = abs(length(pg) - 2);
        analysis_lineup{2,2}.PF{i} = abs(length(pf) - 2);
        analysis_lineup{2,2}.SF{i} = abs(length(sf) - 2);
        analysis_lineup{2,2}.SG{i} = abs(length(sg) - 2);
    end

    clear i c pg pf sf sg positions_needed   

%SECTION B.2
    %Calculate needed player positions for a given lineup    
    
    %Calculate necessary loop requirements for filling out the necessary
    %positions
    lineup = cell2mat(analysis_lineup{2,2}{1,:});
    for i = 1:6
        position = find(eq(max(lineup),lineup));  

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
        lineup(position(1)) = lineup(position(1)) - 1;        
    end

    loop = sortrows(loop,2);


%SECTION A.2
    %Calculate possible lineups with remaining players       
    for i = 1:2
        temp3 = cell(1,8);
        z = 0;
        
        %Delete duplicate players 
        temp = analysis_players{loop(i,2),4}(:,1:8);
        comp = eq(temp.player_id, analysis_lineup{1,2}.player1(1));
        row = find(comp == 1);
        temp(row,:) = [];
        
        comp1 = eq(temp.player_id, analysis_lineup{1,2}.player2(1));
        row = find(comp1 == 1);
        temp(row,:) = [];
        
        comp2 = eq(temp.player_id, analysis_lineup{1,2}.player3(1));
        row = find(comp2 == 1);
        temp(row,:) = [];        
        
        for a = 1:size(temp,1)

            temp1 = [analysis_players{loop(i+2,2),4}(:,1:8)];
            comp = eq(temp.player_id, analysis_lineup{1,2}.player1(1));
            row = find(comp == 1);
            temp1(row,:) = [];

            comp1 = eq(temp.player_id, analysis_lineup{1,2}.player2(1));
            row = find(comp1 == 1);
            temp1(row,:) = [];

            comp2 = eq(temp.player_id, analysis_lineup{1,2}.player3(1));
            row = find(comp2 == 1);
            temp1(row,:) = [];
                       
            for b = 1:size(temp1,1)

                temp2 = [analysis_players{loop(4+i,2),4}(:,1:8)];                 
                comp = eq(temp.player_id, analysis_lineup{1,2}.player1(1));
                row = find(comp == 1);
                temp2(row,:) = [];

                comp1 = eq(temp.player_id, analysis_lineup{1,2}.player2(1));
                row = find(comp1 == 1);
                temp2(row,:) = [];

                comp2 = eq(temp.player_id, analysis_lineup{1,2}.player3(1));
                row = find(comp2 == 1);
                temp2(row,:) = [];
                
                for c = 1:size(temp2,1)

                    fppg_total = temp.fppg(a) + temp1.fppg(b) + temp2.fppg(c);
                    salary_total = temp.salary(a) + temp1.salary(b) + temp2.salary(c);
                    rating_total = temp.total(a) + temp1.total(b) + temp2.total(c);
                    position = strcat(temp.position(a), temp1.position(b), temp2.position(c));
                    teams = strcat(temp.team(a), temp1.team(b), temp2.team(c));  

                    z = z + 1;
                    temp3(z,:) = {fppg_total,...
                                         salary_total,...
                                         rating_total,...
                                         position,...
                                         teams,...
                                         temp.player_id(a),...
                                         temp1.player_id(b),...
                                         temp2.player_id(c),...
                                         }; 

                end
            end
        end
        temp3 = sortrows(temp3,-3);
%         temp3 = temp3(1:number_bot_six,:);
        temp3 = array2table(temp3);
        temp3.Properties.VariableNames = {'fppg',...
                                          'salary',...
                                          'rating',...
                                          'positions',...
                                          'teams',...
                                          'player1',...
                                          'player2',...
                                          'player3'};
                                      
    %Delete lineups that cost too much
        max_salary = 60000 - 3*4500 - analysis_lineup{1,2}.salary(1);
        row = find(cell2mat(temp3.salary) < max_salary);
    
        temp_lineups{1,i} = temp3(row,:);    
    end
    
    clear i a b c temp temp1 temp2 temp3 row comp1 comp2 comp loop lineup rating_total salary_total team z position fppg_total
    
    %Combine all possible lineup ratios
    temp = cell(1,14);
    z = 0;
    for a = 1:size(temp_lineups{1,1},1)       
        for b = 1:size(temp_lineups{1,2},1)
            
            fppg_total = temp_lineups{1,1}.fppg{a} + temp_lineups{1,2}.fppg{b} + analysis_lineup{1,2}.fppg(1);
            salary_total = temp_lineups{1,1}.salary{a} + temp_lineups{1,2}.salary{b} + analysis_lineup{1,2}.salary(1);
            rating_total = temp_lineups{1,1}.rating{a} + temp_lineups{1,2}.rating{b} + analysis_lineup{1,2}.rating(1);
            position = strcat(temp_lineups{1,1}.positions{a}, temp_lineups{1,2}.positions{b}, analysis_lineup{1,2}.positions(1));
            teams = strcat(temp_lineups{1,1}.teams{a}, temp_lineups{1,2}.teams{b}, analysis_lineup{1,2}.teams(1));  

            z = z + 1;
            temp(z,:) = {fppg_total,...
                         salary_total,...
                         rating_total,...
                         position,...
                         teams,...
                         temp_lineups{1,1}.player1{a},...
                         temp_lineups{1,1}.player2{a},...
                         temp_lineups{1,1}.player3{a},...
                         temp_lineups{1,2}.player1{b},...
                         temp_lineups{1,2}.player2{b},...
                         temp_lineups{1,2}.player3{b},...
                         analysis_lineup{1,2}.player1(1),...
                         analysis_lineup{1,2}.player2(1),...
                         analysis_lineup{1,2}.player3(1),...
                         };            
        end        
    end
    temp = sortrows(temp,2);
    temp = array2table(temp);
    temp.Properties.VariableNames = {'fppg',...
                                      'salary',...
                                      'rating',...
                                      'positions',...
                                      'teams',...
                                      'player1',...
                                      'player2',...
                                      'player3',...
                                      'player4',...
                                      'player5',...
                                      'player6',...
                                      'player7',...
                                      'player8',...
                                      'player9'};
    temp_lineups{1,3} = temp;
    
    clear z rating_total salary_total teams position b a fppg_teams temp
    
                      
    %This section delete lineups that do not meet necessary restrictions
    
    row_del = zeros(size(temp_lineups{1,3},1),1); %rows to delete
    for i = 1:size(temp_lineups{1,3},1)

        %incorrect number of player positions
        c = strfind(temp_lineups{1,3}.positions{i},import_positions{3,1});
        pg = strfind(temp_lineups{1,3}.positions{i},import_positions{1,1});
        pf = strfind(temp_lineups{1,3}.positions{i},import_positions{2,1});
        sf = strfind(temp_lineups{1,3}.positions{i},import_positions{4,1});
        sg = strfind(temp_lineups{1,3}.positions{i},import_positions{5,1});
        
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
        if temp_lineups{1,3}.salary{i} > import_scoring.salary_cap
           row_del(i) = i;
           
        elseif temp_lineups{1,3}.salary{i} < 58000
           row_del(i) = i;
        end
        
        %delete rows with more than 4 players from one team
        for j = 1:length(import_teams)
            team = strfind(temp_lineups{1,3}.teams{i},import_teams{j,1});
            
            if length(team{1,1}) > 4
                row_del(i) = i;
            end
        end
        
       %Find duplicate player id numbers
       playerid = cell2mat(table2array(temp_lineups{1,3}(i,[6:14])));
       duplicate = length(unique(playerid));
       if duplicate < 9
           row_del(i) = i;       
    
       end
    end
    
    %Delete ineligible rows
    row_del(row_del == 0) = [];
    temp_lineups{1,3}(row_del,:) = [];
    
    clear temp i j team sg sf pf pg c row_del row 
                            
     
    
%SECTION B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION C





% %SECTION C.5
%     %Export workspace variables to .mat file
%     save(['/Users/ccm/Documents/Fantasy_Basketball/export/ex_workspace_variables'])


%SECTION C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
