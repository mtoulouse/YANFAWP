% WL1 = ActiveWars(WL);
% AAL = PropertyArray(PropertyArray(WL,'Attacker'),'Alliance');
AAL = PropertyArray(PropertyArray(WL,'Defender'),'Alliance');
[b m n] = unique(AAL); % unique entries in the AA list, and locations

AA_num = zeros(size(b)); % initialize the AA number counts.
for i = 1:length(WL)
    % count the number of mentions of each AA
    AA_num(n(i)) = AA_num(n(i))+1;
end
if sum(AA_num) ~= length(WL)
    disp('MISMATCH') % total number of slots in the AA list should match
    % the summed slot usage by AA.
end
% note: the "unique" command recognizes capitalization (Umbrella =/=
% umbrella). This section uses case-insensitive comparison to merge these
% cases.
rem_inds = [];
for i = 1:length(b)
    Anam1 = b{i};
    if AA_num(i) % not zeroed?
        for j = 1:length(b)
            Anam2 = b{j};
            if i ~= j && strcmpi(Anam1,Anam2)
                AA_num(i) = AA_num(i) + AA_num(j);
                AA_num(j) = 0;
                rem_inds = [rem_inds j];
            end
        end
    end
end

Q = [b num2cell(AA_num)]; % create table
Q(unique(rem_inds),:) = []; %remove the redundant AA listings
Q = sortrows(Q,-2); % sort descending by slot #.