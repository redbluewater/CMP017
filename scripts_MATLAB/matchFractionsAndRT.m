%find the fraction with the highest concentration...then link that to the RT time
%but, need to ignore the pooled samples, and this is making my head
%explode....
%KL3/1/2023
clear all
close all

figure(100)

subplot(211)
load CMP017_pos.2023.02.28.mat

for a = 1:size(mtabDetails.mtabNames,1)
    maxA = max(mtabData(a,idxSample),[],2);
    k = find(mtabData(a,:)==maxA);
    mtabDetails.fraction(a,1) = sInfo.fraction(k);
    clear maxA k
end
clear a

gscatter(mtabDetails.RT,mtabDetails.fraction,mtabDetails.QCflag,[],[],20)
xlabel('expected RT (min)')
ylabel('LC fraction number (number is ending minute)')
title('Positive ion mode (0=poor BC data, 0.5=questionable BC data)')

subplot(212)
load CMP017_neg.2023.03.01.mat

for a = 1:size(mtabDetails.mtabNames,1)
    maxA = max(mtabData(a,idxSample),[],2);
    k = find(mtabData(a,:)==maxA);
    mtabDetails.fraction(a,1) = sInfo.fraction(k);
    clear maxA k
end
clear a

gscatter(mtabDetails.RT,mtabDetails.fraction,mtabDetails.QCflag,[],[],20)
xlabel('expected RT (min)')
ylabel('LC fraction number (number is ending minute)')
title('Negative ion mode (0=poor BC data, 0.5=questionable BC data)')

title_up('CMP017')

