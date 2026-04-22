function plot_follower(csv_dir, report_dir)
csv_follower = fullfile(csv_dir, 'follower_hand_data.csv');
csv_helper_R = fullfile(csv_dir, 'interaction_hand_data_right.csv'); 
csv_helper_L = fullfile(csv_dir, 'interaction_hand_data_left.csv'); 
report_file = fullfile(report_dir, 'interaction_force_report.md');

set(0, 'DefaultFigureColor', 'w');      
set(0, 'DefaultAxesColor', 'w');        
set(0, 'DefaultAxesXColor', 'k');       
set(0, 'DefaultAxesYColor', 'k');       
set(0, 'DefaultAxesZColor', 'k');       
set(0, 'DefaultTextColor', 'k');        
set(0, 'DefaultLineLineWidth', 1.5);    

fprintf('Loading data...\n');
data_F = readtable(csv_follower);
data_HR = readtable(csv_helper_R);
data_HL = readtable(csv_helper_L);
time = data_F.Time; 

fig1 = figure('Name', 'Full Interaction Analysis', 'Color', 'w', 'Position', [100 100 1000 900]);

subplot(3,1,1);
plot(time, data_F.Fout_X, 'Color', '#D95319', 'DisplayName', 'Follower (Local X)'); hold on;
plot(time, data_HR.Force_WristRadioCarpal_DorsoVolarForce, 'Color', '#0072BD', 'LineStyle', '--', 'DisplayName', 'Helper Right (DorsoVolar)'); 
plot(time, data_HL.Force_WristRadioCarpal_DorsoVolarForce, 'Color', '#77AC30', 'LineStyle', ':', 'DisplayName', 'Helper Left (DorsoVolar)'); 
title('Follower Forward/Backward Interaction Forces (x-axis)', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,1,2);
plot(time, data_F.Fout_Z, 'Color', '#D95319', 'DisplayName', 'Follower (Local Y)'); hold on;
plot(time, data_HR.Force_WristRadioCarpal_ProximoDistalForce, 'Color', '#0072BD', 'LineStyle', '--', 'DisplayName', 'Helper Right (ProximoDistal)'); 
plot(time, data_HL.Force_WristRadioCarpal_ProximoDistalForce, 'Color', '#77AC30', 'LineStyle', ':', 'DisplayName', 'Helper Left (ProximoDistal)'); 
title('Up/Down Interaction Forces (y-axis)', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

subplot(3,1,3);
plot(time, data_F.Fout_Y, 'Color', '#D95319', 'DisplayName', 'Follower (Local Z)'); hold on;
plot(time, data_HR.Force_WristRadioCarpal_RadialForce, 'Color', '#0072BD', 'LineStyle', '--', 'DisplayName', 'Helper Right (Radial)'); 
plot(time, data_HL.Force_WristRadioCarpal_RadialForce, 'Color', '#77AC30', 'LineStyle', ':', 'DisplayName', 'Helper Left (Radial)'); 
title('Left/Right Interaction Forces (z-axis)', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); xlabel('Time (s)', 'Color', 'k');
grid on;
legend('Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');
set(fig1, 'InvertHardcopy', 'off'); 
fprintf('Full interaction plotting complete!\n');

get_peak = @(x) max(abs(x));
get_avg = @(x) mean(x);

fptr = fopen(report_file, 'w');
fprintf(fptr, 'INTERACTION FORCE SUMMARY\n\n');

fprintf(fptr, 'LATERAL STABILIZATION (Left/Right)\n\n');
fprintf(fptr, '<img src="../docs/hand directions.jpg" width="400">\n\n');
fprintf(fptr, 'Follower (Global Y) (Side to side horizontal force)\nPeak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_F.Fout_Y), get_avg(data_F.Fout_Y));
fprintf(fptr, 'Helper Right (Radial) (Force traveling side to side across the wrist joint)\nPeak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_HR.Force_WristRadioCarpal_RadialForce), get_avg(data_HR.Force_WristRadioCarpal_RadialForce));
fprintf(fptr, 'Helper Left (Radial) (Force traveling side to side across the wrist joint)\nPeak: %6.2f N   | Avg: %6.2f N\n\n', ...
    get_peak(data_HL.Force_WristRadioCarpal_RadialForce), get_avg(data_HL.Force_WristRadioCarpal_RadialForce));

fprintf(fptr, 'VERTICAL WEIGHT SUPPORT (Up/Down)\n');
fprintf(fptr, 'Follower (Global Z) (Upward or downward force)\nPeak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_F.Fout_Z), get_avg(data_F.Fout_Z));
fprintf(fptr, 'Helper Right (ProximoDistal) (Force traveling along the length of the arm)\nPeak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_HR.Force_WristRadioCarpal_ProximoDistalForce), get_avg(data_HR.Force_WristRadioCarpal_ProximoDistalForce));
fprintf(fptr, 'Helper Left (ProximoDistal) (Force traveling along the length of the arm)\nPeak: %6.2f N   | Avg: %6.2f N\n\n', ...
    get_peak(data_HL.Force_WristRadioCarpal_ProximoDistalForce), get_avg(data_HL.Force_WristRadioCarpal_ProximoDistalForce));

fprintf(fptr, 'PUSH/PULL DYNAMICS (Forward/Backward)\n');
fprintf(fptr, 'Follower (Global X)\nPeak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_F.Fout_X), get_avg(data_F.Fout_X));
fprintf(fptr, 'Helper Right (DorsoVolar)\nPeak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_HR.Force_WristRadioCarpal_DorsoVolarForce), get_avg(data_HR.Force_WristRadioCarpal_DorsoVolarForce));
fprintf(fptr, 'Helper Left (DorsoVolar)\nPeak: %6.2f N   | Avg: %6.2f N\n', ...
    get_peak(data_HL.Force_WristRadioCarpal_DorsoVolarForce), get_avg(data_HL.Force_WristRadioCarpal_DorsoVolarForce));
fclose(fptr);
fprintf('Report Written to %s!\n', report_file);

end