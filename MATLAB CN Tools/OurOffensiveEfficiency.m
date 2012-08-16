function OurOffensiveEfficiency

numnat = length(GNN);
NatSheet = cell(numnat+2,12);
AA = GNN(1).Alliance;
ndatetaken = max(PropertyArray(GNN,'StatDateTaken'));
NatSheet{1,2} = ['Data taken on ' datestr(ndatetaken) ' (game time)'];
NatSheet{1,5} = '# of open target def. slots (below NS)';
NatSheet{1,9} = '# of open target def. slots (in range of NS)';
NatSheet(2,:) = {'#' 'RULER of NATION' 'NS' 'Open Off. Slots' 'Tot' 'NPL' 'GDA' 'MCXA' 'Tot' 'NPL' 'GDA' 'MCXA'};
for i = 1:length(GNN)
    NatSheet{i+2,1} = i;
    NatSheet{i+2,2} = GNN(i).RulerName;
    NatSheet{i+2,3} = GNN(i).NS;
    openoff = 0;
    for j = 1:length(GNN(i).WarsList)
        if strcmp(GNN(i).WarsList(j).Attacker.RulerName,GNN(i).RulerName)
            openoff = openoff + 1;            
        end
    end
    NatSheet{i+2,4} = openoff;
    for k = 1:length(NPLN)
        if NPLN(k).Mode == 1
            WL = NPLN(k).WarsList;
            for l = 1:length(WL)
                WL(l).RulerName
            end
        end
    end
    NatSheet{i+2,6} = NPL;
    NatSheet{i+2,7} = tot_below;
    NatSheet{i+2,8} = tot_below;    
    
    NatSheet{i+2,5} = tot_below;
%     NatSheet(i+2,:) = {i, natstr, TargetNL(i).NS, TargetNL(i).Tech,TargetNL(i).Infra, TargetNL(i).Nukes, slstr, wslstr, attslstr, warpe, NationLink(TargetNL(i))};
end


% function opendefslots(GNN(i),NPLN,'NPL')
function opendefslots(OurNat,TheirAA,AA_abbr)
    InRangeOurNat.NS

end