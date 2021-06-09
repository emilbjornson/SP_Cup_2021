close all;
clear;


%% Load the dataset. If you don't have it, then run generateDatasets.m to create it
load dataset2.mat;


%Number of elements per row in the IRS
N_H = 64;

%Number of elements per column in the IRS
N_V = 64;

%Total number of elements in the IRS
N = N_H*N_V;

%Number of channel taps
M = 20;

%Number of subcarriers
K = 500;

%Compute a K x K DFT matrix
F_full = fft(eye(K));

%Extract the K x M matrix that used in (6) and elsewhere
F_mat = F_full(1:K,1:M);

%The projection matrix defined in (22)
Aproj = kron(ones(N_V,1),eye(N_H));

%Extract the transmitted signal (same on all subcarriers)
x = transmitSignal(1);

%Noise power spectral density (including 9 dB noise figure)
N0 = db2pow(-174+9)/1000; %W per Hz



%Prepare to save configurations
theta_basic = zeros(N,50);
theta_uniform = -ones(N,50);
theta_powermethod = zeros(N,50);


%% Go through each of the UEs in the dataset
for i = 1:50
    
    %Extract the received signal at user i
    Z = receivedSignal(:,:,i);
    
    
    
    %Benchmark: Pick a solution among those used in pilot transmission
    
    %Estimate the rate for all the rates values
    ratevalue = zeros(N,1);
    
    for c = 1:N
        
        %Approximate rate computation
        ratevalue(c) = sum(log2(1+abs(Z(:,c)).^2/N0));
        
    end
    
    %Find the pilot giving the highest rate
    [~,ind] = max(ratevalue);
    
    %Save the corresponding value
    theta_basic(:,i) = pilotMatrix(:,ind);
    
    %Compute the believed extended pilot matrix
    Omega_e_tilde = [ones(1,N); Aproj'*pilotMatrix];
    
    %Compute the LS estimate based on (XX)
    LS_estimate = ((F_mat'*F_mat)\F_mat')*Z*(Omega_e_tilde'/(Omega_e_tilde*Omega_e_tilde'))/x;
    
    %Extract the LS estimates
    hd_estimate = LS_estimate(:,1);
    V_estimate = Aproj*transpose(LS_estimate(:,2:end));
    
    
    
    %Proposed power method algorithm
    
    %Initiate the power method based on the best pilot solution
    phase_start = Aproj'*theta_basic(:,i)/N_V;
    phase_best = phase_start;
    
    %Estimate the effective channel with the initial configuration
    hbar = F_mat*(hd_estimate+(Aproj'*V_estimate).'*phase_start);
    
    %Estimate the rate with the initial configuration
    ratevalue = sum(log2(1+abs(hbar.*transmitSignal).^2/N0));
    
    %Compute the B matrix from (25)
    B = [hd_estimate (Aproj'*V_estimate).'];
    BB = B'*B;
    BB = (BB+BB')/2;
    
    
    %Set a maximum number of iterations, in case the algorithm oscillates
    %between two solutions
    for n = 1:20
        
        %Compute one step in the power method
        a = [1; phase_start];
        a_new = BB*a;
        
        %Rotate the solution so that the uncontrolled path has a +1
        a_new = a_new*a_new(1)';
        
        %Quantize the current solution to +1 and -1
        a_new(real(a_new) > 0) = 1;
        a_new(real(a_new) < 0) = -1;
        phase_start = a_new(2:end,:);
        
        %Estimate the rate with the new configuration
        hbar_new = F_mat*(hd_estimate+(Aproj'*V_estimate).'*a_new(2:end,:));
        ratevalue_new = sum(log2(1+abs(hbar_new.*transmitSignal).^2/N0));
        
        %Save the best solution so far
        if ratevalue_new>ratevalue

            ratevalue = ratevalue_new;
            phase_best = phase_start;
            
        end
        
    end
    
    %Save the final solution
    theta_powermethod(:,i) = Aproj*phase_best;
    
end


%Evaluate the true rates with all the considered methods
[metric_basic,R_basic] = testrate(theta_basic);
[metric_uniform,R_uniform] = testrate(theta_uniform);
[metric_powermethod,R_powermethod] = testrate(theta_powermethod);


%Sort the UEs with increasing rates
[R_powermethod_sorted,ordering] = sort(R_powermethod,'ascend');



%% Plot simulation results
figure;
hold on; box on; grid on;
plot(1:50,R_powermethod_sorted,'k','LineWidth',2);
plot(1:50,R_basic(ordering),'b-.','LineWidth',2);
plot(1:50,R_uniform(ordering),'b:','LineWidth',2);
set(gca,'fontsize',16);
xlabel('User index (sorted)','Interpreter','Latex');
ylabel('Data rate [Mbit/s]','Interpreter','Latex');
legend({'IRS: Power method','IRS: Best pilot','Uniform surface'},'Interpreter','Latex','Location','NorthWest');
ylim([0 150]);
