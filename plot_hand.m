clear;
clc;
close all;

set(0, 'DefaultFigureColor', 'w');      
set(0, 'DefaultAxesColor', 'w');        
set(0, 'DefaultAxesXColor', 'k');       
set(0, 'DefaultAxesYColor', 'k');       
set(0, 'DefaultAxesZColor', 'k');       
set(0, 'DefaultTextColor', 'k');        
set(0, 'DefaultLineLineWidth', 1.5);    

csv_file_right = 'data_csv/interaction_hand_data.csv';
csv_file_left  = 'data_csv/interaction_hand_data_left.csv';
report_file = 'reports/hand_forces_report.md';

if exist(csv_file_right, 'file') ~= 2 || exist(csv_file_left, 'file') ~= 2
    error('One or both CSV files not found! Run run_hand.m first.');
end

fprintf("Loading hand data...");
data_R = readtable(csv_file_right);
data_L = readtable(csv_file_left);
time = data_R.Time; 

fig1 = figure('Name', 'Elbow Joint Analysis', 'Color', 'w', 'Position', [50 100 1200 600]);

subplot(2,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Moment_ElbowFlexion, 'Color', '#0072BD'); 
title('Right Elbow Flexion Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Moment_ElbowFlexion, 'Color', '#0072BD'); 
title('Left Elbow Flexion Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_R.Force_ElbowHumeroUlnar_ProximoDistalForce), 'Color', '#D95319'); 
title('Right Elbow Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(2,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_L.Force_ElbowHumeroUlnar_ProximoDistalForce), 'Color', '#D95319'); 
title('Left Elbow Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig1, 'InvertHardcopy', 'off'); 

fig2 = figure('Name', 'Wrist Joint Analysis', 'Color', 'w', 'Position', [100 150 1200 600]);

subplot(2,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Moment_WristFlexion, 'Color', '#77AC30'); 
title('Right Wrist Flexion Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Moment_WristFlexion, 'Color', '#77AC30'); 
title('Left Wrist Flexion Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_R.Force_WristRadioCarpal_ProximoDistalForce), 'Color', '#A2142F'); 
title('Right Wrist Vertical Load (Walker Push)', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(2,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_L.Force_WristRadioCarpal_ProximoDistalForce), 'Color', '#A2142F'); 
title('Left Wrist Vertical Load (Walker Push)', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig2, 'InvertHardcopy', 'off'); 

fptr = fopen(report_file, 'w');
if fptr == -1
    error('Could not open report file for writing.');
end
fprintf(fptr, 'HAND ASSISTANCE REPORT\n\n');

get_peak = @(v) max(abs(v));

fprintf(fptr, 'ELBOW JOINT\n\n');
fprintf(fptr, '<img src="../docs/elbow.jpg" width="400">\n\n');
fprintf(fptr, 'Max Flexion Torque (Rotational force causing the joint to bend):\nRight: %6.2f Nm  |  Left: %6.2f Nm\n', ...
    get_peak(data_R.Moment_ElbowFlexion), get_peak(data_L.Moment_ElbowFlexion));
fprintf(fptr, 'Max Vertical Load (Upward or downward weight bearing force):\nRight: %6.2f N   |  Left: %6.2f N\n', ...
    get_peak(data_R.Force_ElbowHumeroUlnar_ProximoDistalForce), get_peak(data_L.Force_ElbowHumeroUlnar_ProximoDistalForce));
fprintf(fptr, '\n\n');

fprintf(fptr, 'WRIST JOINT\n');
fprintf(fptr, 'Max Flexion Torque (Rotational force causing the joint to bend):\nRight: %6.2f Nm  |  Left: %6.2f Nm\n', ...
    get_peak(data_R.Moment_WristFlexion), get_peak(data_L.Moment_WristFlexion));
fprintf(fptr, 'Max Vertical Load (Upward or downward weight bearing force):\nRight: %6.2f N   |  Left: %6.2f N\n', ...
    get_peak(data_R.Force_WristRadioCarpal_ProximoDistalForce), get_peak(data_L.Force_WristRadioCarpal_ProximoDistalForce));
fprintf(fptr, '\n');
fprintf(fptr, '\n');
fclose(fptr);
fprintf('Hand Report successfully written to: %s\n', report_file);