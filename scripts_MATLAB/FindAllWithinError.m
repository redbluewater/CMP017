function [idxTarget,idxIn] = FindAllWithinError(target,inputList,maxErr)
%function [idxTarget,idxIn] = FindAllWithinError(target,inputList,maxErr)
%find the closest target value to each inputList value, returns the
%indices (if found) of the points in the inputList and the target list
%maxErr is maximum distance allowed from points
%errType = assumed to be 'ppm' for this m-file
%
%Updates:
%09/05/07, version 0.1: lists can be unsorted
%26/May/07, v0.1: update for length(target)=1 and length(inputList)=1
%KL modifying this to match any feature within the error window...will only
%be able to use on one mz at a time; variant of FindClosest_0_1
%
%KL notes: target is the ONE mz value I am searching for
%input list is the full list of mz values that are possibilities

%check for empty input
if (isempty(inputList) | isempty(target)); warning('Empty input'); idxTarget=[]; idxIn=[]; return; end;

%sort inputList
[inputList,idxSortInput] = sort(inputList.');
inputList = inputList.';

%sort target
[target,idxSortTarget] = sort(target.');
target = target.';

%find index of closest in target list to each input
if length(target)==1
    ti = 1;
else
    error('This version will only consider one mz value at a time')
end

%will only do this for ppm calculations
% case 'ppm'
e = abs(inputList - target(ti)) ./ target(ti);
ii = find(e <= maxErr/1e6);

%return indices wrt original (unsorted) input
idxTarget = idxSortTarget(ti).';
idxIn = idxSortInput(ii).';

return