function xu_generateTiles_II(imgPath,imgName,bwHimg,tl,br,slidePtr,levelforRead,magHigh,magCoarse,magToUseAbove)

%% process most salient image patch
bpp=0.7; %% the percentage of blocks used
if nargin==9
    tsize=[320,320];
    tsize_low=tsize./(magHigh/magCoarse);
    
    rind_low=tl(1):tsize_low(1)/2:br(1)-tsize_low(1)+1;
    cind_low=tl(2):tsize_low(2)/2:br(2)-tsize_low(2)+1;
    
    tlp=tl;
    brp=br;
    tlp=(tlp-1).*(magHigh/magCoarse)+1;
    brp=(brp-1).*(magHigh/magCoarse)+1;
    
    rind=tlp(1):tsize(1)/2:brp(1)-tsize(1)+1;
    cind=tlp(2):tsize(2)/2:brp(2)-tsize(2)+1;
    
    score=zeros(length(rind),length(cind));
    for j=1:length(rind)
        for k=1:length(cind)
            
            rtemp=rind_low(j);
            ctemp=cind_low(k);
            temp=bwHimg(rtemp:rtemp+tsize_low(1)-1,ctemp:ctemp+tsize_low(2)-1);
            score(j,k)=sum(temp(:))/(tsize_low(1)*tsize_low(2));
            
            %             if sum(sum(temp))>(size(temp,1)*size(temp,1)*0.5)
            %                 tl=[rind(j),cind(k)];
            %                 br=tl+tsize;
            %                 ARGB = openslide_read_region(slidePtr,tl(2),tl(1),br(2)-tl(2),br(1)-tl(1),levelforRead-1);
            %                 RGB=ARGB(:,:,2:4);
            %
            %
            %                 imgName2=strcat(imgName,'_',num2str(j),'_',num2str(k),'_.jpg');
            %                 imwrite(RGB,strcat(imgPath,imgName2));
            %             end
        end
    end
    
    [Ms,originalpos]=sort(score(:),'descend');
    ts=round(length(rind)*length(cind)*bpp);
    topv = Ms(1:ts);
    topp=originalpos(1:ts);
    ss=zeros(size(score));
    ss(topp)=1;
    
    for j=1:length(rind)
        for k=1:length(cind)
            if ss(j,k)==1
                tl=[rind(j),cind(k)];
                br=tl+tsize;
                ARGB = openslide_read_region(slidePtr,tl(2),tl(1),br(2)-tl(2),br(1)-tl(1),levelforRead-1);
                RGB=ARGB(:,:,2:4);
                
                
                imgName2=strcat(imgName,'_',num2str(j),'_',num2str(k),'_.jpg');
                imwrite(RGB,strcat(imgPath,imgName2));
            end
            
        end
    end
else
    tsize=[640,640];
    
    tsize_low=tsize./(magToUseAbove/magCoarse);
    
    rind_low=tl(1):tsize_low(1)/2:br(1)-tsize_low(1)+1;
    cind_low=tl(2):tsize_low(2)/2:br(2)-tsize_low(2)+1;
    
    tlp=tl;
    brp=br;
    tlp=(tlp-1).*(magToUseAbove/magCoarse)+1;
    brp=(brp-1).*(magToUseAbove/magCoarse)+1;
    
    rind=tlp(1):tsize(1)/2:brp(1)-tsize(1)+1;
    cind=tlp(2):tsize(2)/2:brp(2)-tsize(2)+1;
    
    score=zeros(length(rind),length(cind));
    for j=1:length(rind)
        for k=1:length(cind)
            
            rtemp=rind_low(j);
            ctemp=cind_low(k);
            temp=bwHimg(rtemp:rtemp+tsize_low(1)-1,ctemp:ctemp+tsize_low(2)-1);
            score(j,k)=sum(temp(:))/(tsize_low(1)*tsize_low(2));
            
            %             if sum(sum(temp))>(size(temp,1)*size(temp,1)*0.5)
            %                 tl=[rind(j),cind(k)];
            %                 br=tl+tsize;
            %                 ARGB = openslide_read_region(slidePtr,tl(2),tl(1),br(2)-tl(2),br(1)-tl(1),levelforRead-1);
            %                 RGB=ARGB(:,:,2:4);
            %                 RGB=imresize(RGB,magHigh/magToUseAbove);
            %
            %
            %                 imgName2=strcat(imgName,'_',num2str(j),'_',num2str(k),'_.jpg');
            %                 imwrite(RGB,strcat(imgPath,imgName2));
            %             end
            
        end
    end
    
    [Ms,originalpos]=sort(score(:),'descend');
    ts=round(length(rind)*length(cind)*bpp);
    topv = Ms(1:ts);
    topp=originalpos(1:ts);
    ss=zeros(size(score));
    ss(topp)=1;
    
    for j=1:length(rind)
        for k=1:length(cind)
            if ss(j,k)==1
                tl=[rind(j),cind(k)];
                br=tl+tsize;
                ARGB = openslide_read_region(slidePtr,tl(2),tl(1),br(2)-tl(2),br(1)-tl(1),levelforRead-1);
                RGB=ARGB(:,:,2:4);
                RGB=imresize(RGB,magHigh/magToUseAbove);
                
                
                imgName2=strcat(imgName,'_',num2str(j),'_',num2str(k),'_.jpg');
                imwrite(RGB,strcat(imgPath,imgName2));
            end
            
        end
    end
end


% [m,n,~]=size(RGB);
% cr=round(m/2);  %% row number
% cc=round(n/2);  %% column number
%
% tt=min(round(m/2),round(n/2));
%
% rr=tt-sqrt(2*((ps/2)^2))-2; % 2 for boundary safty not important
%
% a=2*pi/neiN;
% for ri=1:rotN
%     angle=(ri-1)*(360/rotN);
%     RGB2=imrotate(RGB,angle,'bilinear','crop');
%     for i=1:neiN
%         sp_column=round(cc-rr*sin((i-1)*a));  %% column number location
%         sp_row=round(cr+rr*cos((i-1)*a));   %% row number location
%         imgPatch=RGB2(sp_row-ps/2:sp_row+ps/2-1,sp_column-ps/2:sp_column+ps/2-1,:);
%         imgName2=strcat(imgName,'_',num2str(ri),'_',num2str(i),'_.jpg');
%         imwrite(imgPatch,strcat(imgPath,imgName2));
%     end
%     % save center patch
%     sp_column=cc;  %% column number location
%     sp_row=cr;     %% row number location
%     imgPatch=RGB2(sp_row-ps/2:sp_row+ps/2-1,sp_column-ps/2:sp_column+ps/2-1,:);
%     imgName2=strcat(imgName,'_',num2str(ri),'_',num2str(neiN+1),'_.jpg');
%     imwrite(imgPatch,strcat(imgPath,imgName2));
% end