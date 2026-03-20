classdef integratedterminalpreferences
    %INTEGRATEDTERMINALPREFERENCES Summary of this class goes here
    %   Detailed explanation goes here

    properties
        json
    end

    methods
        function obj = integratedterminalpreferences()
            %INTEGRATEDTERMINALPREFERENCES Construct an instance of this class
            %   Detailed explanation goes here
            [cd, ~] = fileparts(mfilename("fullpath"));
            obj.json = cd + "/preferences.json";

            if ~isfile(obj.json)
                if computer == "PCWIN64"
                    copyfile(cd + "/defaultwindows.json", obj.json);
                elseif computer == "GLNXA64"
                    copyfile(cd + "/defaultlinux.json", obj.json);
                elseif computer == "MACI64"
                    copyfile(cd + "/defaultmacos.json", obj.json);
                else
                    error('Unsupported operating system.');
                end
            end
        end

        function open(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            open(obj.json);
        end
    end
end