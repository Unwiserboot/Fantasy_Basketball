%D_lineup_optimization
    %run this script after running C_data_analysis to produce the most optimal lineups
    clearvars -except import_orig analysis_players analysis_teams import import_nodata import_positions import_scoring import_teams number_top_players number_top_lineups multiplier
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION A
    %Create lineups of three players from any position
    
%SECTION A.1
    %Prep table
    analysis_lineup{1,1} = 'Top Initial Lineups';
    analysis_lineup{2,1} = 'Positions Needed';
    analysis_lineup{4,1} = 'Complete Lineup 1';
    analysis_lineup{5,1} = 'Complete Lineup 2';    
    
%SECTION A.2
    %Create lineups of top players
    z = 0;
    temp = analysis_players{2,3}(1:number_top_players,:);
    for i = 1:height(temp)-2
        temp1 = [temp(i+1:end,[1:2,5:8])]; 
        for k = 1:size(temp1,1)
            temp2 = [temp(i+k+1:end,[1:2,5:8])];
            for j = 1:size(temp2,1)
                
                fppg_total = temp.fppg(i)+temp1.fppg(k)+temp2.fppg(j);
                salary_total = temp.salary(i)+temp1.salary(k)+temp2.salary(j);
                rating_total = temp.total(i)+temp1.total(k)+temp2.total(j);
                position = strcat(temp.position(i), temp1.position(k), temp2.position(j));
                teams = strcat(temp.team(i), temp1.team(k), temp2.team(j));   
                dollar_per_rating = salary_total/rating_total;
                     
                z = z + 1;
                analysis_lineup{1,2}(z,:) = {fppg_total,...
                                             salary_total,...
                                             rating_total,...
                                             dollar_per_rating,...
                                             position,...
                                             teams,...
                                             temp.player_id(i),...
                                             temp1.player_id(k),...
                                             temp2.player_id(j)};                        
            end
        end     
    end
    
    %Conver results to table
    analysis_lineup{1,2} = cell2table(analysis_lineup{1,2}); 
    analysis_lineup{1,2}.Properties.VariableNames = {'fppg',...
                                                     'salary',...
                                                     'rating',...
                                                     'dollar_per_rating',...
                                                     'positions',...
                                                     'teams',...
                                                     'player1',...
                                                     'player2',...
                                                     'player3',...
                                                      };
    
     clear i j k z top_players price_per_point rating_total salary_total
     clear temp temp1 temp2 fppg_total position teams dollar_per_rating
    
%SECTION A.3
    %Delete lineups that have too many players at any one position
    
    row_del = zeros(size(analysis_lineup{1,2},1),1); %rows to delete
    
    %Players at each position
    c = strfind(analysis_lineup{1,2}.positions,import_positions{3,1});
    pg = strfind(analysis_lineup{1,2}.positions,import_positions{1,1});
    pf = strfind(analysis_lineup{1,2}.positions,import_positions{2,1});
    sf = strfind(analysis_lineup{1,2}.positions,import_positions{4,1});
    sg = strfind(analysis_lineup{1,2}.positions,import_positions{5,1});
        
    for i = 1:size(analysis_lineup{1,2},1)
    
        if length(c{i,1}) > 1
            row_del(i) = i;
            
        elseif length(pg{i,1}) > 2
            row_del(i) = i;
        
        elseif length(pf{i,1}) > 2
            row_del(i) = i;
            
        elseif length(sf{i,1}) > 2
            row_del(i) = i;  
            
         elseif length(sg{i,1}) > 2
            row_del(i) = i;              
        end 
    end
    
    %Delete zeros from array
    row_del = row_del(row_del~=0);
    
    %Delete ineligible lineups
    analysis_lineup{1,2}(row_del,:) = [];
    
    %Sort in order of best rating
    analysis_lineup{1,2} = sortrows(analysis_lineup{1,2},'rating','descend');
    analysis_lineup{1,2} = analysis_lineup{1,2}(1:number_top_lineups,:);
    
    clear row_del i sg sf c pg pf number_top_players 
    
    
