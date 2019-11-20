function feat=cellular_feature_computation(RGB)

%% 1) Nuclei seeds detections by gLoG kernels
debug=1;
gth=0.5;
nuclei_size=25;
gimg=RGB(:,:,1);
bwn=(gimg<gth*255);
bwn=imfill(bwn,'holes');
bwn=bwareaopen(bwn,nuclei_size);
Para.thetaStep=pi/9;          % thetaStep
Para.largeSigma=10;
Para.smallSigma=5;
Para.sigmaStep=-1;          % Sigma step
Para.kerSize=Para.largeSigma*4;              % Kernel size
Para.bandwidth=12;          % Mean-shift bandwidth
Para.dis=3;

cs=xp_NucleiSeedsDetection(gimg,bwn,Para);
ind1=find(cs(:,1)<Para.dis | (size(bwn,1)-cs(:,1))<Para.dis | cs(:,2)<Para.dis | (size(bwn,2)-cs(:,2))<Para.dis);
if ~isempty(ind1)  %% remove nuclear seeds close to image borders
    cs(ind1,:)=[];
end
if debug==1
    figure,imshow(RGB)
    hold on,plot(cs(:,2),cs(:,1),'y+','MarkerSize',5,'LineWidth',2);
end
bwSeed=zeros(size(bwn));
ind=sub2ind(size(bwn),cs(:,1),cs(:,2));
bwSeed(ind)=1;


%% 3) three features computation and kmeans clustering classification
H1 = fspecial('disk',5);
H1(H1>0)=1;

H2=fspecial('disk',11);
H2(H2>0)=1;
H2=H2-padarray(H1,[6,6]);

blurred_f1 = imfilter(double(gimg),H1,'replicate')./sum(sum(H1));
blurred_f2 = imfilter(double(gimg),H2,'replicate')./sum(sum(H2));
%blurred_e= imfilter(double(Eg),H1,'replicate');

%H2=fspecial('disk',15);
%H2(H2>0)=1;
%binary_f=imfilter(bwSeed,H2);

X=double(blurred_f2(ind)./blurred_f1(ind));

% X=bsxfun(@minus,X,mean(X));    % feature standardization
% X=bsxfun(@rdivide,X,std(X));   % feature standardization
rng(10);
options = statset('MaxIter',300);
GMModel = fitgmdist(X,2,'RegularizationValue',0.01,'Options',options);
P=posterior(GMModel,X);

LL=zeros(size(P,1),1);

mm=GMModel.mu;
if mm(1,1)<mm(2,1)
    LL(P(:,1)>0.7)=1;  %% assume 1: tumor cell nuclei
    LL(P(:,2)>0.7)=2;  %% assume 2: non-tumor cell nuclei
else
    LL(P(:,2)>0.7)=1;
    LL(P(:,1)>0.7)=2;
end
LL(LL==0)=3;

if debug==1
    hold on,plot(cs(LL==1,2),cs(LL==1,1),'g+','MarkerSize',5,'LineWidth',2);
    plot(cs(LL==2,2),cs(LL==2,1),'c+','MarkerSize',5,'LineWidth',2);
    plot(cs(LL==3,2),cs(LL==3,1),'y+','MarkerSize',5,'LineWidth',2);
%    hold off;
%     figure,
%     scatter(X(:,1),X(:,2),10,P(:,1));
%     hb=colorbar;
end

%% 3) adaptive nearest neighbor refinement
bwL1=zeros(size(bwSeed));
bwL1(ind(LL==1))=1;
bwL2=zeros(size(bwSeed));
bwL2(ind(LL==2))=1;
bwL3=zeros(size(bwSeed));
bwL3(ind(LL==3))=1;

H3=fspecial('disk',15);
H3(H3>0)=1;
bwf1=imfilter(bwL1,H3);
bwf2=imfilter(bwL2,H3);
bwf3=imfilter(bwL3,H3);

votes=[bwf1(ind),bwf2(ind),bwf3(ind)];
[~,LLf]=max(votes,[],2);

if debug==1
    %figure,imshow(RGB)
    hold on,plot(cs(LLf==1,2),cs(LLf==1,1),'g+','MarkerSize',5,'LineWidth',2);
    plot(cs(LLf==2,2),cs(LLf==2,1),'c+','MarkerSize',5,'LineWidth',2);
    plot(cs(LLf==3,2),cs(LLf==3,1),'y+','MarkerSize',5,'LineWidth',2);
    hold off;
    
    %close all;
end
feat=0;