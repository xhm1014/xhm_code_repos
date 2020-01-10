function xu_generate_maps_v2(top_left,bottom_right,slidePtr,levelforRead,magFine,magCoarse,imgname,imgpath,magToUseAbove)

if nargin==8
    for tind=1:size(top_left,1)
        tlp=top_left(tind,:);
        brp=bottom_right(tind,:);
        
        tlp=(tlp-1).*(magFine/magCoarse)+1;
        brp=(brp-1).*(magFine/magCoarse)+1;
        ARGB = openslide_read_region(slidePtr,tlp(2),tlp(1),brp(2)-tlp(2),brp(1)-tlp(1),levelforRead-1);
        RGB=ARGB(:,:,2:4);
        
        
%         [RGB, ~, ~] = normalizeStaining(RGB);
        
       
        imgnn=strcat(imgname,'_',num2str(tlp(1)),'_',num2str(tlp(2)),'_',num2str(brp(1)),'_',num2str(brp(2)),'_','.png');
        imwrite(RGB,strcat(imgpath,imgnn));
       

    end
else
    for tind=1:size(top_left,1)
        tlp=top_left(tind,:);
        brp=bottom_right(tind,:);
        
        tlp=(tlp-1).*(magToUseAbove/magCoarse)+1;
        brp=(brp-1).*(magToUseAbove/magCoarse)+1;
        ARGB = openslide_read_region(slidePtr,tlp(2),tlp(1),brp(2)-tlp(2),brp(1)-tlp(1),levelforRead-1);
        RGB=ARGB(:,:,2:4);
        
        RGB=imresize(RGB,magFine/magToUseAbove);
        
%         [RGB, ~, ~] = normalizeStaining(RGB);
        
        imgnn=strcat(imgname,'_',num2str(tlp(1)),'_',num2str(tlp(2)),'_',num2str(brp(1)),'_',num2str(brp(2)),'_','.png');
        imwrite(RGB,strcat(imgpath,imgnn));
 
    end
end

