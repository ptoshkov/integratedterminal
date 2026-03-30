classdef integratedterminal < handle
    %INTEGRATEDTERMINAL Summary of this class goes here
    %   Detailed explanation goes here

    properties
        f
        h
        c
    end

    methods
        function obj = integratedterminal(preferences, pty)
            %INTEGRATEDTERMINAL Construct an instance of this class
            %   Detailed explanation goes here
            [cd, ~] = fileparts(mfilename("fullpath"));

            %% Set up figure
            obj.f = uifigure('WindowStyle', 'docked', ...
                             'Name', 'Terminal', ...
                             'Icon', cd + "/../images/integratedTerminal.png");
            g = uigridlayout(obj.f);
            g.RowHeight = {'1x'};
            g.ColumnWidth = {'1x'};
            obj.h = uihtml(g, ...
                           'Data', fileread(preferences.json), ...
                           'HTMLSource', cd + "/../frontend/index.html", ...
                           'HTMLEventReceivedFcn', @obj.receivedatafromfrontend);

            %% Set up client
            obj.c = tcpclient(pty.pty.address, pty.pty.port, ...
                              'EnableTransferDelay', false);
            configureCallback(obj.c, ...
                              'byte', 128, ...
                              @obj.receivedatafrombackend);
        end

        function delete(obj)
            %% Close connection
            flush(obj.c);
            delete(obj.c);
            clear obj.c
        end

        function receivedatafrombackend(obj,src,event)
            %RECEIVEDATAFROMBACKEND Summary of this function goes here
            %   Detailed explanation goes here
            data = read(obj.c, 128);
            data = native2unicode(data, 'UTF-8');
            sendEventToHTMLSource(obj.h, 'EventToFrontend', data);
        end

        function receivedatafromfrontend(obj,src,event)
            %RECEIVEDATAFROMFRONTEND Summary of this function goes here
            %   Detailed explanation goes here
            write(obj.c, event.HTMLEventData);
        end
    end
end
