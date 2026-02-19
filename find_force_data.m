function find_force_data(info_struct, path_so_far)
if contains(info_struct.Name, 'SelectedOutput')
    fprintf("Found path: %s %s\n", path_so_far, info_struct.Name);
end
if contains(info_struct.Name, 'Knee') && ...
       (contains(info_struct.Name, 'Moment') || contains(info_struct.Name, 'JointMoment'))
        fprintf('Found Knee Data: %s%s\n', path_so_far, info_struct.Name);
end
if ~isempty(info_struct.Groups)
        for i = 1:length(info_struct.Groups)
            find_force_data(info_struct.Groups(i), [path_so_far]); 
        end
end
end