%SECTION A.4
    %Lowest Price Per Rating
    row = find(min(analysis_lineup{1,2}.dollar_per_rating) == analysis_lineup{1,2}.dollar_per_rating);
    temp_lineups{2,2}(1,:) = analysis_lineup{1,2}(row,:); 
    analysis_lineup{1,2}(row,:) = [];
    
    %Most Fantasy Points
    row = find(analysis_lineup{1,2}.fppg == max(analysis_lineup{1,2}.fppg));
    temp_lineups{3,2}(1,:) = analysis_lineup{1,2}(row,:);
    analysis_lineup{1,2}(row,:) = [];
    
    clear row

%SECTION A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%SECTION B
    %Creates remaining lineup of six players
    
%SECTION B.1
    %Calculate needed player positions for a given
    
    %Prepare data cell
    num_lineups = length(temp_lineups(2:end,2));
    positions_needed = cell(num_lineups,5);
    analysis_lineup{2,2} = cell2table(positions_needed);
    analysis_lineup{2,2}.Properties.VariableNames = {'C',...
                                                     'PG',...
                                                     'PF',...
                                                     'SG',...
                                                     'SF'};
    %Run calculation
    for m = 1:num_lineups

        %calculate number of each position
        c = strfind(temp_lineups{m+1,2}.positions{1},import_positions{3,1});
        pg = strfind(temp_lineups{m+1,2}.positions{1},import_positions{1,1});
        pf = strfind(temp_lineups{m+1,2}.positions{1},import_positions{2,1});
        sf = strfind(temp_lineups{m+1,2}.positions{1},import_positions{4,1});
        sg = strfind(temp_lineups{m+1,2}.positions{1},import_positions{5,1});
        
        %calculate needed positions
        analysis_lineup{2,2}.C{m} = abs(length(c) - 1);
        analysis_lineup{2,2}.PG{m} = abs(length(pg) - 2);
        analysis_lineup{2,2}.PF{m} = abs(length(pf) - 2);
        analysis_lineup{2,2}.SF{m} = abs(length(sf) - 2);
        analysis_lineup{2,2}.SG{m} = abs(length(sg) - 2);
    end

    clear i c pg pf sf sg positions_needed   

%SECTION B.2
    %Create a loop requirements to create lineups
    %Column1 - number of players
    %Column2 - location of player data
    
    %Run for each lineups to analyze
    for m = 1:num_lineups
        
        lineup = cell2mat(analysis_lineup{2,2}{m,:});
        for i = 1:6
            position = find(eq(max(lineup),lineup));  

            if position(1) == 1
                loop{m,1}(i,1) = size(analysis_players{6,4},1);
                loop{m,1}(i,2) = 6;

            elseif position(1) == 2
                loop{m,1}(i,1) = size(analysis_players{4,4},1);
                loop{m,1}(i,2) = 4;

            elseif position(1) == 3
                loop{m,1}(i,1) = size(analysis_players{5,4},1);
                loop{m,1}(i,2) = 5;

            elseif position(1) == 4
                loop{m,1}(i,1) = size(analysis_players{8,4},1);    
                loop{m,1}(i,2) = 8;

            elseif position(1) == 5
                loop{m,1}(i,1) = size(analysis_players{7,4},1);
                loop{m,1}(i,2) = 7;
            end
            
            lineup(position(1)) = lineup(position(1)) - 1;        
        end
        loop{m,1} = sortrows(loop{m,1},2);
    end
    

    clear i lineup position m

