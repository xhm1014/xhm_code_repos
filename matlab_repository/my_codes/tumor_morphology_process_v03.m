

function [bw]=tumor_morphology_process_v03(bwTumor,thrNoise)

%1) remove small noisy regions                 
bwTumor=bwareaopen(bwTumor,thrNoise);                         

%% step 2--fill small holes in the image--%
bwNoholes=imfill(bwTumor,'holes');
holes=bwNoholes&~bwTumor;
bigholes=bwareaopen(holes,round(thrNoise));                 % holes less than thrNoise/3 are considered as small holes which are filled
smallholes=holes&~bigholes;
bw=bwTumor|smallholes;
%-- end filling small holes -- %

