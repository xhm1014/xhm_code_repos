function [h]=xu_Haralick(glcm)
Har = xu_GLCM_Features4(glcm);                                 %<<20 Haralic features>>
Gf=reshape(struct2array(Har),[],length(fieldnames(Har)));
h=mean(Gf,1);                                                 % compute mean value in four directions
%h=reshape(h,[1,1,length(h)]);