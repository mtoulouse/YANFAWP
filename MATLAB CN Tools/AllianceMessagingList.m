function AllianceMessagingList(NList)
% ALLIANCEMESSAGINGLIST Color-coded Alliance Messaging List
%   ALLIANCEMESSAGINGLIST takes the array of nation objects and spits out a
%   forum-formatted color-coded PM list. Not alphabetized, but sorted by 
%   NS. Can be edited to do different color divisions or even infra or tech
%   pretty easily.
datetaken = max(PropertyArray(NList,'StatDateTaken'));
namelist = PropertyArray(NList,'RulerName');
linklist = MessageLinkList(NList);
NSlist = PropertyArray(NList,'NS');
% Infralist = PropertyArray(NList,'Infra');
% Techlist = PropertyArray(NList,'Tech');
% lastactlist = PropertyArray(NList,'LastActivity');
% seniorlist = PropertyArray(NList,'Seniority');

disp(['Date taken (game time): ' datestr(datetaken)])
disp('  ')
disp('Members by NS')
disp('  ')
disp('Note:')
disp('[color=red]50k+ NS - Frogout Company[/color]')
disp('[color=orange]30k thru 49k NS - Erotic Company[/color]')
disp('[color=yellow]20k thru 29k NS - Downs Company[/color]')
disp('[color=green]10k thru 19k NS - Colbert Company[/color]')
disp('[color=blue]5k thru 9k NS - BYOB Company[/color]')
disp('[color=purple]1k thru 4k NS - Aspie Company[/color]')
disp('[color=black]1k- NS - Newbies[/color]')
D = zeros(1,7);
num = length(namelist);
for i = 1:num
    cnam = namelist{i};
    m_link = linklist{i};
    NS = NSlist(i);
%     Infra = Infralist(i);
%     Tech = Techlist(i);
    switch 1
        case NS>=50000
            company = 1;
            col = 'red';
        case NS<50000 && NS>=30000
            company = 2;
            col = 'orange';
        case NS<30000 && NS>=20000
            company = 3;
            col = 'yellow';
        case NS<20000 && NS>=10000
            company = 4;
            col = 'green';
        case NS<10000 && NS>=5000
            company = 5;
            col = 'blue';
        case NS<5000 && NS>=1000
            company = 6;
            col = 'purple';
        case NS<1000
            company = 7;
            col = 'black';
    end
    D(company) = D(company) + 1;
    % displays a messaging link url instead for every 26th name. Click the
    % PM link, paste the next 25 names into CC, rinse, repeat.
    
    if mod(D(company),26) == 1
        disp('   ')
        disp(['[url=' m_link ']' cnam '[/url]'])
    else
        disp(['[color=' col ']' cnam '[/color]'])
    end
end
% Gives a quick count of the number of nations in each division.
disp(' ')
disp('[b]Company count:[/b]')
disp(['Frogout:' num2str(D(1))])
disp(['Erotic:' num2str(D(2))])
disp(['Downs:' num2str(D(3))])
disp(['Colbert:' num2str(D(4))])
disp(['BYOB:' num2str(D(5))])
disp(['Aspie:' num2str(D(6))])
disp(['Newbies:' num2str(D(7))])