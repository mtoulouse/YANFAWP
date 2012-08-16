function AList = CreateAidList(varargin)
% CREATEAIDLIST Parses aid list page source to create an array of aid
% objects.
%   CREATEAIDLIST takes the page source from htm files with the AA name and
%   "aidsource" and extracts all the useful information from it, storing it
%   in a list of Aid objects.
tic
AA = varargin{1};
pick_latest_entry = 0;
if nargin == 2
    pick_latest_entry = varargin{2};
end
AList = [];
% find all the relevant files to open, make a list
fil = dir([pwd '\AAsources']);
finf = [];
for d = 1:length(fil)
    patt = [AA ' (\d+T\d+) aidsource (\d+).htm'];
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
        'PromptString','Aid source: storage date (local time)',...
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
disp([AA ' - Creating aid list'])
for d = 1:length(sourcefile);
    fid = fopen(sourcefile{d}); % open the htm file
    A = Aid.empty;
    datetaken = [];
    counter = 0;
    l_num = 0;
    memoflag = 0;
    amtflag = 0;
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
        if isempty(datetaken) % no date of data extraction found yet?
            v = strfind(tline, 'M</td>'); % look for date
            if ~isempty(v)
                datetaken = datenum(datevec(tline(1:v)));
            end
        end
        % Find date of aid
        n = strfind(tline, 'M</font>');
        if ~isempty(n)
            counter = counter + 1;
            A(counter) = Aid;
            A(counter).StatDateTaken = datetaken;
            A(counter).DateAided = datenum(datevec(tline(1:n)));
            memoflag = 1;
        end
        % Find aid reason
        if memoflag == 1
            FF = regexp(tline,'"(.+)"','tokens');
            if ~isempty(FF)
                FF = FF{1};
                A(counter).Memo = FF{1};
                memoflag = 0;
            end
        end
        % Find a nation and its team, create an aid object
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
            VV = regexp(P,'ID=(\d+)">(.+)</a><br>Ruler: (.+)<br>','tokens');
            % Find nation ID, name, ruler, alliance if it's none (else it
            % shows up later)
            if ~isempty(VV)
                VV = VV{1};
                NAT.ID = str2double(VV{1});
                NAT.NationName = VV{2};
                NAT.RulerName = VV{3};
                rul_flag = 0;
                unalig = strfind(P, 'Alliance: None');
                if ~isempty(unalig)
                    NAT.Alliance = 'None';
                    if isempty(A(counter).Sender)
                        A(counter).Sender = NAT;
                    else
                        A(counter).Receiver = NAT;
                    end
                    allyflag = 0;
                else
                    allyflag = 1;
                end
                P = [];
            end
        end
        % Find nation alliance, assign nation object to sender or receiver
        % slot in aid object.
        srch = strfind(tline, 'search_aid.asp?');
        if ~isempty(srch) && allyflag == 1
            JJ = regexp(tline,'search=(.+)&amp','tokens');
            JJ = JJ{1};
            NAT.Alliance = regexprep(JJ{1},'%20',' ');
            if isempty(A(counter).Sender)
                A(counter).Sender = NAT;
            else
                A(counter).Receiver = NAT;
            end
            allyflag = 0;
        end
        % Find amount info for aid ($$,tech,soldiers)
        dolla = strfind(tline, '$');
        if ~isempty(dolla)
            fakedolla = strfind(tline, '#$%');
            if isempty(fakedolla)
                amtflag = 1;
                A(counter).Amount.Money = str2double(regexprep(tline,'\D',''));
            end
        end
        nerd = strfind(tline, 'Tech');
        if ~isempty(nerd) && amtflag == 1
            A(counter).Amount.Tech = str2double(regexprep(tline,'\D',''));
        end
        troop = strfind(tline, 'Soldiers');
        if ~isempty(troop) && amtflag == 1
            A(counter).Amount.Soldiers = str2double(regexprep(tline,'\D',''));
            amtflag = 0;
        end
        % Find aid status (approved, pending, expired, etc.)
        sta = strfind(tline,'<font color="#');
        if ~isempty(sta)
            KK = regexp(tline,'<font color="#\d+">(\w+)</font>','tokens');
            if ~isempty(KK)
                KK = KK{1};
                A(counter).Status = KK{1};
                B2 = datestr(A(counter).StatDateTaken,1);
                B1 = datestr(A(counter).DateAided,1);
                if daysact(B1,B2) >= 10
                    A(counter).Status = 'Expired';
                end
            end
        end
    end
    disp(['Aid file ' num2str(d) ' - taken ' datestr(datetaken,'mmm-dd HH:MM:SS PM') ' game time'])
    fclose(fid); % Close the current file (memory leaks make me sad)
    AList = [AList A];
end
disp('Removing Applicants')
% Aid listings in CN go by name search, so this removes any entries that
% aren't exactly the same as the specified AA name. In practice, this
% removes entries for applicant AAs, if the other aid party is also non-AA.
ri = [];
for i = 1:length(AList)
    Smatch = strcmpi(AA,AList(i).Sender.Alliance);
    Rmatch = strcmpi(AA,AList(i).Receiver.Alliance);
    if ~(Smatch || Rmatch)
        disp(['ALERT: ' AList(i).Sender.Alliance ' to ' AList(i).Receiver.Alliance])
        ri = [ri i];
    end
end
% remove the offending entries
AList(ri) = [];
disp([num2str(length(ri)) ' aid entries removed'])
disp([num2str(toc) ' seconds for aid list'])
end