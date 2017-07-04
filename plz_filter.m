% LPZ filtering function
% this is a batch function which iterate function in a dataset images
%
% kazuki minemura
% 18th Apr 2014 last udate


%%% Read 8x8 block from csv
if Switch == 'H264'
    csvnames = dir([input_dir,video_dir,'/', 'COF_F', frame_index,'.csv']);
    CSVname = csvnames.name; %H264
    CSVname = [input_dir,video_dir,'/',CSVname];
else
    %%% JPEG-XR
    CSVname = [input_dir,video_dir,videoName,'_',num2str(frame_index),'/','DCT_F0_Y.csv'];
end

CoefALL_Y = csvread(CSVname);
% ImageName = [NewinputName,'_',num2str(frame_num),'.jpg'];
% ImageName = [videoName(1:length(videoName)-4),'_',num2str(frame_index),'.pnm'];
% ImageName = [videoName(1:length(videoName)),'_',num2str(frame_index),'.pnm'];


%%% Global variance
[X Y] = size(CoefALL_Y);
Y = Y - 1;
LPZ = zeros(X/4,Y/4);

%------ 4x4 PLZ -----------------------
Zigzag4x4 = [
    1     2     6     7
    3     5     8    13
    4     9    12    14
    10    11    15    16
    ];
Zigzag4x4 = Zigzag4x4(:);
Block = zeros(4,4);
for height=1:4:X
    for width=1:4:Y
        Block(:,:) = CoefALL_Y(height:height+3,width:width+3);
        Block_1D = reshape(Block,[16,1]);
        Block_1D(Zigzag4x4(:))=Block_1D(:);
        if sum(sum(abs(Block))) == 0
            LPZ(floor(height/4) + 1,floor(width/4) + 1) = 0;
        else
            LPZ(floor(height/4) + 1,floor(width/4) + 1) = find(Block_1D ~= 0, 1, 'last');
        end
    end
end

% LPZ_max = max(max(LPZ));
% figure('Visible','off');
% LPZ1D = reshape(LPZ,[],1);
% hist(LPZ1D,LPZ_max);
% set(gca,'FontSize',18);
% set(gca,'XScale','linear');
% set(gca,'YLim',[0 2000]);
% xlabel('postion of last HP cofficients','FontSize', 18, 'FontWeight', 'bold');
% ylabel('Frequency','FontSize', 18, 'FontWeight', 'bold');
% saveas(gca,[suboutput_dir,'HIS_LPZ_',ImageName(1:length(ImageName)-4),'.jpg']);


% %----- standard deviation
% Input = LPZ;
% Output = zeros(X/4,Y/4);
% for x=2:1:X/4-1
%     for y=2:1:Y/4-1
%         ParBlk = zeros(3,3);
%         ParBlk(:,:) = Input(x-1:1:x+1,y-1:1:y+1);
%         ParBlk = reshape(ParBlk,[9,1]);
%         AS = size(ParBlk,2); %% size of 1 dimension InputArray
%         M = median(ParBlk); %% median of InputArray
%         TemSum = sum(ParBlk - M)^2;
%         TemSum = TemSum/AS;
%         Output(x,y) = sqrt(TemSum); %%% Median std
%     end
% end
% Output = Output*255 / max(max(Output));
% Output = imresize(Output,4,'nearest');
% tag = 'STD';
% imwrite(uint8(Output),[suboutput_dir,tag,'_',ImageName]);

%----- gause filtering
% H = fspecial('average');
% LPZ_avg = imfilter(LPZ,H,'replicate');
% H = fspecial('gaussian');
% LPZ_gau = imfilter(LPZ,H,'replicate');

%----- histogram -------
% figure('Visible','off');
% hist(reshape(LPZ,[X*Y/16 1]),16);
% tag = 'LPZHist';
% saveas(gca,[suboutput_dir,tag,'_',ImageName(1 : length(ImageName) - 4)],'jpg');
% close all


% %%%% Histogram of LPZ
% figure('Visible','off');
% Com1D = reshape(LPZ,[],1);
% hist(Com1D,16);
% set(gca,'FontSize',18);
% set(gca,'XScale','linear');
% % set(gca,'YLim',[0 2000]);
% xlabel('PLZ value','FontSize', 18, 'FontWeight', 'bold');
% ylabel('Frequency','FontSize', 18, 'FontWeight', 'bold');
% saveas(gcf,[suboutput_dir,'HIS_PLZ_',ImageName(1:length(ImageName)-4),'.eps']);
% delete(gcf);

%----- normalization ---------
LPZ = floor((LPZ*255) / max(max(LPZ)));
% LPZ = imresize(LPZ,4,'nearest');
% LPZ_avg = LPZ_avg*255 / max(max(LPZ_avg));
% LPZ_avg = imresize(LPZ_avg,4,'nearest');
% LPZ_gau = LPZ_gau*255 / max(max(LPZ_gau));
% LPZ_gau = imresize(LPZ_gau,4,'nearest');

%----- comprexity selection ---------
% LPZF = LPZ > (255 * 0.75);
% LPZ =  LPZ .* LPZF;




%------- Wirte image--------------------
tag = 'PLZ';
imwrite(uint8(LPZ),[suboutput_dir,tag,'_',ImageName]);
% tag = 'LPZavg';
% imwrite(uint8(LPZ_avg),[suboutput_dir,tag,'_',ImageName]);
% tag = 'LPZgau';
% imwrite(uint8(LPZ_gau),[suboutput_dir,tag,'_',ImageName]);

% Salience filter ---------------------
% [X_MB, Y_MB] = size(LPZ);
% if frame_num > 1
%     %%% LPZ energy
% else
%     %%% Intra-LPZ
%     ILPZ = zeros(X_MB, Y_MB);
%     ILPZ = LPZ;
%
%     ILPZ = ILPZ*255 / max(max(ILPZ));
%     ILPZ = imresize(ILPZ,4,'nearest');
% end

