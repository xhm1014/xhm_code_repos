function [LBP_OCR_3D,LBP_R_OC_2D]=xu_featureConnection3D_2D(LBP_O,LBP_C,LBP_R,numO,numR)

level=max(max(LBP_C))+1;

% 3D feature joint connection
LBP_MCSum = LBP_O;
idx = find(LBP_C);
LBP_MCSum(idx) = LBP_MCSum(idx)+numO;
LBP_temp = [LBP_R,LBP_MCSum];
Hist3D = hist3(LBP_temp,[numR,numO*level]);
LBP_OCR_3D = reshape(Hist3D,1,numel(Hist3D));

% 2D feature joint connection
LBP_Rf=hist(LBP_R,0:numR-1);
LBP_OC=[LBP_O,LBP_C];
Hist2D=hist3(LBP_OC,[numO,level]);
LBP_OCf=reshape(Hist2D,1,numel(Hist2D));
LBP_R_OC_2D=[LBP_Rf,LBP_OCf];



