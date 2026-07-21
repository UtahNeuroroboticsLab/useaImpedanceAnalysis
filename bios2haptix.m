function [haptix_elecs] = bios2haptix(bios_elecs)
%bios2haptix converts haptix electrodes to bios electrodes
%   converts from old USEA electrodes with the haptix mapping to ripple
%   channels to the bios interface to the blackrock electrode numbers
%   MAT
%   20260630
arguments (Input)
    bios_elecs
end

arguments (Output)
    haptix_elecs
end

%% ADD PATH
addBoxPath('Box\JAGLAB\Tasks\FeedbackDecode\dependencies');

%% CONVERT TO RIPPLE CHANS
ripple_chan = e2c(bios_elecs,'BIOS');

%% CONVER TO BLACKROCK ELECTRODES
haptix_electrodes = c2e(ripple_chan,'haptix');
end