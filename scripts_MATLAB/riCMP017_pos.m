%read in the SkyLine output from CMP017...hack as there is only derivatized
%compound in here, not c13 or d5. All I need is compound and fraction
%number (and peak area I guess)
%KL 2/28/2023
%start with pos mode data as the instrument started having issues by neg mode data
clear all 
close all
NameOfFile = 'CMP017_pos.2023.02.28.mat';

fName = 'CMP017_pos_export.2023.02.28.csv';
% T = readtable(fName,'TreatAsMissing','#N/A'); %must be newer command, not
% working
T = readtable(fName); 
clear fName
s = strcmp(T.TotalArea,'#N/A');
T.TotalArea(s) = {'NaN'};

%only need the precursor molecules (from the light ions)
s = contains(T.Molecule,'light');
keepData = T(s,:);
clear T s

%need the retention time information from the transition list
fName = 'Transitions_SkyLine_bothModes.2023.02.28.xlsx';
tempRT = readtable(fName,'sheet','combined');
%strip the ridiculous symbols from the names
for a = 1:size(tempRT,1)
    tempRT.stripMtabName{a,1} = stripName(tempRT.PrecursorName{a});
end
clear a

%also read in the sequence as that has the fraction numbers
sName = 'CMP17_Fractions_MediawithStds_021523.KLdetails.xlsx';
temp = readtable(sName);

%note that for the fraction numbers, the fraction number will correspond to
%the ending time (in minutes) for that fraction. So, fraction #5 was
%collected from 4 to 5 minutes.

s = strcmp(temp.ionMode,'pos');
ks = find(s==1 & temp.goodData==1);
sInfo = temp(ks,:);
clear sName temp ks ks

tempNames = unique(keepData.Molecule);

%setup the matrix
mtabData = nan(length(tempNames),size(sInfo,1));

%make a table to hold mtabDetails
mtabDetails= table();

for a = 1:length(tempNames);
    s = strcmp(tempNames(a),keepData.Molecule);
    ks = find(s==1);
    %easier on the brain tonight
    useSmall = keepData(ks,:);
    [c ia ib] = intersect(useSmall.FileName,sInfo.fullfilename);
    mtabData(a,ib) = str2double(useSmall.TotalArea(ia,1));
    clear s ks c ia ib useSmall

    one = tempNames{a};
    %tidy up the mtabNames
    r = regexp(one,'_light');
    mtabDetails.mtabNames{a,1} = tempNames{a}(1:(r-1));    
    
    %get the retention time
    oneS = stripName(one);
    [c ia ib] = intersect(oneS,tempRT.stripMtabName); %can use intersect bc only need one row in tempRT
    mtabDetails.RT(a,1) = tempRT.RT(ib);
    clear oneS c ia ib
    
    %set up a place to mark good/bad data
    mtabDetails.QCflag(a,1) = 1; %make the default goodData
    
    clear r one
end
clear a

sInfo.sampleType(:,1) = {'fraction'};

idxPool = isnan(sInfo.fraction);
sInfo.sampleType(idxPool) = {'pooled'};

idxSample = find(idxPool~=1);

clear keepData fName tempRT
save(NameOfFile)

