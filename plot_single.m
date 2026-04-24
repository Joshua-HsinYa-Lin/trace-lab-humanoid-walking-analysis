function plot_single(csv_dir)
f_single_arm = fullfile(csv_dir, 'single_hand_data_right.csv');
f_single_leg = fullfile(csv_dir, 'single_joint_data_right.csv');
f_int_arm = fullfile(csv_dir, 'interaction_hand_data_right.csv');
f_int_leg = fullfile(csv_dir, 'interaction_joint_data_right.csv');

if exist(f_single_arm, 'file') ~= 2 || exist(f_single_leg, 'file') ~= 2
    fprintf('Missing single data files. Plotting aborted.\n');
    return;
end

data_single_arm = readtable(f_single_arm);
data_single_leg = readtable(f_single_leg);
data_int_arm = readtable(f_int_arm);
data_int_leg = readtable(f_int_leg);

set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesColor', 'w');
set(0, 'DefaultAxesXColor', 'k');
set(0, 'DefaultAxesYColor', 'k');
set(0, 'DefaultAxesZColor', 'k');
set(0, 'DefaultTextColor', 'k');
set(0, 'DefaultLineLineWidth', 1.5);

time_single = data_single_arm.Time;
time_int = data_int_arm.Time;

s_arm_dv = get_col(data_single_arm, {'Force_WristRadioCarpal_DorsoVolarForce'});
i_arm_dv = get_col(data_int_arm, {'Force_WristRadioCarpal_DorsoVolarForce'});
s_arm_pd = get_col(data_single_arm, {'Force_WristRadioCarpal_ProximoDistalForce'});
i_arm_pd = get_col(data_int_arm, {'Force_WristRadioCarpal_ProximoDistalForce'});

s_leg_ap = get_col(data_single_leg, {'Force_Ankle_AnteroPosteriorForce'});
i_leg_ap = get_col(data_int_leg, {'Force_Ankle_AnteroPosteriorForce'});
s_leg_pd = get_col(data_single_leg, {'Force_Ankle_ProximoDistalForce'});
i_leg_pd = get_col(data_int_leg, {'Force_Ankle_ProximoDistalForce'});

figure('Color', 'w', 'Name', 'Single vs Interaction Forces', 'Position', [100 100 1200 800]);
sgtitle('Helper vs Single Person Walking Muscle Forces', 'Color', 'k');

subplot(2,2,1); 
hold on;
if ~isempty(s_arm_dv)
    plot(time_single, s_arm_dv, 'Color', '#0072BD', 'DisplayName', 'Single Person Arm Push Pull');
end
if ~isempty(i_arm_dv)
    plot(time_int, i_arm_dv, 'Color', '#D95319', 'DisplayName', 'Interaction Helper Arm Push Pull');
end
title('Arm Forward / Backward Force (x-axis)'); 
xlabel('Time (s)'); 
ylabel('Force (N)'); 
grid on;

subplot(2,2,2); 
hold on;
if ~isempty(s_arm_pd)
    plot(time_single, s_arm_pd, 'Color', '#0072BD', 'DisplayName', 'Single Person Arm Vertical');
end
if ~isempty(i_arm_pd)
    plot(time_int, i_arm_pd, 'Color', '#D95319', 'DisplayName', 'Interaction Helper Arm Vertical');
end
title('Arm Vertical Weight Force (z-axis)'); 
xlabel('Time (s)'); 
ylabel('Force (N)'); 
grid on;

subplot(2,2,3); 
hold on;
if ~isempty(s_leg_ap)
    plot(time_single, s_leg_ap, 'Color', '#77AC30', 'DisplayName', 'Single Person Leg Forward / Backward');
end
if ~isempty(i_leg_ap)
    plot(time_int, i_leg_ap, 'Color', '#7E2F8E', 'DisplayName', 'Interaction Leg Forward / Backward');
end
title('Leg Ankle Forward / Backward Force (x-axis)'); 
xlabel('Time (s)'); 
ylabel('Force (N)'); 
grid on;

subplot(2,2,4); 
hold on;
if ~isempty(s_leg_pd)
    plot(time_single, s_leg_pd, 'Color', '#77AC30', 'DisplayName', 'Single Person Leg Vertical Load');
end
if ~isempty(i_leg_pd)
    plot(time_int, i_leg_pd, 'Color', '#7E2F8E', 'DisplayName', 'Interaction Leg Vertical Load');
end
title('Leg Ankle Vertical Weight Force (z-axis)'); 
xlabel('Time (s)'); 
ylabel('Force (N)'); 
grid on;

fprintf('Single vs Interaction plotting complete\n');
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