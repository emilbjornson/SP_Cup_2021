function [metric,R] = testrate(theta)

%Extract data that is needed to compute the metric (if you notice any
%discrepances compared to metric computations during the SP Cup, this is
%because the corrMatrix has been turned from double to single precision, to
%keep down the file size)
load trueParameters.mat;

%Set the weights used when evaluating the performance in the SP Cup
weights = ones(1,50);
weights(NLOSusers) = 2; %Double the weight of NLOS users


%Prepare to compute the SNR for all UEs at all subcarriers
SNRs = zeros(K,50);

%Go through all the UEs
for index = 1:50
    
    %Compute the reflection coefficients with the selected configuration
    reflection_coefficient = RISvector(theta(:,index),corrMatrix);
    
    %Compute the result end-to-end channel
    hbar = F*(hd(:,index)+V(:,:,index).'*reflection_coefficient);
    
    %Compute the SNR per subcarrier
    SNRs(:,index) = abs(hbar.*transmitSignal).^2/N0;
    
end

%Compute the rate (in Mbit/s) per user
R = (symboltime/(K+M-1))*sum(log2(1+SNRs),1)/1e6;

%Compute the metric that is used in the Signal Processing Cup
metric = mean(R.*weights);
