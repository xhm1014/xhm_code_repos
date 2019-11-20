

function [bw]=tumor_morphology_process_v02(bwTumor)


%1) remove small noisy regions
CC=bwconncomp(bwTumor);
numPixels = cellfun(@numel,CC.PixelIdxList);
m=max(numPixels);
numPixels(bsxfun(@eq,numPixels,m))=-Inf;
m2=max(numPixels);
thrNoise=max(round(m2/3),64*64*10);                   % less than noise_ratio of the maximum region is considered as noise
bwTumor=bwareaopen(bwTumor,thrNoise);                         


%% step 2--fill small holes in the image--%
bwNoholes=imfill(bwTumor,'holes');
holes=bwNoholes&~bwTumor;
bigholes=bwareaopen(holes,round(thrNoise/2));                 % holes less than thrNoise/3 are considered as small holes which are filled
smallholes=holes&~bigholes;
bw=bwTumor|smallholes;
%-- end filling small holes -- %

