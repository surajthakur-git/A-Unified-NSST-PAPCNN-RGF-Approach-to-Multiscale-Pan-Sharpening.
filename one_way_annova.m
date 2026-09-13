clc;
clear;
close all;

%% --- Input Data (Each row = Technique, Each column = Dataset A-E) ---

QABF = [...

    0.4666   0.1404   0.8436   0.1194   0.6525;   % FGF-XDoG2
    0.4744   0.3771   0.4600   0.5451   0.4859;   % CDIF-CBF2
    0.5135   0.4560   0.5231   0.6667   0.5113;   % CBF2
    0.5155   0.4747   0.5600   0.6778   0.5125;   % Structure-aware2
    0.5047   0.2044   0.7857   0.7290   0.5365;   % LEGFF2
    0.6690   0.2217   0.7548   0.0696   0.7820;   % MDHU2
    0.3162   0.5992   0.5992   0.6834   0.1541;   % IMA2
    0.5212   0.2252   0.7322   0.2809   0.5117;   % VSM-WLS2
    0.3929   0.1232   0.9426   0.0525   0.7880;   % GFDF2
    0.5759   0.1464   0.7949   0.2249   0.5440;   % Two-scale2
    0.7144   0.5453   0.4833   0.1225   0.6520;   % MST-SR2
    0.802774 0.6514   0.695366 0.565074 0.699054; % NcFSRM2
    0.572581 0.2807   0.487769 0.446378 0.391134; % Gost2
    0.757194 0.7197   0.666764 0.535132 0.769528; % MFIFU2
    0.566247 0.3663   0.388496 0.390475 0.590271; % MORFO2
    0.843852 0.5229   0.388496 0.896222 0.590271; % PMEF2
    0.834412 0.67598  0.663702 0.894021 0.856096; % EXP2
    0.844257 0.561952 0.761992 0.897054 0.845410; % ASDM
    0.841611 0.770766 0.730325 0.640974 0.838577; % Page
    0.650194 0.580088 0.587545 0.792624 0.631582; % AFI
    0.825653 0.587222 0.753699 0.870134 0.822860; % UMC
    0.847194 0.535097 0.755214 0.889823 0.846739; % SWT
    0.858027 0.686879 0.772999 0.902645 0.850517    % Proposed

];

%% --- Method Names ---

methods = { ...
    'FGF-XDoG2', ...
    'CDIF-CBF2', ...
    'CBF2', ...
    'Structure-aware2', ...
    'LEGFF2', ...
    'MDHU2', ...
    'IMA2', ...
    'VSM-WLS2', ...
    'GFDF2', ...
    'Two-scale2', ...
    'MST-SR2', ...
    'NcFSRM2', ...
    'Gost2', ...
    'MFIFU2', ...
    'MORFO2', ...
    'PMEF2', ...
    'EXP2', ...
    'ASDM', ...
    'Page', ...
    'AFI', ...
    'UMC', ...
    'SWT', ...
    'Proposed' ...
};

%% Step 2: Significance Level

alpha = 0.05;

%% Step 3: Degrees of Freedom

[a,b] = size(QABF);

N = numel(QABF);

df_between = a - 1;
df_within = N - a;
df_total = N - 1;

fprintf('\n3. CALCULATE DEGREES OF FREEDOM\n');

fprintf('   Total observations N = %d\n', N);
fprintf('   Number of methods    = %d\n', a);
fprintf('   Number of datasets   = %d\n', b);
fprintf('   df_between = %d\n', df_between);
fprintf('   df_within  = %d\n', df_within);
fprintf('   df_total   = %d\n', df_total);

%% Step 4: ANOVA Components

group_means = mean(QABF,2);

overall_mean = mean(QABF(:));

SS_between = sum(b * (group_means - overall_mean).^2);

SS_within = sum(sum((QABF - group_means).^2));

SS_total = SS_between + SS_within;

MS_between = SS_between / df_between;

MS_within = SS_within / df_within;

F_value = MS_between / MS_within;

%% Step 5: Display Test Statistics

fprintf('\n5. CALCULATE TEST STATISTICS\n');

fprintf('------------------------------------------------------------\n');

fprintf('%-12s %-12s %-5s %-12s %-8s %-8s\n', ...
    'Source','SS','df','MS','F','Prob>F');

fprintf('------------------------------------------------------------\n');

p_val = 1 - fcdf(F_value, df_between, df_within);

fprintf('%-12s %-12.4f %-5d %-12.4f %-8.2f %-8.4f\n', ...
    'Between', SS_between, df_between, MS_between, F_value, p_val);

fprintf('%-12s %-12.4f %-5d %-12.4f\n', ...
    'Within', SS_within, df_within, MS_within);

fprintf('%-12s %-12.4f %-5d\n', ...
    'Total', SS_total, df_total);

fprintf('------------------------------------------------------------\n');

%% Step 6: Decision Rule

F_crit = finv(1-alpha, df_between, df_within);

fprintf('\n6. STATE DECISION RULE\n');

fprintf('   Critical value F(%.2f; %d,%d) = %.4f\n', ...
    1-alpha, df_between, df_within, F_crit);

fprintf('   If F_calc > F_crit => Reject H0\n');

%% Step 7: Result & Conclusion

fprintf('\n7. STATE RESULT & CONCLUSION\n');

if F_value > F_crit

    fprintf('   F_calc = %.4f > %.4f => Reject H0\n', ...
        F_value, F_crit);

    fprintf(['   => Significant difference among methods ' ...
             '(p = %.4f < alpha)\n'], p_val);

else

    fprintf('   F_calc = %.4f < %.4f => Fail to Reject H0\n', ...
        F_value, F_crit);

    fprintf(['   => No significant difference among methods ' ...
             '(p = %.4f > alpha)\n'], p_val);

end

%% Step 8: Effect Size

eta_sq = SS_between / SS_total;

fprintf('\n8. EFFECT SIZE\n');

fprintf('   Eta-Squared (eta^2) = %.4f (%.2f%% of total variance explained)\n', ...
    eta_sq, eta_sq*100);

fprintf('==============================================================\n\n');