%% Initialization and Configuration
clear;
clc;

% Setup file paths
inversefile = 'GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_InverseDynamicStudy.anydata.h5';
output_csv_right = 'data_csv/interaction_angles_right.csv';
output_csv_left  = 'data_csv/interaction_angles_left.csv';

% Setup extraction parameters
sides = {'Right', 'Left'};

% Target joints in the Interface folder
target_joints = {'HipFlexion', 'HipAbduction', 'KneeFlexion', 'AnklePlantarFlexion', ...
                 'ElbowFlexion', 'WristFlexion'};

%% Check for File existence
if exist(inversefile, 'file') ~= 2
    error('File not found. Please check the file path.');
end
fprintf('Start Joint Angle Data Extraction\n');

%% Get time vector
possible_time_paths = {'/Output/Abscissa/t', '/Output/t', '/Output/Model/t'};
time_data = [];

for i = 1:length(possible_time_paths)
    try
        time_data = h5read(inversefile, possible_time_paths{i});
        fprintf('Found Time vector (%d frames)\n', length(time_data));
        break; 
    catch
    end
end

if isempty(time_data)
    error('Could not find Time vector.');
end

%% Looping through Sides (Right and Left)
for s = 1:length(sides)
    current_side = sides{s};
    fprintf('\nProcessing %s Side Kinematics\n', current_side);
    
    % Initialize results table
    ResultsTable = table(time_data, 'VariableNames', {'Time'});
    
    if strcmp(current_side, 'Right')
        current_output_csv = output_csv_right;
    else
        current_output_csv = output_csv_left;
    end

    % Base path for Interface kinematics
    base_path = sprintf('/Output/_Main/HumanModel/BodyModel/Interface/%s/', current_side);
    
    % Loop through target joints
    for j = 1:length(target_joints)
        current_joint = target_joints{j};
        full_path = [base_path, current_joint, '/Pos'];
        
        try
            % Read data (returns radians)
            data_rad = h5read(inversefile, full_path);
            data_deg = data_rad * (180 / pi);
            data_deg = data_deg(:);
            col_name = ['Angle_', current_joint];
            col_name = matlab.lang.makeValidName(col_name);
            
            if length(data_deg) == length(time_data)
                ResultsTable.(col_name) = data_deg;
                fprintf('Saved: %s (Converted to Degrees)\n', col_name);
            else
                fprintf('Skipped %s: Size mismatch\n', col_name);
            end
            
        catch
            fprintf('Skipped %s: Path not found (%s)\n', current_joint, full_path);
        end
    end
    
    %% Export the table
    fprintf('Writing %s angle data to %s\n', current_side, current_output_csv);
    writetable(ResultsTable, current_output_csv);
end

fprintf('\nJoint Angle Extraction Complete\n');