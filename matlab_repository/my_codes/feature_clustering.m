%%------%%
% input: featm: feature matrix
%        numc: the number of desired clusters
% output: find: index of selected features
function [idx,indf]=feature_clustering(featm,numc)

featm00=bsxfun(@minus,featm,mean(featm));    % feature standardization
featm01=bsxfun(@rdivide,featm00,std(featm));   % feature standardization

if size(featm01,1)>numc
    rng default; % for reproducibility
    opts=statset('Display','final');
    [idx,C]=kmeans(featm01,numc,'Replicates',5,'Options',opts);
    
    D=pdist2(C,featm01);
    [minv,indf]=min(D,[],2);
else
    indf=(1:1:size(featm01,1))';
    idx=(1:1:size(featm01,1))';
end