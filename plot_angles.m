function plot_angles(csv_dir, report_dir)
csv_file_right = fullfile(csv_dir, 'interaction_angles_right.csv');
csv_file_left  = fullfile(csv_dir, 'interaction_angles_left.csv');
report_file = fullfile(report_dir, 'kinematics_report.md');

set(0, 'DefaultFigureColor', 'w');      
set(0, 'DefaultAxesColor', 'w');        
set(0, 'DefaultAxesXColor', 'k');       
set(0, 'DefaultAxesYColor', 'k');       
set(0, 'DefaultAxesZColor', 'k');       
set(0, 'DefaultTextColor', 'k');        
set(0, 'DefaultLineLineWidth', 1.5);    

if exist(csv_file_right, 'file') ~= 2 || exist(csv_file_left, 'file') ~= 2
    error('One or both CSV files not found! Run run_angles.m first.');
end

fprintf("Loading kinematic data...");
data_R = readtable(csv_file_right);
data_L = readtable(csv_file_left);
time = data_R.Time; 

fig1 = figure('Name', 'Leg Joint Angles', 'Color', 'w', 'Position', [50 100 1200 800]);

subplot(3,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Angle_HipFlexion, 'Color', '#0072BD'); 
hold on;
plot(time, data_R.Angle_HipAbduction, 'Color', '#D95319', 'LineStyle', '--');
title('Right Hip Angles', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;
legend('Flexion', 'Abduction', 'Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Angle_HipFlexion, 'Color', '#0072BD'); 
hold on;
plot(time, data_L.Angle_HipAbduction, 'Color', '#D95319', 'LineStyle', '--');
title('Left Hip Angles', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;
legend('Flexion', 'Abduction', 'Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Angle_KneeFlexion, 'Color', '#77AC30'); 
title('Right Knee Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

subplot(3,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Angle_KneeFlexion, 'Color', '#77AC30'); 
title('Left Knee Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

subplot(3,2,5);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Angle_AnklePlantarFlexion, 'Color', '#A2142F'); 
title('Right Ankle PlantarFlexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(3,2,6);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Angle_AnklePlantarFlexion, 'Color', '#A2142F'); 
title('Left Ankle PlantarFlexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig1, 'InvertHardcopy', 'off'); 

fig2 = figure('Name', 'Arm Joint Angles', 'Color', 'w', 'Position', [100 150 1200 600]);

subplot(2,2,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Angle_ElbowFlexion, 'Color', '#0072BD'); 
title('Right Elbow Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

subplot(2,2,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Angle_ElbowFlexion, 'Color', '#0072BD'); 
title('Left Elbow Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

subplot(2,2,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_R.Angle_WristFlexion, 'Color', '#D95319'); 
title('Right Wrist Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(2,2,4);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data_L.Angle_WristFlexion, 'Color', '#D95319'); 
title('Left Wrist Flexion', 'Color', 'k');
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig2, 'InvertHardcopy', 'off'); 

fptr = fopen(report_file, 'w');

if fptr == -1
    error('Could not open report file for writing.');
end

get_rom = @(v) max(v) - min(v);
fprintf(fptr, '# KINEMATICS AND RANGE OF MOTION REPORT\n\n');
fprintf(fptr, '### HIP KINEMATICS\n\n');
fprintf(fptr, '<img src="../docs/hip%%20flexion.jpg" width="400">\n\n');
fprintf(fptr, 'The right hip required a flexion (bending a joint to decrease the angle between bones) range of motion (ROM) (the full movement potential of a joint) of %5.2f degrees, ', get_rom(data_R.Angle_HipFlexion));
fprintf(fptr, 'while the left hip required %5.2f degrees.\n\n', get_rom(data_L.Angle_HipFlexion));
fprintf(fptr, '<img src="../docs/abduction.jpg" width="400">\n\n');
fprintf(fptr, 'In terms of side to side stabilization, the right hip abduction (moving a limb away from the center line of the body) ROM was %5.2f degrees ', get_rom(data_R.Angle_HipAbduction));
fprintf(fptr, 'compared to %5.2f degrees on the left side.\n\n', get_rom(data_L.Angle_HipAbduction));
fprintf(fptr, '### KNEE KINEMATICS\n\n');
fprintf(fptr, '<img src="../docs/knee%%20joint%%20flexion.jpg" width="400">\n\n');
fprintf(fptr, 'The right knee traveled through a flexion (bending a joint to decrease the angle between bones) ROM of %5.2f degrees. ', get_rom(data_R.Angle_KneeFlexion));
fprintf(fptr, 'The left knee traveled through a flexion (bending a joint to decrease the angle between bones) ROM of %5.2f degrees. ', get_rom(data_L.Angle_KneeFlexion));
fprintf(fptr, 'This shows the difference in leg bending when utilizing the helper rod.\n\n');
fprintf(fptr, '### ANKLE KINEMATICS\n\n');
fprintf(fptr, '<img src="../docs/ankle.jpg" width="400">\n\n');
fprintf(fptr, 'The right ankle exhibited a plantarflexion (pointing the foot downward) ROM of %5.2f degrees. ', get_rom(data_R.Angle_AnklePlantarFlexion));
fprintf(fptr, 'The left ankle exhibited a plantarflexion (pointing the foot downward) ROM of %5.2f degrees.\n\n', get_rom(data_L.Angle_AnklePlantarFlexion));
fprintf(fptr, '### ARM AND ROD SUPPORT KINEMATICS\n\n');
fprintf(fptr, '<img src="../docs/elbow.jpg" width="400">\n\n');
fprintf(fptr, 'While supporting the body with the rod, the right elbow went through a flexion (bending a joint to decrease the angle between bones) ROM of %5.2f degrees, ', get_rom(data_R.Angle_ElbowFlexion));
fprintf(fptr, 'and the right wrist went through a flexion (bending a joint to decrease the angle between bones) ROM of %5.2f degrees. ', get_rom(data_R.Angle_WristFlexion));
fprintf(fptr, 'By contrast, the unassisted left elbow and wrist showed minimal ROM of %5.2f degrees and %5.2f degrees respectively.\n\n', get_rom(data_L.Angle_ElbowFlexion), get_rom(data_L.Angle_WristFlexion));
fclose(fptr);

end