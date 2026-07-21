function [e_map] = removeRef(e_map)
%removeRef removes the reference electrodes from a USEA map and replaces
%them with NaN
arguments (Input)
    e_map
end

arguments (Output)
    e_map
end

% removes the top and bottom two electrodes from the left most column
e_map(1,1) = NaN;
e_map(2,1) = NaN;
e_map(9,1) = NaN;
e_map(10,1) = NaN;

end