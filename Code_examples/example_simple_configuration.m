close all;
clear;

load dataset1;


%% Given parameter values

P = 1; %Transmit power in Watt
B = 10e6; %Bandwidth in Hertz


%% Compute received signal powers

symbolTime = 1/B; %There are B symbols per second

%Compute received signal energy per symbol, for each configuration and
%for all subcarriers
receivedSignalEnergy_allConfigs = abs(receivedSignal4N).^2;

%Sum up to the power over all subcarriers, for each configuration
totalReceivedSignalEnergy_perConfig = sum(receivedSignalEnergy_allConfigs,1);


%Identify the configuration that gives the largest total received power
[strongestTotalPower,strongestIndex] = max(totalReceivedSignalEnergy_perConfig);

%Identify the configuration that gives the smallest total received power
[weakestTotalPower,weakestIndex] = min(totalReceivedSignalEnergy_perConfig);


%Compute received signal energy per second, for the two configurations
pathloss_strongestIndex = receivedSignalEnergy_allConfigs(:,strongestIndex)/symbolTime;
pathloss_weakestIndex = receivedSignalEnergy_allConfigs(:,weakestIndex)/symbolTime;



%% Compute power difference

pathlossDifference = pow2db(strongestTotalPower/weakestTotalPower);



%% Plot pathlosses for the two considered configurations
figure;

subplot(1,2,1)
plot(1:K,pow2db(pathloss_strongestIndex),'b','LineWidth',1);
xlabel('Subcarrier index');
ylabel('Received power [dBW]');
title('Strongest total received power')

subplot(1,2,2)
plot(1:K,pow2db(pathloss_weakestIndex),'b','LineWidth',1);
xlabel('Subcarrier index');
ylabel('Received power [dBW]');
title('Weakest total received power')
