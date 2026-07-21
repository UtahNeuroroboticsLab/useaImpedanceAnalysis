function addBoxPath(des_path)
%%% checks if [des_path] is in current working directory and adds it if it
%%% isnt
%%% MAT
%%% 20260408

% establish home directory
home_dir = cd();
home_path = regexp(home_dir,'\\','split');
home_path = home_path(1:3);
home_path = fullfile(home_path{:});

% add dependencies
dep_dir = fullfile(home_path, des_path);

% check paths
curr_paths = path();

% add path
if ~contains(curr_paths,dep_dir)
    addpath(dep_dir);
end

end