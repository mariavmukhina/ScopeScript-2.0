function startDebug()
    % -------- SETTINGS --------
    folderName = scopeParams.expPath;      % Target directory
    fileName   = 'logfile.txt';        % File name
    fullPath   = fullfile(folderName, fileName);

   
    % -------- OPEN FILE FOR WRITING --------
    fid = fopen(fullPath, 'a');
    
    if fid == -1
        error('Could not open file for writing.');
    end
    
    % Ensure file closes properly even if error occurs
    cleanupObj = onCleanup(@() fclose(fid));
    
    % -------- CONTINUOUS SAVE LOOP EXAMPLE --------
end
