function D = data_selection(Data,Expr)
%load(['Data/',Expr,'.mat']);
Frame = Data(:,1); D = Data;
for i = min(Frame):max(Frame)
    A = imread(['Tracing/',Expr,'_Frame',num2str(i),'.tif']);
    Dk = D(D(:,1)==i,:); D(D(:,1)==i,:) = [];
    figure(1); imshow(A,[]);
    k = input('Input the cell number you want to delete (if none, put 0): ');
    figure(1); set(gcf,'units','normalized','outerposition',[0 0 1 1]); 
    while k~=0
        Dk(Dk(:,2)==k,:) = []; close 1;
        figure(1); imshow(A,[]);
        k = input('Input another cell number you want to delete (if none, put 0): ');
        figure(1); set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    end
    D = [D; Dk];
    clear A Dk k; close all; 
end