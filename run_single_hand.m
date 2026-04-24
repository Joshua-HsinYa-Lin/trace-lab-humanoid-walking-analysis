function run_single_hand(inversefile, csv_dir, hand_paths)
output_csv_right = fullfile(csv_dir, 'single_hand_data_right.csv');
output_csv_left  = fullfile(csv_dir, 'single_hand_data_left.csv');

sides = {'Right', 'Left'};
folders_to_scan = {'JointMomentMeasure', 'JointReactionForce'};
target_joints = {'Wrist', 'Elbow', 'Shoulder'};

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
    fprintf('\nProcessing %s ShoulderArm\n', current_side);
    
    ResultsTable = table(time_data(:), 'VariableNames', {'Time'});
    
    if strcmp(current_side, 'Right')
        current_output_csv = output_csv_right;
    else
        current_output_csv = output_csv_left;
    end

    paths_to_try = hand_paths.(current_side);
    
    if ~iscell(paths_to_try)
        paths_to_try = {paths_to_try};
    end
    
    for bp = 1:length(paths_to_try)
        base_path = paths_to_try{bp};
        
        for f = 1:length(folders_to_scan)
            current_folder = [base_path, folders_to_scan{f}];
            
            if verify_h5_path(inversefile, current_folder)
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
                            data_raw = h5read(inversefile, full_path);
                            data = data_raw(:);
                            
                            if contains(folders_to_scan{f}, 'Moment')
                                col_name = ['Moment_', var_name];
                            else
                                col_name = ['Force_', var_name];
                            end
                            col_name = matlab.lang.makeValidName(col_name);
                            
                            if length(data) == length(time_data)
                                ResultsTable.(col_name) = data;
                                fprintf('   Saved: %s\n', col_name);
                            end
                        end
                    end
                catch
                end
            end
        end
    end
    
    if width(ResultsTable) > 1
        writetable(ResultsTable, current_output_csv);
        fprintf('Done writing %s arm\n', current_side);
    end
end

fprintf('\nUpper Body Data Extraction Complete\n');
end