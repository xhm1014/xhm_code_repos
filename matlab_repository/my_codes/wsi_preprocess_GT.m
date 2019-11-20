function bwGT=wsi_preprocess_GT(xmlfolder,imgName,objectivePower,magCoarse,rc)

%2) read xml lables
tt=objectivePower/magCoarse;
%xmlname=strcat(imgs(im).name(1:end-3),'xml');
xmlname=strcat(imgName(1:end-3),'xml');
fullFileName=fullfile(xmlfolder,xmlname);

if exist(fullFileName,'file')==2
    s=xml2struct(fullFileName);
    
    rr=s.Annotations.Annotation.Regions.Region;
    bwGT=false(rc);
    if isstruct(rr)
        bw=false(rc);
        v=rr.Vertices;
        m=cell2mat(v.Vertex);
        temp=[m.Attributes];
        X={temp.X};
        X3=cellfun(@str2num,X');
        %X2=cell2mat(X');
        %X3=str2num(X2);
        
        Y={temp.Y};
        Y3=cellfun(@str2num,Y');
        %Y2=cell2mat(Y');
        %Y3=str2num(Y2);
        
        
        X3=round(X3/tt);
        Y3=round(Y3/tt);
        
        Li=(Y3<1 | Y3>size(bw,1) | X3<1 | X3>size(bw,2));
        X3(Li)=[];
        Y3(Li)=[];
        
        ind=sub2ind(size(bw),Y3,X3);
        bw(ind)=1;
        
        bw2=roipoly(bw,X3,Y3);
        bwGT=bwGT|bw2;
    else
        for n=1:length(rr)
            bw=false(rc);
            v=rr{1,n}.Vertices;
            m=cell2mat(v.Vertex);
            temp=[m.Attributes];
            X={temp.X};
            X3=cellfun(@str2num,X');
            %X2=cell2mat(X');
            %X3=str2num(X2);
            
            Y={temp.Y};
            Y3=cellfun(@str2num,Y');
            %Y2=cell2mat(Y');
            %Y3=str2num(Y2);
            
            
            X3=round(X3/tt);
            Y3=round(Y3/tt);
            
            Li=(Y3<1 | Y3>size(bw,1) | X3<1 | X3>size(bw,2));
            X3(Li)=[];
            Y3(Li)=[];
            
            ind=sub2ind(size(bw),Y3,X3);
            bw(ind)=1;
            
            bw2=roipoly(bw,X3,Y3);
            bwGT=bwGT|bw2;
            
        end
    end
else
    bwGT=false(rc);
end
%figure,imshow(bwGT);