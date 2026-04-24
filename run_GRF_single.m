function run_GRF_single(inversefile, csv_dir, single_grf_paths)
output_csv_grf = fullfile(csv_dir, 'grf_data_single.csv');
fprintf('Start Ground Reaction Force Extraction (Single)\n');

possible_time_paths = {'/Output/Abscissa/t', '/Output/t', '/Output/Model/t'};
time_data = [];
for i = 1:length(possible_time_paths)
    if verify_h5_path(inversefile, possible_time_paths{i})
        time_data = h5read(inversefile, possible_time_paths{i});
        break; 
    end
end

if isempty(time_data)
    fprintf('Extraction Skipped: Could not find Time vector.\n');
    return;
end

ResultsTable = table(time_data(:), 'VariableNames', {'Time'});

fields = fieldnames(single_grf_paths);
for i = 1:length(fields)
    plate = fields{i};
    paths_to_try = single_grf_paths.(plate);
    
    if ~iscell(paths_to_try)
        paths_to_try = {paths_to_try};
    end
    
    for k = 1:length(paths_to_try)
        target_path = paths_to_try{k};
        
        if verify_h5_path(inversefile, target_path)
            try
                f_raw = h5read(inversefile, target_path);
                if ndims(f_raw) == 3
                    f_raw = reshape(f_raw, size(f_raw, 1), [])';
                end
                
                if size(f_raw, 1) == length(time_data) || size(f_raw, 2) == length(time_data)
                    if size(f_raw, 1) == 3
                        ResultsTable.(sprintf('%s_Fx', plate)) = f_raw(1, :)';
                        ResultsTable.(sprintf('%s_Fy', plate)) = f_raw(3, :)'; 
                        ResultsTable.(sprintf('%s_Fz', plate)) = f_raw(2, :)'; 
                    else
                        ResultsTable.(sprintf('%s_Fx', plate)) = f_raw(:, 1);
                        ResultsTable.(sprintf('%s_Fy', plate)) = f_raw(:, 3); 
                        ResultsTable.(sprintf('%s_Fz', plate)) = f_raw(:, 2); 
                    end
                    fprintf('   Saved %s data (matrix)\n', plate);
                    break;
                end
            catch
            end
        end
        
        path_x = fullfile(target_path, 'Fx');
        path_y = fullfile(target_path, 'Fy');
        path_z = fullfile(target_path, 'Fz');
        
        if verify_h5_path(inversefile, path_x)
            data_x = h5read(inversefile, path_x);
            data_y = h5read(inversefile, path_y);
            data_z = h5read(inversefile, path_z);
            
            ResultsTable.(sprintf('%s_Fx', plate)) = data_x(:);
            ResultsTable.(sprintf('%s_Fy', plate)) = data_y(:);
            ResultsTable.(sprintf('%s_Fz', plate)) = data_z(:);
            fprintf('   Saved %s data (Separate XYZ)\n', plate);
            break;
        end
    end
end

if width(ResultsTable) > 1
    writetable(ResultsTable, output_csv_grf);
    fprintf('GRF Single Extraction Complete -> %s\n', output_csv_grf);
end
end