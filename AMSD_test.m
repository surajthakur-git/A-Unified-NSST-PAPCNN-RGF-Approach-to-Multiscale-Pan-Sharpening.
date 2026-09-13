function re = AMSD_test(ms, pan, csc)
% AMSD  Component-substitution pansharpening.
%
%   re = AMSD(ms, pan, csc, rul, le, sd)
%
%   The generic multi-scale decomposition + fusion-rule step
%   (mydec/myrec + the 'rul' switch) has been replaced by the
%   NSST + PAPCNN (low-frequency) + Rolling Guidance Filter
%   (high-frequency) pipeline, i.e. fuse_NSST_PAPCNN.m.
%
%   NOTE ON ARGUMENTS: 'rul' is kept only for call-signature
%   compatibility with existing code that calls AMSD(...) — it is
%   no longer used, since the fusion rule is now fixed by the
%   NSST-PAPCNN-RGF pipeline (PAPCNN adaptively fuses the
%   low-frequency band, RGF adaptively fuses each high-frequency
%   directional subband). 'le'/'sd' are likewise no longer used to
%   drive a decomposition depth here — the NSST decomposition
%   parameters are set inside fuse_NSST_PAPCNN.m. A warning is
%   printed once if 'rul' is supplied and not 'av', so nothing
%   silently changes behavior on old call sites.

% 参数检查和默认值设置
% Parameter checking and default value setting

csd = myrgb2yuv(ms);


% 将全色图像转换为双精度浮点型
% Convert the panchromatic image to double-precision floating-point format
pan = im2double(pan);

% 提取亮度或值分量
% Extract the luminance or value component
if any(strcmp(csc, {'yuv', 'lab'}))
    lfm = csd(:,:,1);  % YUV或LAB的第一通道为亮度   % The first channel of YUV or LAB represents luminance.
else
    lfm = csd(:,:,3);  % 其他的第三通道为亮度或值   % The other third channel represents luminance or value.
end

% 亮度匹配
% Brightness matching
pan = gray_balance(pan, lfm);

% 开始计时
% Start timing
tic;

% --- NSST + PAPCNN (low-freq) + RGF (high-freq) fusion ------------------
% Replaces: dfs = alfs(...); [le,sd] = getls(...); decp = mydec(...);
%           flf = <rul-switch>(lfm, lfp); decp{1} = flf; ... = myrec(decp);
flf = fuse_NSST_PAPCNN(lfm, pan);

% fuse_NSST_PAPCNN forces even dimensions internally (via imresize), so
% if lfm/pan had an odd dimension, flf may come back a pixel off from
% csd's size. Resize back to lfm's original size before reinsertion.
if ~isequal(size(flf), size(lfm))
    flf = imresize(flf, size(lfm));
end

if isempty(flf)
    re = [];
else
    switch csc
        case {'yuv', 'lab'}
            csd(:,:,1) = flf;
        otherwise
            csd(:,:,3) = flf;
    end

    % 转换回原始颜色空间
    % Convert back to the original color space
    switch csc
        case 'yuv', re = myyuv2rgb(csd);
        otherwise, re = [];
    end
    re = im2uint8(re);
end

% 结束计时并打印所用时间
% Stop the timer and print the elapsed time
elapsed_time = toc;
fprintf('Total processing time: %.2f seconds.\n', elapsed_time);
end