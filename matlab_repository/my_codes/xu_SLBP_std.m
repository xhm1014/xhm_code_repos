function [slbp3D,slbp2D]=xu_SLBP_std(img,lbpRadius,lbpPoints,mapping)


numLBPbins = mapping.num;

% image sample preprocessing
img = samp_prepro(img);     % temporarily comment normalization

% *********************************************************************
if mod(lbpRadius,2) == 0
    filWin = lbpRadius + 1;
    siz=floor((lbpRadius+1)/2);
else
    filWin = lbpRadius;
    siz=floor((lbpRadius)/2);
end
imgExt = padarray(img,[siz siz],'symmetric','both');
imgblks = im2col(imgExt,[filWin filWin],'sliding');
a = std(imgblks,0,1);
b = reshape(a,size(img));
% *********************************************************************

CImg = b(lbpRadius+1:end-lbpRadius,lbpRadius+1:end-lbpRadius);
CImg=CImg>=mean(double(CImg(:)));

[NILBPImage,RDLBPImage] = xu_SLBP(b,lbpRadius,lbpPoints,mapping,'image');

[slbp3D,slbp2D]=xu_featureConnection3D_2D(NILBPImage',CImg(:),RDLBPImage',numLBPbins,numLBPbins);




