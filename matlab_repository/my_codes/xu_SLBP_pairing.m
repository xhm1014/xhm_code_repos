function [RD_slbp_med,RD_slbp_std] = xu_SLBP_pairing(img_med,img_std,lbpRadius,lbpPoints,mapping,mode)
block_med = cirInterpSingleRadiusNew(img_med,lbpPoints,lbpRadius);
block_med = block_med'; 

block_std = cirInterpSingleRadiusNew(img_std,lbpPoints,lbpRadius);
block_std = block_std'; 

% blocks1=xu_prime_base(block_med,block_std);
% img=xu_prime_base(img_med,img_std);

bins = 2^lbpPoints;
weight = 2.^(0:lbpPoints-1);

imgTemp_med = img_med(lbpRadius+1:end-lbpRadius,lbpRadius+1:end-lbpRadius);
blocks2 = repmat(imgTemp_med(:),1,lbpPoints);
radialDiff =block_med  - blocks2;
radialDiff(radialDiff >= 0) = 1;
radialDiff(radialDiff < 0) = 0;
radialDiff = radialDiff .* repmat(weight,size(radialDiff,1),1);
RD_slbp_med = sum(radialDiff,2);


imgTemp_std = img_std(lbpRadius+1:end-lbpRadius,lbpRadius+1:end-lbpRadius);
blocks2 = repmat(imgTemp_std(:),1,lbpPoints);
radialDiff =block_std  - blocks2;
radialDiff(radialDiff >= 0) = 1;
radialDiff(radialDiff < 0) = 0;
radialDiff = radialDiff .* repmat(weight,size(radialDiff,1),1);
RD_slbp_std = sum(radialDiff,2);

% blocks1 = blocks1 - repmat(mean(blocks1,2),1,size(blocks1,2));
% blocks1(blocks1 >= 0) = 1;
% blocks1(blocks1 < 0) = 0;
% blocks1 = blocks1 .* repmat(weight,size(blocks1,1),1);
% NI_slbp = sum(blocks1,2);

% Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    
    RD_slbp_med = mapping.table(RD_slbp_med+1);
    
    RD_slbp_std = mapping.table(RD_slbp_std+1);
end


if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
    % Return with LBP histogram if mode equals 'hist'.
    RD_slbp_med = hist(RD_slbp_med(:),0:(bins-1));
    
    RD_slbp_std = hist(RD_slbp_std(:),0:(bins-1));
    
    if (strcmp(mode,'nh'))
        RD_slbp_med = RD_slbp_med/sum(RD_slbp_med);
        
        RD_slbp_std = RD_slbp_std/sum(RD_slbp_std);
    end
% else
%     % Otherwise return a matrix of unsigned integers
%     if ((bins-1) <= intmax('uint8'))
%         result = uint8(result);
%     elseif ((bins-1) <= intmax('uint16'))
%         result = uint16(result);
%     else
%         result = uint32(result);
%     end
end








