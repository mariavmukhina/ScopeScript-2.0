classdef DebugLogger < handle

    methods(Static)
        % -------- WRITE DEBUG MESSAGE METHOD --------
        function writeDebugMessage(message)

            persistent fid fullPath

            % First call: initialize
            if isempty(fid) || fid == -1
                fcScope = scopeParams();
                % Create directory if needed
                folderName = fcScope.returnPath();      % Target directory
                fileName   = 'logfile.txt';        % File name
                fullPath   = fullfile(folderName, fileName);

                if ~exist(folderName, 'dir')
                    mkdir(folderName);    % create folder if it doesn't exist
                end


                fid = fopen(fullPath, 'a');
                if fid == -1
                    error(fullPath);
                end

            end

            % Write message
            timestamp = char(datetime('now','Format','yyyy-MM-dd HH:mm:ss.SSS'));
            fprintf(fid, '[%s] %s\n', timestamp, message);

            % Flush immediately for crash protection
            fseek(fid, 0, 'cof');
        end

        function close()
            % Optional manual close method
            persistent fid
            if ~isempty(fid) && fid ~= -1
                fclose(fid);
                fid = [];
            end
        end
    end
end
