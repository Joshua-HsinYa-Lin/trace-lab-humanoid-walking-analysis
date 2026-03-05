clear;
clc;

inversefile = 'GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_InverseDynamicStudy.anydata.h5';
output_csv = 'data_csv/grf_data.csv';

fprintf('Start Ground Reaction Force Extraction\n');

possible_time_paths = {'/Output/Abscissa/t', '/Output/t', '/Output/Model/t'};
time_data = [];

for i = 1:length(possible_time_paths)
try
time_data = h5read(inversefile, possible_time_paths{i});
fprintf('Found Time vector\n');
break; 
catch
end
end

if isempty(time_data)
error('Could not find Time vector.');
end

time_data = time_data(:);
ResultsTable = table(time_data, 'VariableNames', {'Time'});

base_path_right = '/Output/_Main/EnvironmentModel/ForcePlates/GRF_Prediction_Right/';
base_path_left = '/Output/_Main/EnvironmentModel/ForcePlates/GRF_Prediction_Left/';

try
ResultsTable.Right_Fx = squeeze(h5read(inversefile, [base_path_right, 'Fx']));
ResultsTable.Right_Fy = squeeze(h5read(inversefile, [base_path_right, 'Fy']));
ResultsTable.Right_Fz = squeeze(h5read(inversefile, [base_path_right, 'Fz']));
ResultsTable.Right_Fx = ResultsTable.Right_Fx(:);
ResultsTable.Right_Fy = ResultsTable.Right_Fy(:);
ResultsTable.Right_Fz = ResultsTable.Right_Fz(:);
fprintf('Saved Right GRF data\n');
catch ME
fprintf('Error reading Right GRF: %s\n', ME.message);
end

try
ResultsTable.Left_Fx = squeeze(h5read(inversefile, [base_path_left, 'Fx']));
ResultsTable.Left_Fy = squeeze(h5read(inversefile, [base_path_left, 'Fy']));
ResultsTable.Left_Fz = squeeze(h5read(inversefile, [base_path_left, 'Fz']));
ResultsTable.Left_Fx = ResultsTable.Left_Fx(:);
ResultsTable.Left_Fy = ResultsTable.Left_Fy(:);
ResultsTable.Left_Fz = ResultsTable.Left_Fz(:);
fprintf('Saved Left GRF data\n');
catch ME
fprintf('Error reading Left GRF: %s\n', ME.message);
end

fprintf('Writing GRF data to %s\n', output_csv);
writetable(ResultsTable, output_csv);
fprintf('GRF Data Extraction Complete\n');