%% Import File
clear; 
clc; 
close all;
csv_file_right = 'interaction_joint_data.csv';
csv_file_left  = 'interaction_joint_data_left.csv';
report_file = 'joint_forces_report.txt';
if exist(csv_file_right, 'file') ~= 2 || exist(csv_file_left, 'file') ~= 2
    error('One or both CSV files not found! Run run_analysis.m first.');
end
data_R = readtable(csv_file_right);
data_L = readtable(csv_file_left);
time = data_R.Time;

%% Plot Format Setting
set(0, 'DefaultFigureColor', 'w');      
set(0, 'DefaultAxesColor', 'w');        
set(0, 'DefaultAxesXColor', 'k');       
set(0, 'DefaultAxesYColor', 'k');       
set(0, 'DefaultAxesZColor', 'k');       
set(0, 'DefaultTextColor', 'k');        
set(0, 'DefaultLineLineWidth', 1.5);

%% Generate Text Report
fptr = fopen(report_file, 'w');

if fptr == -1
    error('Could not open report file for writing.');
end

% Function to Find Maximum Absolute Value
get_peak = @(v) max(abs(v));

% Write Header
fprintf(fptr, '=================================================\n');
fprintf(fptr, '       HUMAN FORCE ANALYSIS REPORT\n');
fprintf(fptr, '       Date: %s\n', datetime('today'));
fprintf(fptr, '=================================================\n\n');

% HIP JOINT
fprintf(fptr, '[HIP JOINT]\n');
fprintf(fptr, '  * Max Flexion Torque:    Right: %6.2f Nm  |  Left: %6.2f Nm\n', ...
    get_peak(data_R.Moment_HipFlexion), get_peak(data_L.Moment_HipFlexion));
fprintf(fptr, '  * Max Abduction Torque:  Right: %6.2f Nm  |  Left: %6.2f Nm\n', ...
    get_peak(data_R.Moment_HipAbduction), get_peak(data_L.Moment_HipAbduction));
fprintf(fptr, '  * Max Vertical Load:     Right: %6.2f N   |  Left: %6.2f N\n', ...
    get_peak(data_R.Force_Hip_ProximoDistalForce), get_peak(data_L.Force_Hip_ProximoDistalForce));
fprintf(fptr, '  ------------------------------------------\n\n');

% KNEE JOINT
fprintf(fptr, '[KNEE JOINT]\n');
fprintf(fptr, '  * Max Flexion Torque:    Right: %6.2f Nm  |  Left: %6.2f Nm\n', ...
    get_peak(data_R.Moment_KneeFlexion), get_peak(data_L.Moment_KneeFlexion));
fprintf(fptr, '  * Max Vertical Load:     Right: %6.2f N   |  Left: %6.2f N\n', ...
    get_peak(data_R.Force_Knee_ProximoDistalForce), get_peak(data_L.Force_Knee_ProximoDistalForce));
fprintf(fptr, '  ------------------------------------------\n\n');

% ANKLE JOINT
fprintf(fptr, '[ANKLE JOINT]\n');
fprintf(fptr, '  * Max Plantar Torque:    Right: %6.2f Nm  |  Left: %6.2f Nm\n', ...
    get_peak(data_R.Moment_AnklePlantarFlexion), get_peak(data_L.Moment_AnklePlantarFlexion));
fprintf(fptr, '  * Max Lateral Force:     Right: %6.2f N   |  Left: %6.2f N\n', ...
    get_peak(data_R.Force_Ankle_MedioLateralForce), get_peak(data_L.Force_Ankle_MedioLateralForce));
fprintf(fptr, '  ------------------------------------------\n');

fclose(fptr);
fprintf("Report Written!\n");

%% FIGURE 1: HIP JOINT ANALYSIS
fig1 = figure('Name', 'Hip Joint Analysis', 'Color', 'w', 'Position', [50 100 1200 800]);

% Right Hip Torques
subplot(3,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Moment_HipFlexion, 'Color', '#0072BD'); 
hold on;
plot(time, data_R.Moment_HipAbduction, 'Color', '#D95319', 'LineStyle', '--');
title('Right Hip Torques', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;
legend('Flexion', 'Abduction', 'Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

% Left Hip Torques
subplot(3,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Moment_HipFlexion, 'Color', '#0072BD'); 
hold on;
plot(time, data_L.Moment_HipAbduction, 'Color', '#D95319', 'LineStyle', '--');
title('Left Hip Torques', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;
legend('Flexion', 'Abduction', 'Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

% Right Hip Vertical Load
subplot(3,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_R.Force_Hip_ProximoDistalForce), 'Color', '#0072BD'); 
title('Right Hip Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;

% Left Hip Vertical Load
subplot(3,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_L.Force_Hip_ProximoDistalForce), 'Color', '#0072BD'); 
title('Left Hip Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;

% Right Hip Lateral Force
subplot(3,2,5);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Force_Hip_MediolateralForce, 'Color', '#D95319'); 
title('Right Hip Lateral Force', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

% Left Hip Lateral Force
subplot(3,2,6);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Force_Hip_MediolateralForce, 'Color', '#D95319'); 
title('Left Hip Lateral Force', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig1, 'InvertHardcopy', 'off'); 

%% FIGURE 2: KNEE JOINT ANALYSIS
fig2 = figure('Name', 'Knee Joint Analysis', 'Color', 'w', 'Position', [100 150 1200 600]);

% Right Knee Torque
subplot(2,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Moment_KneeFlexion, 'Color', '#77AC30');
title('Right Knee Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

% Left Knee Torque
subplot(2,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Moment_KneeFlexion, 'Color', '#77AC30');
title('Left Knee Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

% Right Knee Vertical Load
subplot(2,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_R.Force_Knee_ProximoDistalForce), 'Color', '#77AC30'); 
title('Right Knee Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

% Left Knee Vertical Load
subplot(2,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_L.Force_Knee_ProximoDistalForce), 'Color', '#77AC30'); 
title('Left Knee Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig2, 'InvertHardcopy', 'off'); 

%% FIGURE 3: ANKLE JOINT ANALYSIS
fig3 = figure('Name', 'Ankle Joint Analysis', 'Color', 'w', 'Position', [150 200 1200 800]);

% Right Ankle Torque
subplot(3,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Moment_AnklePlantarFlexion, 'Color', '#A2142F');
title('Right Ankle Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

% Left Ankle Torque
subplot(3,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Moment_AnklePlantarFlexion, 'Color', '#A2142F');
title('Left Ankle Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

% Right Ankle Vertical Load
subplot(3,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_R.Force_Ankle_ProximoDistalForce), 'Color', '#A2142F'); 
title('Right Ankle Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;

% Left Ankle Vertical Load
subplot(3,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_L.Force_Ankle_ProximoDistalForce), 'Color', '#A2142F'); 
title('Left Ankle Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;

% Right Ankle Lateral Force
subplot(3,2,5);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Force_Ankle_MedioLateralForce, 'Color', '#7E2F8E'); 
title('Right Ankle Lateral Force', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

% Left Ankle Lateral Force
subplot(3,2,6);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Force_Ankle_MedioLateralForce, 'Color', '#7E2F8E'); 
title('Left Ankle Lateral Force', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig3, 'InvertHardcopy', 'off');

fprintf("Graphs Plotted!\n")