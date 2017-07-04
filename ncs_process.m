function NCS_process(input_DIR,suboutput_DIR,VID_DIR,FRM_FN,FRM_IDX)
%%% NCS procressing for all frames
%%%
%%% Code rule: mainfunction_subfunction in English rule, captial indicates abbriation text,
%%% i.e., IMG (image), FRM (frame), VID (video), FN (file name)
%%%
%%% Author: kazuki minemura
%%% Last update: 22th MAY 2015


%%% Read 8x8 block from csv
csv_FN = [input_DIR,VID_DIR,'COF_F',FRM_IDX,'.csv'];
COF_Y = csvread(csv_FN);


%%% Global variance
COF_Y = COF_Y(1:end,1:end-1);
[M N] = size(COF_Y);
% NCS = zeros(M/4,N/4,2);
NCS_P = zeros(M/4,N/4);% plus sign number
NCS_N = zeros(M/4,N/4);% negative sign number

for height=1:4:M
%     disp(height);
    for width=1:4:N
        BLK = zeros(4,4);
        BLK(:,:) = COF_Y(height:height+3,width:width+3);
        BLK(1,1) = 0;

        NCS_P(floor(height/4) + 1,floor(width/4) + 1) = sum(sum((BLK > 0)));
        NCS_N(floor(height/4) + 1,floor(width/4) + 1) = sum(sum((BLK < 0)));
    end
end

NCS_M = NCS_P > NCS_N;

% NCS = NCS_P+NCS_N;
% NCS_P = NCS_P(NCS>0);
% NCS_N = NCS_N(NCS>0);
% NCS = [PNCS(:),NNCS(:)];
% %%%% Scatter figure of NCS
% figure('Visible','off');
% hist3(NCS,[16 16]);
% set(gca,'FontSize',18);
% set(gca,'XScale','linear');
% xlabel('Positive Sign','FontSize', 18, 'FontWeight', 'bold');
% ylabel('Negative Sign','FontSize', 18, 'FontWeight', 'bold');
% saveas(gcf,[suboutput_dir,'HIS3_NCS_',ImageName(1:length(ImageName)-4),'.jpg']);
% delete(gcf);


%--- Edge similarity score ---
NCS_P_BW = im2bw(NCS_P,graythresh(NCS_P));
NCS_N_BW = im2bw(NCS_N,graythresh(NCS_N));
BW_P = sum(sum(NCS_P_BW==1));
BW_N = sum(sum(NCS_P_BW==0));
n1 = sum(sum((NCS_P==0)&(NCS_N==0)));
n2 = sum(sum((NCS_P==1)&(NCS_N==1)));
n3 = sum(sum((NCS_P==0)&(NCS_N==1)));
n4 = sum(sum((NCS_P==1)&(NCS_N==0)));

ESS = n1/BW_N + n2/BW_P - n3/BW_N - n4/BW_P;


if FRM_IDX == 1
    fid = fopen([suboutput_DIR,'NCS_statistics.csv'],'w');
    fprintf(fid,'%s,%d,%d,%d,%f\n',FRM_FN,sum(NCS_P(:))+sum(NCS_N(:)),sum(NCS_P(:)),sum(NCS_N(:)),ESS);
    fclose(fid);
else
    fid = fopen([suboutput_DIR,'NCS_statistics.csv'],'a');
    fprintf(fid,'%s,%d,%d,%d,%f\n',FRM_FN,sum(NCS_P(:))+sum(NCS_N(:)),sum(NCS_P(:)),sum(NCS_N(:)),ESS);
    fclose(fid);
end


%------- Wirte image--------------------
tag = 'NCS_P';
imwrite(NCS_P,[suboutput_DIR,tag,'_',FRM_FN]);
tag = 'NCS_N';
imwrite(NCS_N,[suboutput_DIR,tag,'_',FRM_FN]);
tag = 'NCS_M';
imwrite(NCS_M,[suboutput_DIR,tag,'_',FRM_FN]);