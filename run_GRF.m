function run_GRF(inversefile, output_csv, plate_paths)
fprintf('Start Ground Reaction Force Extraction\n');

possible_time_paths = {'/Output/Abscissa/t', '/Output/t', '/Output/Model/t'};
time_data = [];

for i = 1:length(possible_time_paths)
    try
        time_data = h5read(inversefile, possible_time_paths{i});
        break; 
    catch
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
        
        try
            f_raw = h5read(inversefile, target_path);
            f_data = squeeze(f_raw);
            if size(f_data, 1) == 3
                f_data = f_data';
            end
            
            ResultsTable.(sprintf('%s_Fx', side)) = f_data(:, 1);
            ResultsTable.(sprintf('%s_Fy', side)) = f_data(:, 2); 
            ResultsTable.(sprintf('%s_Fz', side)) = f_data(:, 3); 
            fprintf('   Saved %s Forces from %s\n', side, target_path);
            
            m_path = strrep(target_path, 'Fout', 'Mout');
            try
                m_raw = h5read(inversefile, m_path);
                m_data = squeeze(m_raw);
                if size(m_data, 1) == 3
                    m_data = m_data';
                end
                ResultsTable.(sprintf('%s_Mx', side)) = m_data(:, 1);
                ResultsTable.(sprintf('%s_My', side)) = m_data(:, 2); 
                ResultsTable.(sprintf('%s_Mz', side)) = m_data(:, 3); 
                fprintf('   Saved %s Moments from %s\n', side, m_path);
            catch
            end
            
            extracted_successfully = true;
            break; 
            
        catch
            path_x = [target_path, 'Fx'];
            path_y = [target_path, 'Fy'];
            path_z = [target_path, 'Fz'];
            
            if ~endsWith(target_path, '/') 
                path_x = [target_path, '/Fx'];
                path_y = [target_path, '/Fy'];
                path_z = [target_path, '/Fz'];
            end
            
            try
                data_x = squeeze(h5read(inversefile, path_x));
                data_y = squeeze(h5read(inversefile, path_y));
                data_z = squeeze(h5read(inversefile, path_z));
                
                ResultsTable.(sprintf('%s_Fx', side)) = data_x(:);
                ResultsTable.(sprintf('%s_Fy', side)) = data_y(:);
                ResultsTable.(sprintf('%s_Fz', side)) = data_z(:);
                fprintf('   Saved %s Forces (Separate XYZ)\n', side);
                
                path_mx = strrep(path_x, 'Fx', 'Mx');
                path_my = strrep(path_y, 'Fy', 'My');
                path_mz = strrep(path_z, 'Fz', 'Mz');
                
                try
                    data_mx = squeeze(h5read(inversefile, path_mx));
                    data_my = squeeze(h5read(inversefile, path_my));
                    data_mz = squeeze(h5read(inversefile, path_mz));
                    
                    ResultsTable.(sprintf('%s_Mx', side)) = data_mx(:);
                    ResultsTable.(sprintf('%s_My', side)) = data_my(:);
                    ResultsTable.(sprintf('%s_Mz', side)) = data_mz(:);
                    fprintf('   Saved %s Moments (Separate XYZ)\n', side);
                catch
                end
                
                extracted_successfully = true;
                break; 
            catch
            end
        end
    end
    
    if ~extracted_successfully
        fprintf('   Warning: Could not find %s plate data.\n', side);
    end
end

if width(ResultsTable) > 1
    writetable(ResultsTable, output_csv);
    fprintf('GRF Extraction Complete -> %s\n', output_csv);
end
end