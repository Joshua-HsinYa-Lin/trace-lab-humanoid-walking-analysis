%% Setup and Import
clear;
clc;
close all;

% VISUAL SETTINGS
set(0, 'DefaultFigureColor', 'w');      
set(0, 'DefaultAxesColor', 'w');        
set(0, 'DefaultAxesXColor', 'k');       
set(0, 'DefaultAxesYColor', 'k');       
set(0, 'DefaultAxesZColor', 'k');       
set(0, 'DefaultTextColor', 'k');        
set(0, 'DefaultLineLineWidth', 1.5);    

% Define files
csv_follower = 'data_csv/follower_hand_data.csv';
csv_helper_R = 'data_csv/interaction_hand_data_right.csv'; 
csv_helper_L = 'data_csv/interaction_hand_data_left.csv'; 
report_file = 'reports/interaction_force_report.md';

% Load Data
fprintf('Loading data...\n');
data_F = readtable(csv_follower);
data_HR = readtable(csv_helper_R);
data_HL = readtable(csv_helper_L);
time = data_F.Time; 

%% human-human interaction
fig1 = figure('Name', 'Full Interaction Analysis', 'Color', 'w', 'Position', [100 100 1000 900]);

% X-Axis Force (Push/Pull)
subplot(3,1,1);
plot(time, data_F.LocalForce_X, 'Color', '#D95319', 'DisplayName', 'Follower (Local X)'); hold on;
plot(time, data_HR.Force_WristRadioCarpal_DorsoVolarForce, 'Color', '#0072BD', 'LineStyle', '--', 'DisplayName', 'Helper Right (DorsoVolar)'); 
plot(time, data_HL.Force_WristRadioCarpal_DorsoVolarForce, 'Color', '#77AC30', 'LineStyle', ':', 'DisplayName', 'Helper Left (DorsoVolar)'); 
title('Forward/Backward Interaction Forces (Push vs Pull)', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

% Y-Axis Force (Vertical Support)
subplot(3,1,2);
plot(time, data_F.LocalForce_Y, 'Color', '#D95319', 'DisplayName', 'Follower (Local Y)'); hold on;
plot(time, data_HR.Force_WristRadioCarpal_ProximoDistalForce, 'Color', '#0072BD', 'LineStyle', '--', 'DisplayName', 'Helper Right (ProximoDistal)'); 
plot(time, data_HL.Force_WristRadioCarpal_ProximoDistalForce, 'Color', '#77AC30', 'LineStyle', ':', 'DisplayName', 'Helper Left (ProximoDistal)'); 
title('Up/Down Interaction Forces (Vertical Weight Support)', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

% Z-Axis Force (Lateral Support)
subplot(3,1,3);
plot(time, data_F.LocalForce_Z, 'Color', '#D95319', 'DisplayName', 'Follower (Local Z)'); hold on;
plot(time, data_HR.Force_WristRadioCarpal_RadialForce, 'Color', '#0072BD', 'LineStyle', '--', 'DisplayName', 'Helper Right (Radial)'); 
plot(time, data_HL.Force_WristRadioCarpal_RadialForce, 'Color', '#77AC30', 'LineStyle', ':', 'DisplayName', 'Helper Left (Radial)'); 
title('Left/Right Interaction Forces (Lateral Stabilization)', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); xlabel('Time (s)', 'Color', 'k');
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');
set(fig1, 'InvertHardcopy', 'off'); 
fprintf('Full interaction plotting complete!\n');

%% Report
get_peak = @(x) max(abs(x));
get_avg = @(x) mean(x);

%% Write Report
fptr = fopen(report_file, 'w');
fprintf(fptr, 'INTERACTION FORCE SUMMARY\n\n');

% LATERAL STABILIZATION (Left/Right)
fprintf(fptr, 'LATERAL STABILIZATION (Left/Right)\n\n');
fprintf(fptr, '<img src="../docs/elbow.jpg" width="400">\n\n');
fprintf(fptr, 'Follower (Local Z) (Side to side horizontal force)          | Peak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_F.LocalForce_Z), get_avg(data_F.LocalForce_Z));
fprintf(fptr, 'Helper Right (Radial) (Force traveling side to side across the wrist joint)       | Peak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_HR.Force_WristRadioCarpal_RadialForce), get_avg(data_HR.Force_WristRadioCarpal_RadialForce));
fprintf(fptr, 'Helper Left (Radial) (Force traveling side to side across the wrist joint)        | Peak: %6.2f N   | Avg: %6.2f N\n\n', ...
    get_peak(data_HL.Force_WristRadioCarpal_RadialForce), get_avg(data_HL.Force_WristRadioCarpal_RadialForce));

% VERTICAL WEIGHT SUPPORT (Up/Down)
fprintf(fptr, 'VERTICAL WEIGHT SUPPORT (Up/Down)\n');
fprintf(fptr, 'Follower (Local Y) (Upward or downward force)           | Peak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_F.LocalForce_Y), get_avg(data_F.LocalForce_Y));
fprintf(fptr, 'Helper Right (ProximoDistal) (Force traveling along the length of the arm) | Peak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_HR.Force_WristRadioCarpal_ProximoDistalForce), get_avg(data_HR.Force_WristRadioCarpal_ProximoDistalForce));
fprintf(fptr, 'Helper Left (ProximoDistal) (Force traveling along the length of the arm)  | Peak: %6.2f N   | Avg: %6.2f N\n\n', ...
    get_peak(data_HL.Force_WristRadioCarpal_ProximoDistalForce), get_avg(data_HL.Force_WristRadioCarpal_ProximoDistalForce));

% PUSH/PULL (Forward/Backward)
fprintf(fptr, 'PUSH/PULL DYNAMICS (Forward/Backward)\n');
fprintf(fptr, 'Follower (Local X)           | Peak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_F.LocalForce_X), get_avg(data_F.LocalForce_X));
fprintf(fptr, 'Helper Right (DorsoVolar)    | Peak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_HR.Force_WristRadioCarpal_DorsoVolarForce), get_avg(data_HR.Force_WristRadioCarpal_DorsoVolarForce));
fprintf(fptr, 'Helper Left (DorsoVolar)     | Peak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_HL.Force_WristRadioCarpal_DorsoVolarForce), get_avg(data_HL.Force_WristRadioCarpal_DorsoVolarForce));
fclose(fptr);
fprintf('Report Written to %s!\n', report_file);

