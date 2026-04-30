function plot_GRFvsHOG(csv_dir, report_dir, cond, fig_dir)
if nargin < 3
    cond = 'UnknownCondition';
end
if nargin < 4
    fig_dir = fullfile(pwd, 'analysis_figure');
end

if ~exist(fig_dir, 'dir')
    mkdir(fig_dir);
end

grf_file = fullfile(csv_dir, 'grf_data.csv');
f_file = fullfile(csv_dir, 'follower_hand_data.csv');
report_file = fullfile(report_dir, 'statistical_dependence.txt');

file_grf_exists = exist(grf_file, 'file');
if file_grf_exists ~= 2
    fprintf('Missing GRF file.\n');
    return;
end

file_f_exists = exist(f_file, 'file');
if file_f_exists ~= 2
    fprintf('Missing Follower file.\n');
    return;
end

data_grf = readtable(grf_file);
data_f = readtable(f_file);

set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesColor', 'w');
set(0, 'DefaultAxesXColor', 'k');
set(0, 'DefaultAxesYColor', 'k');
set(0, 'DefaultAxesZColor', 'k');
set(0, 'DefaultTextColor', 'k');
set(0, 'DefaultLineLineWidth', 1.5);

time_grf = data_grf.Time;
time_f = data_f.Time;

rfx = get_col(data_grf, {'Right_Fx'});
rfy = get_col(data_grf, {'Right_Fy'});
rfz = get_col(data_grf, {'Right_Fz'});
lfx = get_col(data_grf, {'Left_Fx'});
lfy = get_col(data_grf, {'Left_Fy'});
lfz = get_col(data_grf, {'Left_Fz'});

rmx = get_col(data_grf, {'Right_Mx'});
rmy = get_col(data_grf, {'Right_My'});
rmz = get_col(data_grf, {'Right_Mz'});
lmx = get_col(data_grf, {'Left_Mx'});
lmy = get_col(data_grf, {'Left_My'});
lmz = get_col(data_grf, {'Left_Mz'});

hx = get_col(data_f, {'Fout_X', 'LocalForce_X'});
hy = get_col(data_f, {'Fout_Y', 'LocalForce_Y'});
hz = get_col(data_f, {'Fout_Z', 'LocalForce_Z'});

mx = get_col(data_f, {'LocalMoment_X'});
my = get_col(data_f, {'LocalMoment_Y'});
mz = get_col(data_f, {'LocalMoment_Z'});

label_mx = 'HOG Moment X';
if isempty(mx)
    mx = hx;
    label_mx = 'HOG Force X';
end

label_my = 'HOG Moment Y';
if isempty(my)
    my = hy;
    label_my = 'HOG Force Y';
end

label_mz = 'HOG Moment Z';
if isempty(mz)
    mz = hz;
    label_mz = 'HOG Force Z';
end

fig1 = figure('Name', '1. GRF Right and Left', 'Position', [50 50 1000 800]);

subplot(3,1,1); 
hold on;
if ~isempty(rfx)
    plot(time_grf, rfx, 'Color', '#0072BD', 'DisplayName', 'Right Fx');
end
if ~isempty(lfx)
    plot(time_grf, lfx, 'Color', '#D95319', 'DisplayName', 'Left Fx');
end
title('GRF Forward/Backward Force (X-axis)'); 
ylabel('Force (N)'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,1,2); 
hold on;
if ~isempty(rfy)
    plot(time_grf, rfy, 'Color', '#0072BD', 'DisplayName', 'Right Fy');
end
if ~isempty(lfy)
    plot(time_grf, lfy, 'Color', '#D95319', 'DisplayName', 'Left Fy');
end
title('GRF Lateral Force (Y-axis)'); 
ylabel('Force (N)'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,1,3); 
hold on;
if ~isempty(rfz)
    plot(time_grf, rfz, 'Color', '#0072BD', 'DisplayName', 'Right Fz');
