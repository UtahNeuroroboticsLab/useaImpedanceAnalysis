function visualizeHeatmaps(folder_path, dates, save_path)
%VISUALIZEHEATMAPS shows the impedance heatmaps of the arrays for given dates 
%   Given the folder_path to the impedance data, visualizeHeatmaps will
%   generate the heatmaps for the dates closest to those listed in dates

%% DEFINE INPUTS
arguments (Input)
    folder_path char % mandatory inpute
    dates datetime % mandatory list of dates
    save_path string = "" % default to no path
end

%% RUN ANALYSIS

% usea manuals
pre_imp_data = getBlackrockImp(preImplantImpPath());

% measured data
[imp_data] = analyzeImpedance(folder_path);

%% SEPARATE DATA

% get list of array types pre implant
arrays_pi = {pre_imp_data.array};

% sort out different arrays for pre implant data
u1_pi = pre_imp_data(contains(arrays_pi, 'USEA1'));
u2_pi = pre_imp_data(contains(arrays_pi, 'USEA2'));
u3_pi = pre_imp_data(contains(arrays_pi, 'USEA3'));

% get list of array types post implant
arrays = {imp_data.array};

% sort out different arrays
u1 = imp_data(contains(arrays, 'USEA1'));
u2 = imp_data(contains(arrays, 'USEA2'));
u3 = imp_data(contains(arrays, 'USEA3'));

%% FIND RELEVANT DATES

% get list of dates from data
u1_dates = [u1.date];
u2_dates = [u2.date];
u3_dates = [u3.date];

% loop through desired dates
for date_indx = 1:length(dates)

    % get relevant date
    my_date = dates(date_indx);

    % compare my_date to lists of dates and find closest one before or on
    % given date
    u1_doi(date_indx) = find(my_date <= u1_dates, 1, 'first');
    u2_doi(date_indx) = find(my_date <= u2_dates, 1, 'first');
    u3_doi(date_indx) = find(my_date <= u3_dates, 1, 'first');


end % loop through dates

%% VISUALIZE

% calculate layout dimensions
rows = ceil((length(dates)+1)/3);
cols = min(3,(length(dates)+1));

%%%% visualize usea 1
figure('WindowStyle','normal');
tiledlayout(rows, cols);

% start with preimplant
nexttile;
% plot heatmap
heatmap(u1_pi.impedance);
title('Pre-Implant');
% set color and limits
colormap('turbo')
clim([0 500])

% cycle through dates of interest
for doi_indx = 1:length(dates)
    nexttile;
    % plot heatmap
    heatmap(u1(u1_doi(doi_indx)).impedance);
    title(string(u1(u1_doi(doi_indx)).date));
    % set color and limits
    colormap('turbo')
    clim([0 500])
end

% save plot if given a save path
if save_path ~= ""
    fname = [char(save_path) '\usea1Imps.svg'];
    saveas(gcf, fname, 'svg');
    fname = [char(save_path) '\usea1Imps.png'];
    saveas(gcf, fname, 'png');
end

%%%% repeat for usea 2
figure('WindowStyle','normal');
tiledlayout(rows, cols);

% start with preimplant
nexttile;
% plot heatmap
heatmap(u2_pi.impedance);
title('Pre-Implant');
% set color and limits
colormap('turbo')
clim([0 500])

% cycle through dates of interest
for doi_indx = 1:length(dates)
    nexttile;
    % plot heatmap
    heatmap(u2(u2_doi(doi_indx)).impedance);
    title(string(u2(u2_doi(doi_indx)).date));
    % set color and limits
    colormap('turbo')
    clim([0 500])
end

% save plot if given a save path
if save_path ~= ""
    fname = [char(save_path) '\usea2Imps.svg'];
    saveas(gcf, fname, 'svg');
    fname = [char(save_path) '\usea2Imps.png'];
    saveas(gcf, fname, 'png');
end

%%%% repeat for usea 3
figure('WindowStyle','normal');
tiledlayout(rows, cols);

% start with preimplant
nexttile;
% plot heatmap
heatmap(u3_pi.impedance);
title('Pre-Implant');
% set color and limits
colormap('turbo')
clim([0 500])

% cycle through dates of interest
for doi_indx = 1:length(dates)
    nexttile;
    % plot heatmap
    heatmap(u3(u3_doi(doi_indx)).impedance);
    title(string(u3(u3_doi(doi_indx)).date));
    % set color and limits
    colormap('turbo')
    clim([0 500])
end

% save plot if given a save path
if save_path ~= ""
    fname = [char(save_path) '\usea3Imps.svg'];
    saveas(gcf, fname, 'svg');
    fname = [char(save_path) '\usea3Imps.png'];
    saveas(gcf, fname, 'png');
end

end %end visualizeHeatmaps