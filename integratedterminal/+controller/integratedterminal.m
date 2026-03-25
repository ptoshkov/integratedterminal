classdef integratedterminal < handle
    %INTEGRATEDTERMINAL Summary of this class goes here
    %   Detailed explanation goes here

    properties
        f
        h
        c
    end

    methods
        function obj = integratedterminal(preferences)
            %INTEGRATEDTERMINAL Construct an instance of this class
            %   Detailed explanation goes here
            [cd, ~] = fileparts(mfilename("fullpath"));
            arg1 = '"' + preferences.json + '"';

            %% Start server
            if computer == "PCWIN64"
                system("start /B " + cd + "/../backend/index-win.exe " + arg1);
            elseif computer == "GLNXA64"
                system(cd + "/../backend/index-linux.exe " + arg1 + " &");
            elseif computer == "MACI64"
                system(cd + "/../backend/index-macos.exe " + arg1 + " &");
            else
                error('Unsupported operating system.');
            end

            %% Set up figure
            obj.f = uifigure('WindowStyle', 'docked');
            g = uigridlayout(obj.f);
            g.RowHeight = {'1x'};
            g.ColumnWidth = {'1x'};
            obj.h = uihtml(g, ...
                'Data', fileread(preferences.json), ...
                'HTMLSource', cd + "/../frontend/index.html", ...
                'HTMLEventReceivedFcn', @obj.receivedatafromfrontend);

            %% Set up client
            obj.c = tcpclient('localhost', 8080);
            configureCallback(obj.c, 'byte', 1, @obj.receivedatafrombackend);
        end

        function delete(obj)
            % Close connection
            delete(obj.c);
            clear obj.c
        end

        function receivedatafrombackend(obj,src,event)
            %RECEIVEDATAFROMBACKEND Summary of this function goes here
            %   Detailed explanation goes here
            arguments (Input)
                obj
                src
                event
            end

            if obj.c.NumBytesAvailable > 0
                data = read(obj.c);
                sendEventToHTMLSource(obj.h, 'EventToFrontend', char(data));
            end
        end

        function receivedatafromfrontend(obj,src,event)
            %RECEIVEDATAFROMFRONTEND Summary of this function goes here
            %   Detailed explanation goes here
            arguments (Input)
                obj
                src
                event
            end

            write(obj.c, event.HTMLEventData);
        end
    end
end
