classdef integratedterminalpreferences < handle
    %INTEGRATEDTERMINALPREFERENCES Summary of this class goes here
    %   Detailed explanation goes here

    properties
        destdir
        json
    end

    methods
        function obj = integratedterminalpreferences(profile)
            %INTEGRATEDTERMINALPREFERENCES Construct an instance of this class
            %   Detailed explanation goes here
            [cd, ~] = fileparts(mfilename("fullpath"));
            obj.destdir = fileparts(cd) + "/profiles";
            default = obj.destdir + "/default.json";

            %% Create the profiles directory if it doesn't exist
            if ~isfolder(obj.destdir)
                mkdir(obj.destdir);
            end

            %% Create the default profile if it doesn't exist
            if ~isfile(default)
                if computer == "PCWIN64"
                    copyfile(cd + "/defaultwindows.json", default);
                elseif computer == "GLNXA64"
                    copyfile(cd + "/defaultlinux.json", default);
                elseif computer == "MACI64" || computer == "MACA64"
                    copyfile(cd + "/defaultmacos.json", default);
                else
                    error('Unsupported operating system.');
                end
            end

            %% Copy the profile and strip the comments,
            %% because comments are not allowed in JSON
            jsonwithcomments = fileread(obj.destdir + "/" + profile);
            [jsonwithoutcomments, ~] = regexp(jsonwithcomments, "//[^\r\n]*", "split");
            tmp = tempname();
            writecell(jsonwithoutcomments', tmp + ".txt", "QuoteStrings", "none");
            movefile(tmp + ".txt", tmp + ".json");
            obj.json = tmp + ".json";
        end

        function delete(obj)
            if isfile(obj.json)
                delete(obj.json);
            end
        end

        function open(obj, src, event)
            [file, location] = uigetfile("*.json", "", obj.destdir);

            if isequal(file,0)
                % User selected Cancel
                return;
            end

            if fullfile(location, file) ~= fullfile(obj.destdir, file)
                warning("The selected file is not in the profiles folder.");
                return;
            end

            integratedTerminal(string(file));
        end

        function edit(obj, src, event)
            [file, location] = uigetfile("*.json", "", obj.destdir);

            if isequal(file,0)
                % User selected Cancel
                return;
            end

            if fullfile(location, file) ~= fullfile(obj.destdir, file)
                warning("The selected file is not in the profiles folder.");
                return;
            end

            open(fullfile(location, file));
        end
    end
end
