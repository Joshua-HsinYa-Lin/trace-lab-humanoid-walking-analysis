function run_GRF(inversefile, output_csv)

fprintf('Start Ground Reaction Force Extraction (Assisted)\n');

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
    error('Could not find Time vector in %s.', inversefile);
end

ResultsTable = table(time_data(:), 'VariableNames', {'Time'});

% Point directly to the Fout datasets
plate1_path = '/Output/_Main/EnvironmentModel/ForcePlates/Plate1/ForcePlate/Force/Fout';
plate2_path = '/Output/_Main/EnvironmentModel/ForcePlates/Plate2/ForcePlate/Force/Fout';

try
    % Read the entire 3xN matrix at once
    f1_raw = h5read(inversefile, plate1_path);
    
    % Separate the rows into respective columns (Row 1=X, Row 2=Z, Row 3=Y)
    ResultsTable.Right_Fx = f1_raw(1, :)';
    ResultsTable.Right_Fy = f1_raw(3, :)'; 
    ResultsTable.Right_Fz = f1_raw(2, :)'; 
    fprintf('   Saved Plate 1 data as Right Leg\n');
catch ME
    fprintf('   Plate 1 Extraction Failed: %s\n', ME.message);
end

try
    % Read the entire 3xN matrix at once
    f2_raw = h5read(inversefile, plate2_path);
    
    % Separate the rows into respective columns
    ResultsTable.Left_Fx = f2_raw(1, :)';
    ResultsTable.Left_Fy = f2_raw(3, :)';
    ResultsTable.Left_Fz = f2_raw(2, :)';
    fprintf('   Saved Plate 2 data as Left Leg\n');
catch ME
    fprintf('   Plate 2 Extraction Failed: %s\n', ME.message);
end

writetable(ResultsTable, output_csv);
fprintf('GRF Extraction Complete -> %s\n', output_csv);

end