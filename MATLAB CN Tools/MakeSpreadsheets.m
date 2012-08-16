function MakeSpreadsheets(NL,AL)
% This is just a demo platform for how to export info to a xls spreadsheet.
% You could choose to copy and paste the result into Google Docs or
% something for an easy-make auditing sheet.
%
% Spreadsheet looks something like this:
% Data taken on DATE						
% Ruler | Link | NS | Tech | Infra | Nukes | 20+ Days? | Slots(S--R) | 1 | 2 | 3 | 4 | 5 | 6
% then a list of all the nations like below
% Me | url | 20000 | 1000 | 3999 | 0 | (blank) | 4--2 | S - 3m | R - 50t | S - 3m,2000s | R - 50t | S - 3m | S - 3m | S - 3m | 
numnat = length(NL);
numaid = length(AL);
NatSheet = cell(numnat+2,14);
ndatetaken = max(PropertyArray(NL,'StatDateTaken'));
NatSheet{1,1} = ['Data taken on ' datestr(ndatetaken) ' (game time)'];
NatSheet(2,:) = {'Ruler Name'	'Nation Link'	'NS'	'Tech'	'Infra'	'Nukes'	'20+ days'	'Slots(S--R)' '1' '2' '3' '4' '5' '6'};
for i = 1:length(NL)
    if daysact(datestr(NL(i).LastActivity,1),datestr(NL(i).StatDateTaken,1)) > 20
        twen = 'Yes';
    else
        twen = [];
    end
    slots(i,1) = length(NL(i).AidsList);
    slots(i,2) = 0;
    slots(i,3) = 0;
    slinf = cell(1,6);
    for j = 1:slots(i,1)
        if strcmp(NL(i).AidsList(j).Sender.RulerName,NL(i).RulerName)
            slots(i,2) = slots(i,2) + 1;
            astr = ['S - '];
        elseif strcmp(NL(i).AidsList(j).Receiver.RulerName,NL(i).RulerName)
            slots(i,3) = slots(i,3) + 1;
            astr = ['R - '];
        end
        dol = NL(i).AidsList(j).Amount.Money;
        tol = NL(i).AidsList(j).Amount.Tech;
        sol = NL(i).AidsList(j).Amount.Soldiers;
        if dol == 3e6
            astr = [astr '$3m'];
        elseif dol ~= 0
            astr = [astr '$' num2str(dol)];
        end
        if tol > 0 && dol ~= 0
                astr = [astr ',' num2str(tol) 't'];
        elseif tol > 0 && dol == 0
            astr = [astr num2str(tol) 't'];
        end
        if sol > 0 && (dol ~= 0 || tol > 0)
                astr = [astr ',' num2str(sol) 's'];
        elseif sol > 0 && ~(dol ~= 0 || tol > 0)
            astr = [astr num2str(sol) 's'];
        end
        slinf{j} = astr;
    end
    slstr = [num2str(slots(i,2)) ' -- ' num2str(slots(i,3))];
    NatSheet(i+2,:) = [{NL(i).RulerName, NationLink(NL(i)), NL(i).NS, NL(i).Tech,NL(i).Infra, NL(i).Nukes, twen,slstr} slinf];
end
adatetaken = max(PropertyArray(AL,'StatDateTaken'));

warning off MATLAB:xlswrite:AddSheet
xlswrite('AllianceCheck.xls',NatSheet,'Nations')

