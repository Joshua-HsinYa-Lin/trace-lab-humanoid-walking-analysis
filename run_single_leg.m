%% Initialization and Configuration
clear; 
clc;
% Setup file paths
inversefile = 'FullBody_IC_walk_01_InverseDynamicStudy.anydata.h5';
output_csv_right = 'data_csv/single_joint_data_right.csv';
output_csv_left  = 'data_csv/single_joint_data_left.csv';

% Setup folders to extract
sides = {'Right', 'Left'};
folders_to_scan = {'JointMomentMeasure', 'JointReactionForce'};
target_joints = {'Hip', 'Knee', 'Ankle'};

%% Check for File existence
inverse_presented = exist(inversefile, 'file');
if((inverse_presented ~= 2))
    error('One or both files do not exist. Please check the file paths.');
else 
    fprintf("Start Data Extraction");
end

%% Get time vector
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

%% Looping through Sides (Right and Left)
for s = 1:length(sides)
    current_side = sides{s};
    fprintf('\n--- Processing %s Leg ---\n', current_side);
    % Base path
    base_path = sprintf('/Output/_Main/HumanModel/BodyModel/SelectedOutput/%s/Leg/', current_side);    
    % Reinitialize result table
    ResultsTable = table(time_data, 'VariableNames', {'Time'});
    % Determine which CSV to save to
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
            % Loop through datasets
            for i = 1:length(info.Datasets)
                var_name = info.Datasets(i).Name;
                % Check if this variable name contains Hip, Knee, or Ankle
                is_relevant = false;
                for k = 1:length(target_joints)
                    if contains(var_name, target_joints{k}, 'IgnoreCase', true)
                        is_relevant = true;
                        break;
                    end
                end
                % Grab target data
                if is_relevant
                    full_path = [current_folder, '/', var_name];
                    data = h5read(inversefile, full_path);
                    if contains(folders_to_scan{f}, 'Moment')
                        col_name = ['Moment_', var_name];
                    else
                        col_name = ['Force_', var_name];
                    end
                    col_name = matlab.lang.makeValidName(col_name);
                    % Add to table
                    if length(data) == length(time_data)
                        ResultsTable.(col_name) = data;
                        fprintf('   Saved: %s\n', col_name);
                    else
                        fprintf('Skipping %s: Size mismatch (%d vs %d)\n', ...
                            col_name, length(data), length(time_data));
                    end
                end
            end
        catch ME
            fprintf('Could not process folder: %s\n', current_folder);
            fprintf('   Error: %s\n', ME.message);
        end
    end
    
    %% Export the table to the respective .csv file
    fprintf('Writing %s leg data to %s ...\n', current_side, current_output_csv);
    writetable(ResultsTable, current_output_csv);
    fprintf('Done writing %s leg!\n', current_side);
end

fprintf('\nAll Data Extraction Complete!\n');