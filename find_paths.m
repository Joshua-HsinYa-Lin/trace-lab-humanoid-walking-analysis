clear;
clc;

inversefile = 'GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_InverseDynamicStudy.anydata.h5';

base_path = '/Output/_Main/HumanModel/BodyModel/SelectedOutput/Right/';

try
    info = h5info(inversefile, base_path);
    fprintf('Folders found under %s:\n\n', base_path);
    for i = 1:length(info.Groups)
        % Extract just the folder name from the full path
        split_path = strsplit(info.Groups(i).Name, '/');
        folder_name = split_path{end};
        fprintf('  - %s\n', folder_name);
    end
catch ME
    fprintf('Error reading path: %s\n', ME.message);
end