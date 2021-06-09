function Gamma_n = refcoefficient(Cn,omega)
% Compute the reflection coefficient using the circuit from (3) in
% "Intelligent Reflecting Surface: Practical Phase Shift Model and
% Beamforming Optimization" by Samith Abeywickrama, Rui Zhang, Chau Yuen.
% Note that the values are slightly different, to avoid that the students
% in the IEEE Signal Processing Cup 2021 could identify the exact values
% from the paper.

L1 = 2.8e-9; %Bottom layer inductance
L2 = 0.8e-9; %Top layer inductance
Rn = 1; %Effective resistance
Z0 = 377; %Impedance of free space

%Compute the impedance of the surface
Zn = 1i*omega*L1*(1i*omega*L2+1./(1i*omega*Cn)+Rn)./(1i*omega*L1+(1i*omega*L2+1./(1i*omega*Cn)+Rn));

%Compute reflection coefficient
Gamma_n = (Zn-Z0)./(Zn+Z0);

end