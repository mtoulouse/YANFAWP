function nl = PropertyArray(NAWL,field)
% PROPERTYARRAY Array creator from object lists
%   PROPERTYARRAY takes an array of Nation, Aid, or War objects and the
%   name of a property of that class, and assembles an array of that
%   property. Can be a matrix if all numbers, or a cell array if the field
%   contains strings.
if ~isempty(NAWL)
    if isa(NAWL,'Nation')
        switch field
            case {'RulerName','NationName', 'Alliance', 'Team'}
                nl = {};
            otherwise
                nl = [];
        end
    elseif isa(NAWL,'Aid')
        switch field
            case {'Memo','Status'}
                nl = {};
            otherwise
                nl = [];
        end
    elseif isa(NAWL,'War')
        switch field
            case {'Memo','Status'}
                nl = {};
            otherwise
                nl = [];
        end
    end
    for i = 1:length(NAWL)
        nl = [nl;NAWL(i).(field)];
    end
end
end