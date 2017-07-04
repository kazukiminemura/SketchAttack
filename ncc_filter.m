% NCC filtering function
% this is a batch function which iterate function in a dataset images
%
% kazuki minemura
% 12th May 2014 last udate


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
NCC = zeros(X/4,Y/4);
NZA = zeros(X/4,Y/4);
%------ 4x4 NCC -----------------------
for height=1:4:X
    for width=1:4:Y
        Block = zeros(4,4);
        Block(:,:) = CoefALL_Y(height:height+3,width:width+3);
        Block(1,1) = 0;
        Block = (Block ~= 0);
        NCC(floor(height/4) + 1,floor(width/4) + 1) = floor(sum(sum(Block)));
    end
end

% %%%% Histogram of MBS
% figure('Visible','off');
% Com1D = reshape(NCC,[],1);
% hist(Com1D,16);
% set(gca,'FontSize',18);
% set(gca,'XScale','linear');
% % set(gca,'YLim',[0 2000]);
% xlabel('NCC value','FontSize', 18, 'FontWeight', 'bold');
% ylabel('Frequency','FontSize', 18, 'FontWeight', 'bold');
% saveas(gcf,[suboutput_dir,'HIS_NCC_',ImageName(1:length(ImageName)-4),'.eps']);
% delete(gcf);




NZA = NCC;
NCC = floor((NCC*255) / max(max(NCC)));

%------ 4x4 NZA -----------------------
r1 = 2;
r2 = 12;
NZA = (NZA >= 2) & (NZA < 13);
NZA = floor(NZA*255);


% %------ 16x16 NCC -----------------------
% for height=1:16:X
%     for width=1:16:Y
%         Block16 = zeros(16,16);
%         Block16(:,:) = CoefALL_Y(height:height+15,width:width+15);
%         for i=0:3
%             for j=0:3
%                 Block16(height+i*4,width+j*4)=0;
%             end
%         end
% 
%         Block16 = (Block ~= 0);
%         NCC16(floor(height/16) + 1,floor(width/16) + 1) = floor(sum(sum(Block16)));
%     end
% end
% NCC16 = floor((NCC16*255) / max(max(NCC16)));




%% Mophorogical Operations ------------
% SC = strel('diamond', 1);
% SO = strel('diamond', 1);
% NCCB = imclose(NCCB,SC);
% NCCB = imopen(NCCB,SO);

%----- comprexity selection ---------
% LPZF = LPZ > (255 * 0.75);
% LPZ =  LPZ .* LPZF;



%------- Wirte image--------------------
% tag = 'NZA';
% imwrite(uint8(NZA),[suboutput_dir,tag,'_',ImageName]);
tag = 'NCC';
imwrite(uint8(NCC),[suboutput_dir,tag,'_',ImageName]);
% tag = 'NCC16';
% imwrite(uint8(NCC16),[suboutput_dir,tag,'_',ImageName]);
% tag = 'NCCB';
% imwrite(NCCB,[suboutput_dir,tag,'_',ImageName]);
% tag = 'LPZavg';
% imwrite(uint8(LPZ_avg),[suboutput_dir,tag,'_',ImageName]);
% tag = 'LPZgau';
% imwrite(uint8(LPZ_gau),[suboutput_dir,tag,'_',ImageName]);


