classdef integratedterminalpty < handle
    %INTEGRATEDTERMINALPTY Summary of this class goes here
    %   Detailed explanation goes here

    properties (Constant)
        timeout = 3000 % ms
    end

    properties
        json
        pty
    end

    methods
        function obj = integratedterminalpty(preferences)
            %INTEGRATEDTERMINALPTY Construct an instance of this class
            %   Detailed explanation goes here
            [cd, ~] = fileparts(mfilename("fullpath"));
            obj.json = cd + "/pty.json";
            obj.deletejsonifexists();

            %% Start server
            arg1 = '"' + preferences.json + '"';
            arg2 = '"' + obj.json + '"';

            if computer == "PCWIN64"
                system("start /B " + cd + "/../backend/index-win.exe " + arg1 + " " + arg2);
            elseif computer == "GLNXA64"
                system(cd + "/../backend/index-linux.exe " + arg1 + " " + arg2 + " &");
            elseif computer == "MACI64"
                system(cd + "/../backend/index-macos.exe " + arg1 + " " + arg2 + " &");
            else
                error("Unsupported operating system.");
            end

            t = now();

            % while ~isfile(obj.json) does not work - concurrency issue
            while exist(obj.json, "file") ~= 2
                if now() - t > obj.timeout
                    error("Could not obtain server information.");
                end
            end

            obj.pty = jsondecode(fileread(obj.json));
        end

        function delete(obj)
            obj.deletejsonifexists();
        end

        function deletejsonifexists(obj)
            if isfile(obj.json)
                delete(obj.json);
            end
        end
    end
end
