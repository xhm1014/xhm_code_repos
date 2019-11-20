function hys=xu_hysteresis(img,t1,t2,conn)

%% scale t1 & t2 based on image intensity range
if t1>t2    % swap values if t1>t2 
	tmp=t1;
	t1=t2; 
	t2=tmp;
end

%% hysteresis
abovet1=img>t1;                                     % points above lower threshold
seed_indices=sub2ind(size(abovet1),find(img>t2));   % indices of points above upper threshold
hys=imfill(~abovet1,seed_indices,conn);              % obtain all connected regions in abovet1 that include points with values above t2
hys=hys & abovet1;

%highmask = img>t2; 
%lowmask = bwlabel(~(img<t1)); 
%hys2 = ismember(lowmask,unique(lowmask(highmask)));