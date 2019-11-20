%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used for cal. the grid for given image tile size

%  Inputs:
%  -bwTissue: the binary mask with foreground region as tissue region
%  -bwHimg: the binary mask foreground as nuclei pixels region
%  -pp: the percent of the largest intrested value (the interest value is
%  the raito of nuclei pixels over the total pixels)
%  -ppt: the percent of tissue pixels in the image patch
%  -tileSize: the image tile size
%  -agumentStep: it depends on applications may be not necessary

%  Output:
%  -top_left : each row is the top-left corner of a selected block; the
%  first column: row number; the second column: column number
%  -bottome_right: each row is the bottom-right corner of a selected block



% (c) Edited by Hongming Xu,
% Deptment of Quantitative Health Sciences,
% Cleveland Clinic, USA.  December 2017
% If you have any problem feel free to contact me.
% Please address questions or comments to: mxu@ualberta.ca

% Terms of use: You are free to copy,
% distribute, display, and use this work, under the following
% conditions. (1) You must give the original authors credit. (2) You may
% not use or redistribute this work for commercial purposes. (3) You may
% not alter, transform, or build upon this work. (4) For any reuse or
% distribution, you must make clear to others the license terms of this
% work. (5) Any of these conditions can be waived if you get permission
% from the authors.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%# Usage: consider all the WSIs, but only select mnum=10 dentist tiles from WSIs
function [top_left2,bottom_right2]=xu_SelectImageTiles_V(bwTissue,bwHimg,pp,ppt,tileSize,mnum)

if nargin<5
    disp('Error: Input argments not enough!!!');
end

if nargin==5
    mnum=10;
end


CC=bwconncomp(bwTissue);
stats=regionprops(CC,'BoundingBox');
bb=cat(1,stats.BoundingBox);
ss=10; %% for safty not out of image, this parimeter is not affect performance
fun=@(x)sum(sum(x.data))/(tileSize(1)*tileSize(2));
top_left_temp=[];
bottom_right_temp=[];
B_temp=[];

for bi=1:size(bb,1)
    tbb=bb(bi,:);
    rs=round(tbb(2))+ss;
    cs=round(tbb(1))+ss;
    re=round(tbb(2))+round(tbb(4))-ss;
    ce=round(tbb(1))+round(tbb(3))-ss;
    B=blockproc(bwHimg(rs:re,cs:ce),tileSize,fun);        %% hematoxylin channels
    Bt1=(B>max(B(:))*pp);
    BTis=blockproc(bwTissue(rs:re,cs:ce),tileSize,fun);   %% tissue binary mask
    Bt2=(BTis>ppt);
    Bt=Bt1&Bt2;
    
    yy=[rs,rs+tileSize(2):tileSize(2):re,re];           %% row direction
    xx=[cs,cs+tileSize(1):tileSize(1):ce,ce];           %% column direction
    [ry,cx]=find(Bt);
    top_left_temp=[top_left_temp;yy(ry)',xx(cx)'];              %% the first column: row; the second column: column; top-left point position
    bottom_right_temp=[bottom_right_temp;yy(ry+1)',xx(cx+1)'];  %% the first column: row; the second column: column; bottom-right point position
    B_temp=[B_temp;B(Bt)];
end

%% make sure the number is not too large
[temp,sortIndex]=sort(B_temp,'descend');
if mnum<size(top_left_temp,1)
    top_left=top_left_temp(sortIndex(1:mnum),:);
    bottom_right=bottom_right_temp(sortIndex(1:mnum),:);
else
    top_left=top_left_temp;
    bottom_right=bottom_right_temp;
end

%% remove the blocks that are smaller than predetermined tile size
temp=bottom_right-top_left;
tt=repmat([tileSize(1),tileSize(2)],size(temp,1),1);
index=any(~(tt==temp),2);
top_left2=top_left(~index,:);
bottom_right2=bottom_right(~index,:);

end