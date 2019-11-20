function [slbp3D,slbp2D]=xu_SLBP_median_std(img,lbpRadius,lbpPoints,mapping)


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

CImg = img(lbpRadius+1:end-lbpRadius,lbpRadius+1:end-lbpRadius); %% C using original image without any preprocessing
CImg=CImg>=mean(double(CImg(:)));

a_med = median(imgblks);
b_med = reshape(a_med,size(img));

a_std = std(imgblks,0,1);
b_std = reshape(a_std,size(img));

[SLBPImage_med,SLBPImage_std] = xu_SLBP_pairing(b_med,b_std,lbpRadius,lbpPoints,mapping,'image');

[slbp3D,slbp2D]=xu_featureConnection3D_2D(SLBPImage_med',CImg(:),SLBPImage_std',numLBPbins,numLBPbins);
