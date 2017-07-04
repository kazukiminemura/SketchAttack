% QDCT filtering function
% this is a batch function which iterate function in a dataset images
%
% kazuki minemura
% 3rd Apr 2014 last udate



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
X4 = floor(X/4);
Y4 = floor(Y/4);
X16 = floor(X/16);
Y16 = floor(Y/16);

%%% conventional
EAC = zeros(X4,Y4);
if Switch == 'H264'
    DCEC = zeros(X/4,Y/4); %% H264
    DCEC = abs(CoefALL_Y(1:4:end,1:4:end-1)); %%% H264
else
    DCEC = zeros(X/16,Y/16); %% XR
    DCEC = abs(CoefALL_Y(1:16:end,1:16:end-1)); %%% XR
end
%%% Proposed
SAC = zeros(X4,Y4);


% DDC = zeros(X/4,Y/4);
% CSAC = zeros(X/4,Y/4);
% VSAC = zeros(X/4,Y/4);
% HSAC = zeros(X/4,Y/4);
% DSAC = zeros(X/4,Y/4);
% FSAC = zeros(X/4,Y/4);
% UBC = zeros(X,Y);
% USC = zeros(X,Y);
% BE = zeros(X/4,Y/4);
% SBB = zeros(X/4,Y/4);
% HPB = zeros(X/4,Y/4);
% MPB = zeros(X/4,Y/4);
% LPB = zeros(X/4,Y/4);
% LSAC = zeros(X/4,Y/4);
% LBE = zeros(X/4,Y/4);
% LUSC = zeros(X,Y);


% DC error categroy (DCEC) -----------------------
DCEC = floor(2.^log2(DCEC));
DCEC = floor(DCEC*255/max(max(DCEC)));


% Energy of absolute AC coefficients (EAC) -----------------------
for x=1:4:X
    for y=1:4:Y
        BLK = zeros(4,4);
        BLK(:,:) = CoefALL_Y(x:x+3,y:y+3);
        BLK(1,1) = 0;
        sac_x = 1 + floor(x/4);
        sac_y = 1 + floor(y/4);
        EAC(sac_x,sac_y) = sum(sum(abs(BLK)));
    end
end


EAC_max = max(max(EAC));
% figure('Visible','off');
% SAC1D = reshape(EAC,[],1);
% hist(SAC1D,EAC_max);
% set(gca,'FontSize',18);
% set(gca,'XScale','linear');
% set(gca,'YLim',[0 2000]);
% xlabel('Summation of absolute of value AC cofficients','FontSize', 18, 'FontWeight', 'bold');
% ylabel('Frequency','FontSize', 18, 'FontWeight', 'bold');
% saveas(gca,[suboutput_dir,'HIS_EAC_',ImageName(1:length(ImageName)-4),'.eps']);


EAC_mean = floor(mean(mean(EAC)));
EAC = floor(EAC*255/EAC_mean);
for x=1:X4
    for y=1:Y4
        if EAC(x,y) > 255
            EAC(x,y) = 255;
        end
    end
end

% % Uniformed block coefficient (UBC) -----------------------
% for x=1:4:X
%     for y=1:4:Y
%         BLK = zeros(4,4);
%         BLK(:,:) = abs(CoefALL_Y(x:1:x+3,y:1:y+3));
%         BLK(1,1) = 0;
%         Coef_max = max(max(BLK));
%
%         UBC(x:1:x+3,y:1:y+3) = BLK(:,:)/Coef_max;
%     end
% end
%
% % Uniformed subband coefficient (USC) -----------------------
% for x=1:4
%     for y=1:4
%         BLK = abs(CoefALL_Y(x:4:X,y:4:Y));
%         Coef_max = max(max(BLK));
%         USC(x:4:X,y:4:Y) = BLK(:,:)/Coef_max;
%     end
% end


% Differential DC image (DDC) -----------------------
% DDC = abs(CoefALL_Y(1:4:end,1:4:end-1));
% DDC = floor(DDC*255/max(max(DDC)));

% Summation of absolute AC coefficients (SAC) -----------------------
for x=1:4:X
    for y=1:4:Y
        BLK = zeros(4,4);
        BLK(:,:) = CoefALL_Y(x:x+3,y:y+3);
        BLK(1,1) = 0;
        sac_x = 1 + floor(x/4);
        sac_y = 1 + floor(y/4);
        SAC(sac_x,sac_y) = sum(sum(abs(BLK)));
    end
