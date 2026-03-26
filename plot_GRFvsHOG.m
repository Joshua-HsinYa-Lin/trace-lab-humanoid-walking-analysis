clear;
clc;
close all;

data_grf = readtable('data_csv/grf_data.csv');
data_f = readtable('data_csv/follower_hand_data.csv');
report_file = 'reports/statistical_dependence.txt';

set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesColor', 'w');
set(0, 'DefaultAxesXColor', 'k');
set(0, 'DefaultAxesYColor', 'k');
set(0, 'DefaultAxesZColor', 'k');
set(0, 'DefaultTextColor', 'k');
set(0, 'DefaultLineLineWidth', 1.5);

fprintf('Loading GRF and HandOfGod Data ...\n');

time = data_grf.Time;

fig1 = figure('Color', 'w', 'Name', 'GRF Prediction vs HandOfGod Compensation', 'Position', [100 100 1000 800]);

subplot(2,1,1);
plot(time, data_grf.Right_Fz, 'Color', '#0072BD', 'DisplayName', 'Right Foot Vertical GRF');
hold on;
plot(time, data_grf.Left_Fz, 'Color', '#77AC30', 'DisplayName', 'Left Foot Vertical GRF');
title('Ground Reaction Force Prediction Leg Vertical Load (z-axis)');
ylabel('Force (N)');
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,1,2);
plot(time, data_f.Fout_Z, 'Color', '#D95319', 'DisplayName', 'HandOfGod Vertical Compensation');
title('HandOfGod Vertical Weight Force (z-axis)');
xlabel('Time (s)');
ylabel('Force (N)');
grid on;
legend('Location', 'northeast', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

fprintf('GRF vs HandOfGod plotting complete\n');

grf_R = data_grf.Right_Fz;
grf_tot = data_grf.Right_Fz + data_grf.Left_Fz;
hog_Z = data_f.Fout_Z;

R_mat_R = corrcoef(grf_R, hog_Z);
r_R = R_mat_R(1,2);
r2_R = r_R^2;
cos_sim_R = dot(grf_R, hog_Z) / (norm(grf_R) * norm(hog_Z));

R_mat_tot = corrcoef(grf_tot, hog_Z);
r_tot = R_mat_tot(1,2);
r2_tot = r_tot^2;
cos_sim_tot = dot(grf_tot, hog_Z) / (norm(grf_tot) * norm(hog_Z));

fptr = fopen(report_file, 'w');
fprintf(fptr, 'STATISTICAL DEPENDENCE\n');
fprintf(fptr, '\n');
fprintf(fptr, 'RIGHT LEG GRF vs HAND OF GOD\n');
fprintf(fptr, 'Correlation (r):      %6.4f\n', r_R);
fprintf(fptr, 'R squared:            %6.4f\n', r2_R);
fprintf(fptr, 'Cosine Similarity:    %6.4f\n', cos_sim_R);
fprintf(fptr, '\n');
fprintf(fptr, 'TOTAL GRF (Right + Left) vs HAND OF GOD\n');
fprintf(fptr, 'Correlation (r):      %6.4f\n', r_tot);
fprintf(fptr, 'R squared:            %6.4f\n', r2_tot);
fprintf(fptr, 'Cosine Similarity:    %6.4f\n', cos_sim_tot);
fprintf(fptr, '\n');
fclose(fptr);
fprintf('Report successfully written to %s\n', report_file);