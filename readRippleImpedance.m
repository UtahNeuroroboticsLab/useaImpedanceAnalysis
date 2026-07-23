function [data] = readRippleImpedance(filename,varargin)
% Script for importing Ripple human array impedance data from the text file
% saved by the impedance tester
%
%   inputs: filename.  String.  full file path.
%   outputs: data.  A structure containing the following fields
%       .array. A structure labeling the electrode type for said port
%           .file = file name string
%           .elec = elec number
%           .ch = channel number
%           .impedance = impedance
 %          .units 
%           .firstQuartialMedian= first quartile median (not trimmed)
%           .median = untrimmed median
%           .fourthQuartileMedian = last quartile median (not trimmed)
%           .trimmedMedian = trimmed mean;
%           .trimmedMean =  mean(data.impedance(workingElecInd));
%           .numWorkingElectrodes  = number of working electrodes
%           .maxImpedanceUsed = max impedance value used in trimmed mean and
%           for num working electrodes
%
%   example : >> data =  ReadRippleImpedance("C:\Users\Administrator\Box\Implant Trial\Data\p202601\Impedance\20260201\A_USEA1+B_USEA2+C_iEMG+D_NA.txt");
% smw 07/07/2014
% MAT 20260408 - updated for multiple arrays as dictacted by the filename
% filename must follow this naming procedure:
% "A_elecX+B_elecX+C_elecX+D_elecX"
% where elecX can be "iEMG", "USEAX", or "NA"

%% ADD PATHS

addBoxPath('Box\JAGLAB\Tasks\FeedbackDecode\dependencies');

%% INIT VARS 
I = []; % empty output
port_chans = 0; % for allocating channels to a port


%% PARSE FILE
filename = char(filename);
fid= fopen(filename);

txtdata = char(fread(fid, 'char'));

fclose(fid);

a = regexp(txtdata', 'Nip1', 'split');
date_indx = regexp(txtdata','[Test Date]','once');
data.file = filename;


% scan text data cell
numchans = length(a)-1;

% get date
time_indx = regexp(txtdata','Time]','once');
date = txtdata((date_indx+23):(time_indx-11))';

a = a(2:end); % trim off first cell entry since it contains crud


%% PARSE FILENAME
[array_type,array_num] = findPort(filename);


% assign array metadate
for kk = 1:length(array_num)
    if contains(array_type{kk}, 'USEA')
        array_name{kk} = [array_type{kk} array_num{kk}];
        data.(array_name{kk}).num = array_num{kk};
        port_chans = [port_chans(end)+1:port_chans(end)+32*3];

    elseif contains(array_type{kk}, 'iEMG')
        array_name{kk} = [array_type{kk}];
        data.(array_name{kk}).num = 'NA';
        port_chans = [port_chans(end)+1:port_chans(end)+32];

    else
        continue;
    end % check and label type


    %% PARSE DATA

    % assign date of experiment
    data.(array_name{kk}).date = datetime(date,"InputFormat","MMM d yyyy");

    data.(array_name{kk}).ch = [port_chans]';
    data.(array_name{kk}).impedance = zeros(length(port_chans),1);
    data.(array_name{kk}).phase = zeros(length(port_chans),1);

    for ii = port_chans(1):port_chans(end)
        b = regexp(a{ii}, '\s\s\s\s\s', 'split');
        data.(array_name{kk}).impedance(ii-port_chans(1)+1) = str2double(b{4});
        data.(array_name{kk}).phase(ii-port_chans(1)+1) = str2double(b{5});
    end % iterate over relevant data

    if contains(array_name{kk}, 'USEA')

        % get channels and convert to electrodes
        elects = c2e(1:96,'BIOS');
        data.(array_name{kk}).electrodes = elects;
        
        % get blackrock mapping
        br_map = biosArray();

        % find appropriate indeces
        [~,elect_map] = ismember(elects,br_map); 

        % insert impedance values into appropriate index
        imp_map = br_map;
        imp_map(elect_map) = data.(array_name{kk}).impedance;

        % insert phase values into appropriate index
        phs_map = br_map;
        phs_map(elect_map) = data.(array_name{kk}).phase;


        data.(array_name{kk}).impedance = imp_map;
        data.(array_name{kk}).phase = phs_map;

    end
    %% calculate stats
    % maxImpedance = 500 ; % kOhms.  max value for an electrode to be considered "working"
    % y = sort(data.impedance);
    % compute 25th percentile (first quartile)
    % Q(1) = median(y(y<median(y)));
    % data.firstQuartialMedian= Q(1);
    % compute 50th percentile (second quartile)
    % Q(2) = median(y);
    % data.median = Q(2);
    % compute 75th percentile (3rd quartile)
    % Q(3) = median(y(y>median(y)));
    % data.fourthQuartileMedian = Q(3);

    % workingElecInd =find(data.impedance(data.impedance > 0 & data.impedance < maxImpedance));
    % data.trimmedMedian = median(data.impedance(workingElecInd));
    % data.trimmedMean =  mean(data.impedance(workingElecInd));
    % data.numWorkingElectrodes = length(workingElecInd);
    % data.maxImpedanceThresh = maxImpedance;

    % data.value = data.impedance(1:96);
end % iterate over array type

%% VISUALIZE 
% H = figure;
% % imagesc(I)
% heatmap(I)
% title(regexp(filename,'USEA\d','match','once'))
% caxis([0 500]);
% colorbar



end




