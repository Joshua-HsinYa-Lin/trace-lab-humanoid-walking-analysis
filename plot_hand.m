%% Setup and Import
clear;
clc;
close all;

% GLOBAL VISUAL SETTINGS
set(0, 'DefaultFigureColor', 'w');      
set(0, 'DefaultAxesColor', 'w');        
set(0, 'DefaultAxesXColor', 'k');       
set(0, 'DefaultAxesYColor', 'k');       
set(0, 'DefaultAxesZColor', 'k');       
set(0, 'DefaultTextColor', 'k');        
set(0, 'DefaultLineLineWidth', 1.5);    

% Define the files
csv_file_right = 'data_csv/interaction_hand_data.csv';
csv_file_left  = 'data_csv/interaction_hand_data_left.csv';
report_file = 'reports/hand_forces_report.txt';

% Check if files exist
if exist(csv_file_right, 'file') ~= 2 || exist(csv_file_left, 'file') ~= 2
    error('One or both CSV files not found! Run run_hand.m first.');
end

% Import Data
disp('Loading hand data...');
data_R = readtable(csv_file_right);
data_L = readtable(csv_file_left);
time = data_R.Time; 

%% FIGURE 1: ELBOW JOINT ANALYSIS
fig1 = figure('Name', 'Elbow Joint Analysis', 'Color', 'w', 'Position', [50 100 1200 600]);

% Right Elbow Torque
subplot(2,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Moment_ElbowFlexion, 'Color', '#0072BD'); 
title('Right Elbow Flexion Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

% Left Elbow Torque
subplot(2,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Moment_ElbowFlexion, 'Color', '#0072BD'); 
title('Left Elbow Flexion Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

% Right Elbow Vertical Load
subplot(2,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_R.Force_ElbowHumeroUlnar_ProximoDistalForce), 'Color', '#D95319'); 
title('Right Elbow Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

% Left Elbow Vertical Load
subplot(2,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_L.Force_ElbowHumeroUlnar_ProximoDistalForce), 'Color', '#D95319'); 
title('Left Elbow Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig1, 'InvertHardcopy', 'off'); 

%% FIGURE 2: WRIST JOINT ANALYSIS
fig2 = figure('Name', 'Wrist Joint Analysis', 'Color', 'w', 'Position', [100 150 1200 600]);

% Right Wrist Torque
subplot(2,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Moment_WristFlexion, 'Color', '#77AC30'); 
title('Right Wrist Flexion Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

% Left Wrist Torque
subplot(2,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Moment_WristFlexion, 'Color', '#77AC30'); 
title('Left Wrist Flexion Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

% Right Wrist Vertical Load
subplot(2,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_R.Force_WristRadioCarpal_ProximoDistalForce), 'Color', '#A2142F'); 
title('Right Wrist Vertical Load (Walker Push)', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

% Left Wrist Vertical Load
subplot(2,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_L.Force_WristRadioCarpal_ProximoDistalForce), 'Color', '#A2142F'); 
title('Left Wrist Vertical Load (Walker Push)', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig2, 'InvertHardcopy', 'off'); 

%% Generate Comparative Text Report
fptr = fopen(report_file, 'w');

if fptr == -1
    error('Could not open report file for writing.');
end

% Function to Find Maximum Absolute Value
get_peak = @(v) max(abs(v));

% Write Header
fprintf(fptr, '==================================================\n');
fprintf(fptr, '              HAND ASSISTANCE REPORT\n');
fprintf(fptr, '==================================================\n\n');

% ELBOW JOINT
fprintf(fptr, 'ELBOW JOINT\n');
fprintf(fptr, 'Max Flexion Torque:    Right: %6.2f Nm  |  Left: %6.2f Nm\n', ...
    get_peak(data_R.Moment_ElbowFlexion), get_peak(data_L.Moment_ElbowFlexion));
fprintf(fptr, 'Max Vertical Load:     Right: %6.2f N   |  Left: %6.2f N\n', ...
    get_peak(data_R.Force_ElbowHumeroUlnar_ProximoDistalForce), get_peak(data_L.Force_ElbowHumeroUlnar_ProximoDistalForce));
fprintf(fptr, '\n');
fprintf(fptr, '------------------------------------------------------------\n\n');

% WRIST JOINT (CRITICAL FOR WALKER HYPOTHESIS)
fprintf(fptr, 'WRIST JOINT\n');
fprintf(fptr, 'Max Flexion Torque:    Right: %6.2f Nm  |  Left: %6.2f Nm\n', ...
    get_peak(data_R.Moment_WristFlexion), get_peak(data_L.Moment_WristFlexion));
fprintf(fptr, 'Max Vertical Load:     Right: %6.2f N   |  Left: %6.2f N\n', ...
    get_peak(data_R.Force_WristRadioCarpal_ProximoDistalForce), get_peak(data_L.Force_WristRadioCarpal_ProximoDistalForce));
fprintf(fptr, '\n');
fprintf(fptr, '\n');

fclose(fptr);
fprintf('Hand Report successfully written to: %s\n', report_file);