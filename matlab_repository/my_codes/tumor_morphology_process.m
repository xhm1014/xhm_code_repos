

function [bw]=tumor_morphology_process(bwTumor)

noise_ratio=3;  % or 15
%1) remove small noisy regions
CC=bwconncomp(bwTumor);
numPixels = cellfun(@numel,CC.PixelIdxList);
thrNoise=round(max(numPixels)/noise_ratio);                   % less than noise_ratio of the maximum region is considered as noise
bwTumor=bwareaopen(bwTumor,thrNoise);                         


%% step 2--fill small holes in the image--%
bwNoholes=imfill(bwTumor,'holes');
holes=bwNoholes&~bwTumor;
bigholes=bwareaopen(holes,round(thrNoise/3));                 % holes less than thrNoise/3 are considered as small holes which are filled
smallholes=holes&~bigholes;
bw=bwTumor|smallholes;
%-- end filling small holes -- %

