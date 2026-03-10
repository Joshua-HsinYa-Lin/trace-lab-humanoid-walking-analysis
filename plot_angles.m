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

% Define the CSV files
csv_file_right = 'data_csv/interaction_angles_right.csv';
csv_file_left  = 'data_csv/interaction_angles_left.csv';
report_file = 'reports/kinematics_report.md';

% Check if files exist
if exist(csv_file_right, 'file') ~= 2 || exist(csv_file_left, 'file') ~= 2
    error('One or both CSV files not found! Run run_angles.m first.');
end

% Import Data
disp('Loading kinematic data...');
data_R = readtable(csv_file_right);
data_L = readtable(csv_file_left);
time = data_R.Time; 

%% FIGURE 1: LOWER BODY KINEMATICS
fig1 = figure('Name', 'Leg Joint Angles', 'Color', 'w', 'Position', [50 100 1200 800]);

% Right Hip Angles
subplot(3,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Angle_HipFlexion, 'Color', '#0072BD'); 
hold on;
plot(time, data_R.Angle_HipAbduction, 'Color', '#D95319', 'LineStyle', '--');
title('Right Hip Angles', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;
legend('Flexion', 'Abduction', 'Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

% Left Hip Angles
subplot(3,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Angle_HipFlexion, 'Color', '#0072BD'); 
hold on;
plot(time, data_L.Angle_HipAbduction, 'Color', '#D95319', 'LineStyle', '--');
title('Left Hip Angles', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;
legend('Flexion', 'Abduction', 'Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

% Right Knee Angle
subplot(3,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Angle_KneeFlexion, 'Color', '#77AC30'); 
title('Right Knee Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

% Left Knee Angle
subplot(3,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Angle_KneeFlexion, 'Color', '#77AC30'); 
title('Left Knee Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

% Right Ankle Angle
subplot(3,2,5);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Angle_AnklePlantarFlexion, 'Color', '#A2142F'); 
title('Right Ankle PlantarFlexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

% Left Ankle Angle
subplot(3,2,6);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Angle_AnklePlantarFlexion, 'Color', '#A2142F'); 
title('Left Ankle PlantarFlexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig1, 'InvertHardcopy', 'off'); 

%% FIGURE 2: UPPER BODY KINEMATICS
fig2 = figure('Name', 'Arm Joint Angles', 'Color', 'w', 'Position', [100 150 1200 600]);

% Right Elbow Angle
subplot(2,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Angle_ElbowFlexion, 'Color', '#0072BD'); 
title('Right Elbow Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

% Left Elbow Angle
subplot(2,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Angle_ElbowFlexion, 'Color', '#0072BD'); 
title('Left Elbow Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

% Right Wrist Angle
subplot(2,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Angle_WristFlexion, 'Color', '#D95319'); 
title('Right Wrist Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

% Left Wrist Angle
subplot(2,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Angle_WristFlexion, 'Color', '#D95319'); 
title('Left Wrist Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig2, 'InvertHardcopy', 'off'); 

%% Generate Humanized Text Report
fptr = fopen(report_file, 'w');

if fptr == -1
    error('Could not open report file for writing.');
end

% Function to calculate Range of Motion (Max - Min)
get_rom = @(v) max(v) - min(v);

% Write Header
fprintf(fptr, 'KINEMATICS AND RANGE OF MOTION REPORT\n\n');

% HIP KINEMATICS
fprintf(fptr, '### HIP KINEMATICS\n\n');
fprintf(fptr, '![Hip Flexion](../docs/hip%%20flexion.jpg)\n\n');
fprintf(fptr, 'The right hip required a flexion (bending a joint to decrease the angle between bones) range of motion (ROM) (the full movement potential of a joint) of %5.2f degrees, ', get_rom(data_R.Angle_HipFlexion));
fprintf(fptr, 'while the left hip required %5.2f degrees.\n\n', get_rom(data_L.Angle_HipFlexion));
fprintf(fptr, '![Hip Abduction](../docs/abduction.jpg)\n\n');
fprintf(fptr, 'In terms of side to side stabilization, the right hip abduction (moving a limb away from the center line of the body) ROM was %5.2f degrees ', get_rom(data_R.Angle_HipAbduction));
fprintf(fptr, 'compared to %5.2f degrees on the left side.\n\n', get_rom(data_L.Angle_HipAbduction));

% KNEE KINEMATICS
fprintf(fptr, '### KNEE KINEMATICS\n\n');
fprintf(fptr, '![Knee Flexion](../docs/knee%%20joint%%20flexion.jpg)\n\n');
fprintf(fptr, 'The right knee traveled through a flexion (bending a joint to decrease the angle between bones) ROM of %5.2f degrees. ', get_rom(data_R.Angle_KneeFlexion));
fprintf(fptr, 'The left knee traveled through a flexion (bending a joint to decrease the angle between bones) ROM of %5.2f degrees. ', get_rom(data_L.Angle_KneeFlexion));
fprintf(fptr, 'This shows the difference in leg bending when utilizing the helper rod.\n\n');

% ANKLE KINEMATICS
fprintf(fptr, '### ANKLE KINEMATICS\n\n');
fprintf(fptr, '![Ankle Plantarflexion](../docs/ankle.jpg)\n\n');
fprintf(fptr, 'The right ankle exhibited a plantarflexion (pointing the foot downward) ROM of %5.2f degrees. ', get_rom(data_R.Angle_AnklePlantarFlexion));
fprintf(fptr, 'The left ankle exhibited a plantarflexion (pointing the foot downward) ROM of %5.2f degrees.\n\n', get_rom(data_L.Angle_AnklePlantarFlexion));

% UPPER BODY KINEMATICS
fprintf(fptr, '### ARM AND ROD SUPPORT KINEMATICS\n\n');
fprintf(fptr, '![Elbow Flexion](../docs/elbow.jpg)\n\n');
fprintf(fptr, 'While supporting the body with the rod, the right elbow went through a flexion (bending a joint to decrease the angle between bones) ROM of %5.2f degrees, ', get_rom(data_R.Angle_ElbowFlexion));
fprintf(fptr, 'and the right wrist went through a flexion (bending a joint to decrease the angle between bones) ROM of %5.2f degrees. ', get_rom(data_R.Angle_WristFlexion));
fprintf(fptr, 'By contrast, the unassisted left elbow and wrist showed minimal ROM of %5.2f degrees and %5.2f degrees respectively.\n\n', get_rom(data_L.Angle_ElbowFlexion), get_rom(data_L.Angle_WristFlexion));
fclose(fptr);