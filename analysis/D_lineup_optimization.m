%D_lineup_optimization
    %run this script after running C_data_analysis to produce the most optimal lineups
    clc
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION A
    %This section produces possible lineups to consider
tic
%SECTION A.1
     %Create possible combinations of three players   
    temp_lineups = cell(220,8);
    z = 0;
    for i = 1:height(analysis_players{3,3})-2
        temp = [analysis_players{3,2}(i+1:end,[1:2,5:6]) analysis_players{3,3}(i+1:end,4) analysis_players{3,2}(i+1:end,8)]; 
        for k = 1:size(temp,1)
            temp2 = [analysis_players{3,2}(i+1+k:end,[1:2,5:6]) analysis_players{3,3}(i+1+k:end,4) analysis_players{3,2}(i+1+k:end,8)];            
            for j = 1:size(temp2,1)
                
                fp_total = analysis_players{3,2}.fppg(i)+temp.fppg(k)+temp2.fppg(j);
                salary_total = analysis_players{3,2}.salary(i)+temp.salary(k)+temp2.salary(j);
                rating_total = analysis_players{3,3}.total(i)+temp.total(k)+temp2.total(j);
                position = strcat(analysis_players{3,2}.position(i), temp.position(k), temp2.position(j));
                teams = strcat(analysis_players{3,2}.team(i), temp.team(k), temp2.team(j));   
                
                z = z + 1;
                temp_lineups(z,:) = [fp_total,...
                                salary_total,...
                                rating_total,...
                                position,...
                                teams,...
                                analysis_players{3,3}.player_id(i),...
                                temp.player_id(k),...
                                temp2.player_id(j)];                        
            end
        end     
    end

    clear fp_total salary_total rating_total position teams i j k temp temp2 z
    toc
    tic
%SECTION A.2
    %Calculate possible lineups with remaining players
    z = 0;
%     analysis_lineups = cell(100000000000000,14);
    analysis_lineups = cell(1,14);
    for i = 1:1 %size(temp_lineups,1)
        for a = 1:height(analysis_players{4,3})-5
            temp = [analysis_players{4,2}(a+1:end,[1:2, 5:6]) analysis_players{4,3}(a+1:end,4) analysis_players{4,2}(a+1:end,8)]; 
            for b = 1:size(temp,1)
                temp2 = [analysis_players{4,2}(1+a+b:end,[1:2, 5:6]) analysis_players{4,3}(1+a+b:end,4) analysis_players{4,2}(1+a+b:end,8)];            
                for c = 1:size(temp2,1)
                    temp3 = [analysis_players{4,2}(1+a+b+c:end,[1:2, 5:6]) analysis_players{4,3}(1+a+b+c:end,4) analysis_players{4,2}(1+a+b+c:end,8)];            
                    for d = 1:size(temp3,1)
                        temp4 = [analysis_players{4,2}(1+a+b+c+d:end,[1:2, 5:6]) analysis_players{4,3}(1+a+b+c+d:end,4) analysis_players{4,2}(1+a+b+c+d:end,8)];            
                        for e = 1:size(temp4,1)
                            temp5 = [analysis_players{4,2}(1+a+b+c+d+e:end,[1:2, 5:6]) analysis_players{4,3}(1+a+b+c+d+e:end,4) analysis_players{4,2}(1+a+b+c+d+e:end,8)];            
                            for f = 1:size(temp5,1)

                            fp_total = analysis_players{4,2}.fppg(a)+temp.fppg(b)+temp2.fppg(c)+...
                                       temp3.fppg(d)+temp4.fppg(e)+temp5.fppg(f);
                            salary_total = analysis_players{4,2}.salary(a)+temp.salary(b)+temp2.salary(c)+...
                                       temp3.salary(d)+temp4.salary(e)+temp5.salary(f);
                            rating_total = analysis_players{4,3}.total(a)+temp.total(b)+temp2.total(c)+...
                                       temp3.total(d)+temp4.total(e)+temp5.total(f);
                            position = strcat(analysis_players{4,2}.position(a), temp.position(b), temp2.position(c),...
                                        temp3.position(d),temp4.position(e),temp5.position(f));
                            teams = strcat(analysis_players{4,2}.team(a), temp.team(b), temp2.team(c),...
                                        temp3.team(d),temp4.team(e),temp5.team(f));  

                            fp_total = fp_total + temp_lineups{i,1};
                            salary_total = salary_total + temp_lineups{i,2};
                            rating_total = rating_total + temp_lineups{i,3};
                            position = strcat(position, temp_lineups{i,4});
                            teams = strcat(teams, temp_lineups{i,5});

                            z = z + 1;
                            analysis_lineups(z,:) = [fp_total,...
                                                     salary_total,...
                                                     rating_total,...
                                                     position,...
                                                     teams,...
                                                     temp_lineups(i,6:8),...
                                                     analysis_players{4,3}.player_id(a),...
                                                     temp.player_id(b),...
                                                     temp2.player_id(c),...
                                                     temp3.player_id(d),...
                                                     temp4.player_id(e),...
                                                     temp5.player_id(f)];    
                            end
                        end
                    end
                end
            end
        end
    end
toc
%SECTION A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION B
    %This section delete lineups that do not meet necessary restrictions
    
    row_del = zeros(size(analysis_lineups,1),1); %rows to delete
    for i = 1:size(analysis_lineups,1)

        %incorrect number of player positions
        c = strfind(analysis_lineups(i,4),import_positions{3,1});
        pg = strfind(analysis_lineups(i,4),import_positions{1,1});
        pf = strfind(analysis_lineups(i,4),import_positions{2,1});
        sf = strfind(analysis_lineups(i,4),import_positions{4,1});
        sg = strfind(analysis_lineups(i,4),import_positions{5,1});
        
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
        if analysis_lineups{i,2} > import_scoring.salary_cap
           row_del(i) = i;
           
        else if analysis_lineups{i,2} < 50000
           row_del(i) = i;
            end
        end
        
        %delete rows with more than 4 players from one team
        for j = 1:length(import_teams)
            team = strfind(analysis_lineups(i,5),import_teams{j,1});
            
            if length(team{1,1}) > 4
                row_del(i) = i;
            end
        end        
    end
    
    %Delete inelligible rows
    row_del(row_del == 0) = [];
    analysis_lineups(row_del,:) = [];
    
    clear temp i j team sg sf pf pg c row_del row 





% %SECTION C.5
%     %Export workspace variables to .mat file
%     save(['/Users/ccm/Documents/Fantasy_Basketball/export/ex_workspace_variables'])


%SECTION b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
