function response = RISvector(config,corrMatrix)
%Compute actual vector omega_theta for a certain configuration based on the
%circuit model and coupling model described in Section III

%Extract number of IRS elements
N = length(config);

%Capacitance of state off
C_off = 0.37*1e-12;

%Capacitance of state on
C_on = 0.5*1e-12;

%Determine ideal capacitance of each IRS element
config = config>0;
C_values = C_off + (C_on-C_off)*config;

%Determine the capacitance of each IRS element with coupling
C_values_coupling = corrMatrix*C_values;


%Carrier frequency of 4 GHz
omega = 2*pi*4e9;

%Compute the IRS response (reflection coefficient) of each IRS element
response = zeros(N,1);

for n = 1:N
    response(n) = refcoefficient(C_values_coupling(n),omega);
end

end
