classdef ValueClass
    %VALUECLASS Example value class.
    properties
        prop (1,1) double % Internal property
    end
    
    methods
        function obj = ValueClass(val)
            %VALUECLASS Initialize new instance with given value.
            arguments
                val (1,1) double
            end
            obj.prop = val;
        end
    end
end