end
if ~isempty(lfz)
    plot(time_grf, lfz, 'Color', '#D95319', 'DisplayName', 'Left Fz');
end
title('GRF Vertical Load (Z-axis)'); 
xlabel('Time (s)'); 
ylabel('Force (N)'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

fig2 = figure('Name', '2. GRF vs HOG Force X', 'Position', [100 100 800 600]);
subplot(2,1,1); 
hold on;
if ~isempty(rfx)
    plot(time_grf, rfx, 'Color', '#0072BD', 'DisplayName', 'Right GRF Fx'); 
end
if ~isempty(lfx)
    plot(time_grf, lfx, 'Color', '#77AC30', 'DisplayName', 'Left GRF Fx'); 
end
title('GRF Forward/Backward Force (X-axis)'); 
ylabel('Force (N)'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,1,2); 
hold on;
if ~isempty(hx)
    plot(time_f, hx, 'Color', '#D95319', 'DisplayName', 'HOG Fx'); 
end
title('HandOfGod Forward/Backward Force (X-axis)'); 
xlabel('Time (s)'); 
ylabel('Force (N)'); 
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

fig3 = figure('Name', '3. GRF vs HOG Force Y', 'Position', [150 150 800 600]);
subplot(2,1,1); 
hold on;
if ~isempty(rfy)
    plot(time_grf, rfy, 'Color', '#0072BD', 'DisplayName', 'Right GRF Fy'); 
end
if ~isempty(lfy)
    plot(time_grf, lfy, 'Color', '#77AC30', 'DisplayName', 'Left GRF Fy'); 
end
title('GRF Lateral Force (Y-axis)'); 
ylabel('Force (N)'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,1,2); 
hold on;
if ~isempty(hy)
    plot(time_f, hy, 'Color', '#D95319', 'DisplayName', 'HOG Fy'); 
end
title('HandOfGod Lateral Force (Y-axis)'); 
xlabel('Time (s)'); 
ylabel('Force (N)'); 
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

fig4 = figure('Name', '4. GRF vs HOG Force Z', 'Position', [200 200 800 600]);
subplot(2,1,1); 
hold on;
if ~isempty(rfz)
    plot(time_grf, rfz, 'Color', '#0072BD', 'DisplayName', 'Right GRF Fz'); 
end
if ~isempty(lfz)
    plot(time_grf, lfz, 'Color', '#77AC30', 'DisplayName', 'Left GRF Fz'); 
end
title('GRF Vertical Load (Z-axis)'); 
ylabel('Force (N)'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,1,2); 
hold on;
if ~isempty(hz)
    plot(time_f, hz, 'Color', '#D95319', 'DisplayName', 'HOG Fz'); 
end
title('HandOfGod Vertical Force (Z-axis)'); 
xlabel('Time (s)'); 
ylabel('Force (N)'); 
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

fig5 = figure('Name', '5. GRF vs HOG Moment X', 'Position', [250 250 800 600]);
subplot(2,1,1); 
hold on;
if ~isempty(rmx)
    plot(time_grf, rmx, 'Color', '#0072BD', 'DisplayName', 'Right GRF Mx'); 
end
if ~isempty(lmx)
    plot(time_grf, lmx, 'Color', '#77AC30', 'DisplayName', 'Left GRF Mx'); 
end
title('GRF Moment X'); 
ylabel('Moment (Nm)'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,1,2); 
hold on;
if ~isempty(mx)
    plot(time_f, mx, 'Color', '#7E2F8E', 'DisplayName', label_mx); 
end
title(label_mx); 
xlabel('Time (s)'); 
ylabel('Magnitude'); 
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

fig6 = figure('Name', '6. GRF vs HOG Moment Y', 'Position', [300 300 800 600]);
subplot(2,1,1); 
hold on;
if ~isempty(rmy)
    plot(time_grf, rmy, 'Color', '#0072BD', 'DisplayName', 'Right GRF My'); 
end
if ~isempty(lmy)
    plot(time_grf, lmy, 'Color', '#77AC30', 'DisplayName', 'Left GRF My'); 
end
title('GRF Moment Y'); 
ylabel('Moment (Nm)'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,1,2); 
hold on;
if ~isempty(my)
    plot(time_f, my, 'Color', '#7E2F8E', 'DisplayName', label_my); 
end
title(label_my); 
xlabel('Time (s)'); 
ylabel('Magnitude'); 
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

fig7 = figure('Name', '7. GRF vs HOG Moment Z', 'Position', [350 350 800 600]);
subplot(2,1,1); 
hold on;
if ~isempty(rmz)
    plot(time_grf, rmz, 'Color', '#0072BD', 'DisplayName', 'Right GRF Mz'); 
end
if ~isempty(lmz)
    plot(time_grf, lmz, 'Color', '#77AC30', 'DisplayName', 'Left GRF Mz'); 
end
title('GRF Moment Z'); 
ylabel('Moment (Nm)'); 
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,1,2); 
hold on;
if ~isempty(mz)
    plot(time_f, mz, 'Color', '#7E2F8E', 'DisplayName', label_mz); 
