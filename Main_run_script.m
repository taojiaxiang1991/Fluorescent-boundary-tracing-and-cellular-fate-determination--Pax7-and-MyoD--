close all;clear,clc;
Data_compressed = Tracing_auto_with_DAPI('Compressed_4um',3);
Data_uncompressed = Tracing_auto_with_DAPI('Uncompressed_8um',3);
Data_2nd_only = Tracing_auto_with_DAPI('2nd_only',1); 
Data_compressed = data_selection(Data_compressed,'Compressed_4um');
Data_uncompressed = data_selection(Data_uncompressed,'Uncompressed_8um');
save('Data/Data_compressed.mat','Data_compressed');
save('Data/Data_uncompressed.mat','Data_uncompressed');

