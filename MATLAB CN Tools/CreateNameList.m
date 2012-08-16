function NList = CreateNameList(varargin)
% CREATENAMELIST Parses nation list page source to create an array of
% Nation objects.
%   CREATENAMELIST takes the page source from htm files with the AA name
%   and "namesource" and extracts all the useful information from it,
%   storing it in a list of Nation objects.
tic
AA = varargin{1};
pick_latest_entry = 0;
if nargin == 2
    pick_latest_entry = varargin{2};
end
NList = [];
% find all the relevant files to open, make a list
fil = dir([pwd '\AAsources']);
finf = [];
for d = 1:length(fil)
    patt = ['\<' AA '\> (\d+T\d+) namesource (\d+).htm'];
    xx = regexpi(fil(d).name,patt,'tokens');
%     disp(fil(d).name)
%     disp(patt)
    if ~isempty(xx)
        fdate = datenum(xx{1}{1},'yyyymmddTHHMM');
        ind = str2double(xx{1}{2});
        finf = [finf; fdate ind d];
    end
end
% create a list dialog box to allow choice of date of storage
[b,m,n] = unique(finf(:,1),'first');
if ~pick_latest_entry
    [S,ok] = listdlg('ListString',cellstr(datestr(b)),...
    'PromptString','Name source: storage date (local time)',...
    'InitialValue',length(b),...
    'ListSize',[250 350],...
    'Name',AA);
else
    disp('Picking latest entry')
    S = length(b);
    ok = 1;
end
if ~ok
    return
else
    R = [];
    for j = 1:length(S)
        R = [R; finf(find(n == S(j)),:)];
    end
    for i = 1:size(R,1)
        sourcefile{R(i,2)} = [pwd '\AAsources\' fil(R(i,3)).name];
    end
end
pause(.25);
%start creating the list
disp([AA ' - Creating name list'])
for d = 1:length(sourcefile);
%     disp(sourcefile{d})
    fid = fopen(sourcefile{d});
    datetaken = [];
    curralliance = [];
    NL = Nation.empty;
    counter = 0;
    while 1
        tline = fgetl(fid); % get the next line of text
        if ~ischar(tline) %blank line?
            break %skip to next line
        end
        % Find date data was taken
        if isempty(datetaken)
            v = strfind(tline, 'M</td>'); % look for date taken
            if ~isempty(v)
                ii = regexp(tline(1:v),'\d+/\d+/\d+','start');
                datetaken = datenum(datevec(tline(ii:v)));
            end
        end
        % Find alliance name for this page
        anam = strfind(tline,'alliance in the online game Cyber Nations');
        if ~isempty(anam)
            LS = regexp(tline,'description: "The (.+) alliance in the online game Cyber Nations','tokens');
            LS = LS{1};
            curralliance = LS{1};
            if ~strcmpi(AA,curralliance)
                disp(AA)
                disp(curralliance)
                disp('input AA doesn''t match page''s supposed AA')
            end
        end
        % Find nation ID, start creating the nation object
        l = strfind(tline, 'Nation" href="nation_drill_display.asp?Nation_ID=');
        if ~isempty(l)
            ll = regexp(tline, 'ID=(\d+)">(.+)</a>','tokens');
            if ~isempty(ll)
                counter = counter + 1;
                ll = ll{1};
                natnam = ll{2};
                id = str2double(ll{1});
                N = Nation(natnam,id);
                N.StatDateTaken = datetaken;
                N.Alliance = curralliance;
                NL(counter) = N;
            end
        end
        % Find ruler name
        k = strfind(tline, 'Ruler:'); % look for ruler
        if ~isempty(k)
            rulername = regexp(tline,'"Ruler: ([^"]+)"','tokens');
            rulername = rulername{1};
            rulername = rulername{1};
            NL(counter).RulerName = rulername;
        end
        % Find nuke count if present
        nk = strfind(tline, 'Nukes:');
        if ~isempty(nk)
            JJ = regexp(tline,'"Nukes: (\d+)"','tokens');
            JJ = JJ{1};
            NL(counter).Nukes = str2double(JJ{1});
        end
        % Find NS/Infra/Tech or last activity/seniority dates
        q = strfind(tline, '</center></td><td><center>');
        if ~isempty(q)
            r = strfind(tline, 'AM');
            s = strfind(tline, 'PM');
            if isempty(r) && isempty(s)
                E1 = regexp(regexprep(tline, ',', ''),'>(\d*.\d+)</','tokens');
                NS = str2double(E1{1});
                Infra = str2double(E1{2});
                Tech = str2double(E1{3});
                NL(counter).NS = NS;
                NL(counter).Infra = Infra;
                NL(counter).Tech = Tech;
            else
                EE = regexprep(tline,'</?\w+>','');
                FF = regexp(EE,'(\d+/\d+/\d+ \d+:\d+:\d+ [AP]M)(\d+)Days','tokens');
                FF = FF{1};
                lastact = datenum(datevec(FF{1}));
                NL(counter).LastActivity = lastact;
                seniority = str2double(FF{2});
                NL(counter).Seniority = seniority;
            end
        end
        % Find war/peace mode
        y = strfind(tline, 'War is an option');
        z = strfind(tline, 'Peaceful Nation');
        if ~isempty(y)
            NL(counter).Mode = 1;
        end
        if ~isempty(z)
            NL(counter).Mode = 0;
        end
        % Find team color
        tm = strfind(tline, 'title="Team:');
        if ~isempty(tm)
            GG = regexp(tline,'Team: (\w+)"','tokens');
            GG = GG{1};
            NL(counter).Team = GG{1};
        end
    end
    disp(['Name file ' num2str(d) ' - taken ' datestr(datetaken,'mmm-dd HH:MM:SS PM') ' game time'])
    fclose(fid); % Close current file
    NList = [NList NL];
end
disp([num2str(toc) ' seconds for nation list'])
end