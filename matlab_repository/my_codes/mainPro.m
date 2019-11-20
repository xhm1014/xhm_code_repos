
addpath(genpath('C:\Users\xuh3\Desktop\prostate-project\image-tiles-generation\misc\'));

imgpath={'C:\Users\xuh3\Desktop\prostate-project\image_patches\g6\','C:\Users\xuh3\Desktop\prostate-project\image_patches\g7\',...
    'C:\Users\xuh3\Desktop\prostate-project\image_patches\g8\','C:\Users\xuh3\Desktop\prostate-project\image_patches\g9\'};

debugpath={'C:\Users\xuh3\Desktop\prostate-project\image_patches\debug\g6\','C:\Users\xuh3\Desktop\prostate-project\image_patches\debug\g7\',...
    'C:\Users\xuh3\Desktop\prostate-project\image_patches\debug\g8\','C:\Users\xuh3\Desktop\prostate-project\image_patches\debug\g9\'};
%list=dir(strcat(g6imgpath,'*.jpg'));
siz=33; %% filter size on binary images
mapping1=getmapping(8,'u2');
mapping2=getmapping(16,'riu2');              %% for LBP feature calculation

Para.thetaStep=pi/9;
Para.largeSigma=6;
Para.smallSigma=3;
Para.sigmaStep=-1;
Para.kerSize=Para.largeSigma*4;
Para.bandwidth=4;
dis=10; % if the seeds is close to image borders less than 10 pixels, removed for consideration.
rr=2; 

for gc=1:length(imgpath)
    imagePath=imgpath{gc};
    imgs=dir(fullfile(imagePath,'*.jpg'));
    
    F46=zeros(length(imgs),48);
    for imInd=1:length(imgs)
        file1=fullfile(imagePath,imgs(imInd).name);
        fprintf('fileName=%s\n%d\n',file1,imInd);
        I=imread(file1);
        
        % 1) colornormalization
        [In,H,E]=normalizeStaining(I);
        
            Eg=rgb2gray(E);
            thresh=multithresh(Eg,2);
            bwE=(Eg<=thresh(1));
            bwE=bwareaopen(bwE,15);
        
        
        
         %% 7) compute LNP features from original image usiing LBP --local neighbor pattern combined with LBP
        RBP=xu_RBP(In(:,:,1),3:10,mapping1,'nh');
        
        LNP=xu_LNP(In(:,:,1),7,mapping1,'nh');
        
        
        Lt=LBP(In(:,:,1),rr,16,mapping2,'nh');
        Lt=squeeze(Lt);
            
            
            
        % 2 nuclei detection by gLoG
        Hg=rgb2gray(H);
        thresh=multithresh(Hg,2);
        bwH=(Hg<=thresh(1));
        bwH=bwareaopen(bwH,15);
        
        figure,imshow(I);
        %     B=bwboundaries(bwH);
        %     for k=1:length(B)
        %         boundary = B{k};
        %         hold on,plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 2)
        %     end
        
        
        %% Nuclei seeds detections by gLoG kernels
        cs=xp_NucleiSeedsDetection(Hg,bwH,Para);
        ind1=find(cs(:,1)<dis | (size(Hg,1)-cs(:,1))<dis | cs(:,2)<dis | (size(Hg,2)-cs(:,2))<dis);
        if ~isempty(ind1)  %% remove nuclear seeds close to image borders
            cs(ind1,:)=[];
        end
        hold on,plot(cs(:,2),cs(:,1),'y+','MarkerSize',5,'LineWidth',2);
        bwSeed=zeros(size(bwH));
        ind=sub2ind(size(bwH),cs(:,1),cs(:,2));
        bwSeed(ind)=1;
        
        %3) two features computation and kmeans clustering classification
        H1 = fspecial('disk',10);
        blurred_f = imfilter(double(Hg),H1,'replicate');
        blurred_e= imfilter(double(Eg),H1,'replicate');
        
        H2=fspecial('disk',siz);
        H2(H2>0)=1;
        binary_f=imfilter(bwSeed,H2);
        
        X=[double(blurred_f(ind)),double(blurred_e(ind)),double(binary_f(ind))];
        
        X=bsxfun(@minus,X,mean(X));    % feature standardization
        X=bsxfun(@rdivide,X,std(X)); % feature standardization
        [L,C] = kmeansPlus(X',2);
        cind1=find(L==1);
        cind2=find(L==2);
        
        hold on,plot(cs(cind1,2),cs(cind1,1),'g+','MarkerSize',5,'LineWidth',2);
        %hold off;
        
        
        %% 4) nearest neighbor refinement
        bwLL=zeros(size(bwSeed));
        bwLL(ind(cind1))=1;
        bwLL(ind(cind2))=2;
        H3=fspecial('disk',siz);
        H3(H3>0)=1;
        bwLL_f=imfilter(bwLL,H3);
        Lref=round(bwLL_f(ind)./binary_f(ind));
        
        figure,imshow(I);
        if C(3,1)>C(3,2)         % densitify feature
            cind1=find(Lref==1);  %% let cind1 correspond to epithelial class
            cind2=find(Lref==2);  %% let cind2 correspond to stromal class
        else
            cind1=find(Lref==2);
            cind2=find(Lref==1);
        end
        hold on,plot(cs(cind1,2),cs(cind1,1),'g+','MarkerSize',5,'LineWidth',2); %% epithelial class
        hold on,plot(cs(cind2,2),cs(cind2,1),'c+','MarkerSize',5,'LineWidth',2); % stroal class
        saveas(gcf,strcat(debugpath{gc},imgs(imInd).name));
        
        %% 5) compute delaunay features -- high level feature computation
        DT=delaunayTriangulation(cs(:,2),cs(:,1));
        BE=zeros(1,4); % AA,AB,BB
        tp=DT.ConnectivityList;
        tpL=Lref(tp);
        tpV=sum(tpL,2);
        trinum=size(tp,1)*size(tp,2);
        BE(1,1)=(sum(tpV==3)*3+sum(tpV==4)*1)/trinum;  % AA
        BE(1,2)=(sum(tpV==4)*2+sum(tpV==5)*2)/trinum;  % AB
        BE(1,3)=(sum(tpV==5)*1+sum(tpV==6)*3)/trinum;  % BB
        BE(1,4)=numel(cind1)/numel(Lref);
        
            % for ploting triangles with different colors
            hold on,triplot(DT);
            pp=DT.Points;
            for tt=1:size(tp,1)
                temp=tp(tt,:);
                for kk=1:3
                    ps=pp(temp(kk),:);
                    psl=Lref(temp(kk));
                    if kk~=3
                        pe=pp(temp(kk+1),:);
                        pel=Lref(temp(kk+1));
                    else
                        pe=pp(temp(1),:);
                        pel=Lref(temp(1));
                    end
        
                    if psl==1 && pel==1
                        hold on, plot([ps(1),pe(1)],[ps(2),pe(2)],'k-','LineWidth',2);
                    elseif (psl==1 && pel==2) || (psl==2 && pel==1)
                        hold on,plot([ps(1),pe(1)],[ps(2),pe(2)],'r-','LineWidth',2);
                    elseif (psl==2 && pel==2)
                        hold on, plot([ps(1),pe(1)],[ps(2),pe(2)],'b-','LineWidth',2);
                    else
                        disp('!!!impossible');
        
                    end
                end
            end
        
        %% 6) compute LNP features based on epithilial nuclei - high level neigboring features
        HF=xu_LocalNeighborhoodPattern(45);
        
        bwE=zeros(size(bwSeed));
        bwE(ind(cind1))=1; % epithelial
        bwS=zeros(size(bwSeed));
        bwS(ind(cind2))=1; % stromal
        binN=4;
        FF=zeros(1,size(HF,3)*2);
        
        FF_kk=zeros(size(HF,3),length(cind1));
        for kk=1:size(HF,3)
            bwE_kk=imfilter(bwE,HF(:,:,kk));
            %bwS_kk=imfilter(bwS,HF(:,:,kk));
            %FF_kk=bwS_kk(ind(cind1))./bwE_kk(ind(cind1));
            FF_kk(kk,:)=bwE_kk(ind(cind1));
            
            %% feature rescaling
            %         scal=max(FF_kk)-min(FF_kk);
            %         FF_kk=bsxfun(@minus,FF_kk,min(FF_kk));
            %         FF_kk=bsxfun(@rdivide,FF_kk,scal);
            %         [N,xout]=hist(FF_kk,binN);
            %         FF((kk-1)*binN+1:kk*binN)=N;
        end
        FF_bb=sort(FF_kk);   %% make sure rotation invariant
        FF(1:size(HF,3))=mean(FF_bb,2);
        FF(size(HF,3)+1:end)=std(FF_bb,[],2);
        %FF_nn=bsxfun(@rdivide,FF_kk,sum(FF_kk));
