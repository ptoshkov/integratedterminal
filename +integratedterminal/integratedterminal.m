classdef integratedterminal < handle
    %INTEGRATEDTERMINAL Summary of this class goes here
    %   Detailed explanation goes here

    properties
        f
        h
        c
    end

    methods
        function obj = integratedterminal()
            %INTEGRATEDTERMINAL Construct an instance of this class
            %   Detailed explanation goes here

            % Start server
            if computer == "PCWIN64"
                system('start /B backend/index-win.exe');
            elseif computer == "GLNXA64"
                system('backend/index-linux.exe &');
            elseif computer == "MACI64"
                system('backend/index-macos.exe &');
            else
                error('Unsupported operating system.');
            end

            % Set up figure
            obj.f = uifigure('WindowStyle', 'docked', ...
                'CloseRequestFcn', @obj.closefigure);
            g = uigridlayout(obj.f);
            g.RowHeight = {'1x'};
            g.ColumnWidth = {'1x'};
            obj.h = uihtml(g, ...
                'HTMLSource', 'frontend/index.html', ...
                'HTMLEventReceivedFcn', @obj.receivedatafromfrontend);

            % Set up client
            obj.c = tcpclient('localhost', 8080);
            configureCallback(obj.c, 'byte', 1, @obj.receivedatafrombackend);
        end

        function delete(obj)
            obj.closeconnection();
            close(obj.f);
        end

        function closefigure(obj,src,event)
            obj.closeconnection();
            delete(src);
        end

        function closeconnection(obj)
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
