classdef integratedterminallatch < handle
    %INTEGRATEDTERMINALLATCH Summary of this class goes here
    %   Detailed explanation goes here

    properties
        tmp
    end

    methods
        function obj = integratedterminallatch()
            %INTEGRATEDTERMINALLATCH Construct an instance of this class
            %   Detailed explanation goes here
            obj.tmp = "" + tempname();
            fclose(fopen(obj.tmp, "w"));
        end

        function delete(obj)
            if isfile(obj.tmp)
                delete(obj.tmp);
            end
        end

        function wait(obj, timeout)
            t = datetime();

            while isfile(obj.tmp)
                if seconds(datetime() - t) > timeout
                    error("Timed out waiting for latch.");
                end
            end
        end
    end
end