%SECTION B.3
    %Calculate two groups of three player lineups using remaining positions      
    
    %Run for each lineup to analyze
    for m = 1:num_lineups
        
        %Create two lineups with three players each
        for i = 1:2

            %place holder cell for lineups
            temp3 = cell(1,8);
            z = 0; %initialize row counter

            %Delete duplicate players 
            temp = analysis_players{loop{m,1}(i,2),4}(:,1:8);
            
            for j = 1:3
                
                comp = eq(temp.player_id, table2array(temp_lineups{m+1,2}(1,j+6)));
                row = find(comp == 1);
                temp(row,:) = [];                   
            end      

            
            for a = 1:size(temp,1)
                
                %Delete duplicate players
                temp1 = [analysis_players{loop{m,1}(i+2,2),4}(:,1:8)];
                
                for j = 1:3

                    comp = eq(temp1.player_id, table2array(temp_lineups{m+1,2}(1,j+6)));
                    row = find(comp == 1);
                    temp1(row,:) = [];                   
                end  

                
                for b = 1:size(temp1,1)
                    
                    %Delete duplicate players
                    temp2 = [analysis_players{loop{m,1}(4+i,2),4}(:,1:8)];
                    
                    for j = 1:3

                        comp = eq(temp2.player_id, table2array(temp_lineups{m+1,2}(1,j+6)));
                        row = find(comp == 1);
                        temp2(row,:) = [];                   
                    end  

                    
                    for c = 1:size(temp2,1)

                        fppg_total = temp.fppg(a) + temp1.fppg(b) + temp2.fppg(c);
                        salary_total = temp.salary(a) + temp1.salary(b) + temp2.salary(c);
                        rating_total = temp.total(a) + temp1.total(b) + temp2.total(c);
                        position = strcat(temp.position(a), temp1.position(b), temp2.position(c));
                        teams = strcat(temp.team(a), temp1.team(b), temp2.team(c));  

                        z = z + 1; %Row counter
                        
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
            temp3 = cell2table(temp3);
            temp3.Properties.VariableNames = {'fppg',...
                                              'salary',...
                                              'rating',...
                                              'positions',...
                                              'teams',...
                                              'player1',...
                                              'player2',...
                                              'player3'};

        %Delete lineups that do not meet salary requirement
            max_salary = 60000 - temp_lineups{1+m,2}.salary - 10500;
            row = find(temp3.salary < max_salary);
            temp3 = temp3(row,:);

            temp_lineups{m+1,i+2} = temp3;
        end
    end
    
    temp_lineups{2,1} = 'Lineup 1';
    temp_lineups{3,1} = 'Lineup 2';
    temp_lineups{1,2} = 'Set A';
    temp_lineups{1,3} = 'Set B';
    temp_lineups{1,4} = 'Set C';
    temp_lineups{1,5} = 'Set Final';
    
    clear i a b c temp temp1 temp2 temp3 row comp1 comp2 comp loop lineup m j
    clear rating_total salary_total team z position fppg_total max_salary teams min_salary
    
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%SECTION C
    %Create combination of all possible lineups for each initial set
%     tic

%SECTION C.1  
    %Run for each lineup to analyze
    
    for m = 1:num_lineups
        num_combinations = size(temp_lineups{1+m,3},1)*size(temp_lineups{1+m,4},1);
        temp = cell(num_combinations,2); %Place holder cell
        temp2 = zeros(num_combinations,12);
        
        z = 1; %Initialize row count
        zz = size(temp_lineups{1+m,4},1);
        
        for a = 1:size(temp_lineups{m+1,3},1) 

            %Combine player stats
            fppg_total = temp_lineups{m+1,3}.fppg(a) + temp_lineups{m+1,4}.fppg + temp_lineups{m+1,2}.fppg;
            salary_total = temp_lineups{m+1,3}.salary(a) + temp_lineups{m+1,4}.salary + temp_lineups{m+1,2}.salary;
            rating_total = temp_lineups{m+1,3}.rating(a) + temp_lineups{m+1,4}.rating + temp_lineups{m+1,2}.rating;
            position = strcat(temp_lineups{m+1,3}.positions{a}, temp_lineups{m+1,4}.positions, temp_lineups{m+1,2}.positions);
            teams = strcat(temp_lineups{m+1,3}.teams{a}, temp_lineups{m+1,4}.teams, temp_lineups{m+1,2}.teams);  
            player1(1:size(temp_lineups{m+1,4},1),1) = temp_lineups{m+1,3}.player1(a);
            player2(1:size(temp_lineups{m+1,4},1),1:1) = temp_lineups{m+1,3}.player2(a);
            player3(1:size(temp_lineups{m+1,4},1),1:1) = temp_lineups{m+1,3}.player3(a);
            player4(1:size(temp_lineups{m+1,4},1),1:1) = temp_lineups{m+1,2}.player1;
            player5(1:size(temp_lineups{m+1,4},1),1:1) = temp_lineups{m+1,2}.player2;
            player6(1:size(temp_lineups{m+1,4},1),1:1) = temp_lineups{m+1,2}.player3;
            
            temp(z:zz,1) = (teams);
            temp(z:zz,2) = (position);
            

            temp2(z:zz,1) = (fppg_total);
            temp2(z:zz,2) = (salary_total);
            temp2(z:zz,3) = (rating_total);
            temp2(z:zz,4) = (player1);
            temp2(z:zz,5) = (player2);
            temp2(z:zz,6) = (player3);
            temp2(z:zz,7) = (temp_lineups{m+1,4}.player1);
            temp2(z:zz,8) = (temp_lineups{m+1,4}.player2);
            temp2(z:zz,9) = (temp_lineups{m+1,4}.player3);
            temp2(z:zz,10) = (player4);
            temp2(z:zz,11) = (player5);
            temp2(z:zz,12) = (player6);
            
            z = z + size(temp_lineups{1+m,4},1);
            zz = zz + size(temp_lineups{1+m,4},1);
            clear player1 player2 player3 player4 player5 player6
            
        end
        
        %Convert to table and save lineups
        temp = cell2table(temp);
        temp.Properties.VariableNames = {'teams',...
                                         'positions',};
                                     
                                     
        
        temp2 = array2table(temp2);
        temp2.Properties.VariableNames = {'fppg',...
                                          'salary',...
                                          'rating',...
                                          'player1',...
                                          'player2',...
                                          'player3',...
                                          'player4',...
                                          'player5',...
                                          'player6',...
                                          'player7',...
                                          'player8',...
                                          'player9'};   
          
        temp_lineups{1+m,5} = [temp, temp2];
                                      
    end
    
                                  
    clear z teams position b a fppg_teams temp m zz temp2
    clear fppg_total salary_total rating_total position teams temp1 num_combinations
    
