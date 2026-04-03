classdef integratedterminal < handle
    %INTEGRATEDTERMINAL Summary of this class goes here
    %   Detailed explanation goes here

    properties
        f
        h
        c
        cm
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
            obj.cm = uicontextmenu(obj.f);
            uimenu(obj.cm,"Text","Copy");
            uimenu(obj.cm,"Text","Paste");
            uimenu(obj.cm,"Text","Open Profile","MenuSelectedFcn",@preferences.open);
            uimenu(obj.cm,"Text","Edit Profile","MenuSelectedFcn",@preferences.edit);
            uimenu(obj.cm,"Text","Help");
            obj.h.ContextMenu = obj.cm;

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
            if strcmp(event.HTMLEventName, 'EventToFrontend')
                write(obj.c, event.HTMLEventData);
            end

            if strcmp(event.HTMLEventName, 'contextmenu')
                p = getpixelposition(obj.h,true);
                x = p(1)+event.HTMLEventData(1);
                y = p(2)+p(4)-event.HTMLEventData(2);
                open(obj.cm,x,y);
            end
        end
    end
end
