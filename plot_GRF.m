function plot_GRF(csv_dir, report_dir)

set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesColor', 'w');
set(0, 'DefaultAxesXColor', 'k');
set(0, 'DefaultAxesYColor', 'k');
set(0, 'DefaultAxesZColor', 'k');
set(0, 'DefaultTextColor', 'k');
set(0, 'DefaultLineLineWidth', 1.5);

fprintf('Loading GRF and Leg Joint data\n');

grf_file = fullfile(csv_dir, 'grf_data.csv');
leg_R_file = fullfile(csv_dir, 'interaction_joint_data_right.csv');
leg_L_file = fullfile(csv_dir, 'interaction_joint_data_left.csv');

if exist(grf_file, 'file') ~= 2 || exist(leg_R_file, 'file') ~= 2 || exist(leg_L_file, 'file') ~= 2
    fprintf('Required CSV files not found in %s.', csv_dir);
end

data_grf = readtable(grf_file);
has_leg_R = exist(leg_R_file, 'file') == 2;
has_leg_L = exist(leg_L_file, 'file') == 2;

if has_leg_R, data_leg_R = readtable(leg_R_file); end
if has_leg_L, data_leg_L = readtable(leg_L_file); end

time = data_grf.Time;
has_right_grf = ismember('Right_Fx', data_grf.Properties.VariableNames);
has_left_grf = ismember('Left_Fx', data_grf.Properties.VariableNames);

figure('Color', 'w', 'Name', 'GRF vs Leg Joint Forces', 'Position', [100 100 1000 900]);

subplot(3,1,1);
hold on;
if has_right_grf, plot(time, data_grf.Right_Fx, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF Forward Backward'); end
if has_leg_R, plot(time, data_leg_R.Force_Ankle_AnteroPosteriorForce, 'Color', '#D95319', 'DisplayName', 'Right Ankle Forward Backward'); end
if has_left_grf, plot(time, data_grf.Left_Fx, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF Forward Backward'); end
if has_leg_L, plot(time, data_leg_L.Force_Ankle_AnteroPosteriorForce, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle Forward Backward'); end
title('Forward Backward GRF and Leg Forces');
ylabel('Force (N)'); grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,1,2);
hold on;
if has_right_grf, plot(time, data_grf.Right_Fy, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF Vertical Load'); end
if has_leg_R, plot(time, data_leg_R.Force_Ankle_ProximoDistalForce, 'Color', '#D95319', 'DisplayName', 'Right Ankle Vertical Load'); end
if has_left_grf, plot(time, data_grf.Left_Fy, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF Vertical Load'); end
if has_leg_L, plot(time, data_leg_L.Force_Ankle_ProximoDistalForce, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle Vertical Load'); end
title('Vertical Weight Bearing GRF and Leg Forces');
ylabel('Force (N)'); grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,1,3);
hold on;
if has_right_grf, plot(time, data_grf.Right_Fz, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF Lateral Balance'); end
if has_leg_R, plot(time, data_leg_R.Force_Ankle_MedioLateralForce, 'Color', '#D95319', 'DisplayName', 'Right Ankle Lateral Balance'); end
if has_left_grf, plot(time, data_grf.Left_Fz, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF Lateral Balance'); end
if has_leg_L, plot(time, data_leg_L.Force_Ankle_MedioLateralForce, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle Lateral Balance'); end
title('Lateral Side to Side GRF and Leg Forces');
xlabel('Time (s)'); ylabel('Force (N)'); grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

names = {}; stats_cell = {}; units = {}; row_idx = 1;

if has_right_grf
    names{row_idx} = 'Right Foot';
    sX = get_stats(data_grf.Right_Fx, time);
    sY = get_stats(data_grf.Right_Fy, time);
    sZ = get_stats(data_grf.Right_Fz, time);
    stats_cell{row_idx} = [sX; sY; sZ];
    units{row_idx} = 'N';
    row_idx = row_idx + 1;
end

if has_left_grf
    names{row_idx} = 'Left Foot';
    sX = get_stats(data_grf.Left_Fx, time);
    sY = get_stats(data_grf.Left_Fy, time);
    sZ = get_stats(data_grf.Left_Fz, time);
    stats_cell{row_idx} = [sX; sY; sZ];
    units{row_idx} = 'N';
end

if ~isempty(names)
    report_path = fullfile(report_dir, 'GRF_Report.txt');
    write_report(report_path, 'Ground Reaction Force Report', names, stats_cell, units);
end

fprintf('GRF and Leg Joint Forces plotting complete\n');

end

function s = get_stats(v, t)
    t_max_arr = t(v == max(v));
    t_min_arr = t(v == min(v));
    s = [mean(v), max(v), t_max_arr(1), min(v), t_min_arr(1)];
end