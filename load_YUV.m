function [Y U V] = Load_YUV(suboutput_DIR,FRM_FN,YUV_output,width,height,FRM_IDX)
%%% Load YUV file
%%% this is a batch function which iterate function in a dataset images
%%%
%%% Author: kazuki minemura
%%% Last update: 21th MAY 2015


%--- read YUV file ---
disp(YUV_output);
file_id = fopen([YUV_output], 'r');
FRM_size = floor(1.5 * width * height);
% disp(uint32((FRM_IDX - 1) * FRM_size));
fseek(file_id,(FRM_IDX - 1)*FRM_size,'bof');

% read Y component
buf = fread(file_id,uint32(width * height),'uchar');
Y = reshape(buf,height,width).'; % reshape
% buf = fread(file_id,uint32(width/2 * height/2),'uchar');
% U = reshape(buf,height/2,width/2).'; % reshape
% buf = fread(file_id,uint32(width/2 * height/2),'uchar');
% V = reshape(buf,height/2,width/2).'; % reshape
U = 1;
V = 1;
fclose(file_id);

% U = resize(U,2,'nearest');
% V = resize(V,2,'nearest');

IMG_outdir = [suboutput_DIR,'Y_',FRM_FN];
imwrite(uint8(Y),IMG_outdir);
end