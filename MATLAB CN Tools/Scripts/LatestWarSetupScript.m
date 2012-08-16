% LatestWarSetupScript

AA = 'Goon Order of Oppression Negligence and Sadism';
GNN = CreateNameList(AA);
GNA = CreateAidList(AA);
GNW = CreateWarList(AA);
GNA = RemoveExpired(GNA);
GNW = ActiveWars(GNW);
CombineLists(GNN,GNA,GNW);
% FM 191 DRA 64
%%
AA = 'Fark';
FN = CreateNameList(AA);
FA = CreateAidList(AA);
FW = CreateWarList(AA);
FA = RemoveExpired(FA);
FW = ActiveWars(FW);
CombineLists(FN,FA,FW);
%%
AA = 'Nuclear Proliferation League';
NPLN = CreateNameList(AA);
NPLA = CreateAidList(AA);
NPLW = CreateWarList(AA);
NPLA = RemoveExpired(NPLA);
NPLW = ActiveWars(NPLW);
CombineLists(NPLN,NPLA,NPLW);
% FM 53 DRA 14
%%
AA = 'Global Democratic Alliance';
GDAN = CreateNameList(AA);
GDAA = CreateAidList(AA);
GDAW = CreateWarList(AA);
GDAA = RemoveExpired(GDAA);
GDAW = ActiveWars(GDAW);
CombineLists(GDAN,GDAA,GDAW);
%%
AA = 'Multicolored Cross-X Alliance';
MCXAN = CreateNameList(AA);
MCXAA = CreateAidList(AA);
MCXAW = CreateWarList(AA);
MCXAA = RemoveExpired(MCXAA);
MCXAW = ActiveWars(MCXAW);
CombineLists(MCXAN,MCXAA,MCXAW);
%%
NL = [NPLN GDAN MCXAN]; % list of nations we are attacking
for j = 1:length(GNN)
%     NPLN
    
    posstargets = InRange(NL,GNN(j).NS,'below'); % list of targets below goon's NS in range
    poss_def_slots(j) = 3*length(posstargets);
    for i = 1:length(posstargets)
        if posstargets(i).Mode == 0 % peace mode warrior?
            poss_def_slots(j) = poss_def_slots(j) - 3;
            continue
        end
        for k = 1:length(posstargets(i).WarsList) % check wars of all targets
            if strcmp(posstargets(i).WarsList(k).Defender.RulerName,posstargets(i).RulerName)
                poss_def_slots(j) = poss_def_slots(j) - 1; % target's war is defensive for them?
            end
        end

    end
end
plot(PropertyArray(GNN,'NS'),poss_def_slots,'o')
[PropertyArray(GNN,'RulerName') num2cell(poss_def_slots')]

%%
NSS = PropertyArray(NL,'NS');
subplot(2,1,1)
plot(NSS/1000,defnum,'.')
xlabel('NS, 1000''s')
ylabel('Open defensive slots')
title('Open target defensive slots ')
subplot(2,1,2)
plot(NSS/1000,numinrange,'.')
xlabel('NS, 1000''s')
ylabel('# of nations')
title('# of GOONS nations in range, above the target''s NS')

%%



[UNI1,UNI2] = CompareNationLists(N1,N2)