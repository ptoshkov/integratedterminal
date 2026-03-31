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
            arguments
                profile = []
            end

            [cd, ~] = fileparts(mfilename("fullpath"));
            obj.destdir = cd + "/../profiles";
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

            if isempty(profile)
                return;
            end

            obj.load(profile);
        end

        function delete(obj)
            delete(obj.json);
        end

        function load(obj, profile)
            %% Copy the profile and strip the comments,
            %% because comments are not allowed in JSON
            jsonwithcomments = fileread(obj.destdir + "/" + profile);
            [jsonwithoutcomments, ~] = regexp(jsonwithcomments, "//[^\r\n]*", "split");
            tmp = tempname();
            writecell(jsonwithoutcomments', tmp + ".txt", "QuoteStrings", "none");
            movefile(tmp + ".txt", tmp + ".json");
            obj.json = tmp + ".json";
        end

        function open(obj)
            [file, location] = uigetfile("*.json", "", obj.destdir);

            if isequal(file,0)
                % User selected Cancel
                return;
            else
                open(fullfile(location, file));
            end
        end
    end
end