end

% %%%% Histogram of DCEC
% figure('Visible','off');
% Com_max = max(max(DCEC));
% Com1D = reshape(DCEC,[],1);
% hist(Com1D,Com_max);
% set(gca,'FontSize',18);
% set(gca,'XScale','linear');
% xlabel('DCEC value','FontSize', 18, 'FontWeight', 'bold');
% ylabel('Frequency','FontSize', 18, 'FontWeight', 'bold');
% saveas(gcf,[suboutput_dir,'HIS_DCEC_',ImageName(1:length(ImageName)-4),'.eps']);
% delete(gcf)
% 
% %%%% Histogram of SAC
% figure('Visible','off');
% Com_max = max(max(SAC));
% Com1D = reshape(SAC,[],1);
% hist(Com1D,Com_max);
% set(gca,'FontSize',18);
% set(gca,'XScale','linear');
% xlabel('SAC value','FontSize', 18, 'FontWeight', 'bold');
% ylabel('Frequency','FontSize', 18, 'FontWeight', 'bold');
% saveas(gcf,[suboutput_dir,'HIS_SAC_',ImageName(1:length(ImageName)-4),'.eps']);
% delete(gcf)

SAC = floor((SAC*255)/max(max(SAC)));


% Block Energy (BE) -----------------------
% for x=1:4:X
%     for y=1:4:Y
%         BLK = zeros(4,4);
%         BLK(:,:) = floor(sqrt(abs(CoefALL_Y(x:x+3,y:y+3))^2));
%         BLK(1,1) = 0;
%         sac_x = 1 + floor(x/4);
%         sac_y = 1 + floor(y/4);
%         BE(sac_x,sac_y) = sum(sum(BLK));
%     end
% end

% % Summation of absolute AC coefficients (VSAC) -----------------------
% for x=1:4:X
%     for y=1:4:Y
%         sac_x = 1 + floor(x/4);
%         sac_y = 1 + floor(y/4);
%         VSAC(sac_x,sac_y) = abs(CoefALL_Y(x,y+1)) + abs(CoefALL_Y(x,y+2)) + abs(CoefALL_Y(x,y+3));
%     end
% end
% % Summation of absolute AC coefficients (HSAC) -----------------------
% for x=1:4:X
%     for y=1:4:Y
%         sac_x = 1 + floor(x/4);
%         sac_y = 1 + floor(y/4);
%         HSAC(sac_x,sac_y) = abs(CoefALL_Y(x+1,y)) + abs(CoefALL_Y(x+2,y)) + abs(CoefALL_Y(x+3,y));
%     end
% end
% % Summation of absolute AC coefficients (DSAC) -----------------------
% for x=1:4:X
%     for y=1:4:Y
%         sac_x = 1 + floor(x/4);
%         sac_y = 1 + floor(y/4);
%         DSAC(sac_x,sac_y) = abs(CoefALL_Y(x+1,y+1)) + abs(CoefALL_Y(x+1,y+2)) + abs(CoefALL_Y(x+2,y+1))+ abs(CoefALL_Y(x+2,y+2));
%     end
% end
% % Summation of absolute AC coefficients (CSAC) -----------------------
% for x=1:4:X
%     for y=1:4:Y
%         sac_x = 1 + floor(x/4);
%         sac_y = 1 + floor(y/4);
%         CSAC(sac_x,sac_y) = abs(CoefALL_Y(x+1,y+3)) + abs(CoefALL_Y(x+2,y+3)) + abs(CoefALL_Y(x+3,y+1))+ abs(CoefALL_Y(x+3,y+2)) + abs(CoefALL_Y(x+3,y+3));
%     end
% end


% Subband (SBB) -----------------------
% for x=1:4:X
%     for y=1:4:Y
%         sac_x = 1 + floor(x/4);
%         sac_y = 1 + floor(y/4);
%         SBB(sac_x,sac_y) = CoefALL_Y(x,y+1);
%     end
% end
% SBB = std_median(SBB);

