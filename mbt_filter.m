% MB bits filtering function
% this is a batch function which iterate function in a dataset sequence
%
%
% kazuki minemura
% 1st JUL 2014 last udate

%--- Read 8x8 block csv ---
csv_name = [input_dir,video_dir, 'MBT_F', frame_index,'.csv'];
% disp(csv_name);

MBT = csvread(csv_name);
MBT = MBT(1:end,1:end-1);
[H,W] = size(MBT);
% MBbit = abs(imresize(MBbit,[H W-1]));




% %%%% Histogram of MBS
% figure('Visible','off');
% Com_max = max(max(MBS));
% Com1D = reshape(MBS,[],1);
% hist(Com1D,Com_max);
% set(gca,'FontSize',18);
% set(gca,'XScale','linear');
% % set(gca,'YLim',[0 2000]);
% xlabel('MBS value','FontSize', 18, 'FontWeight', 'bold');
% ylabel('Frequency','FontSize', 18, 'FontWeight', 'bold');
% saveas(gcf,[suboutput_dir,'HIS_MBS_',ImageName(1:length(ImageName)-4),'.eps']);
% delete(gcf);



% MAXmode = max(max(MBS));
% MBS = imresize(MBS,2,'nearest');
% MBS_uint8 = uint8(MBS * 255 / MAXmode);
% Mask_MBbit = Mask_MBbit(1:16:end,1:16:end);?% for JPXR





%%% Equalization
% EQL = histeq(Mask_MBbit);

% write images ----------------------------
% ImageName = [videoName(1:length(videoName)-4),'_',num2str(frame_index),'.pnm'];
% ImageName = [videoName(1:length(videoName)),'_',num2str(frame_index),'.pnm'];


tag = 'MBT';
% disp([suboutput_dir,tag,'_',ImageName]);
imwrite(uint8(MBT),[suboutput_dir,tag,'_',ImageName]);
% tag = 'MBbitEQL';
% imwrite(EQL,[suboutput_dir,tag,'_',ImageName]);