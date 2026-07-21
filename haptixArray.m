function [e_map] = haptixArray()
%HAPTIXARRAY returns the electrode map of the old USEA used in the haptix
%trials

%% DECLARE OUTPUTS
arguments (Output)
    e_map
end

%% GENERATE ARRAY
e_map = reshape(1:100,[10 10]);
e_map = rot90(e_map);
[e_map] = removeRef(e_map);
end