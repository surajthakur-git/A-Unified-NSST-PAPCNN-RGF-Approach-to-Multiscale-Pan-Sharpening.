clc;
clear all;
addpath(genpath('D:\Desktop\An-Adaptive-Multi-Scale-Decomposition-Fusion-Method-main'));
addpath(genpath('nsst_toolbox'));
which nsst_dec2


ms = imread("F:\5th_paper_final - trly_finannnnnnnnnnn\An-Adaptive-Multi-Scale-Decomposition-Fusion-Method-main\dataset\pic5\MS.jpeg");  % 多光谱图像（RGB）
pan = imread("F:\5th_paper_final - trly_finannnnnnnnnnn\An-Adaptive-Multi-Scale-Decomposition-Fusion-Method-main\dataset\pic5\pan1.jpeg");  % 全色图像（灰度图）

% 调用AMSD函数进行图像融合
%fused_image = AMSD(ms, pan, 'yuv', 'av', 4, 1);
fused_image = AMSD_test(ms, pan, 'yuv');
%fused_image = AMSD_test_trl(ms, pan, 'yuv', 'av', 4, 1);
% 显示融合结果
figure;
imshow(ms);
title('MS Image');

figure;
imshow(pan);
title('PAN Image');

figure;
imshow(fused_image);
title('Fused Image');

%matrices_new_suraj(im2gray(fused_image),pan,ms);

Fused_gray = im2gray(fused_image);
PAN_gray   = im2gray(pan);
MS_gray    = im2gray(ms);



imwrite(fused_image, 'F:\5th_paper_final - trly_finannnnnnnnnnn\An-Adaptive-Multi-Scale-Decomposition-Fusion-Method-main\output\Fused_Image5.png');
matrices_new_suraj(Fused_gray,PAN_gray,MS_gray);