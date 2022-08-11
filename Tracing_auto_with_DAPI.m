function [Data] = Tracing_auto_with_DAPI(Expr,Thresh_back)
warning('off'); close all; clc; %Supresses the warning message generated
% path: The directory where all the DIC images are located.


pathname = ([Expr,'/']);
%% FL Tracing
%Thresh_back =3.0; %Threshold below which are considered as background.
disksize = 10; %parameters to close the image.
MinNSize = 100;
Data = [];

DAPIfile = dir([pathname,'*c1*']); Pafile = dir([pathname,'*c2*']); Myfile= dir([pathname,'*c3*']);


%% Loading the image: and initializing Data
for j =	1:length(DAPIfile)
    
    DA = double(imread([pathname,DAPIfile(j).name]));
    PA = double(imread([pathname,Pafile(j).name]));
    Mk = double(imread([pathname,Myfile(j).name]));
    

    %% Tracing
    [Mask,~] = FL_tracing(DA,Thresh_back,MinNSize,disksize);
    Labeling = bwlabel(Mask);
    stats = regionprops(Labeling,'Area','Perimeter','Centroid');
    AreaN = cat(1,stats.Area); centroids = cat(1,stats.Centroid);
    figure(1);  imshow(DA,[]); title('DAPI');
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    for i = 1:length(AreaN)
        Mask_in = Labeling==i; Mask_in = double(Mask_in);
        MaskP = imdilate(Mask_in,strel('disk',10));MaskP = double(MaskP); 
        MaskP2 = imdilate(Mask_in,strel('disk',25)); MaskP2 = double(MaskP2);
        MaskP = MaskP2-MaskP; clear MaskP2; 
        Pg = PA.*MaskP; Mg = Mk.*MaskP; Pg = Pg(Pg~=0); Mg = Mg(Mg~=0); 
        Pg = mean(Pg(:)); Mg = mean(Mg(:));
        Pax7 = PA.*Mask_in; MyoD = Mk.*Mask_in;
        Pax7 = Pax7-Pg;  Pax7(Pax7<0) = 0;   MyoD = MyoD-Mg; MyoD(MyoD<0) = 0;
        Bou = bwboundaries(Mask_in); Bou = Bou{1};
        Data = [Data; j, i, AreaN(i),sum(Pax7(:)),sum(MyoD(:))];
        figure(1); hold on;
        plot(Bou(:,2),Bou(:,1),'b-','linewidth',2);
        text(centroids(i,1), centroids(i,2),int2str(i),'Color',[1 1 1],'FontSize',11,'FontWeight','bold','FontName','Times');
      
        save(['Data_not_refined/',Expr,'.mat'],'Data');
    
    end
    Fig = getframe(gcf); [FrameNew,~] = frame2im(Fig);
   
    imwrite(FrameNew,['Tracing/',Expr,'_Frame',num2str(j),'.tif']); 
   
    close 1;
end