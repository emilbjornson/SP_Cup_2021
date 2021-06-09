close all;
clear;


%% Define the array geometry

%Carrier freqeuncy
fc = 4e9;

%Speed of light
c = 3e8; 

%Wavelength
lambda = c/fc;


N_H = 64; %Number of elements per row in the IRS
N_V = 64; %Number of elements per column in the IRS
d_H = 0.4*lambda; %Horizontal element spacing
d_V = 0.4*lambda; %Vertical element spacing


N = N_H*N_V; %Total number of elements
U = zeros(3,N); %Matrix containing the position of the elements

i = @(m) mod(m-1,N_H); %Horizontal index
j = @(m) floor((m-1)/N_H); %Vertical index
for m = 1:N
    U(:,m) = [0; i(m)*d_H; j(m)*d_V]; %Position of the mth IRS element
end



%% Generate correlation matrix for the capacitances

%Generate a correlation matrix between capacitances among the IRS elements
corrMatrix = zeros(N,N);

for n = 1:N
    
    %Compute the distances between all the IRS elements
    interElementDistances = sqrt(abs(U(2,:)-U(2,n)).^2 +  abs(U(3,:)-U(3,n)).^2);
    
    %Compute the correlation factors and normalize them for all elements
    corrMatrix(n,:) = 100.^(-interElementDistances/lambda);
    corrMatrix(n,:) = corrMatrix(n,:)/sum(corrMatrix(n,:));
    
end


%Plot correlation function
figure;
hold on; box on;
corrMatrix_plot = reshape(corrMatrix(64*4+5,:),[N_H,N_V]);

b = bar3(corrMatrix_plot(1:10,1:10));

for m = 1:length(b)
    zdata = b(m).ZData;
    b(m).CData = zdata;
    b(m).FaceColor = 'interp';
end

view(3);
xlim([1,10]);
ylim([1,10]);
zlim([0,0.5]);
xlabel('Horizontal element index','Interpreter','latex');
ylabel('Vertical element index','Interpreter','latex');
zlabel('Correlation','Interpreter','latex');
set(gca,'fontsize',16);
