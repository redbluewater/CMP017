%plot the XCMS and SkyLine output for one of the metabolites
%KL 3/4/2023
clear all
close all

%this folder will have FindAllWithinError in it
path(path,'C:\Users\klongnecker\Documents\Current projects\Kujawinski_STC\RawData\2023_0215_CMP017\MATLABcode')

T =  readtable('fName_featureQuant_all_pos.txt');

target = 270.1125; %this is derivatized phenylalanine
[idxT idxIn] = FindAllWithinError(target,T.mzmed,5);

figure
subplot(311)
plot(sInfo.fraction,tempData(idxIn,:),'ko')
title('XCMS analysis')
title_up('phenylalanine')
xlabel('run order...close to fraction')
xlim([0.5 28.5])

sky = load('../SkyLine_analysis/CMP017_pos.2023.02.28.mat');

subplot(312)
%idx = 33; %I am cheating and have present the index to match phenylalanein
idx = strcmp(sky.mtabDetails.mtabNames,{'phenylalanine'});
plot(sky.sInfo.fraction,sky.mtabData(idx,:),'bs')
title('SkyLine analysis')
xlabel('fraction')
xlim([0.5 28.5])

subplot(313)
plot(tempData(idxIn,:),sky.mtabData(idx,:),'rs','markerfacecolor','r')
xlabel('XCMS')
ylabel('SkyLine')

%set(gcf,'position',[  -488   286   434   802])
