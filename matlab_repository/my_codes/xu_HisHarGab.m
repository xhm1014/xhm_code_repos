
function FF=xu_HisHarGab(Rimg)

dd=1:2:5;                                       %% glcm distance

%% a) first order histogram features
His=xu_statxture(Rimg); %<<6 features>> from oringial gray intensities

% b) second order glcm features
Hf=zeros(1,length(dd)*20);
for t=1:length(dd)
    glcm = graycomatrix(Rimg, 'offset', [0 dd(t);-dd(t) dd(t);-dd(t) 0;-dd(t) -dd(t)], 'Symmetric', true);
    Har=xu_Haralick(glcm);   %<<20 Haralic features>>
    Hf(1,20*(t-1)+1:20*t)=Har;
end

%% d) Gabor filter features
wavelength=2:2:12;                          %% gabor filter wavelength
deltaTheta=45;                              %% gabor filter orientation step
orientation=0:deltaTheta:(180-deltaTheta);  %% gabor filter orientations
g=gabor(wavelength,orientation);            %% gabor filter generation
Gab=xu_GaborFilters(Rimg,g,length(wavelength),length(orientation)); %<<12 features>>

FF=[His,Hf,Gab];