function [imp_data] = analyzeAllImpedance(folder_path)
%%% given a parent directory [folder_path], will analyze all impedance
%%% checks in subdirectories and put results into [imp_data] as organized
%%% by array then date
%%% MAT
%%% 20260408

%% ADD PATHS

addBoxPath('Box\JAGLAB\Tasks\FeedbackDecode\dependencies');

%% GET DIRS
my_folders = dir(folder_path);
my_folders = my_folders(~matches({my_folders.name},[".",".."]),:);

%% INIT VARS
imp_data = struct(); % Initialize the structure to hold impedance data
sample_num = 1; % variable to increment position withing data struct

%% ITERATE OVER FOLDERS

for kk = 1:length(my_folders)
    subfolder = [my_folders(kk).folder '\' my_folders(kk).name]; % get subfolder
    
    sub_dir = dir(subfolder);
    sub_dir = sub_dir(~matches({sub_dir.name},[".",".."]),:);

    for jj = 1:length(sub_dir)
        my_file = [sub_dir(jj).folder '\' sub_dir(jj).name]; % get data file

        [trial_data] = readRippleImpedance(my_file); % parse data
        
        % get fields
        trial_fields = fields(trial_data);

        % organize by array
        for ll = 1:length(trial_fields)
            if contains(trial_fields{ll},'file') % skip metadata
                continue;
            end

            % assign data
            trial_date = trial_data.(trial_fields{ll}).date; % remove spaces
            imp_data(sample_num).array = trial_fields{ll}; % assign data
            impedance = [trial_data.(trial_fields{ll}).impedance];
            broken_indx = impedance > 500; % broken electrodes are those with impedance over 500 kOhms
            imp_data(sample_num).impedance = impedance;
            imp_data(sample_num).broken = sum(broken_indx,'all');
            imp_data(sample_num).date = trial_date;
            imp_data(sample_num).impedance_mean = mean(impedance(~broken_indx & ~isnan(impedance)));
            imp_data(sample_num).impedance_std = std(impedance(~broken_indx & ~isnan(impedance)));

            % increment struct position
            sample_num = sample_num+1;
        end

    end % iterate over daily trials

end % iterate over folders

%% PRINT VALUES OF INTEREST
% get impedance data
usea1_imp = [imp_data(contains({imp_data.array},'USEA1')).impedance_mean];
usea2_imp = [imp_data(contains({imp_data.array},'USEA2')).impedance_mean];
usea3_imp = [imp_data(contains({imp_data.array},'USEA3')).impedance_mean];

% remove hi-Z data
usea1_imp(usea1_imp > 500) = [];
usea2_imp(usea2_imp > 500) = [];
usea3_imp(usea3_imp > 500) = [];

usea_all = [usea1_imp usea2_imp usea3_imp];

display(['usea1 Z mean: ' num2str(mean(usea_all))]);
display(['usea2 Z std: ' num2str(std(usea_all))]);

usea1_brk = [imp_data(contains({imp_data.array},'USEA1')).broken];
usea2_brk = [imp_data(contains({imp_data.array},'USEA2')).broken];
usea3_brk = [imp_data(contains({imp_data.array},'USEA3')).broken];

display(['usea1 brk min: ' num2str(min(usea1_brk))]);
display(['usea2 brk min: ' num2str(min(usea2_brk))]);
display(['usea3 brk min: ' num2str(min(usea3_brk))]);

display(['usea1 brk max: ' num2str(max(usea1_brk))]);
display(['usea2 brk max: ' num2str(max(usea2_brk))]);
display(['usea3 brk max: ' num2str(max(usea3_brk))]);

end % analyzeAllImpedance