%     disp('Time to create all final lineups')
%     toc
    
%SECTION C.2
    %This section deletes lineups that do not meet necessary restrictions
    
    %Run for each lineup to analyze
    
    for m = 1:num_lineups

        %RESTRICTION 1: Delete rows that are above salary cap
        row_del = find(temp_lineups{m+1,5}.salary > 60000);
        temp_lineups{m+1,5}(row_del,:) = [];

        clear row_del


        %Order lineups in terms of rating
        temp_lineups{m+1, 5} = sortrows(temp_lineups{m+1, 5},'rating','descend');


        %RESTRICTION 2: Select top 500 lineups by rating
        if height(temp_lineups{m+1, 5}) > 500

            temp_lineups{m+1, 5} = temp_lineups{m+1, 5}(1:500,:);        
        else

            temp_lineups{m+1, 5} = temp_lineups{m+1, 5}(1:end,:);
        end


        %Calculate number of positions on each team
        c = strfind(temp_lineups{m+1,5}.positions,import_positions{3,1});
        pg = strfind(temp_lineups{m+1,5}.positions,import_positions{1,1});
        pf = strfind(temp_lineups{m+1,5}.positions,import_positions{2,1});
        sf = strfind(temp_lineups{m+1,5}.positions,import_positions{4,1});
        sg = strfind(temp_lineups{m+1,5}.positions,import_positions{5,1});

        row_del = zeros(size(temp_lineups{m+1,5},1),1); %rows to delete

        for i = 1:size(temp_lineups{m+1,5},1)

            %RESTRICTION 3: Delete lineup if too many players at any one position
            if length(c(i)) > 1
                row_del(i) = i;

            elseif length(pg(i)) > 2
                row_del(i) = i;

            elseif length(pf(i)) > 2
                row_del(i) = i;

            elseif length(sf(i)) > 2
                row_del(i) = i;  

             elseif length(sg(i)) > 2
                row_del(i) = i;              
            end         

            %RESTRICTION 4: Find duplicate player id numbers
            if row_del(i) == 0 %run if row has not been deleted yet
                
                playerid = table2array(temp_lineups{m+1,5}(i,[6:14]));
                duplicate = length(unique(playerid));
                
                if duplicate < 9
                    row_del(i) = i;          
                end
            end

            %RESTRICTION 5: Delete rows with more than 4 players from one team
            if row_del(i) == 0 %run if row has not been deleted before
                for j = 1:length(import_teams)

                    team = strfind(temp_lineups{m+1,5}.teams{i},import_teams{j});            
                    if length(team) > 4
                        row_del(i) = i;
                    end        
                end       
            end      
        end

        %Delete ineligible lineups
        row_del = row_del(row_del ~= 0);
        temp_lineups{m+1,5}(row_del,:) = [];
    end
    
    clear row_del i j team c pg pf sg sf duplicate playerid m
    

    %RESTRICTION 6: Delete duplicate lineups
    %Run for each lineup to analyze
    
    for m = 1:num_lineups
        row_del = zeros(size(temp_lineups{m+1,5},1),1); %rows to delete
        for i = 1:height(temp_lineups{m+1,5})
            sum = zeros(size(temp_lineups{m+1,5},1),1);
            for j = 1:6
              player1 = eq(temp_lineups{m+1,5}.player1(i),table2array(temp_lineups{m+1,5}(:,j+5)));
              player2 = eq(temp_lineups{m+1,5}.player2(i),table2array(temp_lineups{m+1,5}(:,j+5)));
              player3 = eq(temp_lineups{m+1,5}.player3(i),table2array(temp_lineups{m+1,5}(:,j+5)));
              player4 = eq(temp_lineups{m+1,5}.player4(i),table2array(temp_lineups{m+1,5}(:,j+5)));
              player5 = eq(temp_lineups{m+1,5}.player5(i),table2array(temp_lineups{m+1,5}(:,j+5)));
              player6 = eq(temp_lineups{m+1,5}.player6(i),table2array(temp_lineups{m+1,5}(:,j+5)));

              sum = player1 + player2 + player3 + player4 + player5 + player6 + sum;

            end

            repeat = find(sum == 6);

          if isempty(repeat) == 0 && length(repeat) > 1
              repeat = repeat(2:end);
              row_del(repeat) = repeat;
          end       
        end
        
        row_del = row_del(row_del ~= 0);
        temp_lineups{m+1,5}(row_del,:) = [];
    
    end
    
    clear i j repeat row_del sum player1 player2 player3 player4 player5 player6
    
    
