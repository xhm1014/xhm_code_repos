function result = SLBP(img,lbpPoints,lbpRadius,mappingriu2,mappingu2,mode,style)

[imgH,imgW] = size(img);
imgNewH = imgH - 2*lbpRadius(end);
imgNewW = imgW - 2*lbpRadius(end);
imgN=zeros(imgNewH*imgNewW,lbpPoints,length(lbpRadius));
for k=1:length(lbpRadius)
    blocks = cirInterpSingleRadius_SLBP(img,lbpPoints,lbpRadius(k),lbpRadius(end));
    blocks = blocks';
    imgN(:,:,k)=blocks;
end

%% center pixel processing
se=ones((lbpRadius(1)-1)*2+1,(lbpRadius(1)-1)*2+1);
minB=ordfilt2(img,1,se);
medB=ordfilt2(img,round(sum(se(:))/2),se);
maxB=ordfilt2(img,sum(se(:)),se);
stdB=stdfilt(img,se);

minBg=minB(lbpRadius(end)+1:end-lbpRadius(end),lbpRadius(end)+1:end-lbpRadius(end));
medBg=medB(lbpRadius(end)+1:end-lbpRadius(end),lbpRadius(end)+1:end-lbpRadius(end));
maxBg=maxB(lbpRadius(end)+1:end-lbpRadius(end),lbpRadius(end)+1:end-lbpRadius(end));
stdBg=stdB(lbpRadius(end)+1:end-lbpRadius(end),lbpRadius(end)+1:end-lbpRadius(end));

minBC=minB>=mean(double(minB(:)));
medBC=medB>=mean(double(medB(:)));
maxBC=maxB>=mean(double(maxB(:)));
stdBC=stdB>=mean(double(stdB(:)));

minBC=minBC(lbpRadius(end)+1:end-lbpRadius(end),lbpRadius(end)+1:end-lbpRadius(end));
medBC=medBC(lbpRadius(end)+1:end-lbpRadius(end),lbpRadius(end)+1:end-lbpRadius(end));
maxBC=maxBC(lbpRadius(end)+1:end-lbpRadius(end),lbpRadius(end)+1:end-lbpRadius(end));
stdBC=stdBC(lbpRadius(end)+1:end-lbpRadius(end),lbpRadius(end)+1:end-lbpRadius(end));

%% orientational direction - third dimension of blocks (p+2)*4
minBlocks=min(imgN,[],3);
minresult=SLBP_encoding(minBlocks,lbpPoints,minBg(:),mappingriu2,mode);

medianBlocks=median(imgN,3);
medianresult=SLBP_encoding(medianBlocks,lbpPoints,medBg(:),mappingriu2,mode);

maxBlocks=max(imgN,[],3);
maxresult=SLBP_encoding(maxBlocks,lbpPoints,maxBg(:),mappingriu2,mode);

stdBlocks=std(imgN,0,3);
stdresult=SLBP_encoding(stdBlocks,lbpPoints,stdBg(:),mappingriu2,mode);

%% radial direction - second dimension of blocks (p-1)*p+3
radmin=squeeze(min(imgN,[],2));
radmins=SLBP_encoding(radmin,numel(lbpRadius),minBg(:),mappingu2,mode);

radmedian=squeeze(median(imgN,2));
radmedians=SLBP_encoding(radmedian,numel(lbpRadius),medBg(:),mappingu2,mode);

radmax=squeeze(max(imgN,[],2));
radmaxs=SLBP_encoding(radmax,numel(lbpRadius),maxBg(:),mappingu2,mode);

radstd=squeeze(std(imgN,0,2));
radstds=SLBP_encoding(radstd,numel(lbpRadius),stdBg(:),mappingu2,mode);

if strcmp(style,'joint2D')
    %% small feature dimension
    ominr=xu_featureConnection(minresult',minBC(:),mappingriu2.num);
    omedr=xu_featureConnection(medianresult',medBC(:),mappingriu2.num);
    omaxr=xu_featureConnection(maxresult',maxBC(:),mappingriu2.num);
    ostdr=xu_featureConnection(stdresult',stdBC(:),mappingriu2.num);
    
    rminr=xu_featureConnection(radmins',minBC(:),mappingu2.num);
    rmedr=xu_featureConnection(radmedians',medBC(:),mappingu2.num);
    rmaxr=xu_featureConnection(radmaxs',maxBC(:),mappingu2.num);
    rstdr=xu_featureConnection(radstds',stdBC(:),mappingu2.num);
    
    result=[ominr,omedr,omaxr,ostdr,rminr,rmedr,rmaxr,rstdr];
elseif strcmp(style,'joint3D')
    %% large feature dimension
    ocrmin=xu_featureConnection3D(minresult',minBC(:),radmins',mappingriu2.num,mappingu2.num);
    ocrmed=xu_featureConnection3D(medianresult',medBC(:),radmedians',mappingriu2.num,mappingu2.num);
    ocrmax=xu_featureConnection3D(maxresult',maxBC(:),radmaxs',mappingriu2.num,mappingu2.num);
    ocrstd=xu_featureConnection3D(stdresult',stdBC(:),radstds',mappingriu2.num,mappingu2.num);
    result=[ocrmin,ocrmed,ocrmax,ocrstd];
else
    disp('impossible!!!');
end



