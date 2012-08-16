classdef Nation < handle
    %NATION Nation Object.
    %   NATION represents a single nation, storing the ruler/nation name, ID,
    %   alliance, etc. Pretty much everything that can be learned from the
    %   alliance nation listings, plus two fields for storing Aid and War
    %   objects associated with the nation.
    properties
        RulerName % string
        NationName % string
        Alliance % string
        Team % string
        Mode % double (1 = WAR)
        ID % double
        Seniority % double
        NS % double
        Tech % double
        Infra % double
        Nukes = 0; % double
        StatDateTaken % date
        LastActivity % date
        AidsList = Aid.empty; % array of Aid objects
        WarsList = War.empty % array of War objects
    end

    methods
        function NT = Nation(nn,id)
            %constructor method. takes either 0 or 2 inputs.
            if nargin > 0
                NT.NationName = nn;
                NT.ID = id;
            end
        end
        function ml = NationLink(nat)
            % Takes a nation object, gives a string containing the nation link
            ml = ['http://www.cybernations.net/nation_drill_display.asp?Nation_ID=' num2str(nat.ID)];
        end
        function ml = MessageLink(nat)
            % Takes a nation object, gives a string containing the nation
            % PM link.
            ml = ['http://www.cybernations.net/send_message.asp?Nation_ID=' num2str(nat.ID)];
        end

        function ind = findnation(NL,prop,srch)
            % find a nation with a certain property
            if isa(NL(1).(prop),'char')
                ind = find(strcmp(PropertyArray(NL,prop),srch));
            elseif isa(NL(1).(prop),'double')
                ind = find(PropertyArray(NL,prop) == srch);
            end
        end

        function NLL = InRange(varargin)
            % War range method. Input: array of nation objects and a target
            % NS, and optionally a modifier string 'above' or 'below'.
            % Outputs a shortened array of nation objects which are able to
            % attack a nation at the target NS. Can be further shortened to
            % only include nations in war range above or below the target.
            NL = varargin{1};
            targetns = varargin{2};
            if nargin == 3
                modif = varargin{3};
            else
                modif = [];
            end
            upper = 4/3*targetns; % 133%
            lower = 3/4*targetns; % 75%
            NLL = [];
            for i = 1:length(NL)
                ns = NL(i).NS;
                if strcmp(modif,'above')
                    if ns < upper && ns > targetns
                        NLL = [NLL NL(i)];
                    end
                elseif strcmp(modif,'below')
                    if ns < targetns && ns > lower
                        NLL = [NLL NL(i)];
                    end
                else
                    if ns < upper && ns > lower
                        NLL = [NLL NL(i)];
                    end
                end
            end
        end

        function [UNI1,UNI2] = CompareNationLists(N1,N2)
            % Compares lists, shows new names
            if N1(1).StatDateTaken > N2(1).StatDateTaken
                temp = N2;
                N2 = N1;
                N1 = temp;
            end
            d1 = N1(1).StatDateTaken;
            d2 = N2(1).StatDateTaken;
            oldL = PropertyArray(N1,'ID');
            newL = PropertyArray(N2,'ID');
            [leavers,ind1] = setdiff(oldL,newL);
            [newguys,ind2] = setdiff(newL,oldL);
            [comm,ind3a,ind3b] = intersect(oldL,newL);
            disp(['First set taken on ' datestr(d1)])
            disp(['Second set taken on ' datestr(d2)])
            disp('---')
            disp('[b]Leavers[/b]')
            if isempty(leavers)
                disp('none')
            else
                for i = 1:length(leavers)
                    L = N1(ind1(i));
                    if d1 - L.LastActivity > 20
                        adstr = ' - [b]>20 DAYS[/b]';
                    else
                        adstr = [];
                    end
                    disp(['[url=' NationLink(L) ']' L.RulerName ' - '...
                        num2str(L.NS) ' NS - '...
                        num2str(d1 - L.LastActivity) ' days' adstr '[/url]']);
                end
            end
            disp('---')
            disp('[b]New Faces[/b]')
            M = N2(ind2);
            if isempty(M)
                disp('none')
            else
                [Q IX] = sort(PropertyArray(M,'Seniority'),'descend');
                M = M(IX);
                for i = 1:length(M)
                    L = M(i);
                    if d2 - L.LastActivity > 20
                        adstr = ' - [b]>20 DAYS INACTIVE[/b]';
                    else
                        adstr = [];
                    end
                    disp(['[url=' NationLink(L) ']' L.RulerName  ' - ' num2str(L.NS) ' NS[/url] - ' num2str(L.Seniority) ' days on the AA' adstr]);
                end
            end
            disp('---')
            UNI1 = N1(ind3a);
            UNI2 = N2(ind3b);
            disp(length(comm))
        end

        function sixarm = SixArmedBros(NL)
            disp(['As of ' datestr(NL(1).StatDateTaken) ' game time:'])
            ind = [];
            for i = 1:length(NL)
                if length(NL(i).WarsList) == 6
                    ind = [ind i];
                    disp(['Six-Armed Bro #' num2str(length(ind)) ': ' NL(i).RulerName])
                end
            end
            sixarm = NL(ind);
        end

    end
end