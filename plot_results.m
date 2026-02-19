%% Import File
csv_file = 'interaction_joint_data.csv';
report_file = 'joint_forces_report.txt';
if exist(csv_file, 'file') ~= 2
    error(['File not found! Make sure ' ...
        '    "interaction_joint_data.csv" is in folder.']);
end
data = readtable(csv_file);
time = data.Time;

%% Function to Find Maxmimum Value
get_peak = @(v) max(abs(v));

%% Write Report
fptr = fopen(report_file, 'w');
if fptr == -1
    error('Could not open report file for writing.');
end

%Hip Joint
fprintf(fptr, 'HIP Joint:\n');
fprintf(fptr, '  Max Flexion Torque:    %.2f Nm\n', ...
    get_peak(data.Moment_HipFlexion));
fprintf(fptr, '  Max Abduction Torque:  %.2f Nm\n', ...
    get_peak(data.Moment_HipAbduction));
fprintf(fptr, '  Max Vertical Load:     %.2f N\n', ...
    get_peak(data.Force_Hip_ProximoDistalForce));
fprintf('\n');

%Knee Joint
fprintf(fptr, 'KNEE Joint:\n');
fprintf('  Max Flexion Torque:    %.2f Nm\n', ...
    get_peak(data.Moment_KneeFlexion));
fprintf(fptr, '  Max Vertical Load:     %.2f N\n', ...
    get_peak(data.Force_Knee_ProximoDistalForce));
fprintf('\n');

%Ankle Joint
fprintf(fptr, 'ANKLE Joint:\n');
fprintf(fptr, '  Max Plantar Torque:    %.2f Nm\n', ...
    get_peak(data.Moment_AnklePlantarFlexion));
fprintf(fptr, '  Max Lateral Force:     %.2f N\n', ...
    get_peak(data.Force_Ankle_MedioLateralForce));
fclose(fptr);
fprintf("Report Written!\n");

%% Plotting
fig1 = figure('Name', 'Joint Torques', 'Color', 'w', 'Position', [100 100 1000 800]);

% Subplot 1: Hip
subplot(3,1,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data.Moment_HipFlexion, 'Color', '#0072BD'); hold on;
plot(time, data.Moment_HipAbduction, 'Color', '#D95319', 'LineStyle', '--');
title('Hip Joint Moments', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
grid on;
set(gca, 'XColor', 'k', 'YColor', 'k');
legend('Hip Flexion', 'Hip Abduction', ...
       'Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

% Subplot 2: Knee
subplot(3,1,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data.Moment_KneeFlexion, 'Color', '#77AC30');
title('Knee Joint Moment', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k');
grid on;
set(gca, 'XColor', 'k', 'YColor', 'k');
legend('Knee Flexion', 'Location', 'best', 'Color', 'w', 'TextColor', 'k');

% Subplot 3: Ankle
subplot(3,1,3);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data.Moment_AnklePlantarFlexion, 'Color', '#A2142F');
title('Ankle Joint Moment', 'Color', 'k');
ylabel('Torque (Nm)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k');
grid on;
set(gca, 'XColor', 'k', 'YColor', 'k');
legend('Ankle PlantarFlexion', 'Location', 'best', 'Color', 'w', 'TextColor', 'k');

set(fig1, 'InvertHardcopy', 'off'); 

fig2 = figure('Name', 'Joint Reaction Forces', 'Color', 'w', 'Position', [150 150 1000 600]);

% Subplot 1: Vertical Loads
subplot(2,1,1);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, abs(data.Force_Hip_ProximoDistalForce)); hold on;
plot(time, abs(data.Force_Knee_ProximoDistalForce));
plot(time, abs(data.Force_Ankle_ProximoDistalForce));
title('Vertical Joint Reaction Forces', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k');
grid on;
set(gca, 'XColor', 'k', 'YColor', 'k');
legend('Hip Vertical Force', 'Knee Vertical Force', 'Ankle Vertical Force', ...
       'Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

% Subplot 2: Lateral Loads
subplot(2,1,2);
set(gca, 'XColor', 'k', 'YColor', 'k');
plot(time, data.Force_Hip_MediolateralForce); hold on;
plot(time, data.Force_Ankle_MedioLateralForce);
title('Lateral Joint Reaction Forces', 'Color', 'k');
ylabel('Force (N)', 'Color', 'k'); 
xlabel('Time (s)', 'Color', 'k');
grid on;
set(gca, 'XColor', 'k', 'YColor', 'k');
legend('Hip Lateral Force', 'Ankle Lateral Force', ...
       'Location', 'best', 'Color', 'w', 'TextColor', 'k', 'Box', 'on');

set(fig2, 'InvertHardcopy', 'off');
fprintf("Graphs Plotted!\n");