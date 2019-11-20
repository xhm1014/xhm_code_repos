%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is ONLY get one large tumor tile postion

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
%#: Usage: Only consider the largest WSI, only choose one tile from WSI
function [top_left_f,bottom_right_f]=xu_SelectImageTiles_III(bwTissue,bwHimg,tileSize,augmentStep)

if nargin<3
    disp('Error: Input argments not enough!!!');
end

if nargin==3
    augmentStep=0;
end

%% only consider the largest foreground region -- in version II
CC=bwconncomp(bwTissue);
stats=regionprops(CC,'BoundingBox');

idx=0; mv=0;
for j=1:CC.NumObjects        %% find the box with most tumor pixels
    bwtemp=false(size(bwTissue));
    bwtemp(CC.PixelIdxList{j})=1;
    if sum(sum(bwtemp&bwHimg))>mv
        mv=sum(sum(bwtemp&bwHimg));
        idx=j;
    end
end
%numPixels = cellfun(@numel,CC.PixelIdxList);
%[~,idx] = max(numPixels);
bb=stats(idx).BoundingBox;
ss=10; %% for safty not out of image, this parimeter is not affect performance
fun=@(x)sum(sum(x.data))/(tileSize(1)*tileSize(2));
top_left=[];
bottom_right=[];

maxV=zeros(1,length(augmentStep));
step=augmentStep;
for j=1:length(step)
    rs=round(bb(2))+ss+step(j);
    cs=round(bb(1))+ss+step(j);
    re=round(bb(2))+round(bb(4))-ss;
    ce=round(bb(1))+round(bb(3))-ss;
    B=blockproc(bwHimg(rs:re,cs:ce),tileSize,fun);        %% hematoxylin channels
    Bt=(B==max(B(:)));
    maxV(j)=max(B(:));
    yy=[rs,rs+tileSize(2):tileSize(2):re,re];           %% row direction
    xx=[cs,cs+tileSize(1):tileSize(1):ce,ce];           %% column direction
    [ry,cx]=find(Bt);
    top_left=[top_left;yy(ry)',xx(cx)'];              %% the first column: row; the second column: column; top-left point position
    bottom_right=[bottom_right;yy(ry+1)',xx(cx+1)'];  %% the first column: row; the second column: column; bottom-right point position
end

[mv,ind]=max(maxV);
top_left_f=top_left(ind,:);
bottom_right_f=bottom_right(ind,:);
end