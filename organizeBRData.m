function [br_data] = organizeBRData(br_data)
%ORGANIZEBRIMP rearrange br_data vector into 2D usea shape. Assumes the
%input data has been sorted such that it i 1-96 or 1-100.

%% INIT FCN IO
arguments (Input)
    br_data
end

arguments (Output)
    br_data
end

%% CONFRIM DIM OF INPUT DATA

data_size = size(br_data);

% transpose if necessary
if data_size(1) ~= 1
    br_data = br_data';
    data_size = size(br_data); % remeasure size
end

% err out if wrong size
if data_size(2) ~= 96 && data_size(2) ~= 100
    error('br_data is wrong size.')
end

%% RESIZE IF 

if data_size < 100
    br_data = [br_data(1:90) nan([1,2]) br_data(91:96) nan([1,2])];
end

%% RESHAPE DATA
br_data = reshape(br_data,[10 10]);
br_data = rot90(br_data,2);

end