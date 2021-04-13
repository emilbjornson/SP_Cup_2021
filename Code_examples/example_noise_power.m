close all;
clear;

load dataset1;


%% Given parameter values

B = 10e6; %Bandwidth in Hertz
symbolTime = 1/B; %There are B symbols per second


%% Identify two configurations that are exactly the same
%  (notice that pilotMatrix4N(:,1) and pilotMatrix4N(:,8193) are equal)

config1 = 1;
config2 = 8193;


%% Compute the difference between the two received signals
%  It should only contain noise, if everything else in the propagation
%  environment is constant. If the noise is independent, we will double the
%  noise variance when computing the difference, thus we normalize by the
%  square root of 2.

residualnoise = (receivedSignal4N(:,config1)-receivedSignal4N(:,config2))/sqrt(2);


%% Estimate variance of the residual noise in energy per symbol (Watt/Hz)

varianceEstimate = var(residualnoise);


%% Theoretical thermal noise variance as room temperature is -204 dBW/Hz
% This is often written as -174 dBm per Hz

idealThermalNoise = db2pow(-204);

estimateNoiseAmplification = varianceEstimate/idealThermalNoise;



%% Transform the noise powers to energy per second (Watt)
% The unit is changed by the noise amplification is the same

varianceEstimate_power = varianceEstimate/symbolTime;

idealThermalNoise_power = idealThermalNoise/symbolTime;


