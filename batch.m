% batch function
% this is a batch function which iterate function in a dataset images
%
% kazuki minemura
% 7th Jan 2014 last udate

input_DIR = input_dir;
output_DIR = output_dir;
%%% output_dir = output_XQian2012/AAA/
if ~exist(output_DIR,'file')
    mkdir(output_DIR);
end
%%% HEVC/H.265
VID_list = dir(strcat(input_dir, '*.bin'));
for VID_IDX = 1 : length(VID_list)
    VID_FN = VID_list(VID_IDX).name;
    VID_FN = VID_FN(1:length(VID_FN)-4); % old_town_cross_3840x2160
    VID_DIR = [VID_FN,'/'];
    disp(VID_FN);
    
    % Making folder ----------------------------------------------
    suboutput_DIR = [output_DIR,VID_DIR]; % Video sequence
    if ~exist(suboutput_DIR,'file')
        mkdir(suboutput_DIR);
    end
    
    %%% HEVC
    YUV_output = 'current.yuv';
    command = ['./TAppDecoder -b ',input_DIR,VID_FN,'.bin', ' -o ', YUV_output];
    system(command);
    
    FRM_list = dir([input_DIR, VID_DIR,'CUS_*.csv']); %%% HEVC
    TMP = csvread([input_DIR, VID_DIR,'CUS_F001.csv']);
    [width,height] = size(TMP(1:end,1:end-1));
    
    
    remain = VID_FN;
    [null token_length] = size(strfind(remain,'_'));
    for k = 1:token_length+1
        [token, remain] = strtok(remain,'_');
        if k == 1
            token_ini = token;
        end
        if strfind(token,'x') > 0
            break;
        end
    end
    
%     for CSV_IDX = 1 : length(FRM_list) %%% the number of exisiting csv files
        for CSV_IDX = 1 : 2 %%% the number of exisiting csv files
        FRM_IDX = FRM_list(CSV_IDX).name;
        FRM_IDX = FRM_IDX(6:length(FRM_IDX)-4);
        disp(FRM_IDX);
        
        %--- Extracting features ---
        % DCEC_Video_20_5_1_1280x960_001.pnm
        FRM_FN = [VID_FN,'_',num2str(FRM_IDX),'.jpg'];
%         VID_O_FN = [token_ini,'_ori_ra_qp08_',num2str(height),'x',num2str(width)];
        VID_O_FN = [token_ini,'_ori_ra_qp32_',num2str(height),'x',num2str(width)];
        disp(VID_O_FN);
        
        %         qdct_filter;
        %         plz_filter;
        %         ncc_filter;
        %         mbt_filter;
        cus_filter(input_DIR,VID_DIR,suboutput_DIR,FRM_FN,FRM_IDX)
%         ncs_process(input_DIR,suboutput_DIR,VID_DIR,FRM_FN,FRM_IDX)
        
        
        %--- load YUV ---
        [Y_O U_O V_O] = load_YUV(suboutput_DIR,FRM_FN,[input_DIR,VID_O_FN,'.yuv'],width,height,CSV_IDX);
        [Y U V] = load_YUV(suboutput_DIR,FRM_FN,['current.yuv'],width,height,CSV_IDX);
        
        %--- Cryptograohic analysis ---
        %Cryptographic_analysis(suboutput_DIR,FRM_FN,FRM_IDX,Y_O,Y);
        %--- Visually analysis ---
        %Visual_analysis(suboutput_DIR,FRM_FN,FRM_IDX,Y_O,Y);
    end
end