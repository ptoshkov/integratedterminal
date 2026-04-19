classdef integratedterminalpty < handle
    %INTEGRATEDTERMINALPTY Summary of this class goes here
    %   Detailed explanation goes here

    properties
        json
        pty
    end

    methods
        function obj = integratedterminalpty(preferences, latch)
            %INTEGRATEDTERMINALPTY Construct an instance of this class
            %   Detailed explanation goes here
            [cd, ~] = fileparts(mfilename("fullpath"));
            obj.json = tempname() + ".json";
            arg1 = '"' + preferences.json + '"';
            arg2 = '"' + obj.json + '"';
            arg3 = '"' + latch.tmp + '"';

            %% Start server
            if computer == "PCWIN64"
                ret = system( ...
                    "start /B """" """ + cd + "/../backend/index-win.exe"" " + arg1 + " " + arg2 + " " + arg3 ...
                    );
            elseif computer == "GLNXA64"
                ret = system( ...
                    """" + cd + "/../backend/index-linux"" " + arg1 + " " + arg2 + " " + arg3 + " &" ...
                    );
            elseif computer == "MACI64" || computer == "MACA64"
                ret = system( ...
                    """" + cd + "/../backend/index-macos"" " + arg1 + " " + arg2 + " " + arg3 + " &" ...
                    );
            else
                error("Unsupported operating system.");
            end

            if ret ~= 0
                error("Failed to start pty server.")
            end

            latch.wait(60);
            obj.pty = jsondecode(fileread(obj.json));
        end

        function delete(obj)
            if isfile(obj.json)
                delete(obj.json);
            end
        end
    end
end
