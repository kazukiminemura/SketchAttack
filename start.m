% start function
% this is the start point at anytime
%
% kazuki minemura
% 7th Jan 2014 last udate

clear all
close all
clc

addpath('/opt/local/bin');

%%%

% Compute compression features ---------------------
input_dataset = 'APSIPA2015_REV';

input_pre = 'input/';
output_pre = 'output/';
input_dataset = [input_dataset,'_HEVC/'];
% list_dataset = dir(strcat(input_pre,input_dataset,'QP*')); %%% H264


%%%% list_dataset = {AAA,BBB,CCC}
% for quality_index = 1 : length(list_dataset)
% for quality_index = 2 : 2: 6
%%% dataset_name = AAA
%     dataset_name = list_dataset(quality_index).name;
%     dataset_name = ['QP',num2str(5*quality_index + 10)];
%     disp(dataset_name);
%%% input_dir = input/AAA/
input_dir = strcat(input_pre,input_dataset);
%%% output_dir = output_Proposed214/AAA/
output_dir = strcat(output_pre,input_dataset);
%%% batch operation
batch;

% end