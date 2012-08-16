function Q = AidCount(varargin)
%AIDCOUNT Alliance aid breakdown by AA
%   AIDCOUNT takes an array of Aid objects and the "home" AA name, then
%   counts the senders/receivers of aid in the list by AA, outputting a
%   table of AAs with corresponding # of your home AAs slots used by them.
%   A third input can be included, specifying how many (top slot using)
%   alliances to include in a pie chart. Warning: the pie chart is not
%   often pretty. You'll have to fiddle with the label placement, most
%   likely.
%
%   Example: Q = AidCount(UmbAidList,'Umbrella',5) would give a full list
%   of those AAs using Umbrella's aid slots, then a pie chart with the top
%   5 alliances on that list plus "Other" for the rest.
AL = varargin{1};
AA = varargin{2};
if nargin == 3
    chart = varargin{3};
else
    chart = 0;
end

num = length(AL); % number of entries in aid list
AA_List = {}; % initialize list of AAs
for i = 1:num % for each aid entry
    S = AL(i).Sender.Alliance; % AA of the sender
    R = AL(i).Receiver.Alliance; % AA of the receiver
    S_A = strcmpi(S,AA); % true/false: matches "home" AA?
    R_A = strcmpi(R,AA);% true/false: matches "home" AA?
    if S_A % Sender matches
        AA_List = [AA_List; R]; % add receiver AA to AA list
    elseif R_A % Sender doesn't match, receiver matches
        AA_List = [AA_List; S]; % add sender AA to AA list
    else
        disp('Neither matches, wtf') % if you get this message, check your
        % AA name. Maybe you misspelled it so nothing is matching.
    end
end
[b m n] = unique(AA_List); % unique entries in the AA list, and locations
AA_num = zeros(size(b)); % initialize the AA number counts.
for i = 1:num
    % count the number of mentions of each AA
    AA_num(n(i)) = AA_num(n(i))+1;
end
if sum(AA_num) ~= length(AL)
    disp('MISMATCH') % total number of slots in the AA list should match
    % the summed slot usage by AA.
end
% note: the "unique" command recognizes capitalization (Umbrella =/=
% umbrella). This section uses case-insensitive comparison to merge these
% cases.
rem_inds = [];
for i = 1:length(b)
    Anam1 = b{i};
    if AA_num(i) % not zeroed?
        for j = 1:length(b)
            Anam2 = b{j};
            if i ~= j && strcmpi(Anam1,Anam2)
                AA_num(i) = AA_num(i) + AA_num(j);
                AA_num(j) = 0;
                rem_inds = [rem_inds j];
            end
        end
    end
end
% One entry is stored but if it is intra-AA, two alliance members' slots
% are actually used. Double the intra-alliance aid number.
I = find(strcmpi(b,AA));
AA_num(I) = 2*AA_num(I);

Q = [b num2cell(AA_num)]; % create table
Q(unique(rem_inds),:) = []; %remove the redundant AA listings
Q = sortrows(Q,-2); % sort descending by slot #.

% If a pie chart was requested, this section executes.
if chart > 0
    % Pie chart data
    LBLS = cell(1,chart+1);
    lbls = cell(size(LBLS));
    for i = 1:chart
        LBLS{i} = Q{i,1};
    end
    LBLS{chart+1} = 'Other';
    lblperc = zeros(size(LBLS));
    LBLNUM = zeros(size(LBLS));

    for i = 1:length(LBLS)-1
        LBLNUM(i) = Q{i,2};
        lblperc(i) = LBLNUM(i)/sum(AA_num)*100;
        lbls{i} = [LBLS{i} ': ' num2str(LBLNUM(i)) ' (' num2str(lblperc(i),'%6.2f') '%)'];
    end
    LBLNUM(end) = sum(AA_num) - sum(LBLNUM);
    lblperc(end) = LBLNUM(end)/sum(AA_num)*100;
    lbls{end} = [LBLS{end} ': ' num2str(LBLNUM(end)) ' (' num2str(lblperc(end),'%6.2f') '%)'];
    pie(LBLNUM,lbls)
    title(['Slot usage by alliance: ' AA])
end
end