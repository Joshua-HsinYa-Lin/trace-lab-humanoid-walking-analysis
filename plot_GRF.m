function plot_GRF(csv_dir, report_dir)
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

if exist(grf_file, 'file') ~= 2
    fprintf('Missing GRF CSV file for plotting.\n');
    return;
end

data_grf = readtable(grf_file);
has_leg_R = exist(leg_R_file, 'file') == 2;
has_leg_L = exist(leg_L_file, 'file') == 2;

time = data_grf.Time;

rfx = get_col(data_grf, {'Right_Fx'});
rfy = get_col(data_grf, {'Right_Fy'});
rfz = get_col(data_grf, {'Right_Fz'});
lfx = get_col(data_grf, {'Left_Fx'});
lfy = get_col(data_grf, {'Left_Fy'});
lfz = get_col(data_grf, {'Left_Fz'});

rap = []; 
rpd = []; 
rml = [];
if has_leg_R
    data_leg_R = readtable(leg_R_file);
    rap = get_col(data_leg_R, {'Force_Ankle_AnteroPosteriorForce'});
    rpd = get_col(data_leg_R, {'Force_Ankle_ProximoDistalForce'});
    rml = get_col(data_leg_R, {'Force_Ankle_MedioLateralForce'});
end

lap = []; 
lpd = []; 
lml = [];
if has_leg_L
    data_leg_L = readtable(leg_L_file);
    lap = get_col(data_leg_L, {'Force_Ankle_AnteroPosteriorForce'});
    lpd = get_col(data_leg_L, {'Force_Ankle_ProximoDistalForce'});
    lml = get_col(data_leg_L, {'Force_Ankle_MedioLateralForce'});
end

figure('Color', 'w', 'Name', 'GRF vs Leg Joint Forces', 'Position', [100 100 1000 900]);

subplot(3,1,1); 
hold on;
if ~isempty(rfx)
    plot(time, rfx, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF Forward Backward'); 
end
if ~isempty(rap)
    plot(time, rap, 'Color', '#D95319', 'DisplayName', 'Right Ankle Forward Backward'); 
end
if ~isempty(lfx)
    plot(time, lfx, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF Forward Backward'); 
end
if ~isempty(lap)
    plot(time, lap, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle Forward Backward'); 
end
title('Forward Backward GRF and Leg Forces'); 
ylabel('Force (N)'); 
grid on; 

subplot(3,1,2); 
hold on;
if ~isempty(rfy)
    plot(time, rfy, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF Vertical Load'); 
end
if ~isempty(rpd)
    plot(time, rpd, 'Color', '#D95319', 'DisplayName', 'Right Ankle Vertical Load'); 
end
if ~isempty(lfy)
    plot(time, lfy, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF Vertical Load'); 
end
if ~isempty(lpd)
    plot(time, lpd, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle Vertical Load'); 
end
title('Vertical Weight Bearing GRF and Leg Forces'); 
ylabel('Force (N)'); 
grid on; 

subplot(3,1,3); 
hold on;
if ~isempty(rfz)
    plot(time, rfz, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF Lateral Balance'); 
end
if ~isempty(rml)
    plot(time, rml, 'Color', '#D95319', 'DisplayName', 'Right Ankle Lateral Balance'); 
end
if ~isempty(lfz)
    plot(time, lfz, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF Lateral Balance'); 
end
if ~isempty(lml)
    plot(time, lml, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle Lateral Balance'); 
end
title('Lateral Side to Side GRF and Leg Forces'); 
xlabel('Time (s)'); 
ylabel('Force (N)'); 
grid on; 

names = {}; 
stats_cell = {}; 
units = {}; 
row_idx = 1;

if ~isempty(rfx) 
    if ~isempty(rfy) 
        if ~isempty(rfz)
            names{row_idx} = 'Right Foot';
            sX = get_stats(rfx, time);
            sY = get_stats(rfy, time);
            sZ = get_stats(rfz, time);
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
            sX = get_stats(lfx, time);
            sY = get_stats(lfy, time);
            sZ = get_stats(lfz, time);
            stats_cell{row_idx} = [sX; sY; sZ];
            units{row_idx} = 'N';
        end
    end
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

function val = get_col(T, col_names)
    val = [];
    for i = 1:length(col_names)
        if ismember(col_names{i}, T.Properties.VariableNames)
            val = T.(col_names{i});
            return;
        end
    end
end