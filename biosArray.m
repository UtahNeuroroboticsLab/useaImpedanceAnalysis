function [e_map] = biosArray()
%BIOSARRAY returns the electrode map of the new USEA used in the BIOS trial

%% DECLARE OUTPUTS
arguments (Output)
    e_map
end

%% GENERATE ARRAY
e_map = reshape(1:100,[10 10]);
e_map = rot90(e_map,2);
[e_map] = removeRef(e_map);
e_map(:,1) = e_map(:,1) - 2;
end