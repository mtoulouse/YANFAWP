function mll = MessageLinkList(NatL)
% MESSAGELINKLIST makes a list of PM messaging links for a Nation array.
mll = {};
for i = 1:length(NatL)
    mll = [mll;MessageLink(NatL(i))];
end
end