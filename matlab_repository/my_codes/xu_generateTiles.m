function xu_generateTiles(imgPath,imgName,neiN,rotN,ps,tl,br,slidePtr,levelforRead,magHigh,magCoarse,magToUseAbove)

%% process most salient image patch
if nargin==11
    tlp=tl;
    brp=br;
    tlp=(tlp-1).*(magHigh/magCoarse)+1;
    brp=(brp-1).*(magHigh/magCoarse)+1;
    ARGB = openslide_read_region(slidePtr,tlp(2),tlp(1),brp(2)-tlp(2),brp(1)-tlp(1),levelforRead-1);
    RGB=ARGB(:,:,2:4);
else
    tlp=tl;
    brp=br;
    tlp=(tlp-1).*(magToUseAbove/magCoarse)+1;
    brp=(brp-1).*(magToUseAbove/magCoarse)+1;
    ARGB = openslide_read_region(slidePtr,round(tlp(2)),round(tlp(1)),brp(2)-tlp(2),brp(1)-tlp(1),levelforRead-1);
    RGB=ARGB(:,:,2:4);
    RGB=imresize(RGB,magHigh/magToUseAbove);
end


[m,n,~]=size(RGB);
cr=round(m/2);  %% row number
cc=round(n/2);  %% column number

tt=min(round(m/2),round(n/2));

rr=tt-sqrt(2*((ps/2)^2))-2; % 2 for boundary safty not important

a=2*pi/neiN;
for ri=1:rotN
    angle=(ri-1)*(360/rotN);
    RGB2=imrotate(RGB,angle,'bilinear','crop');
    for i=1:neiN
        sp_column=round(cc-rr*sin((i-1)*a));  %% column number location
        sp_row=round(cr+rr*cos((i-1)*a));   %% row number location
        imgPatch=RGB2(sp_row-ps/2:sp_row+ps/2-1,sp_column-ps/2:sp_column+ps/2-1,:);
        imgName2=strcat(imgName,'_',num2str(ri),'_',num2str(i),'_.jpg');
        imwrite(imgPatch,strcat(imgPath,imgName2));
    end
    % save center patch
    sp_column=cc;  %% column number location
    sp_row=cr;     %% row number location
    imgPatch=RGB2(sp_row-ps/2:sp_row+ps/2-1,sp_column-ps/2:sp_column+ps/2-1,:);
    imgName2=strcat(imgName,'_',num2str(ri),'_',num2str(neiN+1),'_.jpg');
    imwrite(imgPatch,strcat(imgPath,imgName2));
end