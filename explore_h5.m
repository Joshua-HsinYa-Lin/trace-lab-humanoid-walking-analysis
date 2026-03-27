function explore_h5(filename, base_path)
    if nargin < 2
        base_path = '/';
    end

    fprintf('Scanning HDF5 path: %s\n', base_path);
    fprintf('\n');

    try
        info = h5info(filename, base_path);
        
        fprintf('FOLDERS (Groups):\n');
        if isempty(info.Groups)
            fprintf('  [None found]\n');
        else
            for i = 1:length(info.Groups)
                split_path = strsplit(info.Groups(i).Name, '/');
                folder_name = split_path{end};
                fprintf('%s/\n', folder_name);
            end
        end
        
        fprintf('\n');
        
        fprintf('DATA VARIABLES (Datasets):\n');
        if isempty(info.Datasets)
            fprintf('  [None found]\n');
        else
            for j = 1:length(info.Datasets)
                fprintf('%s\n', info.Datasets(j).Name);
            end
        end
        
        fprintf('\n');
        fprintf('Scan Complete.\n');
        
    catch ME
        fprintf('Error: Could not read the specified path.\n');
        fprintf('System message: %s\n', ME.message);
    end
end