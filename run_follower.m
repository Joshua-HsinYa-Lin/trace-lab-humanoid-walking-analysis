function run_follower(inversefile, csv_dir, follower_paths)
output_csv = fullfile(csv_dir, 'follower_hand_data.csv');

file_inv_exists = exist(inversefile, 'file');
if file_inv_exists ~= 2
    fprintf('File not found: %s\n', inversefile);
    return;
end

fprintf('Start Follower Hand Data Extraction\n');

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

ResultsTable = table(time_data(:), 'VariableNames', {'Time'});
fields = fieldnames(follower_paths);

for i = 1:length(fields)
    var_target = fields{i};
    paths_to_try = follower_paths.(var_target);
    
    if ~iscell(paths_to_try)
        paths_to_try = {paths_to_try};
    end
    
    for k = 1:length(paths_to_try)
        target_path = paths_to_try{k};
        
        if verify_h5_path(inversefile, target_path)
            data_raw = h5read(inversefile, target_path);
            
            ndims_data = ndims(data_raw);
            if ndims_data == 3
                data = reshape(data_raw, size(data_raw, 1), [])';
            end
            if ndims_data ~= 3
                data = data_raw';
            end
            
            if strcmp(var_target, 'Fout')
                prefix = 'Fout';
            end
            if strcmp(var_target, 'F')
                prefix = 'LocalForce';
            end
            if strcmp(var_target, 'M')
                prefix = 'LocalMoment';
            end
            
            size_data_1 = size(data, 1);
            len_time = length(time_data);
            if size_data_1 == len_time
                ResultsTable.(sprintf('%s_X', prefix)) = data(:, 1);
                ResultsTable.(sprintf('%s_Y', prefix)) = data(:, 2);
                ResultsTable.(sprintf('%s_Z', prefix)) = data(:, 3);
                fprintf('   Saved: %s from %s\n', prefix, target_path);
                break;
            end
        end
    end
end

tab_width = width(ResultsTable);
if tab_width > 1
    writetable(ResultsTable, output_csv);
    fprintf('Follower hand data written to %s\n', output_csv);
end
if tab_width <= 1
    fprintf('No Follower data extracted.\n');
end

fprintf('\nFollower Data Extraction Complete\n');
end