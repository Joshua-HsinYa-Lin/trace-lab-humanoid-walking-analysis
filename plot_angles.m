function plot_angles(csv_dir, report_dir)
csv_file_right = fullfile(csv_dir, 'interaction_angles_right.csv');
csv_file_left  = fullfile(csv_dir, 'interaction_angles_left.csv');
report_file = fullfile(report_dir, 'kinematics_report.txt');

set(0, 'DefaultFigureColor', 'w');      
set(0, 'DefaultAxesColor', 'w');        
set(0, 'DefaultAxesXColor', 'k');       
set(0, 'DefaultAxesYColor', 'k');       
set(0, 'DefaultAxesZColor', 'k');       
set(0, 'DefaultTextColor', 'k');        
set(0, 'DefaultLineLineWidth', 1.5);    

if exist(csv_file_right, 'file') ~= 2 || exist(csv_file_left, 'file') ~= 2
    fprintf('Missing kinematic data CSV files. Plotting aborted.\n');
    return;
end

data_R = readtable(csv_file_right);
time_R = data_R.Time; 

data_L = readtable(csv_file_left);
time_L = data_L.Time; 

hf_R = get_col(data_R, {'Angle_HipFlexion'});
ha_R = get_col(data_R, {'Angle_HipAbduction'});
kf_R = get_col(data_R, {'Angle_KneeFlexion'});
af_R = get_col(data_R, {'Angle_AnklePlantarFlexion'});
ef_R = get_col(data_R, {'Angle_ElbowFlexion'});
wf_R = get_col(data_R, {'Angle_WristFlexion'});

hf_L = get_col(data_L, {'Angle_HipFlexion'});
ha_L = get_col(data_L, {'Angle_HipAbduction'});
kf_L = get_col(data_L, {'Angle_KneeFlexion'});
af_L = get_col(data_L, {'Angle_AnklePlantarFlexion'});
ef_L = get_col(data_L, {'Angle_ElbowFlexion'});
wf_L = get_col(data_L, {'Angle_WristFlexion'});

fig1 = figure('Name', 'Leg Joint Angles', 'Color', 'w', 'Position', [50 100 1200 800]);

subplot(3,2,1); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(hf_R)
    plot(time_R, hf_R, 'Color', '#0072BD'); 
end
if ~isempty(ha_R)
    plot(time_R, ha_R, 'Color', '#D95319', 'LineStyle', '--');
end
title('Right Hip Angles', 'Color', 'k'); 
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

subplot(3,2,2); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(hf_L)
    plot(time_L, hf_L, 'Color', '#0072BD'); 
end
if ~isempty(ha_L)
    plot(time_L, ha_L, 'Color', '#D95319', 'LineStyle', '--');
end
title('Left Hip Angles', 'Color', 'k'); 
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

subplot(3,2,3); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(kf_R)
    plot(time_R, kf_R, 'Color', '#77AC30'); 
end
title('Right Knee Flexion', 'Color', 'k'); 
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

subplot(3,2,4); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(kf_L)
    plot(time_L, kf_L, 'Color', '#77AC30'); 
end
title('Left Knee Flexion', 'Color', 'k'); 
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

subplot(3,2,5); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(af_R)
    plot(time_R, af_R, 'Color', '#A2142F'); 
end
title('Right Ankle PlantarFlexion', 'Color', 'k'); 
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(3,2,6); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(af_L)
    plot(time_L, af_L, 'Color', '#A2142F'); 
end
title('Left Ankle PlantarFlexion', 'Color', 'k'); 
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig1, 'InvertHardcopy', 'off'); 

fig2 = figure('Name', 'Arm Joint Angles', 'Color', 'w', 'Position', [100 150 1200 600]);

subplot(2,2,1); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(ef_R)
    plot(time_R, ef_R, 'Color', '#0072BD'); 
end
title('Right Elbow Flexion', 'Color', 'k'); 
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

subplot(2,2,2); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(ef_L)
    plot(time_L, ef_L, 'Color', '#0072BD'); 
end
title('Left Elbow Flexion', 'Color', 'k'); 
ylabel('Angle (deg)', 'Color', 'k'); 
grid on;

subplot(2,2,3); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(wf_R)
    plot(time_R, wf_R, 'Color', '#D95319'); 
end
title('Right Wrist Flexion', 'Color', 'k'); 
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(2,2,4); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(wf_L)
    plot(time_L, wf_L, 'Color', '#D95319'); 
end
title('Left Wrist Flexion', 'Color', 'k'); 
ylabel('Angle (deg)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig2, 'InvertHardcopy', 'off'); 

names = {}; 
stats_cell = {}; 
units = {}; 
row_idx = 1;

if ~isempty(hf_R)
    names{row_idx} = 'Right Hip Flexion Angle'; 
    stats_cell{row_idx} = get_stats(hf_R, time_R); 
    units{row_idx} = 'deg'; 
    row_idx = row_idx + 1; 
end

if ~isempty(kf_R)
    names{row_idx} = 'Right Knee Flexion Angle'; 
    stats_cell{row_idx} = get_stats(kf_R, time_R); 
    units{row_idx} = 'deg'; 
    row_idx = row_idx + 1; 
end

if ~isempty(af_R)
    names{row_idx} = 'Right Ankle Plantar Angle'; 
    stats_cell{row_idx} = get_stats(af_R, time_R); 
    units{row_idx} = 'deg'; 
    row_idx = row_idx + 1; 
end

if ~isempty(ef_R)
    names{row_idx} = 'Right Elbow Flexion Angle'; 
    stats_cell{row_idx} = get_stats(ef_R, time_R); 
    units{row_idx} = 'deg'; 
    row_idx = row_idx + 1; 
end

if ~isempty(names)
    write_report(report_file, 'Kinematics Report', names, stats_cell, units);
end

fprintf('Kinematics plotting complete!\n');
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