%         for kk=1:size(FF_nn,1)
%             [N,xout]=hist(FF_nn(kk,:),binN);
%             FF((kk-1)*binN+1:kk*binN)=N;
%         end
        
        
        F46(imInd,:)=[BE,FF,LNP,Lt'];
        %se = strel('disk',12);
        %Hg_tophat=imtophat(~Hg,se);
        %     Ts=200; Te=50; HL=0.8; UpSize=150;DownSize=30;
        %     img=255-Hg;
        %     bwNuclei=false(size(img));
        %     figure,imshow(img);
        %     for t=Ts:-20:Te
        %         TH=t;
        %         TL=TH*HL;
        %         hys=xu_hysteresis(img,TL,TH,8);
        % %         CC=bwconncomp(hys);
        % %         numPixels=cellfun(@numel,CC.PixelIdxList);
        % %         ind=find(numPixels>DownSize & numPixels<UpSize);
        % %         bwNuclei(cat(1,CC.PixelIdxList{ind}))=hys(cat(1,CC.PixelIdxList{ind}));
        %         B=bwboundaries(hys);
        %         for k=1:length(B)
        %             boundary = B{k};
        %             hold on,plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 2)
        %         end
        %         %img(cat(1,CC.PixelIdxList{ind}))=0;
        %         img(hys)=0;
        %     end
        %     figure,imshow(hys);
        close all;
    end
    Patname=strcat(num2str(gc),'-',num2str(imInd),'.mat');
    save(strcat(imgpath{gc},Patname),'F46');
end
t=0;