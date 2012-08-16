NPO = CreateNameList('New Pacific Order');
GOONS = CreateNameList('Goon Order Of Oppression Negligence and Sadism');
MK = CreateNameList('Mushroom Kingdom');
UMB = CreateNameList('Umbrella');

NPO_A = CreateAidList('New Pacific Order');
GOONS_A = CreateAidList('Goon Order Of Oppression Negligence and Sadism');
MK_A = CreateAidList('Mushroom Kingdom');
UMB_A = CreateAidList('Umbrella');

NPO_W = CreateWarList('New Pacific Order');
GOONS_W = CreateWarList('Goon Order Of Oppression Negligence and Sadism');
MK_W = CreateWarList('Mushroom Kingdom');
UMB_W = CreateWarList('Umbrella');

NPO_A = RemoveExpired(NPO_A);
NPO_W = ActiveWars(NPO_W);
CombineLists(NPO,NPO_A,NPO_W);
% CombineLists(NPO,NPO_W);

GOONS_A = RemoveExpired(GOONS_A);
GOONS_W = ActiveWars(GOONS_W);
CombineLists(GOONS,GOONS_A,GOONS_W);
% CombineLists(GOONS,GOONS_W);

MK_A = RemoveExpired(MK_A);
MK_W = ActiveWars(MK_W);
CombineLists(MK,MK_A,MK_W);
% CombineLists(MK,MK_W);

UMB_A = RemoveExpired(UMB_A);
UMB_W = ActiveWars(UMB_W);
CombineLists(UMB,UMB_A,UMB_W);
% CombineLists(UMB,UMB_W);
%%
    GOONS = CreateNameList('Goon Order Of Oppression Negligence and Sadism',1);
    GOONS_A = CreateAidList('Goon Order Of Oppression Negligence and Sadism',1);
    GOONS_W = CreateWarList('Goon Order Of Oppression Negligence and Sadism',1);
    GOONS_A = RemoveExpired(GOONS_A);
    GOONS_W = ActiveWars(GOONS_W);
    CombineLists(GOONS,GOONS_A,GOONS_W);
%%
for i = 1:2
    GOONS{i} = CreateNameList('Goon Order Of Oppression Negligence and Sadism');
    GOONS_A{i} = CreateAidList('Goon Order Of Oppression Negligence and Sadism');
    GOONS_W{i} = CreateWarList('Goon Order Of Oppression Negligence and Sadism');
    GOONS_A{i} = RemoveExpired(GOONS_A{i});
    GOONS_W{i} = ActiveWars(GOONS_W{i});
    CombineLists(GOONS{i},GOONS_A{i},GOONS_W{i});
end
%%

[slot_usage slot_perc slot_scoring] = SlotUsagePM(GOONS{2},252,55);

%%
%  NPO+NSO+Invicta+CoJ+TPF+NATO
% N = CreateNameList('New Pacific Order');

for i = 1:1
    NPO{i} = CreateNameList('New Pacific Order');
    NPO_A{i} = CreateAidList('New Pacific Order');
    NPO_W{i} = CreateWarList('New Pacific Order');
    NPO_A{i} = RemoveExpired(NPO_A{i});
    NPO_W{i} = ActiveWars(NPO_W{i});
    CombineLists(NPO{i},NPO_A{i},NPO_W{i});
end
%%
[slot_usage slot_perc slot_scoring] = SlotUsagePM(NPO{1},433,221);

%%
d1 = datestr(UNI1(1).StatDateTaken);
d2 = datestr(UNI2(1).StatDateTaken);
[W,ind] = sort(PropertyArray(UNI1,'NS'),'descend');
UNI1 = UNI1(ind);
for i = 1:length(UNI1)
    Q1(i) = UNI1(i).NS;
    j = find(PropertyArray(UNI2,'ID') == UNI1(i).ID);
    Q2(i) = UNI2(j).NS;
