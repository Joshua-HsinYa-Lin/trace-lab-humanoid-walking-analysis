function plot_results(csv_dir, report_dir)
csv_file_right = fullfile(csv_dir, 'interaction_joint_data_right.csv');
csv_file_left  = fullfile(csv_dir, 'interaction_joint_data_left.csv');
report_file = fullfile(report_dir, 'joint_forces_report.txt');

if exist(csv_file_right, 'file') ~= 2 || exist(csv_file_left, 'file') ~= 2
    fprintf('Missing joint data CSV files. Plotting aborted.\n');
    return;
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

hf_R = get_col(data_R, {'Moment_HipFlexion'});
ha_R = get_col(data_R, {'Moment_HipAbduction'});
hp_R = get_col(data_R, {'Force_Hip_ProximoDistalForce'});
hm_R = get_col(data_R, {'Force_Hip_MediolateralForce'});
kf_R = get_col(data_R, {'Moment_KneeFlexion'});
kp_R = get_col(data_R, {'Force_Knee_ProximoDistalForce'});
af_R = get_col(data_R, {'Moment_AnklePlantarFlexion'});
am_R = get_col(data_R, {'Force_Ankle_MedioLateralForce'});

hf_L = get_col(data_L, {'Moment_HipFlexion'});
ha_L = get_col(data_L, {'Moment_HipAbduction'});
hp_L = get_col(data_L, {'Force_Hip_ProximoDistalForce'});
hm_L = get_col(data_L, {'Force_Hip_MediolateralForce'});
kf_L = get_col(data_L, {'Moment_KneeFlexion'});
kp_L = get_col(data_L, {'Force_Knee_ProximoDistalForce'});
af_L = get_col(data_L, {'Moment_AnklePlantarFlexion'});
am_L = get_col(data_L, {'Force_Ankle_MedioLateralForce'});

fig1 = figure('Name', 'Hip Joint Analysis', 'Color', 'w', 'Position', [50 100 1200 800]);

subplot(3,2,1); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(hf_R)
    plot(time, hf_R, 'Color', '#0072BD', 'DisplayName', 'Flexion'); 
end
if ~isempty(ha_R)
    plot(time, ha_R, 'Color', '#D95319', 'LineStyle', '--', 'DisplayName', 'Abduction'); 
end
title('Right Hip Torques', 'Color', 'k'); 
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(3,2,2); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(hf_L)
    plot(time, hf_L, 'Color', '#0072BD', 'DisplayName', 'Flexion'); 
end
if ~isempty(ha_L)
    plot(time, ha_L, 'Color', '#D95319', 'LineStyle', '--', 'DisplayName', 'Abduction'); 
end
title('Left Hip Torques', 'Color', 'k'); 
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(3,2,3); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(hp_R)
    plot(time, abs(hp_R), 'Color', '#0072BD'); 
end
title('Right Hip Vertical Load', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
grid on;

subplot(3,2,4); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(hp_L)
    plot(time, abs(hp_L), 'Color', '#0072BD'); 
end
title('Left Hip Vertical Load', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
grid on;

subplot(3,2,5); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(hm_R)
    plot(time, hm_R, 'Color', '#D95319'); 
end
title('Right Hip Lateral Force', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(3,2,6); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(hm_L)
    plot(time, hm_L, 'Color', '#D95319'); 
end
title('Left Hip Lateral Force', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig1, 'InvertHardcopy', 'off'); 

fig2 = figure('Name', 'Knee Joint Analysis', 'Color', 'w', 'Position', [100 150 1200 600]);

subplot(2,2,1); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(kf_R)
    plot(time, kf_R, 'Color', '#77AC30'); 
end
title('Right Knee Torque', 'Color', 'k'); 
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,2); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(kf_L)
    plot(time, kf_L, 'Color', '#77AC30'); 
end
title('Left Knee Torque', 'Color', 'k'); 
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,3); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(kp_R)
    plot(time, abs(kp_R), 'Color', '#77AC30'); 
end
title('Right Knee Vertical Load', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(2,2,4); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(kp_L)
    plot(time, abs(kp_L), 'Color', '#77AC30'); 
end
title('Left Knee Vertical Load', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig2, 'InvertHardcopy', 'off'); 

fig3 = figure('Name', 'Ankle Joint Analysis', 'Color', 'w', 'Position', [150 200 1200 800]);

subplot(3,2,1); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(af_R)
    plot(time, af_R, 'Color', '#A2142F'); 
end
title('Right Ankle Torque', 'Color', 'k'); 
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(3,2,2); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(af_L)
    plot(time, af_L, 'Color', '#A2142F'); 
end
title('Left Ankle Torque', 'Color', 'k'); 
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(3,2,3); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(kp_R)
    plot(time, abs(kp_R), 'Color', '#A2142F'); 
end
title('Right Ankle Vertical Load', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
grid on;

subplot(3,2,4); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(kp_L)
    plot(time, abs(kp_L), 'Color', '#A2142F'); 
end
title('Left Ankle Vertical Load', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
grid on;

subplot(3,2,5); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(am_R)
    plot(time, am_R, 'Color', '#7E2F8E'); 
end
title('Right Ankle Lateral Force', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(3,2,6); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(am_L)
    plot(time, am_L, 'Color', '#7E2F8E'); 
end
title('Left Ankle Lateral Force', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig3, 'InvertHardcopy', 'off');

names = {}; 
stats_cell = {}; 
units = {}; 
row_idx = 1;

if ~isempty(hf_R)
    names{row_idx} = 'Right Hip Flexion Torque'; 
    stats_cell{row_idx} = get_stats(hf_R, time); 
    units{row_idx} = 'Nm'; 
    row_idx = row_idx + 1; 
end

if ~isempty(hp_R)
    names{row_idx} = 'Right Hip Vertical Load'; 
    stats_cell{row_idx} = get_stats(hp_R, time); 
    units{row_idx} = 'N'; 
    row_idx = row_idx + 1; 
end

if ~isempty(names)
    write_report(report_file, 'Human Leg Force Analysis', names, stats_cell, units);
end
fprintf('Graphs Plotted and Report Written!\n');
end

function s = get_stats(v, t)
    t_max_arr = t(v == max(v));
    t_min_arr = t(v == min(v));
    s = [mean(v), max(v), t_max_arr(1), min(v), t_min_arr(1)];
end

function val = get_col(T, col_names)
    val = [];
    for i = 1:length(col_names)
        if ismember(col_names{i}, T.Properties.VariableNames)
            val = T.(col_names{i});
            return;
        end
    end
end