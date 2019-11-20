

function [bwTissue]=wsi_preprocess_tissue_mrxs_stromal_analysis(RGB,thrWhite,thrBlack)



%% step 1: select interested regions
gimg=rgb2gray(RGB);
bw1=(gimg<=thrWhite);
bw2=(gimg>=thrBlack);
bwTissue=bw1&bw2;

CC=bwconncomp(bwTissue);
numPixels = cellfun(@numel,CC.PixelIdxList);
thrNoise=round(max(numPixels)/3);                               % less than half of the maximum region is considered as noise
%bwTissue=imclose(bwTissue,strel('disk',2));
bwTissue=bwareaopen(bwTissue,thrNoise);                         % obtain tissue pixels


%% step 2--fill small holes in the image--%
bwNoholes=imfill(bwTissue,'holes');
holes=bwNoholes&~bwTissue;
bigholes=bwareaopen(holes,round(thrNoise/3));    % holes greater than half of image patch not filled
smallholes=holes&~bigholes;
bwTissue=bwTissue|smallholes;
%-- end filling small holes -- %

