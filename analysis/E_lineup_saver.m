%E_lineup_export
    %run this script after running D_lineup_optimization to export teams
    %used

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION A
    %Create a new table
    
    %VARAIBLE 1: Update which rows were seletec for each lineup
    rows_one = [1]; %Rows Lineup 1
    rows_two = [1]; %Rows Lineup 2
    
    teams_entered = [analysis_lineup{4,2}(1,:);...
                    analysis_lineup{5,2}(1,:)];
        
    
    
    
    
    cd('/Users/ccm/Documents/Fantasy_Basketball/export');




    
    %Export teams used on Fanduel
    writetable(analysis_players{2,2},'ex_analysis_players.csv');
    
%SECTION A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
