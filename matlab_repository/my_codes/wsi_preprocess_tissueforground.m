%%-- illustration --%%
%% selection tissue foreground (background assumed with brigher regions)

function [bwTissue]=wsi_preprocess_tissueforground(RGB,thrWhite,thrNoise)

bb=100; %% do not consider image border pixels

%% step 1: select interested regions
gimg=rgb2gray(RGB);
bwTis=(gimg<=thrWhite);
[r,c]=size(bwTis);
bwTissue=false([r,c]);
bwTissue(bb:r-bb,bb:c-bb)=bwTis(bb:r-bb,bb:c-bb);
bwTissue=bwareaopen(bwTissue,thrNoise);                         % obtain tissue pixels

%--fill small holes in the image--%
bwNoholes=imfill(bwTissue,'holes');
holes=bwNoholes&~bwTissue;
bigholes=bwareaopen(holes,round(thrNoise/10));    % holes greater than half of image patch not filled
smallholes=holes&~bigholes;
bwTissue=bwTissue|smallholes;
%-- end filling small holes -- %


