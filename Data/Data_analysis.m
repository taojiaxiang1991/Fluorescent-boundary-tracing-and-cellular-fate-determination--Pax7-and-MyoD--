close all;clear,clc;
load('Data_uncompressed.mat');
load('Data_compressed.mat');
load('../Data_not_refined/2nd_only.mat');
Pcut = 14; Mcut = 40; %Intepolated from the histogram of compressed, Uncompressed and 2nd only intensity file
[Pax7u,MyoDu] = Data_extraction(Data_uncompressed);
[Pax7,MyoD] = Data_extraction(Data_compressed);
[Pn,Mn] = Data_extraction(Data);
clear Data_uncompressed Data_compressed Data
subplot(2,2,1); hold on;
hpn = histogram(Pn); hpn.Normalization = 'Probability'; hpn.BinWidth = 3;
hp = histogram(Pax7); hp.Normalization = 'Probability'; hp.BinWidth = 2;
hpu = histogram(Pax7u); hpu.Normalization = 'Probability'; hpu.BinWidth = 2;
plot([Pcut,Pcut],[0,1],'k--','linewidth',1.5); xlim([0 50]); ylim([0 0.3]);
hp.EdgeColor = 'n'; hpu.EdgeColor = 'n'; hpn.EdgeColor = 'n';

subplot(2,2,2); hold on;
hmn = histogram(Mn); hmn.Normalization = 'Probability'; hmn.BinWidth = 20;
hm = histogram(MyoD); hm.Normalization = 'Probability'; hm.BinWidth = 10;
hmu = histogram(MyoDu); hmu.Normalization = 'Probability'; hmu.BinWidth = 10;
plot([Mcut,Mcut],[0,1],'k--','linewidth',1.5);ylim([0 0.5]);
hm.EdgeColor = 'n'; hmu.EdgeColor = 'n'; hmn.EdgeColor = 'n';
legend('Secondary Antibody Only','2+3d-C','5d-U');

for i = 1:length(Pax7)
    np = 0; nm = 0;
    if Pax7(i)>=Pcut; np = 1; end;
    if MyoD(i)>=Mcut; nm = 1; end;
    count(i) = 10*np+nm; clear np nm;
end
stemcell = 100*length(find(count==10))/length(count);
proginitors = 100*length(find(count==11))/length(count);
diffcells = 100*length(find(count<=1))/length(count);


for i = 1:length(Pax7u)
    np = 0; nm = 0;
    if Pax7u(i)>=Pcut; np = 1; end;
    if MyoDu(i)>=Mcut; nm = 1; end;
    countu(i) = 10*np+nm; clear np nm;
end
%% Calculating the Pax7+/MyoD- (stem cell), Pax7+/MyoD+ (Proginitors), and Pax7- (Diff cells) populational fractions
stemcellu = 100*length(find(countu==10))/length(countu);
proginitorsu = 100*length(find(countu==11))/length(countu);
diffcellsu = 100*length(find(countu<=1))/length(countu);
%% p value calcuation
pvaule_stemcells = MantelHaenTest([length(find(countu==10)),length(find(countu==11))+length(find(countu<=1)); length(find(count==10)),length(find(count==11))+length(find(count<=1))],'ne'); 
pvalue_diff_cells= MantelHaenTest([length(find(countu==10))+length(find(countu==11)),length(find(countu<=1)); length(find(count==10))+length(find(count==11)),length(find(count<=1))],'ne'); 



display(['Among 5d-U cells, ',num2str(stemcellu),'% population is Pax7^+ MyoD^-; ',num2str(proginitorsu), '% population is Pax7^+ MyoD^+; and ',num2str(diffcellsu),'% population is Pax7^-']);
display(['Among 2+3d-C cells, ',num2str(stemcell),'% population is Pax7^+ MyoD^-; ',num2str(proginitors), '% population is Pax7^+ MyoD^+; and ',num2str(diffcells),'% population is Pax7^-']);

