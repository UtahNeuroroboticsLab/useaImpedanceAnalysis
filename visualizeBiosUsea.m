%% Generates a figure showing which front end channels are plugged into 
%% which usea electrodes

%% GET CHANNELS FOR USEA ELECTRODES

% get electrode to channel list
ripple_chans = e2c([1:96],'BIOS');

%% GROUP CHANNELS TO FE

% gen var
ripple_fes = zeros(size(ripple_chans));

% group chans into fe
ripple_fes(ripple_chans < 33) = 1; % fe 1
ripple_fes(ripple_chans > 32) = 2; % fe 2
ripple_fes(ripple_chans > 64) = 3; % fe 3 (overwrites the second fe)

%% RESHAPE INTO 2D

[fe_data] = organizeBRData(ripple_fes); % reshapes into 2d array shape

%% PLOT
figure()
heatmap(fe_data, Colormap = turbo(4));
title('Front Ends')

% save 
save_path = ''; % fill in
fname = [char(save_path) '\feMap.svg'];
saveas(gcf, fname, 'svg');
fname = [char(save_path) '\feMap.png'];
saveas(gcf, fname, 'png');