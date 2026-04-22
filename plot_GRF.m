function plot_GRF(csv_dir)

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
    error('Required CSV files not found in %s.', csv_dir);
end

data_grf = readtable('data_csv/grf_data.csv');
data_leg_R = readtable('data_csv/interaction_joint_data_right.csv');
data_leg_L = readtable('data_csv/interaction_joint_data_left.csv');
time = data_grf.Time;

figure('Color', 'w', 'Name', 'GRF vs Leg Joint Forces', 'Position', [100 100 1000 900]);

subplot(3,1,1);
plot(time, data_grf.Right_Fx, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF Forward Backward'); 
hold on;
plot(time, data_leg_R.Force_Ankle_AnteroPosteriorForce, 'Color', '#D95319', 'DisplayName', 'Right Ankle Forward Backward');
plot(time, data_grf.Left_Fx, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF Forward Backward');
plot(time, data_leg_L.Force_Ankle_AnteroPosteriorForce, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle Forward Backward');
title('Forward Backward GRF and Leg Forces');
ylabel('Force (N)');
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,1,2);
plot(time, data_grf.Right_Fy, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF Vertical Load'); 
hold on;
plot(time, data_leg_R.Force_Ankle_ProximoDistalForce, 'Color', '#D95319', 'DisplayName', 'Right Ankle Vertical Load');
plot(time, data_grf.Left_Fy, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF Vertical Load');
plot(time, data_leg_L.Force_Ankle_ProximoDistalForce, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle Vertical Load');
title('Vertical Weight Bearing GRF and Leg Forces');
ylabel('Force (N)');
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,1,3);
plot(time, data_grf.Right_Fz, 'Color', '#0072BD', 'DisplayName', 'Right Foot GRF Lateral Balance'); 
hold on;
plot(time, data_leg_R.Force_Ankle_MedioLateralForce, 'Color', '#D95319', 'DisplayName', 'Right Ankle Lateral Balance');
plot(time, data_grf.Left_Fz, 'Color', '#77AC30', 'DisplayName', 'Left Foot GRF Lateral Balance');
plot(time, data_leg_L.Force_Ankle_MedioLateralForce, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle Lateral Balance');
title('Lateral Side to Side GRF and Leg Forces');
xlabel('Time (s)');
ylabel('Force (N)');
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

fprintf('GRF and Leg Joint Forces plotting complete\n');

end