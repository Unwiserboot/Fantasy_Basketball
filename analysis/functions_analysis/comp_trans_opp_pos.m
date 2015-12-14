function [ dest_data ] = comp_trans_opp_pos(rows, org_id, dest_id, org_data, player_pos)
%SECTION C.1
%transfer data from one cell to another by comparing team or player id
%numbers
    %rows - number of destination rows
    %original_id - identifier for original data
    %dest_id - identifier for destination data
    %org_data - original data column
    %dest_data - destination column for data
    %player_pos - column of player positions
    dest_data = zeros(rows,1);
    
    for i = 1:rows
        compare = eq(org_id, dest_id(i));
        row = find(compare == 1);
        
        if strcmp(player_pos(i), 'PF') == 1

            dest_data(i) = org_data.forward_rating(row);

        elseif strcmp(player_pos(i), 'C') == 1

            dest_data(i) = org_data.center_rating(row);

        elseif strcmp(player_pos(i), 'PG') == 1

            dest_data(i) = org_data.guard_rating(row);

        elseif strcmp(player_pos(i), 'SG') == 1

            dest_data(i) = org_data.guard_rating(row);

        elseif strcmp(player_pos(i), 'SF') == 1

            dest_data(i) = org_data.forward_rating(row);  

        end
    end
end

