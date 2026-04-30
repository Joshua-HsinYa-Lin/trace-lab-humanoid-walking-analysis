function plot_GRF(csv_dir, report_dir, cond, fig_dir)
if nargin < 3
    cond = 'UnknownCondition';
end
if nargin < 4
    fig_dir = fullfile(pwd, 'analysis_figure');
end

if ~exist(fig_dir, 'dir')
    mkdir(fig_dir);
end

set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesColor', 'w');
set(0, 'DefaultAxesXColor', 'k');
set(0, 'DefaultAxesYColor', 'k');
set(0, 'DefaultAxesZColor', 'k');
set(0, 'DefaultTextColor', 'k');
set(0, 'DefaultLineLineWidth', 1.5);

grf_file = fullfile(csv_dir, 'grf_data.csv');
leg_R_file = fullfile(csv_dir, 'interaction_joint_data_right.csv');
leg_L_file = fullfile(csv_dir, 'interaction_joint_data_left.csv');

file_grf_exists = exist(grf_file, 'file');
if file_grf_exists ~= 2
    fprintf('Missing GRF CSV file for plotting.\n');
    return;
end

data_grf = readtable(grf_file);
time_grf = data_grf.Time;

has_leg_R = exist(leg_R_file, 'file') == 2;
has_leg_L = exist(leg_L_file, 'file') == 2;

rfx = get_col(data_grf, {'Right_Fx'});
rfy = get_col(data_grf, {'Right_Fy'});
rfz = get_col(data_grf, {'Right_Fz'});

lfx = get_col(data_grf, {'Left_Fx'});
lfy = get_col(data_grf, {'Left_Fy'});
lfz = get_col(data_grf, {'Left_Fz'});

time_R = []; 
rap = []; 
rpd = []; 
rml = [];
if has_leg_R
    data_leg_R = readtable(leg_R_file);
    time_R = data_leg_R.Time;
    rap = get_col(data_leg_R, {'Force_Ankle_AnteroPosteriorForce'});
    rpd = get_col(data_leg_R, {'Force_Ankle_ProximoDistalForce'});
    rml = get_col(data_leg_R, {'Force_Ankle_MedioLateralForce'});
end

time_L = []; 
lap = []; 
lpd = []; 
lml = [];
if has_leg_L
    data_leg_L = readtable(leg_L_file);
    time_L = data_leg_L.Time;
    lap = get_col(data_leg_L, {'Force_Ankle_AnteroPosteriorForce'});
    lpd = get_col(data_leg_L, {'Force_Ankle_ProximoDistalForce'});
    lml = get_col(data_leg_L, {'Force_Ankle_MedioLateralForce'});
end

fig1 = figure('Color', 'w', 'Name', 'GRF vs Leg Joint Forces', 'Position', [100 100 1000 900]);

subplot(3,1,1); 
hold on;
if ~isempty(rfx)
    plot(time_grf, rfx, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF (X)'); 
end
if ~isempty(rap)
    plot(time_R, rap, 'Color', '#D95319', 'DisplayName', 'Right Ankle AP'); 
end
if ~isempty(lfx)
    plot(time_grf, lfx, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF (X)'); 
end
if ~isempty(lap)
    plot(time_L, lap, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle AP'); 
end
title('Forward/Backward GRF (X-axis) vs Leg AnteroPosterior Forces'); 
ylabel('Force (N) [+Anterior (Forward) / -Posterior]'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,1,2); 
hold on;
if ~isempty(rfy)
    plot(time_grf, rfy, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF (Y)'); 
end
if ~isempty(rml)
    plot(time_R, rml, 'Color', '#D95319', 'DisplayName', 'Right Ankle ML'); 
end
if ~isempty(lfy)
    plot(time_grf, lfy, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF (Y)'); 
end
if ~isempty(lml)
    plot(time_L, lml, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle ML'); 
end
title('Lateral GRF (Y-axis) vs Leg MedioLateral Forces'); 
ylabel('Force (N) [+Left (Lateral) / -Right]'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,1,3); 
hold on;
if ~isempty(rfz)
    plot(time_grf, rfz, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF (Z)'); 
end
if ~isempty(rpd)
    plot(time_R, rpd, 'Color', '#D95319', 'DisplayName', 'Right Ankle PD'); 
end
if ~isempty(lfz)
    plot(time_grf, lfz, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF (Z)'); 
end
if ~isempty(lpd)
    plot(time_L, lpd, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle PD'); 
end
title('Vertical Weight Bearing GRF (Z-axis) vs Leg ProximoDistal Forces'); 
xlabel('Time (s)'); 
ylabel('Force (N) [+Proximal (Up) / -Distal]'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

% Lock background color to white before saving
set(fig1, 'InvertHardcopy', 'off', 'Color', 'w');
saveas(fig1, fullfile(fig_dir, sprintf('%s_GRFvsLegForces.png', cond)));

names = {}; 
stats_cell = {}; 
units = {}; 
row_idx = 1;

if ~isempty(rfx) 
    if ~isempty(rfy) 
        if ~isempty(rfz)
            names{row_idx} = 'Right Foot';
            sX = get_stats(rfx, time_grf);
            sY = get_stats(rfy, time_grf);
            sZ = get_stats(rfz, time_grf);
            stats_cell{row_idx} = [sX; sY; sZ];
            units{row_idx} = 'N';
            row_idx = row_idx + 1;
        end
    end
end

if ~isempty(lfx) 
    if ~isempty(lfy) 
        if ~isempty(lfz)
            names{row_idx} = 'Left Foot';
            sX = get_stats(lfx, time_grf);
            sY = get_stats(lfy, time_grf);
            sZ = get_stats(lfz, time_grf);
            stats_cell{row_idx} = [sX; sY; sZ];
            units{row_idx} = 'N';
        end
    end
end

if ~isempty(names)
    report_path = fullfile(report_dir, sprintf('GRF_Report_%s.txt', cond));
    write_report(report_path, sprintf('Ground Reaction Force Report - %s', cond), names, stats_cell, units);
end

fprintf('GRF and Leg Joint Forces plotting complete and PNG saved to %s\n', fig_dir);
end

function s = get_stats(v, t)
    t_max_arr = t(v == max(v));
    t_min_arr = t(v == min(v));
    s = [mean(v), max(v), t_max_arr(1), min(v), t_min_arr(1)];
end

function val = get_col(T, col_names)
    val = [];
    for i = 1:length(col_names)
        has_col = ismember(col_names{i}, T.Properties.VariableNames);
        if has_col
            val = T.(col_names{i});
            return;
        end
    end
end