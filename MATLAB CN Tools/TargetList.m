function TargetList(TargetNL,AttackingNL)
%
% Spreadsheet looks something like this:
% Data taken on DATE
% Number | Ruler of Nation (Link) | NS | Tech | Infra | Nukes | 20+ Days? |
% Slots(S--R)-Link | Wars (Off/Def)-Link
numnat = length(TargetNL);
NatSheet = cell(numnat+2,11);
AA = TargetNL(1).Alliance;
ndatetaken = max(PropertyArray(TargetNL,'StatDateTaken'));
NatSheet{1,2} = ['Target List: ' AA];
NatSheet{1,11} = ['Data taken on ' datestr(ndatetaken) ' (game time)'];
NatSheet(2,:) = {'#' 'RULER of NATION'	'NS' 'Tech'	'Infra'	'Nukes' 'Aid slots (S--R)' 'War Slots(O--D)' 'Open off. slots in range (above--total)' 'War/Peace' 'Link'};
for i = 1:length(TargetNL)
    N_above = InRange(AttackingNL,TargetNL(i).NS,'above');
    N_all = InRange(AttackingNL,TargetNL(i).NS);
    offnum_above = 3*length(N_above);
    offnum_all = 3*length(N_all);
    for k = 1:length(N_above)
        for q = 1:length(N_above(k).WarsList)
            if strcmp(N_above(k).WarsList(q).Attacker.RulerName,N_above(k).RulerName)
                offnum_above = offnum_above - 1;
            end
        end
    end
    
    for l = 1:length(N_all)
        for q = 1:length(N_all(l).WarsList)
            if strcmp(N_all(l).WarsList(q).Attacker.RulerName,N_all(l).RulerName)
                offnum_all = offnum_all - 1;
            end
        end
    end
    if TargetNL(i).Mode
        warpe = 'W';
    else
        warpe = 'P';
    end
    slots(i,1) = length(TargetNL(i).AidsList);
    slots(i,2) = 0;
    slots(i,3) = 0;
    for j = 1:slots(i,1)
        if strcmp(TargetNL(i).AidsList(j).Sender.RulerName,TargetNL(i).RulerName)
            slots(i,2) = slots(i,2) + 1;
        elseif strcmp(TargetNL(i).AidsList(j).Receiver.RulerName,TargetNL(i).RulerName)
            slots(i,3) = slots(i,3) + 1;
        end
    end
    wslots(i,1) = length(TargetNL(i).WarsList);
    wslots(i,2) = 0;
    wslots(i,3) = 0;
    for j = 1:wslots(i,1)
        if strcmp(TargetNL(i).WarsList(j).Attacker.RulerName,TargetNL(i).RulerName)
            wslots(i,2) = wslots(i,2) + 1;
        elseif strcmp(TargetNL(i).WarsList(j).Defender.RulerName,TargetNL(i).RulerName)
            wslots(i,3) = wslots(i,3) + 1;
        end
    end
    natstr = [TargetNL(i).RulerName ' of ' TargetNL(i).NationName];
    slstr = [num2str(slots(i,2)) ' -- ' num2str(slots(i,3))];
    wslstr = [num2str(wslots(i,2)) ' -- ' num2str(wslots(i,3))];
    attslstr = [num2str(offnum_above) ' -- ' num2str(offnum_all)];
    NatSheet(i+2,:) = {i, natstr, TargetNL(i).NS, TargetNL(i).Tech,TargetNL(i).Infra, TargetNL(i).Nukes, slstr, wslstr, attslstr, warpe, NationLink(TargetNL(i))};
end

if nnz(slots) == 0
    NatSheet{2,7} = 'NO AID DATA';
end
% datetaken = max(PropertyArray(TargetNL,'StatDateTaken'));
% disp(NatSheet)
warning off MATLAB:xlswrite:AddSheet
xlswrite('AllianceCheck.xls',NatSheet,TargetNL(1).Alliance)

