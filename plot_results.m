clear; 
clc; 
close all;

csv_file_right = 'data_csv/interaction_joint_data.csv';
csv_file_left  = 'data_csv/interaction_joint_data_left.csv';
report_file = 'reports/joint_forces_report.md';

if exist(csv_file_right, 'file') ~= 2 || exist(csv_file_left, 'file') ~= 2
    error('One or both CSV files not found! Run run_analysis.m first.');
end

data_R = readtable(csv_file_right);
data_L = readtable(csv_file_left);
time = data_R.Time;

set(0, 'DefaultFigureColor', 'w');      
set(0, 'DefaultAxesColor', 'w');        
set(0, 'DefaultAxesXColor', 'k');       
set(0, 'DefaultAxesYColor', 'k');       
set(0, 'DefaultAxesZColor', 'k');       
set(0, 'DefaultTextColor', 'k');        
set(0, 'DefaultLineLineWidth', 1.5);

fptr = fopen(report_file, 'w');
if fptr == -1
    error('Could not open report file for writing.');
end
fprintf(fptr, 'HUMAN LEG FORCE ANALYSIS\n\n');

get_peak = @(v) max(abs(v));

fprintf(fptr, 'HIP JOINT\n\n');
fprintf(fptr, '<img src="../docs/hip flexion.jpg" width="400">\n\n');
fprintf(fptr, 'Max Flexion Torque (Rotational force causing the joint to bend):\nRight: %6.2f Nm  |  Left: %6.2f Nm\n\n', ...
    get_peak(data_R.Moment_HipFlexion), get_peak(data_L.Moment_HipFlexion));
fprintf(fptr, 'Max Abduction Torque (Rotational force moving the limb away from the body center):\nRight: %6.2f Nm  |  Left: %6.2f Nm\n\n', ...
    get_peak(data_R.Moment_HipAbduction), get_peak(data_L.Moment_HipAbduction));
fprintf(fptr, 'Max Vertical Load (Upward or downward weight bearing force):\nRight: %6.2f N   |  Left: %6.2f N\n\n\n', ...
    get_peak(data_R.Force_Hip_ProximoDistalForce), get_peak(data_L.Force_Hip_ProximoDistalForce));
fprintf(fptr, 'KNEE JOINT\n\n');
fprintf(fptr, '<img src="../docs/knee joint flexion.jpg" width="400">\n\n');
fprintf(fptr, 'Max Flexion Torque (Rotational force causing the joint to bend):\nRight: %6.2f Nm  |  Left: %6.2f Nm\n\n', ...
    get_peak(data_R.Moment_KneeFlexion), get_peak(data_L.Moment_KneeFlexion));
fprintf(fptr, 'Max Vertical Load (Upward or downward weight bearing force):\nRight: %6.2f N   |  Left: %6.2f N\n\n', ...
    get_peak(data_R.Force_Knee_ProximoDistalForce), get_peak(data_L.Force_Knee_ProximoDistalForce));
fprintf(fptr, 'ANKLE JOINT\n\n');
fprintf(fptr, '<img src="../docs/ankle.jpg" width="400">\n\n');
fprintf(fptr, 'Max Plantar Torque (Rotational force pointing the foot downward):\nRight: %6.2f Nm  |  Left: %6.2f Nm\n\n', ...
    get_peak(data_R.Moment_AnklePlantarFlexion), get_peak(data_L.Moment_AnklePlantarFlexion));
fprintf(fptr, 'Max Lateral Force (Side to side balancing force):\nRight: %6.2f N   |  Left: %6.2f N\n\n', ...
    get_peak(data_R.Force_Ankle_MedioLateralForce), get_peak(data_L.Force_Ankle_MedioLateralForce));

fclose(fptr);
fprintf("Report Written!\n");

fig1 = figure('Name', 'Hip Joint Analysis', 'Color', 'w', 'Position', [50 100 1200 800]);

subplot(3,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Moment_HipFlexion, 'Color', '#0072BD'); 
hold on;
plot(time, data_R.Moment_HipAbduction, 'Color', '#D95319', 'LineStyle', '--');
title('Right Hip Torques', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;
legend('Flexion', 'Abduction', 'Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Moment_HipFlexion, 'Color', '#0072BD'); 
hold on;
plot(time, data_L.Moment_HipAbduction, 'Color', '#D95319', 'LineStyle', '--');
title('Left Hip Torques', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;
legend('Flexion', 'Abduction', 'Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_R.Force_Hip_ProximoDistalForce), 'Color', '#0072BD'); 
title('Right Hip Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;

subplot(3,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_L.Force_Hip_ProximoDistalForce), 'Color', '#0072BD'); 
title('Left Hip Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;

subplot(3,2,5);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Force_Hip_MediolateralForce, 'Color', '#D95319'); 
title('Right Hip Lateral Force', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(3,2,6);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Force_Hip_MediolateralForce, 'Color', '#D95319'); 
title('Left Hip Lateral Force', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig1, 'InvertHardcopy', 'off'); 

fig2 = figure('Name', 'Knee Joint Analysis', 'Color', 'w', 'Position', [100 150 1200 600]);

subplot(2,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Moment_KneeFlexion, 'Color', '#77AC30');
title('Right Knee Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Moment_KneeFlexion, 'Color', '#77AC30');
title('Left Knee Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_R.Force_Knee_ProximoDistalForce), 'Color', '#77AC30'); 
title('Right Knee Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(2,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_L.Force_Knee_ProximoDistalForce), 'Color', '#77AC30'); 
title('Left Knee Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig2, 'InvertHardcopy', 'off'); 

fig3 = figure('Name', 'Ankle Joint Analysis', 'Color', 'w', 'Position', [150 200 1200 800]);

subplot(3,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Moment_AnklePlantarFlexion, 'Color', '#A2142F');
title('Right Ankle Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(3,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Moment_AnklePlantarFlexion, 'Color', '#A2142F');
title('Left Ankle Torque', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(3,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_R.Force_Ankle_ProximoDistalForce), 'Color', '#A2142F'); 
title('Right Ankle Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;

subplot(3,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data_L.Force_Ankle_ProximoDistalForce), 'Color', '#A2142F'); 
title('Left Ankle Vertical Load', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;

subplot(3,2,5);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Force_Ankle_MedioLateralForce, 'Color', '#7E2F8E'); 
title('Right Ankle Lateral Force', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(3,2,6);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Force_Ankle_MedioLateralForce, 'Color', '#7E2F8E'); 
title('Left Ankle Lateral Force', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;
set(fig3, 'InvertHardcopy', 'off');
fprintf("Graphs Plotted!\n")