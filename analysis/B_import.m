%B_import
    %import data into matlab workspace. run once to save on computation
    %time
    ccc

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SECTION A
    %data import into Matlab
    
    import_orig{1,2} = import_vars('vars.csv');
    import_orig{1,1} = 'vars';
    import_orig{2,2} = import_fanduel('fanduel.csv');
    import_orig{2,1} = 'fanduel'; 
    import_orig{3,2} = import_adv('reg_sea_player_adv.csv');
    import_orig{3,1} = 'reg_sea_player_adv'; 
    import_orig{4,2} = import_def('reg_sea_player_def.csv');
    import_orig{4,1} = 'reg_sea_player_def';
    import_orig{5,2} = import_trad('reg_sea_player_trad.csv');
    import_orig{5,1} = 'reg_sea_player_trad';
    import_orig{6,2} = import_team_trad('reg_sea_team_trad.csv');
    import_orig{6,1} = 'reg_sea_team_trad';
    import_orig{7,2} = import_team_opp('reg_sea_team_opp.csv');
    import_orig{7,1} = 'reg_sea_team_opp';
    import_orig{8,2} = import_team_opp('reg_sea_team_opp_forward.csv');
    import_orig{8,1} = 'reg_sea_team_opp_forward';
    import_orig{9,2} = import_team_opp('reg_sea_team_opp_center.csv');
    import_orig{9,1} = 'reg_sea_team_opp_center';
    import_orig{10,2} = import_team_opp('reg_sea_team_opp_guard.csv');
    import_orig{10,1} = 'reg_sea_team_opp_guard';
    import_orig{11,2} = import_trad('reg_sea_player_trad_3gme.csv');
    import_orig{11,1} = 'reg_sea_player_trad_3gme';
    
    %Make all table variables lower case for easy programming
    for i = 1:length(import_orig)
         
        %rename variable names to lowercase
        import_orig{i,2}.Properties.VariableNames = lower(import_orig{i,2}.Properties.VariableNames);        
    end
      
    %rename variable 1 in fandual data to player_id
    import_orig{2,2}.Properties.VariableNames(1) = {'player_id'};
    
    clear i
%SECTION A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
