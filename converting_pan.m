
pan = imread("F:\4_paper_revised\Proposed4-suraj_revised\dataset\pic1\PAN.jpg");  % 全色图像（灰度图）


if size(pan, 3) ~= 1
        pan = rgb2gray(pan);
end

imwrite(pan,"D:\Desktop\5th_paper\An-Adaptive-Multi-Scale-Decomposition-Fusion-Method-main\dataset\pic1/pan1.jpg");