function WList = CreateWarList(varargin)
% CREATEWARLIST Parses war list page source to create an array of War
% objects.
%   CREATEWARLIST takes the page source from htm files with the AA name
%   and "warsource" and extracts all the useful information from it,
%   storing it in a list of War objects.
tic
AA = varargin{1};
pick_latest_entry = 0;
if nargin == 2
    pick_latest_entry = varargin{2};
end
WList = [];
% find all the relevant files to open, make a list
fil = dir([pwd '\AAsources']);
finf = [];
for d = 1:length(fil)
    patt = [AA ' (\d+T\d+) warsource (\d+).htm'];
    xx = regexpi(fil(d).name,patt,'tokens');
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
        'PromptString','War source: storage date (local time)',...
        'InitialValue',length(b),...
        'ListSize',[250 250],...
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
disp([AA ' - Creating war list'])
for d = 1:length(sourcefile);
    fid = fopen(sourcefile{d});
    W = War.empty;
    datetaken = [];
    counter = 0;
    l_num = 0;
    memoflag = 0;
    allyflag = 0;
    team_flag = 0;
    rul_flag = 0;
    while 1
        tline = fgetl(fid); % get the next line of text
        l_num = l_num + 1;
        if ~ischar(tline) %blank line?
            break %skip to next line
        end
        % Find date data was gathered
        if isempty(datetaken)
            v = strfind(tline, 'M</td>'); % look for date
            if ~isempty(v)
                datetaken = datenum(datevec(tline(1:v)));
            end
        end
        % Find date of war declaration
        n = strfind(tline, 'M</font>'); %
        if ~isempty(n)
            counter = counter + 1;
            W(counter) = War;
            W(counter).StatDateTaken = datetaken;
            W(counter).DateDeclared = datenum(datevec(tline(1:n)));
            memoflag = 1;
        end
        % Find war reason
        if memoflag == 1
            FF = regexp(tline,'"(.+)"','tokens');
            if ~isempty(FF)
                FF = FF{1};
                W(counter).Memo = FF{1};
                memoflag = 0;
            end
        end
        % Find team color of nation, create a nation object
        tm = strfind(tline, 'title="Team:');
        if ~isempty(tm)
            GG = regexp(tline,'Team: (\w+)"','tokens');
            GG = GG{1};
            color = GG{1};
            NAT = Nation();
            NAT.Team = color;
            team_flag = 1;
        end
        % Find nation ID, start putting together the next few lines
        % together to parse all at once
        natid = strfind(tline, '"nation_drill_display.asp?Nation_ID=');
        if ~isempty(natid) && team_flag == 1
            P = tline;
            team_flag = 0;
            rul_flag = 1;
            nat_lnum = l_num;
        end
        if rul_flag == 1 && nat_lnum == l_num - 1;
            P = [P tline];
        end
        if rul_flag == 1 && nat_lnum == l_num - 2;
            P = [P tline];
            VV = regexp(P,'ID=(\d+)">\s?(.+)</a> ?<br>Ruler: (.+)<br>','tokens');
            if ~isempty(VV)
                VV = VV{1};
                NAT.ID = str2double(VV{1});
                NAT.NationName = VV{2};
                NAT.RulerName = VV{3};
                rul_flag = 0;
                unalig = strfind(P, 'Alliance: None');
                if ~isempty(unalig)
                    NAT.Alliance = 'None';
                    if isempty(W(counter).Attacker)
                        W(counter).Attacker = NAT;
                    else
                        W(counter).Defender = NAT;
                    end
                    allyflag = 0;
                else
                    allyflag = 1;
                end
                P = [];
            end
        end
        % Find nation alliance, assign nation object to attacker or
        % defender slot in war object.
        srch = strfind(tline, 'search_wars.asp?');
        if ~isempty(srch) && allyflag == 1
            JJ = regexp(tline,'search=(.+)&amp','tokens');
            JJ = JJ{1};
            NAT.Alliance = regexprep(JJ{1},'%20',' ');
            if isempty(W(counter).Attacker)
                W(counter).Attacker = NAT;
            else
                W(counter).Defender = NAT;
            end
            allyflag = 0;
        end
        % Find war status (fighting, peaced, expired)
        CF = strfind(tline,'Currently Fighting');
        PD = strfind(tline,'Peace Declared');
        WE = strfind(tline,'War Expired');
        if ~isempty(CF) || ~isempty(PD) || ~isempty(WE)
            if ~isempty(CF)
                W(counter).Status = 'Fighting';
            elseif ~isempty(PD)
                W(counter).Status = 'Peaced';
            elseif ~isempty(WE)
                W(counter).Status = 'Expired';
            end
            B2 = datestr(W(counter).StatDateTaken,1);
            B1 = datestr(W(counter).DateDeclared,1);
            if daysact(B1,B2) >= 10
                W(counter).Status = 'Expired';
            end
        end
    end
    disp(['War file ' num2str(d) ' - taken ' datestr(datetaken,'mmm-dd HH:MM:SS PM') ' game time'])
    fclose(fid);% Close the current file
    WList = [WList W];
end
disp('Removing Applicants')
% Similar reasoning to aid listings (see CreateAidList)
ri = [];
for i = 1:length(WList)
    Smatch = strcmpi(AA,WList(i).Attacker.Alliance);
    Rmatch = strcmpi(AA,WList(i).Defender.Alliance);
    if ~(Smatch || Rmatch)
        disp(['ALERT: ' WList(i).Attacker.Alliance ' to ' WList(i).Defender.Alliance])
        ri = [ri i];
    end
end
% remove the offending entries
WList(ri) = [];
disp([num2str(length(ri)) ' war entries removed'])
disp([num2str(toc) ' seconds for war list'])
end