function J = rollingGuidanceFilter(I, sigma_s, sigma_r, numIter)
% ROLLINGGUIDANCEFILTER  Structure-preserving edge-aware smoothing.
%
%   J = rollingGuidanceFilter(I)
%   J = rollingGuidanceFilter(I, sigma_s, sigma_r, numIter)
%
%   Implements the standard Rolling Guidance Filter (Zhang et al., 2014)
%   using imguidedfilter as the joint-filtering step:
%     1) Small-structure removal via Gaussian blur (scale sigma_s)
%     2) Iterative guided filtering: J_{t+1} = guidedfilter(I, J_t)
%
%   Inputs
%     I        - input 2-D image (double/single, any range)
%     sigma_s  - spatial scale for the initial Gaussian blur (default 3)
%     sigma_r  - range/edge sensitivity, mapped to guided filter's
%                DegreeOfSmoothing as sigma_r^2 * range(I)^2 (default 0.1)
%     numIter  - number of rolling iterations (default 4)
%
%   Output
%     J        - filtered image, same size as I

if nargin < 2 || isempty(sigma_s), sigma_s = 3;   end
if nargin < 3 || isempty(sigma_r), sigma_r = 0.1; end
if nargin < 4 || isempty(numIter), numIter = 4;   end

I = double(I);

% --- Step 1: initial small-structure removal ---------------------------
J = imgaussfilt(I, sigma_s);

% --- Step 2: iterative guided filtering ---------------------------------
winRadius = max(1, ceil(2 * sigma_s));
neighborhood = [2*winRadius+1, 2*winRadius+1];

rangeI = max(I(:)) - min(I(:));
if rangeI == 0
    rangeI = 1; % avoid degenerate DegreeOfSmoothing on flat inputs
end
degreeOfSmoothing = (sigma_r * rangeI)^2;

for k = 1:numIter
    % Filter the ORIGINAL image I, guided by the previous iterate J.
    J = imguidedfilter(I, J, ...
        'NeighborhoodSize', neighborhood, ...
        'DegreeOfSmoothing', degreeOfSmoothing);
end

end
