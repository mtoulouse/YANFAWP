% demo platform for the initial parsing of the page sources. Make sure your
% current directory contains the parsing functions. It's that box at the
% top, or alternatively something like 
% >> cd('C:\Users\<username>\Desktop\CN Tool Pack')

AA = 'Goon Order of Oppression Negligence and Sadism';
GNN = CreateNameList(AA);
GNA = CreateAidList(AA);
GNW = CreateWarList(AA);
GNA = RemoveExpired(GNA);
GNW = ActiveWars(GNW);
CombineLists(GNN,GNA,GNW);

AW = ActiveWars(GNW);
% Q = AidCount(GNA,AA,5);
%%
AA = 'Mushroom Kingdom';
MKN = CreateNameList(AA);
MKA = CreateAidList(AA);
MKA = RemoveExpired(MKA);
CombineLists(MKN,MKA);
%%
AA = 'Umbrella';
UMN = CreateNameList(AA);
UMA = CreateAidList(AA);
UMA = RemoveExpired(UMA);
CombineLists(UMN,UMA);
% Q = AidCount(UMA,AA,5);

%%
FM_num = 191;
DRA_num = 64;
[slot_usage slot_perc slot_scoring] = SlotUsagePM(GNN,FM_num,DRA_num)
%%
% plot war range member count
j = 1000:1000:150000;
for i = 1:length(j)
    k1(i) = length(InRange(GNN,j(i),'above'));
    k2(i) = length(InRange(MKN,j(i),'above'));
    k3(i) = length(InRange(UMN,j(i),'above'));
end
plot(j/1000,k1,'.-',j/1000,k2,'.-',j/1000,k3,'.-',j/1000,k1+k2+k3,'.-')
% title(['Nations in war range of a target NS: ' NL(1).Alliance])
% title('Nations in war range of a target NS')
title('Nations in war range above a target NS')
ylabel('Number of nations in range (above)')
xlabel('Target NS, in 1000''s')
legend('GOONS','MK','UMB','GOONS+MK+UMB')

% RR = PropertyArray(AL,'Receiver');
% SimpleMessagingList(RR);
% SS = PropertyArray(AL,'Sender');
% SimpleMessagingList(SS);
%%
AA = 'Goon Order of Oppression Negligence and Sadism';
GNN = CreateNameList(AA);
%%
AA = 'Umbrella';
UMN = CreateNameList(AA);
%%
AA = 'Viridian Entente';
VEN = CreateNameList(AA);
%%
AA = 'FOK';
FON = CreateNameList(AA);
%%
AA = 'IFOK';
IFON = CreateNameList(AA);
%%
AA = 'Poison Clan';
PCN = CreateNameList(AA);
%%
j = 1000:500:150000;
for i = 1:length(j)
    k1(i) = length(InRange(UMN,j(i),'above'));
    k2(i) = length(InRange(PCN,j(i),'above'));
    k3(i) = length(InRange(FON,j(i),'above'));
    k4(i) = length(InRange(VEN,j(i),'above'));
    k5(i) = length(InRange(IFON,j(i),'above'));
    k6(i) = length(InRange(GNN,j(i),'above'));
end
plot(j/1000,k1,'.-k',j/1000,k2,'.-',j/1000,k3,'.-c',...
    j/1000,k4,'.-',j/1000,k5,'.-',j/1000,k6,'.-',...
    j/1000,k1+k2+k3+k4+k5+k6,'.-m')
% title(['Nations in war range of a target NS: ' NL(1).Alliance])
% title('Nations in war range of a target NS')
title('Nations in war range above a target NS')
ylabel('Number of nations')
xlabel('Target NS, in 1000''s')
legend('UMB','PC','FOK','VE','IFOK',':((','GAYROLLER')
% set(gca,'XTick',0:5:140)
% set(gca,'YTick',0:1:25)
%%

figure(1);
for t = 1:5
    plot(j/1000,k(:,t),'k.-');
    xlim([0 70])
    ylim([0 50])
    title(['Nations in war range above a target NS: ' kstr{t}])
    ylabel('Number of nations')
    xlabel('Target NS, in 1000''s')
    grid
    set(gcf, 'Color' ,'w');
%     set(gca,'nextplot','replacechildren','visible','off')
    Q(t) = getframe(figure(1));
    [X{t},Map] = frame2im(Q(t));
    [X{t},map] = rgb2ind(X{t},16,'nodither');
    W(:,:,1,t) = X{t};
end
fnam = 'C:\Users\Michael Toulouse\Desktop\YF-CNplots\GOONSprogression.gif';
imwrite(W,map,fnam,'gif','DelayTime',0.6,'LoopCount',Inf)
