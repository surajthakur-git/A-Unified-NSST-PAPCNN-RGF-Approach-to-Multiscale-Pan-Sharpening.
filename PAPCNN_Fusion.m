function F = PAPCNN_Fusion(A,B)
%% Activity Measure
ActivityA = abs(A);
ActivityB = abs(B);

%% Linking Strength
LinkA = ActivityA ./ (max(ActivityA(:))+eps);
LinkB = ActivityB ./ (max(ActivityB(:))+eps);

%% Pulse Generation
PulseA = ActivityA .* LinkA;
PulseB = ActivityB .* LinkB;

%% Neuron Firing
FireA = PulseA > PulseB;
FireB = ~FireA;

%% Coefficient Selection
F = FireA .* A + FireB .* B;
end