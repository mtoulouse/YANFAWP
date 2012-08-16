function CombineLists(varargin)
% COMBINELISTS Combines Nation, Aid, and/or War lists
%   COMBINELISTS takes an array of newly minted Nation objects, plus arrays
%   of Aid and/or War objects, and cross-references them to store the
%   relevant aid/war objects in nation objects, and update the info where
%   possible. Pretty much combines the info from the three sources as much
%   as possible.
tic
NationList = [];
AidList = [];
WarList = [];
for i = 1:nargin
    switch class(varargin{i})
        case 'Nation'
            NationList = varargin{i};
        case 'Aid'
            AidList = varargin{i};
        case 'War'
            WarList = varargin{i};
    end
end
if isempty(NationList)
    disp('No Nation List!')
    return
end
if ~isempty(AidList)
    disp('Combining nation and aid lists')
    for i = 1:length(NationList)
        NL = NationList(i);
        for j = 1:length(AidList)
            AL = AidList(j);
            S = strcmp(AL.Sender.RulerName,NL.RulerName);
            R = strcmp(AL.Receiver.RulerName,NL.RulerName);
            if S
                if isempty(NL.NationName)
                    NL.NationName = AL.Sender.NationName;
                end
                AL.Sender = NL;
                NL.AidsList = [NL.AidsList AL];
            elseif R
                if isempty(NL.NationName)
                    NL.NationName = AL.Receiver.NationName;
                end
                AL.Receiver = NL;
                NL.AidsList = [NL.AidsList AL];
            end
        end
    end
end
if ~isempty(WarList)
    disp('Combining nation and war lists')
    for i = 1:length(NationList)
        NL = NationList(i);
        for j = 1:length(WarList)
            WL = WarList(j);
            S = strcmp(WL.Attacker.RulerName,NL.RulerName);
            R = strcmp(WL.Defender.RulerName,NL.RulerName);
            if S
                if isempty(NL.NationName)
                    NL.NationName = WL.Attacker.NationName;
                end
                WL.Attacker = NL;
                NL.WarsList = [NL.WarsList WL];
            elseif R
                if isempty(NL.NationName)
                    NL.NationName = WL.Defender.NationName;
                end
                WL.Defender = NL;
                NL.WarsList = [NL.WarsList WL];
            end
        end
    end
end
disp([num2str(toc) ' seconds to combine lists'])
end