%SECTION C.3
    %Select top lineups by rating
    
    %Run for each lineup to analyze    
    for m = 1:num_lineups
        if length(temp_lineups{m+1,5}.rating) > number_top_lineups
            
            analysis_lineup{m+3, 2} = temp_lineups{m+1,5}(1:number_top_lineups,:);    
        else
            
            analysis_lineup{m+3, 2} = temp_lineups{m+1,5}(:,:);
        end
    end
    
    clear temp i j team sg sf pf pg c row_del row player_id row_max max_rating m
%     clear temp_lineups
                                
%SECTION C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION D
    %Finalize player lineups and create an output file

%SECTION D.1
    %Replace player id numbers with name
    for m = 1:num_lineups
        temp = cell(height(analysis_lineup{m+3,2}),9);
        for j = 1:height(analysis_lineup{m+3,2})            
            for i = 1:9
                
                comp = eq(table2array(analysis_lineup{m+3,2}(j,5+i)),import{5,2}.player_id);
                row = find(comp == 1);
                temp(j,i) = import{5,2}.player_name(row);      
            end
        end
        temp = cell2table(temp);
        temp.Properties.VariableNames = {'player1',...
                                          'player2',...
                                          'player3',...
                                          'player4',...
                                          'player5',...
                                          'player6',...
                                          'player7',...
                                          'player8',...
                                          'player9'};

        analysis_lineup{m+3,2} = [analysis_lineup{m+3,2}(:,1:5), temp];
    end

    clear m j i temp comp row num_lineups number_top_lineups


% %SECTION D.2
    %Export workspace variables to .mat file
    save(['/Users/ccm/Documents/Fantasy_Basketball/export/ex_workspace_variables'])
    
    cd('/Users/ccm/Documents/Fantasy_Basketball/export');
    writetable(analysis_lineup{4,2},'ex_lineup1.csv');
    writetable(analysis_lineup{5,2},'ex_lineup2.csv');

    
    
    
    
    
    

%SECTION D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
