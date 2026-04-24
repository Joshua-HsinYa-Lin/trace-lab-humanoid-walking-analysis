function plot_hand(csv_dir, report_dir)
csv_file_right = fullfile(csv_dir, 'interaction_hand_data_right.csv');
csv_file_left  = fullfile(csv_dir, 'interaction_hand_data_left.csv');
report_file = fullfile(report_dir, 'hand_forces_report.txt');

set(0, 'DefaultFigureColor', 'w');      
set(0, 'DefaultAxesColor', 'w');        
set(0, 'DefaultAxesXColor', 'k');       
set(0, 'DefaultAxesYColor', 'k');       
set(0, 'DefaultAxesZColor', 'k');       
set(0, 'DefaultTextColor', 'k');        
set(0, 'DefaultLineLineWidth', 1.5);    

if exist(csv_file_right, 'file') ~= 2 || exist(csv_file_left, 'file') ~= 2
    fprintf('Missing hand data CSV files. Plotting aborted.\n');
    return;
end

data_R = readtable(csv_file_right);
data_L = readtable(csv_file_left);
time = data_R.Time; 

ef_R = get_col(data_R, {'Moment_ElbowFlexion'});
ep_R = get_col(data_R, {'Force_ElbowHumeroUlnar_ProximoDistalForce'});
wf_R = get_col(data_R, {'Moment_WristFlexion'});
wp_R = get_col(data_R, {'Force_WristRadioCarpal_ProximoDistalForce'});

ef_L = get_col(data_L, {'Moment_ElbowFlexion'});
ep_L = get_col(data_L, {'Force_ElbowHumeroUlnar_ProximoDistalForce'});
wf_L = get_col(data_L, {'Moment_WristFlexion'});
wp_L = get_col(data_L, {'Force_WristRadioCarpal_ProximoDistalForce'});

fig1 = figure('Name', 'Elbow Joint Analysis', 'Color', 'w', 'Position', [50 100 1200 600]);

subplot(2,2,1); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(ef_R)
    plot(time, ef_R, 'Color', '#0072BD'); 
end
title('Right Elbow Flexion Torque', 'Color', 'k'); 
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,2); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(ef_L)
    plot(time, ef_L, 'Color', '#0072BD'); 
end
title('Left Elbow Flexion Torque', 'Color', 'k'); 
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,3); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(ep_R)
    plot(time, abs(ep_R), 'Color', '#D95319'); 
end
title('Right Elbow Vertical Load', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(2,2,4); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(ep_L)
    plot(time, abs(ep_L), 'Color', '#D95319'); 
end
title('Left Elbow Vertical Load', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig1, 'InvertHardcopy', 'off'); 

fig2 = figure('Name', 'Wrist Joint Analysis', 'Color', 'w', 'Position', [100 150 1200 600]);

subplot(2,2,1); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(wf_R)
    plot(time, wf_R, 'Color', '#77AC30'); 
end
title('Right Wrist Flexion Torque', 'Color', 'k'); 
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,2); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(wf_L)
    plot(time, wf_L, 'Color', '#77AC30'); 
end
title('Left Wrist Flexion Torque', 'Color', 'k'); 
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;

subplot(2,2,3); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(wp_R)
    plot(time, abs(wp_R), 'Color', '#A2142F'); 
end
title('Right Wrist Vertical Load', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

subplot(2,2,4); 
set(gca, 'XColor', 'k', 'YColor', 'k'); 
hold on;
if ~isempty(wp_L)
    plot(time, abs(wp_L), 'Color', '#A2142F'); 
end
title('Left Wrist Vertical Load', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig2, 'InvertHardcopy', 'off'); 

names = {}; 
stats_cell = {}; 
units = {}; 
row_idx = 1;

if ~isempty(ef_R)
    names{row_idx} = 'Right Elbow Flexion Torque'; 
    stats_cell{row_idx} = get_stats(ef_R, time); 
    units{row_idx} = 'Nm'; 
    row_idx = row_idx + 1; 
end

if ~isempty(ep_R)
    names{row_idx} = 'Right Elbow Vertical Load'; 
    stats_cell{row_idx} = get_stats(ep_R, time); 
    units{row_idx} = 'N'; 
    row_idx = row_idx + 1; 
end

if ~isempty(wf_R)
    names{row_idx} = 'Right Wrist Flexion Torque'; 
    stats_cell{row_idx} = get_stats(wf_R, time); 
    units{row_idx} = 'Nm'; 
    row_idx = row_idx + 1; 
end

if ~isempty(wp_R)
    names{row_idx} = 'Right Wrist Vertical Load'; 
    stats_cell{row_idx} = get_stats(wp_R, time); 
    units{row_idx} = 'N'; 
    row_idx = row_idx + 1; 
end

if ~isempty(ef_L)
    names{row_idx} = 'Left Elbow Flexion Torque'; 
    stats_cell{row_idx} = get_stats(ef_L, time); 
    units{row_idx} = 'Nm'; 
    row_idx = row_idx + 1; 
end

if ~isempty(ep_L)
    names{row_idx} = 'Left Elbow Vertical Load'; 
    stats_cell{row_idx} = get_stats(ep_L, time); 
    units{row_idx} = 'N'; 
    row_idx = row_idx + 1; 
end

if ~isempty(wf_L)
    names{row_idx} = 'Left Wrist Flexion Torque'; 
    stats_cell{row_idx} = get_stats(wf_L, time); 
    units{row_idx} = 'Nm'; 
    row_idx = row_idx + 1; 
end

if ~isempty(wp_L)
    names{row_idx} = 'Left Wrist Vertical Load'; 
    stats_cell{row_idx} = get_stats(wp_L, time); 
    units{row_idx} = 'N'; 
    row_idx = row_idx + 1; 
end

if ~isempty(names)
    write_report(report_file, 'Hand Assistance Report', names, stats_cell, units);
end

fprintf('Hand plotting complete!\n');
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