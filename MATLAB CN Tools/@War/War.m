classdef War < handle
%WAR War Object.
%   WAR represents a single war, storing the declare date, attacking and
%   defending nations, war status and reason.
    properties
        StatDateTaken % date data was gathered
        DateDeclared % date
        Memo % string
        Attacker % Nation object
        Defender % Nation object
        Status  = 'UNKNOWN' % string (Fighting, Peaced, Expired, UNKNOWN)
    end

    methods
        function WR = War()
            % constructor method. Empty.
        end

        function AW = ActiveWars(WL)
            % takes an array of war objects, outputs a shortened list with
            % only the wars currently being fought.
            AW = [];
            if ~isempty(WL)
                Q = strcmp(PropertyArray(WL,'Status'),'Fighting');
                for i = 1:length(WL)
                    if Q(i)
                        AW = [AW WL(i)];
                    end
                end
            end
        end

        function WL = RemoveExpired(WL)
            % takes an array of war objects, outputs a shortened list with
            % only the expired wars removed. Note that this differs from
            % ActiveWars because it keeps the unexpired peaced-out wars.
            ri = [];
            Q = strcmp(PropertyArray(WL,'Status'),'Expired');
            R = strcmp(PropertyArray(WL,'Status'),'UNKNOWN');
            for i = 1:length(WL)
                if Q(i) || R(i)
                    ri = [ri i];
                end
            end
            WL(ri) = [];
        end
    end
end