function [br_electrodes] = haptix2blackrock(haptix_elecs)
%haptix2bios converts haptix electrodes to bios electrodes
%   converts from old USEA electrodes with the haptix mapping to
%   the blackrock electrode numbers
%   MAT
%   20260630
arguments (Input)
    haptix_elecs
end

arguments (Output)
    br_electrodes
end

%% ADD PATH
addBoxPath('Box\JAGLAB\Tasks\FeedbackDecode\dependencies');

%% GET ELECTRODE POSITION
% get haptix array numbers
haptix_array = haptixArray();

% get corresponding electrode positions
[~,e_pos] = ismember(haptix_elecs, haptix_array);

%% CONVER TO BLACKROCK ELECTRODES

% get blackrock array numbers
br_array = biosArray();

% get blackrock array numbers
br_electrodes = br_array(e_pos);

end