end
figure
hold all
plot(Q1,'.')
plot(Q2,'.')
xlabel('Initial Nation Rank')
ylabel('Nation Strength')
title('Current and Initial Nation Strength')
legend(d1,d2)
hold off

figure

plot(Q2-Q1,'.')
xlabel('Initial Nation Rank')
ylabel('Change in NS')
title(['Change in NS between ' d1 ' and ' d2])

% Create a plot comparing the former and current NS of the common members
%%

W = zeros(3,2);
Y = zeros(3,1);
for i = 1:length(GOONS_A)
    if strcmpi(GOONS_A(i).Sender.Alliance,'Umbrella')
        W(1,1) = W(1,1) + GOONS_A(i).Amount.Money;
        W(2,1) = W(2,1) + GOONS_A(i).Amount.Tech;
        W(3,1) = W(3,1) + GOONS_A(i).Amount.Soldiers;
    elseif strcmpi(GOONS_A(i).Sender.Alliance,'Mushroom Kingdom')
        W(1,2) = W(1,2) + GOONS_A(i).Amount.Money;
        W(2,2) = W(2,2) + GOONS_A(i).Amount.Tech;
        W(3,2) = W(3,2) + GOONS_A(i).Amount.Soldiers;
    end
    if strcmpi(GOONS_A(i).Receiver.Alliance,GOONS(1).Alliance)
        Y(1) = Y(1) + GOONS_A(i).Amount.Money;
        Y(2) = Y(2) + GOONS_A(i).Amount.Tech;
        Y(3) = Y(3) + GOONS_A(i).Amount.Soldiers;
    end
end
% X = zeros(3,1);
% for j = 1:length(NPO_A)
%     if strcmpi(NPO_A(j).Receiver.Alliance,'New Pacific Order')
%         X(1,1) = X(1,1) + NPO_A(j).Amount.Money;
%         X(2,1) = X(2,1) + NPO_A(j).Amount.Tech;
%         X(3,1) = X(3,1) + NPO_A(j).Amount.Soldiers;
% %         if NPO_A(j).Amount.Money > 0
% %             disp(['Sender AA: ' NPO_A(j).Sender.Alliance])
% %         end
%     end
% end
disp(['Between ' datestr(GOONS_A(end).DateAided) ' and ' datestr(GOONS_A(end).StatDateTaken) ' game time'])
disp(['Umbrella aided GOONS [b]' num2str(W(1,1)) '[/b] dongs and [b]' num2str(W(3,1)) '[/b] soldiers'])
disp(['Mushroom Kingdom aided GOONS [b]' num2str(W(1,2)) '[/b] dongs and [b]' num2str(W(3,2)) '[/b] soldiers'])
disp(['Members of GOONS were aided [b]' num2str(Y(1)) '[/b] dongs and [b]' num2str(Y(3)) '[/b] soldiers'])
% disp(['Between ' datestr(NPO_A(end).DateAided) ' and ' datestr(NPO_A(end).StatDateTaken) ' game time'])
% disp(['Members of New Pacific Order were aided [b]' num2str(X(1,1)) '[/b] dollars and [b]' num2str(X(3,1)) '[/b] soldiers'])
%%
NL = GOONS;
WL = GOONS_W;
warid = [];
for i = 1:length(WL)
    if strcmp(WL(i).Defender.Alliance,NL(1).Alliance)
        warid = [warid; WL(i).Attacker.ID];
    end
end
warid = sort(warid);
[n,xout]=hist(warid,unique(warid));
disp(['The following nations have three offensive wars against ' NL(1).Alliance ' as of ' datestr(WL(1).StatDateTaken) ' game time:'])
for j = 1:length(n)
    if n(j) == 3
        GHB = WL(find(PropertyArray(PropertyArray(WL,'Attacker'),'ID') == xout(j),1)).Attacker;
        disp(['[url=' NationLink(GHB) ']' GHB.RulerName ' of ' GHB.NationName ' - ' GHB.Alliance '[/url]']);
    end
end
