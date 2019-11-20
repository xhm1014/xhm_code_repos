function xu_debugShownTiles_V2(RGB,bwTruth,top_left,bwFalse,top_left2,tileSize)

%figure,imshow(RGB); %% show seleced image tiles
% bwT=false(size(RGB(:,:,1)));
% %bwTruth=bwareaopen(bwTruth,tileSize(1)*tileSize(2)*6); %% remove small noisy tissue regions !!!!
% CC=bwconncomp(bwTruth);
% stats=regionprops(CC,'BoundingBox');
% bb=cat(1,stats.BoundingBox);
% ss=10; %% for safty not out of image this parimeter is not affect performance
% for bi=1:size(bb,1)
%     tbb=bb(bi,:);
%     rs=round(tbb(2))+ss;
%     re=round(tbb(2))+round(tbb(4))-ss;
%     cs=round(tbb(1))+ss;
%     ce=round(tbb(1))+round(tbb(3))-ss;
%     yy=[rs,rs+tileSize(2):tileSize(2):re,re]; %% row direction
%     xx=[cs,cs+tileSize(1):tileSize(1):ce,ce]; %% column direction
%     bwT(yy,xx(1):xx(end))=1;
%     bwT(yy(1):yy(end),xx)=1;
% end
% bwT=imdilate(bwT,strel('disk',2));
% B=imoverlay(RGB,bwT,'r');



% bwF=false(size(RGB(:,:,1)));
% %bwTruth=bwareaopen(bwTruth,tileSize(1)*tileSize(2)*6); %% remove small noisy tissue regions !!!!
% CC=bwconncomp(bwFalse);
% stats=regionprops(CC,'BoundingBox');
% bb=cat(1,stats.BoundingBox);
% ss=10; %% for safty not out of image this parimeter is not affect performance
% for bi=1:size(bb,1)
%     tbb=bb(bi,:);
%     rs=round(tbb(2))+ss;
%     re=round(tbb(2))+round(tbb(4))-ss;
%     cs=round(tbb(1))+ss;
%     ce=round(tbb(1))+round(tbb(3))-ss;
%     yy=[rs,rs+tileSize(2):tileSize(2):re,re]; %% row direction
%     xx=[cs,cs+tileSize(1):tileSize(1):ce,ce]; %% column direction
%     bwF(yy,xx(1):xx(end))=1;
%     bwF(yy(1):yy(end),xx)=1;
% end
% bwF=imdilate(bwF,strel('disk',2));
% B=imoverlay(B,bwF,'g');

figure,imshow(RGB);
if ~isempty(top_left)
    for i=1:size(top_left,1)
        tl=top_left(i,:);
        pos=[tl(2) tl(1) tileSize(2)-1 tileSize(1)-1];
        hold on, rectangle('Position',pos,'EdgeColor','c','LineWidth',2);
        hold on,plot(tl(2)+tileSize(2)/2,tl(1)+tileSize(1)/2,'rp','MarkerSize',5);
    end
     temp01=bwperim(bwTruth);
     [r,c]=find(temp01);
     hold on,plot(c,r,'r*'); 
end

if ~isempty(top_left2)
    for i=1:size(top_left2,1)
        tl=top_left2(i,:);
        pos=[tl(2) tl(1) tileSize(2)-1 tileSize(1)-1];
        hold on, rectangle('Position',pos,'EdgeColor','b','LineWidth',2);
        hold on,plot(tl(2)+tileSize(2)/2,tl(1)+tileSize(1)/2,'gp','MarkerSize',5);
    end
    
    temp01=bwperim(bwFalse);
    [r,c]=find(temp01);
    hold on,plot(c,r,'y*'); 
end

hold off;
%             imagename=strcat(num2str(k),'.jpg');
%             saveas(gcf,strcat(imageDebugPath{gc},imagename));
%             close all;