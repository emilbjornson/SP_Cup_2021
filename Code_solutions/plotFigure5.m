close all;
clear;


%% Load the dataset. If you don't have it, then run generateDatasets.m to create it
load dataset1.mat;


%Number of elements per row in the IRS
N_H = 64;

%Number of elements per column in the IRS
N_V = 64;

%Total number of elements in the IRS
N = N_H*N_V;

%Number of taps
M = 20;

%Number of subcarriers
K = 500;

%Compute a K x K DFT matrix
F_full = fft(eye(K));

%Extract the K x M matrix that used in (6) and elsewhere
F_mat = F_full(1:K,1:M);

%Extract the transmitted signal (same on all subcarriers)
x = transmitSignal(1);


%% Least-squares channel estimation

%Received signal from pilot transmission
Z = receivedSignal4N;

%Compute the believed extended pilot matrix
Omega_e_tilde = [ones(1,4*N); pilotMatrix4N];

%Compute LS estimate based on (20)
LSestimate = ((F_mat'*F_mat)\F_mat')*Z*(Omega_e_tilde'/(Omega_e_tilde*Omega_e_tilde'))/x;

%Extract estimate of uncontrollable channel
hd_estimate = LSestimate(:,1);

%Extract estimate of controllable channel
V_estimate = transpose(LSestimate(:,2:end));

%Take V(:,1) and rewrite as 64 x 64 matrix
V_estimate_square1 = reshape(real(V_estimate(:,1)),[N_H N_V]);



%% Plot simulation results
figure;
surf(1:N_H,1:N_V,zeros(size(V_estimate_square1))',V_estimate_square1','EdgeColor','none');
colormap(parula);
colorbar;
view(2);
xlabel('Horizontal element index','Interpreter','latex');
ylabel('Vertical element index','Interpreter','latex');
set(gca,'fontsize',18);
xlim([1 64]);
ylim([1 64]);
