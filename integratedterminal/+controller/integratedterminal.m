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
                             'Name', 'Terminal');
            g = uigridlayout(obj.f);
            g.RowHeight = {'1x'};
            g.ColumnWidth = {'1x'};
            obj.h = uihtml(g, ...
                           'Data', fileread(preferences.json), ...
                           'HTMLSource', cd + "/../frontend/index.html", ...
                           'HTMLEventReceivedFcn', @obj.receivedatafromfrontend);

            %% Set up client
            obj.c = tcpclient(pty.pty.address, pty.pty.port, ...
                              'Timeout', 0.05, ...
                              'EnableTransferDelay', false);
            configureCallback(obj.c, ...
                              'byte', 1, ...
                              @obj.receivedatafrombackend);
        end

        function delete(obj)
            % Close connection
            warning('off', 'MATLAB:class:DestructorError');
            delete(obj.c);
            clear obj.c
            warning('on', 'MATLAB:class:DestructorError');
        end

        function receivedatafrombackend(obj,src,event)
            %RECEIVEDATAFROMBACKEND Summary of this function goes here
            %   Detailed explanation goes here
            warning('off', 'MATLAB:callback:DynamicPropertyEventError');
            data = read(obj.c, max(obj.c.BytesAvailableFcnCount, obj.c.NumBytesAvailable));
            warning('on', 'MATLAB:callback:DynamicPropertyEventError');

            if isempty(data)
                return;
            end

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
