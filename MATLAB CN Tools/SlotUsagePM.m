function [slot_usage slot_perc slot_scoring] = SlotUsagePM(NL,FM_num,DRA_num)
% SLOTUSAGEPM Alliance slot usage analysis + PM list
%   SLOTUSAGEPM takes a nation list (assumed to have updated aid slot 
%   listings inside) for an AA, as well as its FM and DRA counts, then
%   gives several outputs:
%   1) A PM list sorted by number of slots used, so you can have a
%   ready-made list of the bastards using zero slots.
%   2) slot_usage: an array of seven values giving the number of members
%   using 0,1,...,5,6 aid slots.
%   3) slot_perc: gives the total number of aid slots used and the total
%   possible, given your current FM/DRA count.
%   4) slot_scoring: something new I'm working on, to test how effective a
%   buyer/seller a nation is. +1 for sending 3m or receiving 50t, -1 for
%   the opposite. Good sellers are -5, good buyers are +6. Gives a member
%   count for each value from -6 to +6.
NNL = NL;
alliancename = NL(1).Alliance;
uni = zeros(1,7);
% Create PM list and slot usage array
for j = 0:6
    open_inds = [];
    for i = 1:length(NNL)
        N = NNL(i);
        slts = length(N.AidsList);
        if slts == j
            open_inds = [open_inds; i];
        end
    end
    disp(' ')
    disp(['[b]' alliancename ' - using ' num2str(j) ' aid slots[/b]'])
    uni(j+1) = SimpleMessagingList(NNL(open_inds),1);
end
% slot percentage utilization
slav = length(NL)*4 + DRA_num + FM_num; % total available slots
sl = sum(uni.*(0:6)); % slots used
disp([num2str(sl) '/' num2str(slav) ' ---> ' num2str(100*sl/slav) '% utilization'])
% slot scoring
for i = 1:length(NL)
    slots(i,1) = length(NL(i).AidsList);
    slots(i,2) = 0;
    for j = 1:slots(i,1)
        dol = NL(i).AidsList(j).Amount.Money;
        tol = NL(i).AidsList(j).Amount.Tech;
        sol = NL(i).AidsList(j).Amount.Soldiers;
        if strcmp(NL(i).AidsList(j).Sender.RulerName,NL(i).RulerName) % nation is sender
            if dol == 3e6
                slots(i,2) = slots(i,2) + 1;
            end
            if tol == 50
                slots(i,2) = slots(i,2) - 1;
            end
        elseif strcmp(NL(i).AidsList(j).Receiver.RulerName,NL(i).RulerName) % nation is receiver
            if dol == 3e6
                slots(i,2) = slots(i,2) - 1;
            end
            if tol == 50
                slots(i,2) = slots(i,2) + 1;
            end
        end
    end
end
SL = slots(:,2);
GG = -6:6;
for kk = 1:length(GG)
    HH(kk) = nnz(SL == GG(kk));
end
slot_usage = uni;
slot_perc = [sl slav];
slot_scoring = [GG;HH];