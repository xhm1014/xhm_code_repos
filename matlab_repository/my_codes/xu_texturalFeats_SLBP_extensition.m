function [TF_3D,TF_2D]=xu_texturalFeats_SLBP_extensition(top_left,bottom_right,slidePtr,levelforRead,magFine,magCoarse,magToUseAbove)


lbpRadiusSet = [2 4 6 8];
lbpPoints = 8;
mapping = getmapping_MRELBP(lbpPoints,'riu2');

TF_3D=[];
TF_2D=[];

tic
if nargin==6
    for tind=1:size(top_left,1)
        tlp=top_left(tind,:);
        brp=bottom_right(tind,:);
        
        tlp=(tlp-1).*(magFine/magCoarse)+1;
        brp=(brp-1).*(magFine/magCoarse)+1;
        ARGB = openslide_read_region(slidePtr,tlp(2),tlp(1),brp(2)-tlp(2),brp(1)-tlp(1),levelforRead-1);
        RGBN=normalizeStaining(ARGB(:,:,2:4));
        Rimg=RGBN(:,:,1);                       %% use only red channel
        
        f3D=[];f2D=[];
        for idxLbpRadius = 1 : length(lbpRadiusSet)
            lbpRadius = lbpRadiusSet(idxLbpRadius);
            
            if idxLbpRadius > 1
                lbpRadiusPre = lbpRadiusSet(idxLbpRadius-1);
            else
                lbpRadiusPre = 0;
            end
            
            [f00_3D,f00_2D]=SLBP_median(double(Rimg),lbpRadius,lbpPoints,lbpRadiusPre,mapping);   %
            [f01_3D,f01_2D]=SLBP_std(double(Rimg),lbpRadius,lbpPoints,lbpRadiusPre,mapping);
            %[f02_3D,f02_2D]=SLBP_min(double(Rimg),lbpRadius,lbpPoints,lbpRadiusPre,mapping);
            %[f03_3D,f03_2D]=SLBP_max(double(Rimg),lbpRadius,lbpPoints,lbpRadiusPre,mapping);
            f3D=[f3D,f00_3D,f01_3D];
            f2D=[f2D,f00_2D,f01_2D];
        end
        TF_3D(tind,:)=f3D;
        TF_2D(tind,:)=f2D;
        
    end
else
    for tind=1:size(top_left,1)
        tlp=top_left(tind,:);
        brp=bottom_right(tind,:);
        tlp=(tlp-1).*(magToUseAbove/magCoarse)+1;
        brp=(brp-1).*(magToUseAbove/magCoarse)+1;
        ARGB = openslide_read_region(slidePtr,round(tlp(2)),round(tlp(1)),brp(2)-tlp(2),brp(1)-tlp(1),levelforRead-1);
        RGBN=normalizeStaining(ARGB(:,:,2:4));
        Rimg=RGBN(:,:,1);   % for only red channel
        Rimg=imresize(Rimg,magFine/magToUseAbove);
        
        f3D=[];f2D=[];
        for idxLbpRadius = 1 : length(lbpRadiusSet)
            lbpRadius = lbpRadiusSet(idxLbpRadius);
            
            if idxLbpRadius > 1
                lbpRadiusPre = lbpRadiusSet(idxLbpRadius-1);
            else
                lbpRadiusPre = 0;
            end
            [f00_3D,f00_2D]=SLBP_median(double(Rimg),lbpRadius,lbpPoints,lbpRadiusPre,mapping);   %
            [f01_3D,f01_2D]=SLBP_std(double(Rimg),lbpRadius,lbpPoints,lbpRadiusPre,mapping);
            %[f02_3D,f02_2D]=SLBP_min(double(Rimg),lbpRadius,lbpPoints,lbpRadiusPre,mapping);
            %[f03_3D,f03_2D]=SLBP_max(double(Rimg),lbpRadius,lbpPoints,lbpRadiusPre,mapping);
            f3D=[f3D,f00_3D,f01_3D];
            f2D=[f2D,f00_2D,f01_2D];
        end
        TF_3D(tind,:)=f3D;
        TF_2D(tind,:)=f2D;
        
    end
end
toc

