function TF=xu_texturalFeats_SLBP(top_left,bottom_right,slidePtr,levelforRead,magFine,magCoarse,magToUseAbove)


lbpRadius = 2:1:9;
lbpPoints=16;
lbpMethod={'u2','ri','riu2'};
mappingu2 = getmapping_MRELBP(numel(lbpRadius),lbpMethod{1});
mappingriu2 = getmapping_MRELBP(lbpPoints,lbpMethod{3});
style='joint3D';

TF=[];

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
        
        
        
        
        %ftemp=xu_SLBP(double(Rimg),lbpRadius,lbpPoints,lbpRadiusPre,mapping);   %
        result = SLBP(double(Rimg),lbpPoints,lbpRadius,mappingriu2,mappingu2,'image',style);
        
        TF(tind,:)=result;
        
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
        
        
        %ftemp=xu_MRELBP(double(Rimg),lbpRadius,lbpPoints,lbpRadiusPre,mapping);   %
        result = SLBP(double(Rimg),lbpPoints,lbpRadius,mappingriu2,mappingu2,'image',style);
        
        TF(tind,:)=result;
        
    end
end
toc

