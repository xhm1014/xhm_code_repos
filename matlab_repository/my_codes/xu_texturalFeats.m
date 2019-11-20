function TF=xu_texturalFeats(top_left,bottom_right,slidePtr,levelforRead,magFine,magCoarse,mapping,mapping2,magToUseAbove)

%dd=1:2:7;                                       %% glcm distance
%PatsF=zeros(1,size(top_left,1),93);        % 210 features
%gsall=[2,4,8,16,32,64,128];
TF=[];
%TF=zeros(size(top_left,1),288);             % 288 features
tic
if nargin==8
    for tind=1:size(top_left,1)
        tlp=top_left(tind,:);
        brp=bottom_right(tind,:);
        tlp=(tlp-1).*(magFine/magCoarse)+1;
        brp=(brp-1).*(magFine/magCoarse)+1;
        ARGB = openslide_read_region(slidePtr,tlp(2),tlp(1),brp(2)-tlp(2),brp(1)-tlp(1),levelforRead-1);
        RGBN=normalizeStaining(ARGB(:,:,2:4));
        Rimg=RGBN(:,:,1);                       %% use only red channel
        
        TF(tind,:)=xu_LBP(Rimg,mapping);
        
        %TF(tind,:)=xu_lbpFeats(Rimg,mapping,mapping2);  %% proposed cslbp
        
        %TF(tind,:)=xu_HisHarGab(Rimg);                    %% HHG comparison
        
        
       
        %TF(tind,:)=xu_FractalAnalysis(double(Rimg),gsall);   %<<8 features>>  %% FA comparison
        
        %figure,imshow(Rimg)
        
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
        
        TF(tind,:)=xu_LBP(Rimg,mapping);
        %TF(tind,:)=xu_lbpFeats(Rimg,mapping,mapping2); % proposed cslbp
        
        %TF(tind,:)=xu_HisHarGab(Rimg);                    %% HHG comparison
        
        %TF(tind,:)=xu_FractalAnalysis(double(Rimg),gsall);   %<<8 features>>  %% FA comparison
        
        
    end
end
toc
%TF=squeeze(PatsF);
