function [array_type,array_num] = findPort(fname)
%%% returns the vectors [array_type] and [array_num] as parsed from the [fname]
%%% [array_type] contains the cell array type in sequential order
%%% [array_num] contains the cell array with the number for each USEA in sequential order
%%% port on the Summit. eg ['USEA1','USEA2','iEMG','USEA3']

%% SPLIT BASED ON "\" TO GET FNAME
my_path = regexp(fname,'\','split');

fname = my_path{end};

% remove '.txt'
fname = erase(fname,'.txt');


%%  SPLIT BASED ON "+" TO GET PORTS
my_ports = regexp(fname,'+','split');


%% PARSE PORTS
% initiate output vars
array_type = {};
array_num = {};

% iterate over ports
for kk = 1:length(my_ports)
    % get current port
    my_port = my_ports{kk};

    % split at '_'
    my_array = regexp(my_port,'_','split');

    % get relevant array info
    my_array = my_array{2};
    
    if my_array(1) == 'U'
        array_type{kk} = 'USEA';
        array_num{kk} = my_array(end);

    elseif my_array(1) == 'i'
        array_type{kk} = 'iEMG';
        array_num{kk} = 'NA';

    elseif my_array(1) == 'N'
        array_type{kk} = 'NA';
        array_num{kk} = 'NA';

    else
        array_type{kk} = 'UNKNOWN';
        array_num{kk} = 'UNKNOWN';
        warning('Unknown electrode array...');
    end
end