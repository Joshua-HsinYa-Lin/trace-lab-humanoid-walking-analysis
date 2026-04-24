function plot_follower(csv_dir, report_dir)
csv_follower = fullfile(csv_dir, 'follower_hand_data.csv');
csv_helper_R = fullfile(csv_dir, 'interaction_hand_data_right.csv'); 
csv_helper_L = fullfile(csv_dir, 'interaction_hand_data_left.csv'); 
report_file = fullfile(report_dir, 'interaction_force_report.txt');

set(0, 'DefaultFigureColor', 'w');      
set(0, 'DefaultAxesColor', 'w');        
set(0, 'DefaultAxesXColor', 'k');       
set(0, 'DefaultAxesYColor', 'k');       
set(0, 'DefaultAxesZColor', 'k');       
set(0, 'DefaultTextColor', 'k');        
set(0, 'DefaultLineLineWidth', 1.5);    

has_F = exist(csv_follower, 'file') == 2;
has_HR = exist(csv_helper_R, 'file') == 2;
has_HL = exist(csv_helper_L, 'file') == 2;

if ~has_F
    fprintf('Missing Follower CSV. Plotting aborted.\n');
    return;
end

data_F = readtable(csv_follower);
time = data_F.Time;

fx_F = get_col(data_F, {'Fout_X'});
fy_F = get_col(data_F, {'Fout_Y'});
fz_F = get_col(data_F, {'Fout_Z'});

fx_HR = []; 
fy_HR = []; 
fz_HR = [];
if has_HR
    data_HR = readtable(csv_helper_R);
    fx_HR = get_col(data_HR, {'Force_WristRadioCarpal_DorsoVolarForce'});
    fy_HR = get_col(data_HR, {'Force_WristRadioCarpal_ProximoDistalForce'});
    fz_HR = get_col(data_HR, {'Force_WristRadioCarpal_RadialForce'});
end

fx_HL = []; 
fy_HL = []; 
fz_HL = [];
if has_HL
    data_HL = readtable(csv_helper_L);
    fx_HL = get_col(data_HL, {'Force_WristRadioCarpal_DorsoVolarForce'});
    fy_HL = get_col(data_HL, {'Force_WristRadioCarpal_ProximoDistalForce'});
    fz_HL = get_col(data_HL, {'Force_WristRadioCarpal_RadialForce'});
end

fig1 = figure('Name', 'Full Interaction Analysis', 'Color', 'w', 'Position', [100 100 1000 900]);

subplot(3,1,1); 
hold on;
if ~isempty(fx_F)
    plot(time, fx_F, 'Color', '#D95319', 'DisplayName', 'Follower (Local X)'); 
end
if ~isempty(fx_HR)
    plot(time, fx_HR, 'Color', '#0072BD', 'LineStyle', '--', 'DisplayName', 'Helper Right (DorsoVolar)'); 
end
if ~isempty(fx_HL)
    plot(time, fx_HL, 'Color', '#77AC30', 'LineStyle', ':', 'DisplayName', 'Helper Left (DorsoVolar)'); 
end
title('Follower Forward/Backward Interaction Forces (x-axis)', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
grid on;

subplot(3,1,2); 
hold on;
if ~isempty(fz_F)
    plot(time, fz_F, 'Color', '#D95319', 'DisplayName', 'Follower (Local Y)'); 
end
if ~isempty(fy_HR)
    plot(time, fy_HR, 'Color', '#0072BD', 'LineStyle', '--', 'DisplayName', 'Helper Right (ProximoDistal)'); 
end
if ~isempty(fy_HL)
    plot(time, fy_HL, 'Color', '#77AC30', 'LineStyle', ':', 'DisplayName', 'Helper Left (ProximoDistal)'); 
end
title('Up/Down Interaction Forces (y-axis)', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
grid on;

subplot(3,1,3); 
hold on;
if ~isempty(fy_F)
    plot(time, fy_F, 'Color', '#D95319', 'DisplayName', 'Follower (Local Z)'); 
end
if ~isempty(fz_HR)
    plot(time, fz_HR, 'Color', '#0072BD', 'LineStyle', '--', 'DisplayName', 'Helper Right (Radial)'); 
end
if ~isempty(fz_HL)
    plot(time, fz_HL, 'Color', '#77AC30', 'LineStyle', ':', 'DisplayName', 'Helper Left (Radial)'); 
end
title('Left/Right Interaction Forces (z-axis)', 'Color', 'k'); 
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k'); 
grid on;

set(fig1, 'InvertHardcopy', 'off');

names = {}; 
stats_cell = {}; 
units = {}; 
row_idx = 1;

if ~isempty(fx_F) 
    if ~isempty(fy_F) 
        if ~isempty(fz_F)
            names{row_idx} = 'Follower HandOfGod Global Force';
            sX = get_stats(fx_F, time);
            sY = get_stats(fy_F, time);
            sZ = get_stats(fz_F, time);
            stats_cell{row_idx} = [sX; sY; sZ];
            units{row_idx} = 'N';
            row_idx = row_idx + 1;
        end
    end
end

if ~isempty(fx_HR) 
    if ~isempty(fy_HR) 
        if ~isempty(fz_HR)
            names{row_idx} = 'Helper Right Wrist Force (DorsoVolar, ProximoDistal, Radial)';
            sX = get_stats(fx_HR, time);
            sY = get_stats(fy_HR, time);
            sZ = get_stats(fz_HR, time);
            stats_cell{row_idx} = [sX; sY; sZ];
            units{row_idx} = 'N';
            row_idx = row_idx + 1;
        end
    end
end

if ~isempty(fx_HL) 
    if ~isempty(fy_HL) 
        if ~isempty(fz_HL)
            names{row_idx} = 'Helper Left Wrist Force (DorsoVolar, ProximoDistal, Radial)';
            sX = get_stats(fx_HL, time);
            sY = get_stats(fy_HL, time);
            sZ = get_stats(fz_HL, time);
            stats_cell{row_idx} = [sX; sY; sZ];
            units{row_idx} = 'N';
        end
    end
end

if ~isempty(names)
    write_report(report_file, 'Follower Interaction Force Report', names, stats_cell, units);
end
fprintf('Full interaction plotting complete!\n');
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