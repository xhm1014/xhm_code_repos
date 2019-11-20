function [slbp3D,slbp2D]=SLBP_median(img,lbpRadius,lbpPoints,lbpRadiusPre,mapping)

%Joint_CIRD = zeros(numLBPbins,2);
%Joint_CINI = zeros(numLBPbins,2);
numLBPbins = mapping.num;
%Joint_CINIRD = zeros(numLBPbins,numLBPbins,2);
%Joint_NIRD = zeros(numLBPbins,numLBPbins);

% image sample preprocessing
%img = samp_prepro(img);     % temporarily comment

% *********************************************************************
imgExt = padarray(img,[1 1],'symmetric','both');
imgblks = im2col(imgExt,[3 3],'sliding');
a = median(imgblks);
b = reshape(a,size(img));
% *********************************************************************

CImg = b(lbpRadius+1:end-lbpRadius,lbpRadius+1:end-lbpRadius);
%CImg = CImg(:) - mean(CImg(:));
%CImg(CImg >= 0) = 2;
%CImg(CImg < 0) = 1;
CImg=CImg>=mean(double(CImg(:)));

if lbpRadius == 2
    filWin = 3;
    halfWin = (filWin-1)/2;
    imgExt = padarray(img,[halfWin halfWin],'symmetric','both');
    imgblks = im2col(imgExt,[filWin filWin],'sliding');
    % each column of imgblks represent a feature vector
    imgMedian = median(imgblks);
    imgCurr = reshape(imgMedian,size(img));
    NILBPImage = NILBP_Image_MRELBP(imgCurr,lbpPoints,lbpRadius,mapping,'image');
    %NILBPImage = NILBPImage(:);
    %histNI = hist(NILBPImage,0:(numLBPbins-1));
    %NILBPImage = NILBPImage + 1;
    
    RDLBPImage = RDLBP_Image_SmallestRadiusOnly(b,imgCurr,lbpRadius,lbpPoints,mapping,'image');
    %RDLBPImage = RDLBPImage(:);
    %histRD = hist(RDLBPImage,0:(numLBPbins-1));
    %RDLBPImage = RDLBPImage + 1;
else
    if mod(lbpRadius,2) == 0
        filWin = lbpRadius + 1;
    else
        filWin = lbpRadius;
    end
    halfWin = (filWin-1)/2;
    imgExt = padarray(img,[halfWin halfWin],'symmetric','both');
    imgblks = im2col(imgExt,[filWin filWin],'sliding');
    % each column of imgblks represents a feature vector
    imgMedian = median(imgblks);
    imgCurr = reshape(imgMedian,size(img));
    NILBPImage = NILBP_Image_MRELBP(imgCurr,lbpPoints,lbpRadius,mapping,'image');
    %NILBPImage = NILBPImage(:);
    %histNI = hist(NILBPImage,0:(numLBPbins-1));
    %NILBPImage = NILBPImage + 1;
    
    if mod(lbpRadiusPre,2) == 0
        filWin = lbpRadiusPre + 1;
    else
        filWin = lbpRadiusPre;
    end
    
    halfWin = (filWin-1)/2;
    imgExt = padarray(img,[halfWin halfWin],'symmetric','both');
    imgblks = im2col(imgExt,[filWin filWin],'sliding');
    imgMedian = median(imgblks);
    imgPre = reshape(imgMedian,size(img));
    
    RDLBPImage = NewRDLBP_Image(imgCurr,imgPre,lbpRadius,lbpRadiusPre,lbpPoints,mapping,'image');
    %RDLBPImage = RDLBPImage(:);
    %histRD = hist(RDLBPImage,0:(numLBPbins-1));
    %RDLBPImage = RDLBPImage + 1;
end

% for i = 1 : length(NILBPImage)
%     %Joint_CINI(NILBPImage(i),CImg(i)) = Joint_CINI(NILBPImage(i),CImg(i)) + 1;
%     %Joint_CIRD(RDLBPImage(i),CImg(i)) = Joint_CIRD(RDLBPImage(i),CImg(i)) + 1;
%     %Joint_NIRD(NILBPImage(i),RDLBPImage(i)) = ...
%     %    Joint_NIRD(NILBPImage(i),RDLBPImage(i)) + 1;
%     Joint_CINIRD(NILBPImage(i),RDLBPImage(i),CImg(i)) = ...
%         Joint_CINIRD(NILBPImage(i),RDLBPImage(i),CImg(i)) + 1;
% end
% mrelbp=Joint_CINIRD(:);
[slbp3D,slbp2D]=xu_featureConnection3D_2D(NILBPImage',CImg(:),RDLBPImage',numLBPbins,numLBPbins);
