function run_follower(inversefile, csv_dir)
output_csv = fullfile(csv_dir, 'follower_hand_data.csv');

if exist(inversefile, 'file') ~= 2
    error('File not found. Please check the file path.');
end
fprintf('Start Follower Hand Data Extraction\n');

possible_time_paths = {'/Output/Abscissa/t', '/Output/t', '/Output/Model/t'};
time_data = [];

for i = 1:length(possible_time_paths)
    try
        time_data = h5read(inversefile, possible_time_paths{i});
        fprintf('Found Time vector (%d frames)\n', length(time_data));
        break; 
    catch
    end
end

if isempty(time_data)
    error('Could not find Time vector.');
end
ResultsTable = table(time_data, 'VariableNames', {'Time'});

fout_path = '/Output/FollowerHand/HandOfGod/Fout';
try
    fout_data = h5read(inversefile, fout_path)';
    if size(fout_data, 1) == length(time_data)
        ResultsTable.Fout_X = fout_data(:, 1);
        ResultsTable.Fout_Y = fout_data(:, 2);
        ResultsTable.Fout_Z = fout_data(:, 3);
        fprintf('Saved: Fout Forces (X, Y, Z)\n');
    else
        fprintf('Skipped Fout Forces: Size mismatch\n');
    end
catch ME
    fprintf('Error reading Fout Forces: %s\n', ME.message);
end

force_path = '/Output/FollowerHand/HandOfGod/RefFrameOutput/F';
try
    force_data_raw = h5read(inversefile, force_path);
    force_data = squeeze(force_data_raw(:, 1, :)); 
    force_data = force_data';
    if size(force_data, 1) == length(time_data)
        ResultsTable.LocalForce_X = force_data(:, 1);
        ResultsTable.LocalForce_Y = force_data(:, 2);
        ResultsTable.LocalForce_Z = force_data(:, 3);
        fprintf('Saved: Local Follower Forces (X, Y, Z)\n');
    else
        fprintf('Skipped Local Follower Forces: Size mismatch\n');
    end
catch ME
    fprintf('Error reading Local Follower Forces: %s\n', ME.message);
end

moment_path = '/Output/FollowerHand/HandOfGod/RefFrameOutput/M';
try
    moment_data_raw = h5read(inversefile, moment_path);
    moment_data = squeeze(moment_data_raw(:, 1, :));
    moment_data = moment_data';
    if size(moment_data, 1) == length(time_data)
        ResultsTable.LocalMoment_X = moment_data(:, 1);
        ResultsTable.LocalMoment_Y = moment_data(:, 2);
        ResultsTable.LocalMoment_Z = moment_data(:, 3);
        fprintf('Saved: Local Follower Moments (X, Y, Z)\n');
    else
        fprintf('Skipped Local Follower Moments: Size mismatch\n');
    end
catch ME
    fprintf('Error reading Local Follower Moments: %s\n', ME.message);
end

fprintf('Writing Follower hand data to %s\n', output_csv);
writetable(ResultsTable, output_csv);
fprintf('\nFollower Data Extraction Complete\n');
end