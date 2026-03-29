classdef integratedterminalpreferences
    %INTEGRATEDTERMINALPREFERENCES Summary of this class goes here
    %   Detailed explanation goes here

    properties
        cd
        json
        help
    end

    methods
        function obj = integratedterminalpreferences()
            %INTEGRATEDTERMINALPREFERENCES Construct an instance of this class
            %   Detailed explanation goes here
            [obj.cd, ~] = fileparts(mfilename("fullpath"));
            obj.json = obj.cd + "/preferences.json";
            obj.help = obj.cd + "/help.txt";

            if ~isfile(obj.json)
                obj.reset();
            end
        end

        function reset(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if computer == "PCWIN64"
                copyfile(obj.cd + "/defaultwindows.json", obj.json);
            elseif computer == "GLNXA64"
                copyfile(obj.cd + "/defaultlinux.json", obj.json);
            elseif computer == "MACI64" || computer == "MACA64"
                copyfile(obj.cd + "/defaultmacos.json", obj.json);
            else
                error('Unsupported operating system.');
            end
        end

        function txt = read(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            txt = fileread(obj.json);
        end

        function txt = gethelp(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            txt = fileread(obj.help);
        end

        function write(obj, txtCell)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            tmp = tempname + ".txt";
            writecell(txtCell, tmp, "QuoteStrings", false);
            movefile(tmp, obj.json);
        end
    end
end