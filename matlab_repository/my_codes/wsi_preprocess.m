function [bwTissue,bwHimg]=wsi_preprocess(RGB,thrWhite,thrOverStain,thrNoise)



%% step 1: select interested regions
gimg=rgb2gray(RGB);
bwTissue=(gimg<=thrWhite);
bwTissue=bwareaopen(bwTissue,thrNoise);                         % obtain tissue pixels

%--fill small holes in the image--%
bwNoholes=imfill(bwTissue,'holes');
holes=bwNoholes&~bwTissue;
bigholes=bwareaopen(holes,round(thrNoise/2));    % holes greater than half of image patch not filled
smallholes=holes&~bigholes;
bwTissue=bwTissue|smallholes;
%-- end filling small holes -- %

%% step 2:
thrNoise2=50;                                           % remove noisy nuclei regions
dis=3;
RGB=imresize(RGB,0.5);                                   % for memory issue
[~,Himg,~]=normalizeStaining(RGB);                       % step 2: color normalization
gHimg=rgb2gray(Himg);
gHimg=imresize(gHimg,size(bwTissue));                    % for memory issue
bwHimgO=(gHimg>thrOverStain);                              % over staining regions
thresh=multithresh(gHimg(bwHimgO),2);
bwHimgN=(gHimg<=thresh(1));                              % step 3: obtain nuclei regions
bwHimg=bwHimgN&bwHimgO;
bwgimg=(gimg>thrOverStain);                                     % over staining regions
bwHimg=bwHimg&bwgimg;


bwHimg=bwareaopen(bwHimg,thrNoise2);
bwHimg=imclose(bwHimg,strel('disk',dis));
