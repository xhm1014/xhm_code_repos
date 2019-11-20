function feat=xu_cellular_feature(top_left,bottom_right,slidePtr,levelforRead,magFine,magCoarse,imgname,imgpath,freq,magToUseAbove)

%imgoutput='E:\Hongming\projects\tcga-bladder-mutationburden\debugoutput\4)\';
% Wi=para.Wi;
% Hi=para.Hi;
% Hiv=para.Hiv;
% nstains=para.nstains;
% lambda=para.lambda;
% p=16;
% mapping=getmapping(p,'riu2');
%feat=zeros(size(top_left,1),(p+2)*4);
feat=cell(size(top_left,1),2);


if nargin==9
    for tind=1:size(top_left,1)
        tlp=top_left(tind,:);
        brp=bottom_right(tind,:);
        
        tlp=(tlp-1).*(magFine/magCoarse)+1;
        brp=(brp-1).*(magFine/magCoarse)+1;
        ARGB = openslide_read_region(slidePtr,tlp(2),tlp(1),brp(2)-tlp(2),brp(1)-tlp(1),levelforRead-1);
        RGB=ARGB(:,:,2:4);
        
        %feat(tind,:)=xu_LBP(RGB(:,:,1),mapping);
        %[Wis, His,Hivs]=stainsep(RGB,nstains,lambda);
        %[RGB]=SCN(RGB,Hi,Wi,His);
        %[RGB, ~, ~] = normalizeStaining(RGB);
        
        if tind<10
            imgnn=strcat(imgname,num2str(0),num2str(0),num2str(0),num2str(tind),'.png');
            imwrite(RGB,strcat(imgpath,imgnn));
        elseif tind<100 && tind>=10
            imgnn=strcat(imgname,num2str(0),num2str(0),num2str(tind),'.png');
            imwrite(RGB,strcat(imgpath,imgnn));
        elseif tind<1000 && tind>=100
            imgnn=strcat(imgname,num2str(0),num2str(tind),'.png');
            imwrite(RGB,strcat(imgpath,imgnn));
        else
            imgnn=strcat(imgname,num2str(tind),'.png');
            imwrite(RGB,strcat(imgpath,imgnn));
        end
        
        feat{tind,1}=imgnn;
        feat{tind,2}=freq(tind);
        %feat=cellular_feature_computation(RGB);
        
        %saveas(gcf, strcat(imgoutput,imgname,num2str(tind),'.png'));
        %close all;
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
        
        %feat(tind,:)=xu_LBP(RGB(:,:,1),mapping);
        %[Wis, His, Hivs]=stainsep(RGB,nstains,lambda);
        %[RGB]=SCN(RGB,Hi,Wi,His);
        
        %[RGB, ~, ~] = normalizeStaining(RGB);
        if tind<10
            imgnn=strcat(imgname,num2str(0),num2str(0),num2str(0),num2str(tind),'.png');
            imwrite(RGB,strcat(imgpath,imgnn));
        elseif tind<100 && tind>=10
            imgnn=strcat(imgname,num2str(0),num2str(0),num2str(tind),'.png');
            imwrite(RGB,strcat(imgpath,imgnn));
        elseif tind<1000 && tind>=100
            imgnn=strcat(imgname,num2str(0),num2str(tind),'.png');
            imwrite(RGB,strcat(imgpath,imgnn));
        else
            imgnn=strcat(imgname,num2str(tind),'.png');
            imwrite(RGB,strcat(imgpath,imgnn));
        end
        
        feat{tind,1}=imgnn;
        feat{tind,2}=freq(tind);
        
        %feat=cellular_feature_computation(RGB);
        %saveas(gcf, strcat(imgoutput,imgname,num2str(tind),'.png'));
        %close all;
    end
end

