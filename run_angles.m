function run_angles(inversefile, csv_dir, angle_paths)
output_csv_right = fullfile(csv_dir, 'interaction_angles_right.csv');
output_csv_left  = fullfile(csv_dir, 'interaction_angles_left.csv');

sides = {'Right', 'Left'};
target_joints = {'HipFlexion', 'HipAbduction', 'KneeFlexion', 'AnklePlantarFlexion', 'ElbowFlexion', 'WristFlexion'};

possible_time_paths = {'/Output/Abscissa/t', '/Output/t', '/Output/Model/t'};
time_data = [];

for i = 1:length(possible_time_paths)
    if verify_h5_path(inversefile, possible_time_paths{i})
        time_data = h5read(inversefile, possible_time_paths{i});
        fprintf('Found Time vector (%d frames)\n', length(time_data));
        break; 
    end
end

if isempty(time_data)
    fprintf('Extraction Skipped: Could not find Time vector.\n');
    return;
end

for s = 1:length(sides)
    current_side = sides{s};
    fprintf('\nProcessing %s Side Kinematics\n', current_side);
    
    ResultsTable = table(time_data(:), 'VariableNames', {'Time'});
    
    if strcmp(current_side, 'Right')
        current_output_csv = output_csv_right;
    else
        current_output_csv = output_csv_left;
    end

    paths_to_try = angle_paths.(current_side);
    
    if ~iscell(paths_to_try)
        paths_to_try = {paths_to_try};
    end
  
    for bp = 1:length(paths_to_try)
        base_path = paths_to_try{bp};
        
        for j = 1:length(target_joints)
            current_joint = target_joints{j};
            full_path = [base_path, current_joint, '/Pos'];
            
            if verify_h5_path(inversefile, full_path)
                data_rad = h5read(inversefile, full_path);
                data_deg = data_rad(:) * (180 / pi);
                col_name = ['Angle_', current_joint];
                col_name = matlab.lang.makeValidName(col_name);
                
                if length(data_deg) == length(time_data)
                    ResultsTable.(col_name) = data_deg;
                    fprintf('   Saved: %s\n', col_name);
                end
            end
        end
    end
    
    if width(ResultsTable) > 1
        writetable(ResultsTable, current_output_csv);
        fprintf('Done writing %s angle data\n', current_side);
    end
end

fprintf('\nJoint Angle Extraction Complete\n');
end