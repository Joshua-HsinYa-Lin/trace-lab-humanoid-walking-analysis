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

fprintf('Loading Single Person and Interaction Data\n');

data_single_arm = readtable('data_csv/single_hand_data_right.csv');
data_single_leg = readtable('data_csv/single_joint_data_right.csv');

data_int_arm = readtable('data_csv/interaction_hand_data_right.csv');
data_int_leg = readtable('data_csv/interaction_joint_data_right.csv');

time_single = data_single_arm.Time;
time_int = data_int_arm.Time;

fig1 = figure('Color', 'w', 'Name', 'Single vs Interaction Forces', 'Position', [100 100 1200 800]);

subplot(2,2,1);
plot(time_single, data_single_arm.Force_WristRadioCarpal_DorsoVolarForce, 'Color', '#0072BD', 'DisplayName', 'Single Person Arm Push Pull');
hold on;
plot(time_int, data_int_arm.Force_WristRadioCarpal_DorsoVolarForce, 'Color', '#D95319', 'DisplayName', 'Interaction Helper Arm Push Pull');
title('Arm Forward / Backward Force');
xlabel('Time (s)');
ylabel('Force (N)');
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,2,2);
plot(time_single, data_single_arm.Force_WristRadioCarpal_ProximoDistalForce, 'Color', '#0072BD', 'DisplayName', 'Single Person Arm Vertical');
hold on;
plot(time_int, data_int_arm.Force_WristRadioCarpal_ProximoDistalForce, 'Color', '#D95319', 'DisplayName', 'Interaction Helper Arm Vertical');
title('Arm Vertical Weight Force');
xlabel('Time (s)');
ylabel('Force (N)');
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,2,3);
plot(time_single, data_single_leg.Force_Ankle_AnteroPosteriorForce, 'Color', '#77AC30', 'DisplayName', 'Single Person Leg Forward / Backward');
hold on;
plot(time_int, data_int_leg.Force_Ankle_AnteroPosteriorForce, 'Color', '#7E2F8E', 'DisplayName', 'Interaction Leg Forward / Backward');
title('Leg Ankle Forward / Backward Force');
xlabel('Time (s)');
ylabel('Force (N)');
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(2,2,4);
plot(time_single, data_single_leg.Force_Ankle_ProximoDistalForce, 'Color', '#77AC30', 'DisplayName', 'Single Person Leg Vertical Load');
hold on;
plot(time_int, data_int_leg.Force_Ankle_ProximoDistalForce, 'Color', '#7E2F8E', 'DisplayName', 'Interaction Leg Vertical Load');
title('Leg Ankle Vertical Weight Force');
xlabel('Time (s)');
ylabel('Force (N)');
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

fprintf('Single vs Interaction plotting complete\n');