% Pattern block (HPB, MPB) -----------------
% for x=1:4:X
%     for y=1:4:Y
%         sac_x = 1 + floor(x/4);
%         sac_y = 1 + floor(y/4);
%
%         Block(:,:) = zeros(4,4);
%         Block(:,:) = CoefALL_Y(x:x+3,y:y+3);
%         Block(1:3,1:3) = 0;
%         Block(3,3) = CoefALL_Y(x+3,y+3);
%         Block = abs(Block) > 0;
%         if sum(sum(Block))
%             HPB(sac_x,sac_y) = 0;
%         else
%             HPB(sac_x,sac_y) = 1;
%             %                 end
%
%             %%% MPB
%             Block(:,:) = zeros(4,4);
%             Block(1:3,1:3) = CoefALL_Y(x:x+2,y:y+2);
%             Block(1,1) = 0;
%             Block(3,3) = 0;
%             Block = abs(Block) > 0;
%             if sum(sum(Block))
%                 MPB(sac_x,sac_y) = 1;
%             else
%                 MPB(sac_x,sac_y) = 0;
%                 %         end
%
%                 %%% LPB
%                 Block(:,:) = zeros(4,4);
%                 Block(1:2,1:2) = CoefALL_Y(x:x+1,y:y+1);
%                 Block(1,1) = 0;
%                 Block(2,2) = 0;
%                 Block = abs(Block) > 0;
%                 if sum(sum(Block)) > 0
%                     LPB(sac_x,sac_y) = 1;
%                 else
%                     LPB(sac_x,sac_y) = 0;
%                 end
%             end
%         end
%     end
% end


% Local enhancement USC (LUSC) ------------
% for x=1:4
%     for y=1:4
%         SBD = abs(CoefALL_Y(x:4:X,y:4:Y));
%         for h=2:X4-1
%             for w=2:Y4-1
%                 BLK = zeros(3,3);
%                 BLK(:,:) = SBD(h-1:h+1,w-1:w+1);
%                 Coef_max = max(max(BLK));
%                 if Coef_max ~= 0
%                     BLK = floor(BLK*255/Coef_max);
%                 end
%                 LUSC((h-1)*4+x,(w-1)*4+y) = BLK(2,2);
%             end
%         end
%     end
% end

% Local enhancement SAC (LSAC) ------------
% for x=2:X4-1
%     for y=2:Y4-1
%         BLK = zeros(3,3);
%         BLK(:,:) = SAC(x-1:x+1,y-1:y+1);
%         Coef_max = max(max(BLK));
%         if Coef_max ~= 0
%             BLK = floor(BLK*255/Coef_max);
%         end
%         LSAC(x,y) = BLK(2,2);
%     end
% end

% Local enhancement BE (LBE) ------------
% for x=2:X4-1
%     for y=2:Y4-1
%         BLK = zeros(3,3);
%         BLK(:,:) = BE(x-1:x+1,y-1:y+1);
%         Coef_max = max(max(BLK));
%         if Coef_max ~= 0
%             BLK = floor(BLK*255/Coef_max);
%         end
%         LBE(x,y) = BLK(2,2);
%     end
% end

% Normalization
% SAC = SAC*255 / max(max(SAC));
% SACDC = SACDC*255 / max(max(SACDC));

% if max(max(VSAC)) == 0
%     VSAC = zeros(X/4,Y/4);
% else
% VSAC = VSAC*255 / max(max(VSAC));
% end
% if max(max(HSAC)) == 0
%     HSAC = zeros(X/4,Y/4);
% else
% HSAC = HSAC*255 / max(max(HSAC));
% end
% if max(max(CSAC)) == 0
%     CSAC = zeros(X/4,Y/4);
% else
% CSAC  = CSAC*255 / max(max(CSAC));
% end
% if max(max(DSAC)) == 0
%     DSAC = zeros(X/4,Y/4);
% else
% DSAC = DSAC*255 / max(max(DSAC));
% end

% FSAC(:,:) =
% max(abs(VSAC(:,:)),max(abs(HSAC(:,:)),max(abs(DSAC(:,:)),abs(CSAC(:,:)))));
% %% with CSAC
% FSAC(:,:) = max(abs(VSAC(:,:)),max(abs(HSAC(:,:)),max(abs(DSAC(:,:)),abs(CSAC(:,:)))));
% FSAC(:,:) = min(abs(VSAC(:,:)),min(abs(HSAC(:,:)),min(abs(DSAC(:,:)),abs(CSAC(:,:)))));

