function LBP_SC=xu_featureConnection(LBP_S,LBP_C,num)

level=max(max(LBP_C))+1;

% Generate histogram of LBP_S/C
LBP_SC = [LBP_S,LBP_C];
Hist3D = hist3(LBP_SC,[num,level]);
LBP_SC = reshape(Hist3D,1,numel(Hist3D));

