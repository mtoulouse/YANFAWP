function uni = SimpleMessagingList(varargin)
% SIMPLEMESSAGINGLIST General PM messaging list
% SIMPLEMESSAGINGLIST takes an array of nation objects and spits out an 
% alphabetized PM list without repeats.
if nargin == 1
    NList = varargin{1};
    linkflag = 0;
else
    NList = varargin{1};
    linkflag = varargin{2};
end
if isempty(NList)
    uni = 0;
    return
end
datetaken = max(PropertyArray(NList,'StatDateTaken'));
[namelist,m,n] = unique(PropertyArray(NList,'RulerName'));
linklist = MessageLinkList(NList);
nlinklist = NationLinkList(NList);

disp(['Date taken (game time): ' datestr(datetaken)])
num = length(namelist);
for i = 1:num
    cnam = namelist{i};
    if linkflag
        m_link = nlinklist{m(i)};
    else
        m_link = linklist{m(i)};
    end
    if mod(i,26) == 1
        disp('   ')
        disp(['[url=' m_link ']' cnam '[/url]'])
    else
        if ~linkflag
            disp(cnam)
        else
            disp(['[url=' m_link ']' cnam '[/url]'])
        end
    end
end
uni = length(namelist);
disp(['[i]' num2str(uni) ' unique names[/i]'])