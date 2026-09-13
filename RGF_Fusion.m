function F = RGF_Fusion(A, B, Iguide)
% RGF_FUSION  Edge-preserving fusion of high-frequency (detail) subbands
%             using Rolling-Guidance-filtered activity maps.
%
%   F = RGF_Fusion(A, B)
%   F = RGF_Fusion(A, B, Iguide)
%
%   A, B    - high-frequency directional subbands from source images
%             (same size)
%   Iguide  - optional guidance image for the guided filter (e.g. a
%             rolling-guidance-filtered version of A/B, or the
%             corresponding low-frequency band). Defaults to
%             rollingGuidanceFilter(abs(A)+abs(B)).
%
%   Method
%     1) Local energy is used as the activity measure for each source.
%     2) A binary "who fires" decision map is formed (winner-take-all).
%     3) The decision map is refined with an edge-aware guided filter
%        (guided by Iguide) to remove blocky artifacts while respecting
%        edges — this is the "rolling guidance" fusion step in the
%        pipeline diagram.
%     4) The refined (soft) weight map blends A and B.

if nargin < 3 || isempty(Iguide)
    Iguide = rollingGuidanceFilter(abs(A) + abs(B));
end

A = double(A);
B = double(B);

% --- Activity measure: local energy in a small window -------------------
h = fspecial('average', [3 3]);
EA = imfilter(A.^2, h, 'replicate');
EB = imfilter(B.^2, h, 'replicate');

% --- Initial winner-take-all decision map -------------------------------
W = double(EA >= EB);

% --- Edge-preserving refinement of the decision map ---------------------
W = imguidedfilter(W, Iguide, ...
    'NeighborhoodSize', [7 7], ...
    'DegreeOfSmoothing', 0.5);

% Keep weights in [0,1] (guided filter can slightly overshoot)
W = min(max(W, 0), 1);

% --- Fuse -----------------------------------------------------------------
F = W .* A + (1 - W) .* B;

end
