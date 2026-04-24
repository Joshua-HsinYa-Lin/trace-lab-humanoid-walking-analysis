tic
clear;
clc;
close all;

inversefile_assisted = 'FullBody_IC_walk_01_InverseDynamicStudy.anydata.h5';
markerfile_assisted  = 'FullBody_IC_walk_01_MarkerTracking.anydata.h5';
inversefile_single   = 'GRF_FullBody_IC_walk_01_InverseDynamicStudy.anydata.h5';
csv_dir    = fullfile(pwd, 'data_csv');
report_dir = fullfile(pwd, 'reports');
fig_dir    = fullfile(pwd, 'figures');

plate_paths = struct();
plate_paths.Right = '/Output/_Main/EnvironmentModel/ForcePlates/Plate1/ForcePlate/Force/Fout';
plate_paths.Left = '/Output/_Main/EnvironmentModel/ForcePlates/Plate2/ForcePlate/Force/Fout';


if ~exist(csv_dir, 'dir'), mkdir(csv_dir); end
if ~exist(report_dir, 'dir'), mkdir(report_dir); end
if ~exist(fig_dir, 'dir'), mkdir(fig_dir); end

run_extraction = true;
run_plotting   = true;

if run_extraction
    fprintf('Starting Data Extraction Phase\n');
    run_analysis(inversefile_assisted, csv_dir);
    run_angles(inversefile_assisted, csv_dir);
    run_follower(inversefile_assisted, csv_dir);
    run_hand(inversefile_assisted, csv_dir);
    run_GRF(inversefile_assisted, fullfile(csv_dir, 'grf_data.csv'), plate_paths);
    run_single_hand(inversefile_single, csv_dir);
    run_single_leg(inversefile_single, csv_dir);
    run_GRF_single(inversefile_single, csv_dir);  
    
    fprintf('Data Extraction Complete\n\n');
end

if run_plotting
    fprintf('Starting Plotting and Reporting Phase\n');
    
    %plot_results(csv_dir, report_dir);
    %plot_angles(csv_dir, report_dir);
    %plot_hand(csv_dir, report_dir);
    %plot_follower(csv_dir, report_dir);
    plot_GRF(csv_dir, report_dir);
    %plot_GRFvsHOG(csv_dir, report_dir);
    %plot_single(csv_dir);        
    %plot_single_GRFandLeg(csv_dir);
    
    fprintf('Plotting and Reporting Complete\n\n');
end
toc