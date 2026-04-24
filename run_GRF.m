function run_GRF(inversefile, output_csv, plate_paths)

fprintf('Start Ground Reaction Force Extraction (Assisted)\n');

possible_time_paths = {'/Output/Abscissa/t', '/Output/t', '/Output/Model/t'};
time_data = [];
for i = 1:length(possible_time_paths)
    if verify_h5_path(inversefile, possible_time_paths{i})
        time_data = h5read(inversefile, possible_time_paths{i});
        break; 
    end
end

if isempty(time_data)
    fprintf('Extraction Skipped: Could not find Time vector in %s.\n', inversefile);
    return;
end

ResultsTable = table(time_data(:), 'VariableNames', {'Time'});

fields = fieldnames(plate_paths);
for i = 1:length(fields)
    side = fields{i};
    paths_to_try = plate_paths.(side);
    
    if ~iscell(paths_to_try)
        paths_to_try = {paths_to_try};
    end
    
    extracted_successfully = false;
    
    for k = 1:length(paths_to_try)
        target_path = paths_to_try{k};
        
        if verify_h5_path(inversefile, target_path)
            try
                f_raw = h5read(inversefile, target_path);
                ResultsTable.(sprintf('%s_Fx', side)) = f_raw(1, :)';
                ResultsTable.(sprintf('%s_Fy', side)) = f_raw(3, :)'; 
                ResultsTable.(sprintf('%s_Fz', side)) = f_raw(2, :)'; 
                fprintf('   Saved %s data from %s\n', side, target_path);
                extracted_successfully = true;
                break; 
            catch
            end
        end
        
        path_x = [target_path, 'Fx'];
        path_y = [target_path, 'Fy'];
        path_z = [target_path, 'Fz'];
        
        if ~endsWith(target_path, '/') && ~verify_h5_path(inversefile, path_x)
            path_x = [target_path, '/Fx'];
            path_y = [target_path, '/Fy'];
            path_z = [target_path, '/Fz'];
        end

        if verify_h5_path(inversefile, path_x)
            ResultsTable.(sprintf('%s_Fx', side)) = squeeze(h5read(inversefile, path_x));
            ResultsTable.(sprintf('%s_Fy', side)) = squeeze(h5read(inversefile, path_y));
            ResultsTable.(sprintf('%s_Fz', side)) = squeeze(h5read(inversefile, path_z));
            
            ResultsTable.(sprintf('%s_Fx', side)) = ResultsTable.(sprintf('%s_Fx', side))(:);
            ResultsTable.(sprintf('%s_Fy', side)) = ResultsTable.(sprintf('%s_Fy', side))(:);
            ResultsTable.(sprintf('%s_Fz', side)) = ResultsTable.(sprintf('%s_Fz', side))(:);
            
            fprintf('   Saved %s data from %s\n', side, target_path);
            extracted_successfully = true;
            break; 
        end
    end
    
    if ~extracted_successfully
        fprintf('   Warning: Could not find %s plate data.\n', side);
    end
end

if width(ResultsTable) > 1
    window_size = 15; 
    ResultsTable{:, 2:end} = smoothdata(ResultsTable{:, 2:end}, 'sgolay', window_size);
end

writetable(ResultsTable, output_csv);
fprintf('GRF Extraction Complete -> %s\n', output_csv);

end