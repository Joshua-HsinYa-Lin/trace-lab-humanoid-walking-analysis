function plot_single_GRFandLeg(csv_dir)
data_grf = readtable(fullfile(csv_dir, 'grf_data_single.csv'));
data_leg_R = readtable(fullfile(csv_dir, 'single_joint_data_right.csv'));
data_leg_L = readtable(fullfile(csv_dir, 'single_joint_data_left.csv'));

set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesColor', 'w');
set(0, 'DefaultAxesXColor', 'k');
set(0, 'DefaultAxesYColor', 'k');
set(0, 'DefaultAxesZColor', 'k');
set(0, 'DefaultTextColor', 'k');
set(0, 'DefaultLineLineWidth', 1.5);

fprintf('Loading GRF and Leg Joint data for Symmetry Check\n');
time = data_grf.Time;

figure('Color', 'w', 'Name', 'Lateral Symmetry Check', 'Position', [100 100 1000 700]);

subplot(2,1,1);
plot(time, data_grf.Plate1_Fz, 'Color', '#0072BD', 'DisplayName', 'Plate 1 Z-Axis (Lateral) GRF'); 
hold on;
plot(time, data_grf.Plate2_Fz, 'Color', '#77AC30', 'DisplayName', 'Plate 2 Z-Axis (Lateral) GRF');
title('Force Plate Z-Axis Symmetry Check');
ylabel('Force (N)');
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,1,2);
plot(time, data_leg_R.Force_Ankle_MedioLateralForce, 'Color', '#D95319', 'DisplayName', 'Right Ankle Medio-Lateral Force');
hold on;
plot(time, data_leg_L.Force_Ankle_MedioLateralForce, 'Color', '#7E2F8E', 'DisplayName', 'Left Ankle Medio-Lateral Force');
title('Ankle Joint Z-Axis Symmetry Check');
xlabel('Time (s)');
ylabel('Force (N)');
grid on; 
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

fprintf('Symmetry plotting complete\n');

end