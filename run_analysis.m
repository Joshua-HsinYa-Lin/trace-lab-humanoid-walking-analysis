%% Initialization and Configuration
% Setup file paths
inversefile = 'GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_InverseDynamicStudy.anydata.h5';
markerfile = 'GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_MarkerTracking.anydata.h5';
output_csv = 'interaction_joint_data.csv';

% Setup folders to extract
base_path = '/Output/_Main/HumanModel/BodyModel/SelectedOutput/Right/Leg/';
folders_to_scan = {'JointMomentMeasure', 'JointReactionForce'};
target_joints = {'Hip', 'Knee', 'Ankle'};

%% Check for File existence
inverse_presented = exist(inversefile, 'file');
marker_presented = exist(markerfile, 'file');
if((inverse_presented ~= 2) || (marker_presented ~= 2))
    error('One or both files do not exist. Please check the file paths.');
else 
    fprintf("Start Data Extraction");
end

%% Get time vector
try
    time_data = h5read(inversefile, '/Output/Abscissa/t');
    % Initialize the results table with Time
    ResultsTable = table(time_data, 'VariableNames', {'Time'});
    disp(['Time vector loaded (' num2str(length(time_data)) ' frames)']);
catch
    error('Could not find Time vector at /Output/Abscissa/t');
end

%% Looping through folders
for f = 1:length(folders_to_scan)
    current_folder = [base_path, folders_to_scan{f}];
    
    try
        info = h5info(inversefile, current_folder);

        % Loop through each Dataset
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
            %Grab target data
            if is_relevant
                full_path = [current_folder, '/', var_name];
                data = h5read(inversefile, full_path);

                if contains(folders_to_scan{f}, 'Moment')
                    col_name = ['Moment_', var_name];
                else
                    col_name = ['Force_', var_name];
                end
                col_name = matlab.lang.makeValidName(col_name);
                
                % Add to Table
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
        disp(ME.message);
    end
end

%% Export the table to a .csv file
fprintf('Writing to %s ...\n', output_csv);
writetable(ResultsTable, output_csv);
fprintf('Done writing!\n');

%% Code for testing (currently not in use but might be helpful)
%{
%% Display internal file structures
%h5disp(inversefile, '/', 'min');

%% Load the Files into Matlab
folder_map = h5info(inversefile);

%% Search for data
for i = 1:length(folder_map.Groups)
    find_force_data(folder_map.Groups(i), '');
end
fprintf("Search Complete!\n");
%}