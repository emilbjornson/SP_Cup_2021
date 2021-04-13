close all;
clear;

load dataset1;


%% Given parameter values

B = 10e6; %Bandwidth in Hertz

symbolTime = 1/B; %There are B symbols per second

%% Compute received signal powers

%Compute received signal energy per symbol, for 4 configurations
receivedSignalEnergy_config1 = abs(receivedSignal4N(:,1)).^2;
receivedSignalEnergy_config2 = abs(receivedSignal4N(:,2)).^2;
receivedSignalEnergy_config3 = abs(receivedSignal4N(:,3)).^2;
receivedSignalEnergy_config4097 = abs(receivedSignal4N(:,4097)).^2;

%Transform to energy per second (Watt)
pathloss_config1 = receivedSignalEnergy_config1/symbolTime;
pathloss_config2 = receivedSignalEnergy_config2/symbolTime;
pathloss_config3 = receivedSignalEnergy_config3/symbolTime;
pathloss_config4 = receivedSignalEnergy_config4097/symbolTime;


%% Plot pathlosses for the 4 considered configurations
figure;

subplot(2,2,1)
plot(1:K,pow2db(pathloss_config1),'b','LineWidth',1);
xlabel('Subcarrier index');
ylabel('Received power [dBW]');
title('Configuration 1')

subplot(2,2,2)
plot(1:K,pow2db(pathloss_config2),'b','LineWidth',1);
xlabel('Subcarrier index');
ylabel('Received power [dBW]');
title('Configuration 2')

subplot(2,2,3)
plot(1:K,pow2db(pathloss_config3),'b','LineWidth',1);
xlabel('Subcarrier index');
ylabel('Received power [dBW]');
title('Configuration 3')

subplot(2,2,4)
plot(1:K,pow2db(pathloss_config4),'b','LineWidth',1);
xlabel('Subcarrier index');
ylabel('Received power [dBW]');
title('Configuration 4097')
