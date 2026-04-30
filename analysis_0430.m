tic
clear;
clc;
close all;

base_dir = pwd;
anydata_dir = fullfile(base_dir, 'anydata');
csv_dir = fullfile(base_dir, 'data_csv');
report_dir = fullfile(base_dir, 'reports');
fig_dir = fullfile(base_dir, 'analysis_figure');

dir_csv_exists = exist(csv_dir, 'dir');
if ~dir_csv_exists
    mkdir(csv_dir);
end

dir_rep_exists = exist(report_dir, 'dir');
if ~dir_rep_exists
    mkdir(report_dir);
end

dir_fig_exists = exist(fig_dir, 'dir');
if ~dir_fig_exists
    mkdir(fig_dir);
end

conditions = {'Both20', 'Both30', 'Both40', 'Both50', 'Lin10', 'Lin30', 'Lin40', 'Lin50'};
filename = 'FullBody_IC_walker_WL_helper_push_beam_walk_w_rod_real_01_InverseDynamicStudy.anydata.h5';

plate_paths = struct();
plate_paths.Right = {'/Output/_Main/EnvironmentModel/ForcePlates/Plate1/ForcePlate/Force/Fout', '/Output/_Main/EnvironmentModel/ForcePlates/GRF_Prediction_Right/'};
plate_paths.Left = {'/Output/_Main/EnvironmentModel/ForcePlates/Plate2/ForcePlate/Force/Fout', '/Output/_Main/EnvironmentModel/ForcePlates/GRF_Prediction_Left/'};

follower_paths = struct();
follower_paths.Fout = {'/Output/FollowerHand/HandOfGod/Fout', '/Output/FollowerHand/HandOfGodLimitedStrength/Fout'};
follower_paths.F = {'/Output/FollowerHand/HandOfGod/RefFrameOutput/F', '/Output/FollowerHand/HandOfGodLimitedStrength/RefFrameOutput/F'};
follower_paths.M = {'/Output/FollowerHand/HandOfGod/RefFrameOutput/M', '/Output/FollowerHand/HandOfGodLimitedStrength/RefFrameOutput/M'};

for c = 1:length(conditions)
    cond = conditions{c};
    
    fprintf('PROCESSING CONDITION: %s\n', cond);
    
    inversefile_assisted = fullfile(anydata_dir, cond, filename);
    
    file_inv_exists = exist(inversefile_assisted, 'file');
    if file_inv_exists ~= 2
        fprintf('File not found: %s\n', inversefile_assisted);
        continue;
    end
    
    grf_csv = fullfile(csv_dir, 'grf_data.csv');
    run_GRF(inversefile_assisted, grf_csv, plate_paths);
    
    run_follower(inversefile_assisted, csv_dir, follower_paths);
    
    plot_GRF(csv_dir, report_dir, cond, fig_dir);
    plot_GRFvsHOG(csv_dir, report_dir, cond, fig_dir);
    
    fprintf('\n>>> Figures for %s generated and saved automatically. <<<\n', cond);
    close all;
end

fprintf('\nBatch Automated Analysis Complete! All figures saved to %s\n', fig_dir);
toc