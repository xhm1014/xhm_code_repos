function [TF_3D,TF_2D]=xu_texturalFeats_SLBP_extensition_III(top_left,bottom_right,slidePtr,levelforRead,magFine,magCoarse,magToUseAbove)


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
            
         
            [f00_3D,f00_2D]=xu_SLBP_median_std(double(Rimg),lbpRadius,lbpPoints,mapping);   
            
            f3D=[f3D,f00_3D];
            f2D=[f2D,f00_2D];
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
           
            [f00_3D,f00_2D]=xu_SLBP_median_std(double(Rimg),lbpRadius,lbpPoints,mapping);   %
            
            f3D=[f3D,f00_3D];
            f2D=[f2D,f00_2D];
        end
        TF_3D(tind,:)=f3D;
        TF_2D(tind,:)=f2D;
        
    end
end
toc

