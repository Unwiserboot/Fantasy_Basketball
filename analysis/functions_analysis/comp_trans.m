function [ dest_data ] = comp_trans(org_id, dest_id, org_data)
%transfer data from one cell to another by comparing team or player id
%numbers
    %original_id - identifier for original data
    %dest_id - identifier for destination data
    %org_data - original data column
    %dest_data - destination column for data
    rows = length(dest_id) ;
    dest_data = zeros(rows,1);
    
    for i = 1:rows
        compare = eq(org_id, dest_id(i));
        row = find(compare == 1);
        
        if isempty(row) == 1
            
            dest_data(i) = 0;
        else
            
            dest_data(i) = org_data(row);
        end
    end
end

