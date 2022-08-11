function [Pax7,MyoD] = Data_extraction(Data);
Pax7 = Data(:,4)./Data(:,3); MyoD = Data(:,5)./Data(:,3);