function write_report(filepath, report_title, force_names, stats_cell, units)
    % stats_cell: cell array containing matrices. 
    % Matrix size determines dimensions (3x5 for XYZ, 1x5 for 1D)
    % Columns: [mean, max_pos, t_max_pos, max_neg, t_max_neg]
    
    [report_dir, ~, ~] = fileparts(filepath);
    if ~exist(report_dir, 'dir')
        mkdir(report_dir);
    end
    
    fptr = fopen(filepath, 'w');
    if fptr == -1
        fprintf('Failed to open report file: %s\n', filepath);
        return;
    end
    
    fprintf(fptr, '%s\n\n', report_title);
    
    for i = 1:length(force_names)
        data_mat = stats_cell{i};
        rows = size(data_mat, 1);
        
        if rows == 3
            fprintf(fptr, '%s Force Report (X, Y, Z)\n', force_names{i});
            dirs = {'X', 'Y', 'Z'};
            for d = 1:3
                fprintf(fptr, '  Direction %s:\n', dirs{d});
                fprintf(fptr, '    Mean: %8.2f %s\n', data_mat(d, 1), units{i});
                fprintf(fptr, '    Max Pos: %8.2f %s (t=%.2fs)\n', data_mat(d, 2), units{i}, data_mat(d, 3));
                fprintf(fptr, '    Max Neg: %8.2f %s (t=%.2fs)\n', data_mat(d, 4), units{i}, data_mat(d, 5));
            end
        else
            fprintf(fptr, '%s Force Report\n', force_names{i});
            fprintf(fptr, '  Mean: %8.2f %s\n', data_mat(1, 1), units{i});
            fprintf(fptr, '  Max Pos: %8.2f %s (t=%.2fs)\n', data_mat(1, 2), units{i}, data_mat(1, 3));
            fprintf(fptr, '  Max Neg: %8.2f %s (t=%.2fs)\n', data_mat(1, 4), units{i}, data_mat(1, 5));
        end
        fprintf(fptr, '\n');
    end
    
    fclose(fptr);
    fprintf('Report successfully written to: %s\n', filepath);
end