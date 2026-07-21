function [BIOS_c2e, BIOS_e2c] = generateElectrodeChanCombos(table_path)
%generateElectrodeChanCombos Converts a the table found at the given path
%to the electrode channel pairs necessary for e2c and c2e respectively
%MAT
%20260622

%% ADD PATH
addBoxPath('Box\JAGLAB\Tasks\FeedbackDecode\dependencies');

%% INIT VARS
BIOS_c2e = zeros([1 100]);
BIOS_e2c = NaN([1 100]);

%% READ TABLE
my_data = readtable(table_path);
USEA = my_data.USEA;
BIOS = my_data.BIOS;


%% PARSE NET NAMES

% loop over data
for electrode = 1:length(USEA)
    
    % current e/c pair
    e_num = USEA(electrode);
    bios_chan = char(BIOS{electrode});

    % check if GND
    if contains(bios_chan, {'GND','WR'}, 'IgnoreCase', true)
        %then skip
        continue;
    end

    % split bios channel into port and FE channel
    fe_bank = bios_chan(1);
    fe_num = bios_chan(2:end);

    % offset by FE number
    if fe_bank == 'A' 
        fe_num = str2double(fe_num);
    elseif fe_bank == 'B'
        fe_num = str2double(fe_num)+32;
    elseif fe_bank == 'C'
        fe_num = str2double(fe_num)+64;
    end

    try
        if isnan(BIOS_e2c(e_num))
            BIOS_e2c(e_num) = fe_num;
            BIOS_c2e(fe_num) = e_num;
        else
            display('Duplicate entry...')
        end
    catch
        disp(['Something is wrong at entry ' num2str(e_num)])
        disp(['electrode ' num2str(e_num)])
        disp(['FE ' fe_bank num2str(fe_num)])
        disp('')
    end


end % looping over net names 

end