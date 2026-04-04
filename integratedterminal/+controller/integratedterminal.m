classdef integratedterminal < handle
    %INTEGRATEDTERMINAL Summary of this class goes here
    %   Detailed explanation goes here

    properties
        f
        h
        c
        cd
        cm
    end

    methods
        function obj = integratedterminal(preferences, pty)
            %INTEGRATEDTERMINAL Construct an instance of this class
            %   Detailed explanation goes here
            [obj.cd, ~] = fileparts(mfilename("fullpath"));

            %% Set up figure
            obj.f = uifigure('WindowStyle', 'docked', ...
                             'Name', 'Terminal', ...
                             'Icon', obj.cd + "/../images/integratedTerminal.png");
            g = uigridlayout(obj.f);
            g.RowHeight = {'1x'};
            g.ColumnWidth = {'1x'};
            obj.h = uihtml(g, ...
                           'Data', fileread(preferences.json), ...
                           'HTMLSource', obj.cd + "/../frontend/index.html", ...
                           'HTMLEventReceivedFcn', @obj.receivedatafromfrontend);
            obj.cm = uicontextmenu(obj.f);
            uimenu(obj.cm,"Text","Copy","MenuSelectedFcn",@obj.copy);
            uimenu(obj.cm,"Text","Paste","MenuSelectedFcn",@obj.paste);
            uimenu(obj.cm,"Text","Open Profile","MenuSelectedFcn",@preferences.open);
            uimenu(obj.cm,"Text","Edit Profile","MenuSelectedFcn",@preferences.edit);
            uimenu(obj.cm,"Text","Help","MenuSelectedFcn",@obj.help);
            obj.h.ContextMenu = obj.cm;

            %% Set up client
            obj.c = tcpclient(pty.pty.address, pty.pty.port, ...
                              'EnableTransferDelay', false);
            configureCallback(obj.c, ...
                              'byte', 256, ...
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
            data = read(obj.c, 256);
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

            if strcmp(event.HTMLEventName, 'ReportSelection')
                clipboard('copy', event.HTMLEventData);
            end
        end

        function copy(obj, src, event)
            sendEventToHTMLSource(obj.h, 'GetSelection');
        end

        function paste(obj, src, event)
            write(obj.c, clipboard('paste'));
        end

        function help(obj, src, event)
            open(obj.cd + "/../README.pdf");
        end
    end
end
