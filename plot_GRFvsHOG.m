function plot_GRFvsHOG(csv_dir, report_dir)
grf_file = fullfile(csv_dir, 'grf_data.csv');
f_file = fullfile(csv_dir, 'follower_hand_data.csv');
report_file = fullfile(report_dir, 'statistical_dependence.txt');

if exist(grf_file, 'file') ~= 2 || exist(f_file, 'file') ~= 2
    fprintf('Missing files for GRFvsHOG analysis.\n');
    return;
end

data_grf = readtable(grf_file);
data_f = readtable(f_file);

set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesColor', 'w');
set(0, 'DefaultAxesXColor', 'k');
set(0, 'DefaultAxesYColor', 'k');
set(0, 'DefaultAxesZColor', 'k');
set(0, 'DefaultTextColor', 'k');
set(0, 'DefaultLineLineWidth', 1.5);

time = data_grf.Time;
rfz = get_col(data_grf, {'Right_Fz'});
lfz = get_col(data_grf, {'Left_Fz'});
fz_HOG = get_col(data_f, {'Fout_Z'});

figure('Color', 'w', 'Name', 'GRF Prediction vs HandOfGod Compensation', 'Position', [100 100 1000 800]);

subplot(2,1,1); 
hold on;
if ~isempty(rfz)
    plot(time, rfz, 'Color', '#0072BD', 'DisplayName', 'Right Foot Vertical GRF');
end
if ~isempty(lfz)
    plot(time, lfz, 'Color', '#77AC30', 'DisplayName', 'Left Foot Vertical GRF');
end
title('Ground Reaction Force Prediction Leg Vertical Load (z-axis)'); 
ylabel('Force (N)'); 
grid on;

subplot(2,1,2); 
hold on;
if ~isempty(fz_HOG)
    plot(time, fz_HOG, 'Color', '#D95319', 'DisplayName', 'HandOfGod Vertical Compensation');
end
title('HandOfGod Vertical Weight Force (z-axis)'); 
xlabel('Time (s)'); 
ylabel('Force (N)'); 
grid on;

fprintf('GRF vs HandOfGod plotting complete\n');

if ~isempty(rfz) 
    if ~isempty(fz_HOG)
        grf_R = rfz;
        hog_Z = fz_HOG;
        
        R_mat_R = corrcoef(grf_R, hog_Z);
        r_R = R_mat_R(1,2);
        r2_R = r_R^2;
        cos_sim_R = dot(grf_R, hog_Z) / (norm(grf_R) * norm(hog_Z));
        
        r_tot = NaN; 
        r2_tot = NaN; 
        cos_sim_tot = NaN;
        if ~isempty(lfz)
            grf_tot = rfz + lfz;
            R_mat_tot = corrcoef(grf_tot, hog_Z);
            r_tot = R_mat_tot(1,2);
            r2_tot = r_tot^2;
            cos_sim_tot = dot(grf_tot, hog_Z) / (norm(grf_tot) * norm(hog_Z));
        end

        fptr = fopen(report_file, 'w');
        fprintf(fptr, 'STATISTICAL DEPENDENCE\n\n');
        fprintf(fptr, 'RIGHT LEG GRF vs HAND OF GOD\n');
        fprintf(fptr, 'Correlation (r):      %6.4f\n', r_R);
        fprintf(fptr, 'R squared:            %6.4f\n', r2_R);
        fprintf(fptr, 'Cosine Similarity:    %6.4f\n\n', cos_sim_R);
        
        if ~isnan(r_tot)
            fprintf(fptr, 'TOTAL GRF (Right + Left) vs HAND OF GOD\n');
            fprintf(fptr, 'Correlation (r):      %6.4f\n', r_tot);
            fprintf(fptr, 'R squared:            %6.4f\n', r2_tot);
            fprintf(fptr, 'Cosine Similarity:    %6.4f\n\n', cos_sim_tot);
        end
        fclose(fptr);
    end
end
end

function val = get_col(T, col_names)
    val = [];
    for i = 1:length(col_names)
        if ismember(col_names{i}, T.Properties.VariableNames)
            val = T.(col_names{i});
            return;
        end
    end
end