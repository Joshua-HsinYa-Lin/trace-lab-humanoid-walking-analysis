%% Initialization and Configuration
clear;
clc;

% Setup file paths
inversefile = 'GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_InverseDynamicStudy.anydata.h5';
output_csv_right = 'data_csv/interaction_hand_data.csv';
output_csv_left  = 'data_csv/interaction_hand_data_left.csv';
% Setup extraction parameters
sides = {'Right', 'Left'};
folders_to_scan = {'JointMomentMeasure', 'JointReactionForce'};
target_joints = {'Wrist', 'Elbow', 'Shoulder'};

%% Check for File existence
if exist(inversefile, 'file') ~= 2
    error('File not found. Please check the file path.');
end
fprintf('Start Upper Body Data Extraction\n');

%% Get time vector (Robust Search)
possible_time_paths = {'/Output/Abscissa/t', '/Output/t', '/Output/Model/t'};
time_data = [];
time_path_found = '';

for i = 1:length(possible_time_paths)
    try
        time_data = h5read(inversefile, possible_time_paths{i});
        time_path_found = possible_time_paths{i};
        fprintf('Found Time vector at: %s (%d frames)\n', time_path_found, length(time_data));
        break; 
    catch
    end
end

if isempty(time_data)
    error('Could not find Time vector in standard paths.');
end

%% Looping through Sides (Right and Left)
for s = 1:length(sides)
    current_side = sides{s};
    fprintf('\nProcessing %s ShoulderArm\n', current_side);
    
    % Dynamic base path for the Arm (Updated to ShoulderArm)
    base_path = sprintf('/Output/_Main/HumanModel/BodyModel/SelectedOutput/%s/ShoulderArm/', current_side);
    
    % Initialize the results table
    ResultsTable = table(time_data, 'VariableNames', {'Time'});
    
    if strcmp(current_side, 'Right')
        current_output_csv = output_csv_right;
    else
        current_output_csv = output_csv_left;
    end

    % Looping through folders (Moments and Forces)
    for f = 1:length(folders_to_scan)
        current_folder = [base_path, folders_to_scan{f}];
        
        try
            info = h5info(inversefile, current_folder);
            
            for i = 1:length(info.Datasets)
                var_name = info.Datasets(i).Name;
                
                is_relevant = false;
                for k = 1:length(target_joints)
                    if contains(var_name, target_joints{k}, 'IgnoreCase', true)
                        is_relevant = true;
                        break;
                    end
                end
                
                if is_relevant
                    full_path = [current_folder, '/', var_name];
                    data = h5read(inversefile, full_path);
                    
                    if contains(folders_to_scan{f}, 'Moment')
                        col_name = ['Moment_', var_name];
                    else
                        col_name = ['Force_', var_name];
                    end
                    col_name = matlab.lang.makeValidName(col_name);
                    
                    if length(data) == length(time_data)
                        ResultsTable.(col_name) = data;
                        fprintf('   Saved: %s\n', col_name);
                    else
                        fprintf('   Skipped %s: Size mismatch\n', col_name);
                    end
                end
            end
            
        catch ME
            fprintf('Could not process folder: %s\n', current_folder);
            fprintf('   Error: %s\n', ME.message);
        end
    end
    
    %% Export the table
    fprintf('Writing %s arm data to %s\n', current_side, current_output_csv);
    writetable(ResultsTable, current_output_csv);
    fprintf('Done writing %s arm\n', current_side);
end

fprintf('\nUpper Body Data Extraction Complete\n');