% if max(max(FSAC)) == 0
%     FSAC = zeros(X/4,Y/4);
% else
% FSAC = floor(FSAC*255 / max(max(FSAC)));
% end
% SAC = imresize(SAC,4,'nearest');

% % smoothing procedure -------
% H = fspecial('gaussian',3,3);
% FSACG = imfilter(FSAC,H,'replicate');

% figure('Visible','off');
% surf(SAC);
% tag = 'SUF';SAC
% saveas(gca,[suboutput_dir,tag,'_',ImageName],'jpg');
% close gca

% standar deviation -----------
% [X Y] = size(FSAC);
% SAC_std = zeros(X,Y);
% for x=2:1:X-1
%     for y=2:1:Y-1
%         ParBlk = zeros(3,3);
%         ParBlk(:,:) = FSAC(x-1:1:x+1,y-1:1:y+1);
%         ParBlk = reshape(ParBlk,[9,1]);
%
%         AS = size(ParBlk,2); %% size of 1 dimension InputArray
%         M = median(ParBlk); %% median of InputArray
%         TemSum = sum(ParBlk - M)^2;
%         TemSum = TemSum/AS;
%
%         SAC_std(x,y) = sqrt(TemSum); %%% Median std
%     end
% end
% imshow(SAC_std);


% Mophorogical Operations ------------
% SAC = SAC > 0;
% SE = strel('rectangle', [3 3]);
% SAC = imclose(SAC,SE);
% SAC = imopen(SAC,SE);
% if frame_num > 1
% %    Tmp_SF =  BS < 9;
% %    SF = SF + Tmp_SF;
% else
% %     SF = zeros(X_MB, Y_MB);
%     ISAC = imresize(SAC,4,'nearest');
% end



tag = 'DCEC';
imwrite(uint8(DCEC),[suboutput_dir,tag,'_',ImageName]);
% 
% tag = 'EAC';
% imwrite(uint8(EAC),[suboutput_dir,tag,'_',ImageName]);

tag = 'SAC';
imwrite(uint8(SAC),[suboutput_dir,tag,'_',ImageName]);

% SACDC = imresize(SACDC,4,'nearest');
% tag = 'DDC';
% imwrite(uint8(DDC),[suboutput_dir,tag,'_',ImageName]);
%
% VSAC = imresize(VSAC,4,'nearest');
% tag = 'SAC_V';
% imwrite(uint8(VSAC),[suboutput_dir,tag,'_',ImageName]);
%
% HSAC = imresize(HSAC,4,'nearest');
% tag = 'SAC_H';
% imwrite(uint8(HSAC),[suboutput_dir,tag,'_',ImageName]);
%
% DSAC = imresize(DSAC,4,'nearest');
% tag = 'SAC_D';
% imwrite(uint8(DSAC),[suboutput_dir,tag,'_',ImageName]);
%
% CSAC = imresize(CSAC,4,'nearest');
% tag = 'SAC_C';
% imwrite(uint8(CSAC),[suboutput_dir,tag,'_',ImageName]);
%
% FSAC = imresize(FSAC,4,'nearest');
% tag = 'SAC_F';
% imwrite(uint8(FSAC),[suboutput_dir,tag,'_',ImageName]);

% FSACG = imresize(FSACG,4,'nearest');
% tag = 'FASCG';
% imwrite(uint8(FSACG),[suboutput_dir,tag,'_',ImageName]);

% tag = 'UBC';
% imwrite(UBC,[suboutput_dir,tag,'_',ImageName]);

% tag = 'USC';
% imwrite(USC,[suboutput_dir,tag,'_',ImageName]);

% tag = 'BE';
% imwrite(BE,[suboutput_dir,tag,'_',ImageName]);

% tag = 'SBB';
% imwrite(SBB,[suboutput_dir,tag,'_',ImageName]);

% tag = 'LSAC';
% imwrite(uint8(LSAC),[suboutput_dir,tag,'_',ImageName]);
%
% tag = 'LBE';
% imwrite(uint8(LBE),[suboutput_dir,tag,'_',ImageName]);

% tag = 'LUSC';
% imwrite(uint8(LUSC),[suboutput_dir,tag,'_',ImageName]);

% tag = 'Coef';
% imwrite(CoefALL_Y,[suboutput_dir,tag,'_',ImageName]);