end
title(label_mz); 
xlabel('Time (s)'); 
ylabel('Magnitude'); 
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

name_mx = strrep(label_mx, ' ', '');
name_my = strrep(label_my, ' ', '');
name_mz = strrep(label_mz, ' ', '');

set(fig1, 'InvertHardcopy', 'off', 'Color', 'w');
set(fig2, 'InvertHardcopy', 'off', 'Color', 'w');
set(fig3, 'InvertHardcopy', 'off', 'Color', 'w');
set(fig4, 'InvertHardcopy', 'off', 'Color', 'w');
set(fig5, 'InvertHardcopy', 'off', 'Color', 'w');
set(fig6, 'InvertHardcopy', 'off', 'Color', 'w');
set(fig7, 'InvertHardcopy', 'off', 'Color', 'w');

saveas(fig1, fullfile(fig_dir, sprintf('%s_GRFLeftvsRight.png', cond)));
saveas(fig2, fullfile(fig_dir, sprintf('%s_GRFXforcevsHOGforceX.png', cond)));
saveas(fig3, fullfile(fig_dir, sprintf('%s_GRFYforcevsHOGforceY.png', cond)));
saveas(fig4, fullfile(fig_dir, sprintf('%s_GRFZforcevsHOGforceZ.png', cond)));
saveas(fig5, fullfile(fig_dir, sprintf('%s_GRFXmomentvs%s.png', cond, name_mx)));
saveas(fig6, fullfile(fig_dir, sprintf('%s_GRFYmomentvs%s.png', cond, name_my)));
saveas(fig7, fullfile(fig_dir, sprintf('%s_GRFZmomentvs%s.png', cond, name_mz)));

fptr = fopen(report_file, 'w');
fprintf(fptr, 'STATISTICAL DEPENDENCE\n\n');

if ~isempty(rfz) 
    if ~isempty(hz)
        len_r = length(rfz);
        len_h = length(hz);
        if len_r == len_h
            grf_R = rfz;
            hog_Z = hz;
            R_mat_R = corrcoef(grf_R, hog_Z);
            r_R = R_mat_R(1,2);
            r2_R = r_R^2;
            cos_sim_R = dot(grf_R, hog_Z) / (norm(grf_R) * norm(hog_Z));
            
            fprintf(fptr, 'RIGHT LEG VERTICAL GRF vs HOG VERTICAL\n');
            fprintf(fptr, 'Correlation (r):      %6.4f\n', r_R);
            fprintf(fptr, 'R squared:            %6.4f\n', r2_R);
            fprintf(fptr, 'Cosine Similarity:    %6.4f\n\n', cos_sim_R);
        end
    end
end
fclose(fptr);

fprintf('GRF vs HandOfGod plotting complete and PNGs saved to %s\n', fig_dir);
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