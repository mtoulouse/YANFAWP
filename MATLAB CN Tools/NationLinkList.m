function mll = NationLinkList(NatL)
% NATIONLINKLIST makes a list of nation links for a Nation array.
mll = {};
for i = 1:length(NatL)
    mll = [mll;NationLink(NatL(i))];
end
end