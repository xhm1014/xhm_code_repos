function [NI_slbp,RD_slbp] = xu_SLBP(img,lbpRadius,lbpPoints,mapping,mode)
blocks1 = cirInterpSingleRadiusNew(img,lbpPoints,lbpRadius);
blocks1 = blocks1'; 

imgTemp = img(lbpRadius+1:end-lbpRadius,lbpRadius+1:end-lbpRadius);
blocks2 = repmat(imgTemp(:),1,lbpPoints);
radialDiff = blocks1 - blocks2;
radialDiff(radialDiff >= 0) = 1;
radialDiff(radialDiff < 0) = 0;
bins = 2^lbpPoints;
weight = 2.^(0:lbpPoints-1);
radialDiff = radialDiff .* repmat(weight,size(radialDiff,1),1);
RD_slbp = sum(radialDiff,2);


blocks1 = blocks1 - repmat(mean(blocks1,2),1,size(blocks1,2));
blocks1(blocks1 >= 0) = 1;
blocks1(blocks1 < 0) = 0;
blocks1 = blocks1 .* repmat(weight,size(blocks1,1),1);
NI_slbp = sum(blocks1,2);

% Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    
    RD_slbp = mapping.table(RD_slbp+1);
    
    NI_slbp = mapping.table(NI_slbp+1);
end


if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
    % Return with LBP histogram if mode equals 'hist'.
    RD_slbp = hist(RD_slbp(:),0:(bins-1));
    
    NI_slbp = hist(NI_slbp(:),0:(bins-1));
    
    if (strcmp(mode,'nh'))
        RD_slbp = RD_slbp/sum(RD_slbp);
        
        NI_slbp = NI_slbp/sum(NI_slbp);
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








