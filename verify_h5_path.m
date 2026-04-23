function is_valid = verify_h5_path(filename, target_path)
    is_valid = false;
    try
        h5info(filename, target_path);
        is_valid = true;
    catch
        fprintf('Path missing: %s not found in %s.\\n', target_path, filename);
    end
end