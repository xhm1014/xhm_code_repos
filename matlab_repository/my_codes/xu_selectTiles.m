function [tl,br]=xu_selectTiles(bwHimg,top_left,bottom_right,slidePtr,levelforRead,magHigh,magCoarse,magToUseAbove)

Para.thetaStep=pi/9;
Para.largeSigma=7;
Para.smallSigma=4;
Para.sigmaStep=-1;
Para.kerSize=Para.largeSigma*4;
Para.bandwidth=5;
Para.dis=10; % if the seeds is close to image borders less than 10 pixels, removed for consideration.

score=zeros(1,size(top_left,1));
if nargin==7
    for tind=1:size(top_left,1)
        tlp=top_left(tind,:);
        brp=bottom_right(tind,:);
        tlp=(tlp-1).*(magHigh/magCoarse)+1;
        brp=(brp-1).*(magHigh/magCoarse)+1;
        ARGB = openslide_read_region(slidePtr,tlp(2),tlp(1),brp(2)-tlp(2),brp(1)-tlp(1),levelforRead-1);
        RGB=ARGB(:,:,2:4);
        bwTumor=bwHimg(top_left(tind,1):bottom_right(tind,1)-1,top_left(tind,2):bottom_right(tind,2)-1);
        bwTumor=imresize(bwTumor,magHigh/magCoarse);
        score(tind)=xu_compTumorScore(RGB,bwTumor,Para);
    end
else
    for tind=1:size(top_left,1)
        tlp=top_left(tind,:);
        brp=bottom_right(tind,:);
        tlp=(tlp-1).*(magToUseAbove/magCoarse)+1;
        brp=(brp-1).*(magToUseAbove/magCoarse)+1;
        ARGB = openslide_read_region(slidePtr,round(tlp(2)),round(tlp(1)),brp(2)-tlp(2),brp(1)-tlp(1),levelforRead-1);
        RGB=ARGB(:,:,2:4);
        RGB=imresize(RGB,magHigh/magToUseAbove);
        bwTumor=bwHimg(top_left(tind,1):bottom_right(tind,1)-1,top_left(tind,2):bottom_right(tind,2)-1);
        bwTumor=imresize(bwTumor,magHigh/magCoarse);
        score(tind)=xu_compTumorScore(RGB,bwTumor,Para);
    end
end

[~,id]=max(score);
tl=top_left(id,:);
br=bottom_right(id,:);

