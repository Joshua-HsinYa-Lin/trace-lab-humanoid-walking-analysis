tic
clear;
clc;
close all;

inversefile_assisted = 'FullBody_IC_walk_01_InverseDynamicStudy.anydata.h5';
markerfile_assisted = 'FullBody_IC_walk_01_MarkerTracking.anydata.h5';
GRF_file = 'GRF_FullBody_IC_walk_01_InverseDynamicStudy.anydata.h5';
%GRF_file = 'GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_InverseDynamicStudy.anydata.h5';
inversefile_single = GRF_file;

csv_dir = fullfile(pwd, 'data_csv');
report_dir = fullfile(pwd, 'reports');
fig_dir = fullfile(pwd, 'figures');

if ~exist(csv_dir, 'dir')
    mkdir(csv_dir); 
end
if ~exist(report_dir, 'dir')
    mkdir(report_dir); 
end
if ~exist(fig_dir, 'dir')
    mkdir(fig_dir); 
end

leg_paths = struct();
leg_paths.Right = {'/Output/_Main/HumanModel/BodyModel/SelectedOutput/Right/Leg/'};
leg_paths.Left = {'/Output/_Main/HumanModel/BodyModel/SelectedOutput/Left/Leg/'};

angle_paths = struct();
angle_paths.Right = {'/Output/_Main/HumanModel/BodyModel/Interface/Right/'};
angle_paths.Left = {'/Output/_Main/HumanModel/BodyModel/Interface/Left/'};

hand_paths = struct();
hand_paths.Right = {'/Output/_Main/HumanModel/BodyModel/SelectedOutput/Right/ShoulderArm/'};
hand_paths.Left = {'/Output/_Main/HumanModel/BodyModel/SelectedOutput/Left/ShoulderArm/'};

plate_paths = struct();
plate_paths.Right = {'/Output/_Main/EnvironmentModel/ForcePlates/Plate1/ForcePlate/Force/Fout', '/Output/_Main/EnvironmentModel/ForcePlates/GRF_Prediction_Right/'};
plate_paths.Left = {'/Output/_Main/EnvironmentModel/ForcePlates/Plate2/ForcePlate/Force/Fout', '/Output/_Main/EnvironmentModel/ForcePlates/GRF_Prediction_Left/'};

follower_paths = struct();
follower_paths.Fout = {'/Output/FollowerHand/HandOfGod/Fout'};
follower_paths.F = {'/Output/FollowerHand/HandOfGod/RefFrameOutput/F'};
follower_paths.M = {'/Output/FollowerHand/HandOfGod/RefFrameOutput/M'};

single_grf_paths = struct();
single_grf_paths.Plate1 = {'/Output/_Main/EnvironmentModel/ForcePlates/GRF_Prediction_Right/', '/Output/_Main/EnvironmentModel/ForcePlates/Plate1/ForcePlate/Force/Fout'};
single_grf_paths.Plate2 = {'/Output/_Main/EnvironmentModel/ForcePlates/GRF_Prediction_Left/', '/Output/_Main/EnvironmentModel/ForcePlates/Plate2/ForcePlate/Force/Fout'};

run_extraction = true;
run_plotting = true;

if run_extraction
    fprintf('Starting Data Extraction Phase\n');
    
    run_analysis(inversefile_assisted, csv_dir, leg_paths);
    run_angles(inversefile_assisted, csv_dir, angle_paths);
    run_follower(inversefile_assisted, csv_dir, follower_paths);
    run_hand(inversefile_assisted, csv_dir, hand_paths);
    run_GRF(inversefile_assisted, fullfile(csv_dir, 'grf_data.csv'), plate_paths); 
    run_single_hand(GRF_file, csv_dir, hand_paths);
    run_single_leg(GRF_file, csv_dir, leg_paths);
    run_GRF_single(GRF_file, csv_dir, single_grf_paths);  
    
    fprintf('Data Extraction Complete\n\n');
end

if run_plotting
    fprintf('Starting Plotting and Reporting Phase\n');
    
    plot_results(csv_dir, report_dir);
    plot_angles(csv_dir, report_dir);
    plot_hand(csv_dir, report_dir);
    plot_follower(csv_dir, report_dir);
    plot_GRF(csv_dir, report_dir);
    plot_GRFvsHOG(csv_dir, report_dir);
    plot_single(csv_dir);        
    plot_single_GRFandLeg(csv_dir, report_dir);
    
    fprintf('Plotting and Reporting Complete\n\n');
end
toc