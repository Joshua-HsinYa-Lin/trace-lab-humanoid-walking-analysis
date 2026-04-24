function plot_single_GRFandLeg(csv_dir, report_dir)
f_grf = fullfile(csv_dir, 'grf_data_single.csv');
f_leg_R = fullfile(csv_dir, 'single_joint_data_right.csv');
f_leg_L = fullfile(csv_dir, 'single_joint_data_left.csv');
report_file = fullfile(report_dir, 'Single_GRF_Symmetry_Report.txt');

if exist(f_grf, 'file') ~= 2
    fprintf('Missing Single GRF CSV. Plotting aborted.\n');
    return;
end

data_grf = readtable(f_grf);
time_grf = data_grf.Time;
p1_fz = get_col(data_grf, {'Plate1_Fz'});
p2_fz = get_col(data_grf, {'Plate2_Fz'});

has_R = exist(f_leg_R, 'file') == 2;
has_L = exist(f_leg_L, 'file') == 2;

time_R = [];
aml_R = [];
if has_R
    data_leg_R = readtable(f_leg_R);
    if ismember('Time', data_leg_R.Properties.VariableNames)
        time_R = data_leg_R.Time;
    end
    aml_R = get_col(data_leg_R, {'Force_Ankle_MedioLateralForce'});
end

time_L = [];
aml_L = [];
if has_L
    data_leg_L = readtable(f_leg_L);
    if ismember('Time', data_leg_L.Properties.VariableNames)
        time_L = data_leg_L.Time;
    end
    aml_L = get_col(data_leg_L, {'Force_Ankle_MedioLateralForce'});
end

set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesColor', 'w');
set(0, 'DefaultAxesXColor', 'k');
set(0, 'DefaultAxesYColor', 'k');
set(0, 'DefaultAxesZColor', 'k');
set(0, 'DefaultTextColor', 'k');
set(0, 'DefaultLineLineWidth', 1.5);

figure('Color', 'w', 'Name', 'Lateral Symmetry Check', 'Position', [100 100 1000 700]);

subplot(2,1,1); 
hold on;
if ~isempty(p1_fz)
    plot(time_grf, p1_fz, 'Color', '#0072BD', 'DisplayName', 'Plate 1 Z-Axis (Lateral) GRF'); 
end
if ~isempty(p2_fz)
    plot(time_grf, p2_fz, 'Color', '#77AC30', 'DisplayName', 'Plate 2 Z-Axis (Lateral) GRF');
end
title('Force Plate Z-Axis Symmetry Check'); 
ylabel('Force (N)'); 
grid on; 

subplot(2,1,2); 
hold on;
if ~isempty(aml_R) 
    if ~isempty(time_R)
        plot(time_R, aml_R, 'Color', '#D95319', 'DisplayName', 'Right Ankle Medio-Lateral Force');
    end
end
if ~isempty(aml_L) 
    if ~isempty(time_L)
        plot(time_L, aml_L, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle Medio-Lateral Force');
    end
end
title('Ankle Joint Z-Axis Symmetry Check'); 
xlabel('Time (s)'); 
ylabel('Force (N)'); 
grid on; 

names = {}; 
stats_cell = {}; 
units = {}; 
row_idx = 1;

if ~isempty(p1_fz)
    names{row_idx} = 'Single Baseline Plate 1';
    stats_cell{row_idx} = get_stats(p1_fz, time_grf);
    units{row_idx} = 'N';
    row_idx = row_idx + 1;
end

if ~isempty(p2_fz)
    names{row_idx} = 'Single Baseline Plate 2';
    stats_cell{row_idx} = get_stats(p2_fz, time_grf);
    units{row_idx} = 'N';
    row_idx = row_idx + 1;
end

if ~isempty(names)
    write_report(report_file, 'Single Baseline Symmetry Report', names, stats_cell, units);
end
fprintf('Symmetry plotting complete\n');
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