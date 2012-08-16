AA = 'New Sith Order';
NL = CreateNameList(AA);
% AL = CreateAidList(AA);
WL = CreateWarList(AA);
% AL = RemoveExpired(AL);
WL = ActiveWars(WL);
CombineLists(NL,WL);
%%
GNN = CreateNameList('Goon Order of Oppression Negligence and Sadism');
GNW = CreateWarList('Goon Order of Oppression Negligence and Sadism');
GNW = ActiveWars(GNW);
CombineLists(GNN,GNW);
%%
% [slot_usage slot_perc slot_scoring] = SlotUsagePM(NL,128,42)
TargetList(NL)
%%
numinrange = zeros(size(NL));
defnum = 3*ones(size(NL)); % open slots
for i = 1:length(NL)
    for j = 1:length(NL(i).WarsList)
        if strcmp(NL(i).WarsList(j).Defender.RulerName,NL(i).RulerName)
            defnum(i) = defnum(i) - 1;
        end
    end
    if NL(i).Mode == 0
        defnum(i) = 0;
    end
    numinrange(i) = length(InRange(GNN,NL(i).NS,'above'));
end
NSS = PropertyArray(NL,'NS');
subplot(2,1,1)
plot(NSS/1000,defnum,'.')
xlabel('NS, 1000''s')
ylabel('Open defensive slots')
title('Open defensive slots of NSO nations')
subplot(2,1,2)
plot(NSS/1000,numinrange,'.-')
xlabel('NS, 1000''s')
ylabel('# of nations')
title('# of GOONS nations in range, above the target''s NS')