%SECTION A.1
    %data import into Matlab
    
    import{1,2} = import_vars('vars.csv');
    import{1,1} = 'vars';
    import{2,2} = import_fanduel('fanduel.csv');
    import{2,1} = 'fanduel'; 
    import{3,2} = import_adv('reg_sea_player_adv.csv');
    import{3,1} = 'reg_sea_player_adv'; 
    import{4,2} = import_def('reg_sea_player_def.csv');
    import{4,1} = 'reg_sea_player_def';
    import{5,2} = import_trad('reg_sea_player_trad.csv');
    import{5,1} = 'reg_sea_player_trad';
    import{6,2} = import_team_trad('reg_sea_team_trad.csv');
    import{6,1} = 'reg_sea_team_trad';
    import{7,2} = import_team_opp('reg_sea_team_opp.csv');
    import{7,1} = 'reg_sea_team_opp';
    import{8,2} = import_team_opp('reg_sea_team_opp_forward.csv');
    import{8,1} = 'reg_sea_team_opp_forward';
    import{9,2} = import_team_opp('reg_sea_team_opp_center.csv');
    import{9,1} = 'reg_sea_team_opp_center';
    import{10,2} = import_team_opp('reg_sea_team_opp_guard.csv');
    import{10,1} = 'reg_sea_team_opp_guard';
    
    %Make all table variables lower case for easy programming
    for i = 1:length(import)
         
        %rename variable names to lowercase
        import{i,2}.Properties.VariableNames = lower(import{i,2}.Properties.VariableNames);        
    end