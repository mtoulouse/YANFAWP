j = 500:500:70000;
AA = 'Goon Order of Oppression Negligence and Sadism';
for t = 1:5
    GNN{t} = CreateNameList(AA);
    for i = 1:length(j)
        k(i,t) = length(InRange(GNN{t},j(i),'above'));
        kstr{t} = ['GOONS: ' datestr(GNN{t}(1).StatDateTaken)];
    end
end
plot(j/1000,k,'.-')
% title(['Nations in war range of a target NS: ' NL(1).Alliance])
% title('Nations in war range of a target NS')
title('Nations in war range above a target NS')
ylabel('Number of nations')
xlabel('Target NS, in 1000''s')
legend(kstr)
set(gca,'XTick',0:5:90)
set(gca,'YTick',0:5:60)
% grid
%%
figure(1);
for t = 1:length(GNN)
    plot(j/1000,k(:,t),'k.-');
    xlim([0 70])
    ylim([0 50])
    title(['Nations in war range above a target NS - ' kstr{t}])
    ylabel('Number of nations')
    xlabel('Target NS, in 1000''s')
    legend(num2str(t))
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

%%
A = GOONS;
D = NPO;
% k = 14;
% k = find(strcmp(PropertyArray(GOONS,'RulerName'),'dalstrs'));
% k = find(PropertyArray(GOONS,'ID')==323777);
perc_below = [];
mean_advant = [];
for k = 1:length(A)
    if mod(k,25) == 0
        disp(['-------- NS = ' num2str(A(k).NS) ' --------'])
    end
    InR = InRange(D,A(k).NS); % list of defenders in the individual attacker's range
    Te = PropertyArray(InR,'Tech'); % tech of the list of defenders
    numIR = length(InR);
    mean_advant(k) = mean(Te)-A(k).Tech;
    morT_ind = find(Te>A(k).Tech);
    nummorT = length(morT_ind);
    mean_morT_advant = mean(Te(morT_ind))-A(k).Tech;
    if mean_advant(k)>0
        ma_str = ['+' num2str(mean_advant(k))];
    else
        ma_str = num2str(mean_advant(k));
    end
    perc_below(k) = (1-nummorT/numIR)*100;
    inf_str = [num2str(k) '. ' A(k).RulerName ': ' num2str(nummorT) '/' num2str(numIR) ' (' num2str(perc_below(k)) '%) [' ma_str ' / ' num2str(mean_morT_advant) ']'];
    if perc_below(k)<50
        disp(['[b]' inf_str '[/b]'])
    else
        disp(inf_str)
    end
end
figure;
plot(perc_below,'.')
xlabel('Nation rank')
ylabel('Tech Percentile')
title('Percentage of enemies in range with less tech than you')

figure;
set(gcf,'Position',Center_Fig(400,600))
plot(mean_advant,'.')
xlabel('Nation rank')
ylabel('Enemy tech advantage')
title('Average tech advantage of nations in range')


% disp(['Ruler Name: ' GOONS(k).RulerName])
% disp([num2str(length(A)) ' nations in range, averaging ' num2str(mean(Te)-GOONS(k).Tech) ' tech compared to you'])
% disp([num2str(nnz(Te>GOONS(k).Tech)) '/' num2str(length(A)) ...
%     ' nations with more tech than you (' num2str(nnz(Te>GOONS(k).Tech)/length(A)*100)...
%     '%) , averaging '
%     num2str(mean(Te(find(Te>GOONS(k).Tech)))-GOONS(k).Tech) ' more tech
%     than you'])
