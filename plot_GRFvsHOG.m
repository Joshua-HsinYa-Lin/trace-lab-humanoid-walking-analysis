clear;
clc;
close all;

set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesColor', 'w');
set(0, 'DefaultAxesXColor', 'k');
set(0, 'DefaultAxesYColor', 'k');
set(0, 'DefaultAxesZColor', 'k');
set(0, 'DefaultTextColor', 'k');
set(0, 'DefaultLineLineWidth', 1.5);

fprintf('Loading GRF and HandOfGod Data\n');

data_grf = readtable('data_csv/grf_data.csv');
data_f = readtable('data_csv/follower_hand_data.csv');

time = data_grf.Time;

fig1 = figure('Color', 'w', 'Name', 'GRF Prediction vs HandOfGod Compensation', 'Position', [100 100 1000 800]);

subplot(2,1,1);
plot(time, data_grf.Right_Fy, 'Color', '#0072BD', 'DisplayName', 'Right Foot Vertical GRF');
hold on;
plot(time, data_grf.Left_Fy, 'Color', '#77AC30', 'DisplayName', 'Left Foot Vertical GRF');
title('Ground Reaction Force Prediction Vertical Load');
ylabel('Force (N)');
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,1,2);
plot(time, data_f.LocalForce_Y, 'Color', '#D95319', 'DisplayName', 'HandOfGod Vertical Compensation');
title('HandOfGod Vertical Weight Bearing Force');
xlabel('Time (s)');
ylabel('Force (N)');
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

fprintf('GRF vs HandOfGod plotting complete\n');

% Statistical Analysis for GRF vs Hand of God linear dependency
grf_R = data_grf.Right_Fy;
grf_tot = data_grf.Right_Fy + data_grf.Left_Fy;
hog_Y = data_f.LocalForce_Y;

R_mat_R = corrcoef(grf_R, hog_Y);
r_R = R_mat_R(1,2);
r2_R = r_R^2;
cos_sim_R = dot(grf_R, hog_Y) / (norm(grf_R) * norm(hog_Y));

R_mat_tot = corrcoef(grf_tot, hog_Y);
r_tot = R_mat_tot(1,2);
r2_tot = r_tot^2;
cos_sim_tot = dot(grf_tot, hog_Y) / (norm(grf_tot) * norm(hog_Y));

fprintf('\nSTATISTICAL DEPENDENCE\n');
fprintf('\n');
fprintf('RIGHT LEG GRF vs HAND OF GOD\n');
fprintf('Correlation (r):      %6.4f\n', r_R);
fprintf('R squared:            %6.4f\n', r2_R);
fprintf('Cosine Similarity:    %6.4f\n', cos_sim_R);
fprintf('\n');
fprintf('TOTAL GRF (Right + Left) vs HAND OF GOD\n');
fprintf('Correlation (r):      %6.4f\n', r_tot);
fprintf('R squared:            %6.4f\n', r2_tot);
fprintf('Cosine Similarity:    %6.4f\n', cos_sim_tot);
fprintf('\n');