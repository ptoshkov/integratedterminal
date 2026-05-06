classdef integratedterminal < handle
    %INTEGRATEDTERMINAL Summary of this class goes here
    %   Detailed explanation goes here

    properties
        f
        h
        c
        cd
        preferences
        cm
        t
    end

    methods
        function obj = integratedterminal(preferences, pty)
            %INTEGRATEDTERMINAL Construct an instance of this class
            %   Detailed explanation goes here
            [obj.cd, ~] = fileparts(mfilename("fullpath"));
            obj.preferences = preferences;

            %% Set up client
            obj.c = tcpclient(pty.pty.address, pty.pty.port, ...
                              'EnableTransferDelay', false);
            configureCallback(obj.c, ...
                              'byte', 256, ...
                              @obj.receivedatafrombackend);

            %% Set up figure
            obj.f = uifigure('WindowStyle', 'docked', ...
                             'Name', 'Terminal', ...
                             'Icon', obj.cd + "/../images/integratedTerminal.png");
            g = uigridlayout(obj.f);
            g.RowHeight = {'1x'};
            g.ColumnWidth = {'1x'};
            obj.h = uihtml(g, ...
                           'Data', fileread(obj.preferences.json), ...
                           'HTMLSource', obj.cd + "/../frontend/index.html", ...
                           'HTMLEventReceivedFcn', @obj.receivedatafromfrontend);
            obj.cm = uicontextmenu(obj.f);
            uimenu(obj.cm,"Text","Copy","MenuSelectedFcn",@obj.copy);
            uimenu(obj.cm,"Text","Paste","MenuSelectedFcn",@obj.paste);
            uimenu(obj.cm,"Text","Open Profile","MenuSelectedFcn",@obj.preferences.open);
            uimenu(obj.cm,"Text","Edit Profile","MenuSelectedFcn",@obj.preferences.edit);
            uimenu(obj.cm,"Text","Help","MenuSelectedFcn",@obj.help);
            obj.h.ContextMenu = obj.cm;

            % Nudge the PTY process to show the prompt by sending a space
            % and a backspace
            write(obj.c, [char(32) char(127)]);

            %% Set up timer
            obj.t = timer('TimerFcn', @obj.resetname, 'StartDelay', 3);
        end

        function delete(obj)
            %% Close connection
            delete(obj.c);
            clear obj.c
        end

        function receivedatafrombackend(obj,src,event)
            %RECEIVEDATAFROMBACKEND Summary of this function goes here
            %   Detailed explanation goes here
            data = read(obj.c, 256);
            data = native2unicode(data, 'UTF-8');
            sendEventToHTMLSource(obj.h, 'EventToFrontend', data);
            pause(0);
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

            if strcmp(event.HTMLEventName, 'RingBell')
                %% Execute the visual and/or audio bell if enabled
                if obj.preferences.preferences.AudioBell
                    beep();
                end

                if obj.preferences.preferences.VisualBell
                    obj.f.Name = "Terminal 🔔";

                    %% Restart the timer to clear the visual bell
                    stop(obj.t);
                    start(obj.t);
                end
            end
        end

        function resetname(obj, event, text_arg)
            obj.f.Name = "Terminal";
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
