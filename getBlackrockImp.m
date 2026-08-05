function [imp_data] = getBlackrockImp(usea_data)
%GETBLACKROCKIMP gets the impedance from the blackrock USEA spreadsheets
%   goes through list of files in usea_data, reads the file path corresponding
%   to each array, and assigns the data in imp_data

%% INIT ARGS
arguments (Input)
    usea_data cell
end

arguments (Output)
    imp_data struct
end

%% INIT VARS
imp_data = struct();

%% CYCLE THROUGH USEA_DATA

% loop over usea_data
for my_usea = 1:length(usea_data)

    % get file name 
    fname = char(usea_data{my_usea});

    % assign array number
    imp_data(my_usea).array = ['USEA' num2str(my_usea)];

    % get serial number
    imp_data(my_usea).sn = fname(end-7:end-4);

    % read table
    imp_table = readtable(usea_data{my_usea});

    % get impedance
    Z = imp_table.NSPZ;

    % get electrode number
    e_nums = imp_table.GatorPad__WBOrder_Elect_;
    e_nums = regexp(e_nums,'elec','split'); % remove extra string
    e_nums = [e_nums{:}]; % remove extra dimension
    e_nums = str2double(e_nums(2:2:end)); % remove extra characters

    % sort electrode numbers
    [~,e_nums_indx] = sort(e_nums);

    % sort impedances
    Z = Z(e_nums_indx);

    % count broken electrodes and get impedance stats
    broken_indx = Z > 500; % broken electrodes are those with impedance over 500 kOhms
    imp_data(my_usea).broken = sum(broken_indx,'all');
    imp_data(my_usea).impedance_mean = mean(Z(~broken_indx & ~isnan(Z)));
    imp_data(my_usea).impedance_std = std(Z(~broken_indx & ~isnan(Z)));

    % sort into the appropriate shape
    Z = organizeBRData(Z);


    imp_data(my_usea).impedance = Z;


end % loop over usea_data

end