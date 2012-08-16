function makeplots(varargin)
% MAKEPLOTS plotting demo function
%   MAKEPLOTS is just sort of a demo platform for different possible plots
%   to make.
for i = 1:nargin
    % namelist(i,:) = PropertyArray(varargin{i},'RulerName');
    % linklist(i,:) = MessageLinkList(varargin{i});
    AAnam{i} = inputname(i);
    NSlist{i} = PropertyArray(varargin{i},'NS');
    Infralist{i} = PropertyArray(varargin{i},'Infra');
    Techlist{i} = PropertyArray(varargin{i},'Tech');
    lastactlist{i} = PropertyArray(varargin{i},'LastActivity');
    seniorlist{i} = PropertyArray(varargin{i},'Seniority');
    datetaken{i} = max(PropertyArray(varargin{i},'StatDateTaken'));
end

figure;
%% Tech vs. NS and Tech vs. Rank
subplot(1,2,1)
hold all
for i = 1:nargin
    loglog(NSlist{i},Techlist{i},'.')
end
hold off
title('Tech vs. NS')
xlabel('Nation Strength')
ylabel('Technology Level')
legend(AAnam)
subplot(1,2,2)
hold all
for i = 1:nargin
    semilogy(Techlist{i},'.')
end
hold off
title('Tech vs. Rank')
xlabel('Nation Rank')
ylabel('Technology Level')
legend(AAnam)
%% Tech vs. Infra
figure
hold all
for i = 1:nargin
    loglog(Infralist{i},Techlist{i},'.')
end
hold off
title('Tech vs. Infra')
xlabel('Infrastructure Level')
ylabel('Technology Level')
legend(AAnam)

%% Days since last activity vs. rank
figure;
hold all
maxlen = 0;
for i = 1:nargin
    plot(datetaken{i}-lastactlist{i},'.-')
    maxlen = max(maxlen,length(varargin{i}));
end
hold off
line([1 maxlen],[20 20],'Color','r','LineStyle','--','LineWidth',4)
title('Last Activity vs. Rank')
xlabel('Nation Rank')
ylabel('Days since last activity')
legend(AAnam)
%% Seniority vs. rank
figure;
hold all;
for i = 1:nargin
    plot(seniorlist{i},'.-')
end
hold off;
title('Seniority vs. Rank')
xlabel('Nation Rank')
ylabel('Days in Alliance')
legend(AAnam)

fpos = get(gcf,'Position');
fpos(3) = 800;
set(gcf,'Position',fpos);
%% Activity bars
figure;
for j = 1:nargin
    for i = 1:25
        numunder(i,j) = nnz((datetaken{j}-lastactlist{j})<=i)/length(varargin{j})*100;
    end
end
bar(numunder,'group')
xlabel('% of members active in the last X days')
ylabel('Number of members')
legend(AAnam)