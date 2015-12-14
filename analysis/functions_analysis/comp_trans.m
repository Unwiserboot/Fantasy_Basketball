function [ dest_data ] = comp_trans(rows, org_id, dest_id, org_data)
%transfer data from one cell to another by comparing team or player id
%numbers
    %rows - number of destination rows
    %original_id - identifier for original data
    %dest_id - identifier for destination data
    %org_data - original data column
    %dest_data - destination column for data
    dest_data = zeros(rows,1);
    
    for i = 1:rows
        compare = eq(org_id, dest_id(i));
        row = find(compare == 1);
        dest_data(i) = org_data(row);
    end
end

