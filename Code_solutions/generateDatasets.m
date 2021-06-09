close all;
clear;

%% Initialization

%Set the random number generator to a predefined number to enable
%exact reproduction of the dataset
rng('default');


%% Define the array geometry

%Carrier freqeuncy
fc = 4e9;

%Speed of light
c = 3e8; 

%Wavelength
lambda = c/fc;


N_H = 64; %Number of IRS elements per horizontal row
N_V = 64; %Number of rows
d_H = 0.4*lambda; %Horizontal element spacing
d_V = 0.4*lambda; %Vertical element spacing


N = N_H*N_V; %Total number of elements
U = zeros(3,N); %Matrix containing the position of the elements

i = @(m) mod(m-1,N_H); %Horizontal index
j = @(m) floor((m-1)/N_H); %Vertical index
for m = 1:N
    U(:,m) = [0; i(m)*d_H; j(m)*d_V]; %Position of the mth IRS element
end



%% Define the propagation environment


%Location of transmitting AP (in meters)
APlocation = [40 -100 0]; 

%Total number of UEs
UEs = 51;

%Number of UEs in Dataset2
nbrOfUsers = 50;

%Select 14 NLOS users at random among the first 50 UEs. The other UEs have
%LOS paths
NLOSusers = randperm(UEs-1);
NLOSusers = NLOSusers(1:14);

%Deploy UEs at random locations in a particular region
UElocations = [10+13*rand(UEs,1) 14*rand(UEs,1)-6 zeros(UEs,1)];

%Micro-cell pathloss models from ETSI TR 125 996 (where d is in meter)
pathlossLOS = @(d) db2pow(-30.18-26*log10(d));
pathlossNLOS = @(d) db2pow(-34.53-38*log10(d));

%Distance from AP to center of IRS (located in the origin)
distAP_IRS = norm(APlocation); 

%Compute azimuth angles to the AP and UE as seen from the IRS
varphiAP_IRS = atan(APlocation(2)/APlocation(1));

%Number of paths from the AP to the IRS
La = 101;

%Compute angles of arrival and delays of the paths from AP to the IRS
deviationAngleInterval = 40*pi/180; %The angles are distributed within this interval around the nominal angle
La_angles = varphiAP_IRS + [0; deviationAngleInterval*(2*rand(La-1,1)-1)];
La_delay = distAP_IRS*(1 + [0; 2*rand(La-1,1)])/c; %The delay of the first path (LOS) is determined by its length and the oether ones are randomized

%Compute pathlosses from AP to IRS
RicefactorAP_IRS = db2pow(13-0.03*distAP_IRS); %Compute Rice factor according to ETSI TR 125 996
powerDistribution = rand(La-1,1);
powerDistribution = powerDistribution./sum(powerDistribution); %Allocate the NLOS power randomly among the NLOS paths
La_pathloss = pathlossLOS(distAP_IRS)*[RicefactorAP_IRS/(1+RicefactorAP_IRS); (1/(1+RicefactorAP_IRS))*powerDistribution];

%Penetration loss factor for the uncontrollable paths
penetrationloss = 1/5;

%Define 10 resolvable scattering points inside the room and their fixed
%locations, irrespective of the UE locations
SPs = 10;
SPlocations = [5+40*rand(SPs,1) [12-2*rand(SPs/2,1); -10+3*rand(SPs/2,1)] zeros(SPs,1)];
SPtoIRS = sqrt(sum(abs(SPlocations).^2,2)); %Compute distances from IRS to scattering points



%% Define OFDM transmission properties and channels

%Set the symbol time (also equal to the bandwidth)
symboltime = 10e6;

%Set the length of the 
M = 20;

%Set the number of subcarriers
K = 500;


%Prepare to compute V and h_d based on the formulas in the paper
V = zeros(N,K,UEs);
hd = zeros(K,UEs);


%Go through all UEs
for index = 1:UEs
    
    %Extract UE location
    UElocation = UElocations(index,:);
    
    %Compute distance from the UE to the center of the IRS
    distUE_IRS = norm(UElocation); 
    
    %Compute distance from the AP to the UE
    distAP_UE = norm(APlocation - UElocation); 
    
    %Compute azimuth angles to the UE as seen from the IRS
    varphiUE_IRS = atan(UElocation(2)/UElocation(1));
    
    
    %Generate random propagation conditions
    
    %Number of paths
    Lb = SPs+1;
    Ld = 101;
    
    %Compute Rice factor according to ETSI TR 125 996
    RicefactorUE_RIS = db2pow(13-0.03*distUE_IRS);
    
    %Compute angles from the IRS to the UE and to the scattering points
    Lb_angles = [varphiUE_IRS; atan(SPlocations(:,2)./SPlocations(:,1))];
    
    %Compute distances from scattering points to the UE
    SPtoUE = sqrt(sum(abs(SPlocations-repmat(UElocation,[SPs 1])).^2,2));
    
    %Determine propagation delays based on distances from the IRS (via
    %scattering points) and based on random delays between the AP and UE
    Lb_delay = [distUE_IRS; SPtoIRS+SPtoUE]/c;
    Ld_delay = distAP_UE*(1 + rand(Ld,1))/c;
    
    %Take first sample at the receiver when the first direct path arrives
    eta = min(Ld_delay);
    
    %Allocate the NLOS power randomly among the NLOS paths
    powerDistribution = rand(Lb-1,1);
    powerDistribution = powerDistribution./sum(powerDistribution);
    
    %Compute pathlosses from IRS to UE
    Lb_pathloss = pathlossLOS(distUE_IRS)*[RicefactorUE_RIS/(1+RicefactorUE_RIS); (1/(1+RicefactorUE_RIS))*powerDistribution];
    
    %Compute pathlosses from AP to UE
    Ld_pathloss = penetrationloss*pathlossNLOS(distAP_UE)*ones(Ld,1)/Ld;
    
    
    %Remove LOS path for BLOS users by setting the pathloss to zero
    if find(NLOSusers == index)
        
        Lb_pathloss(1) = 0;
        
    end
    
    
    %Go through all channel taps
    for m = 1:M
        
        %Go through all paths to and from the IRS
        for l1 = 1:La
            for l2 = 1:Lb
                
                %Compute elements of V based on the formula
                V(:,m,index) = V(:,m,index) + cos(La_angles(l1))*cos(Lb_angles(l2))*sqrt(La_pathloss(l1)*Lb_pathloss(l2))*exp(-1i*2*pi*fc*(La_delay(l1)+Lb_delay(l2)))* functionSpatialSignature3DLoS(U,La_angles(l1),0,lambda).*functionSpatialSignature3DLoS(U,Lb_angles(l2),0,lambda)*sinc(m-1+symboltime*(eta-La_delay(l1)-Lb_delay(l2)));
                
                
            end
        end
        
        %Go through all the direct paths
        for l = 1:Ld
            hd(m,index) = hd(m,index) + sqrt(Ld_pathloss(l))*exp(-1i*2*pi*fc*Ld_delay(l))*sinc(m-1+symboltime*(eta-Ld_delay(l)));
        end
        
    end
    
    
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




%% Generate pilot transmission

%The Hadamard matrix is used as pilot matrix
pilotMatrix = hadamard(N);

%Compute the K x K DFT matrix
F = fft(eye(K));

%Transmit power
P = 1; %Transmit power in Watt
Ppersymbol = P/symboltime; %Power per symbol

%Noise power spectral density (including 9 dB noise figure)
N0 = db2pow(-174+9)/1000; %W per Hz

%Create the transmitted signal
transmitSignal = sqrt(Ppersymbol)*ones(K,1);

%Generate all the noise realizations for Dataset2
noiseSignal = sqrt(N0/2)*(randn(K,N,UEs-1)+1i*randn(K,N,UEs-1));


%Prepare to save the simulation results for Dataset2
receivedSignal = zeros(K,N,UEs-1);
SNRs = zeros(K,N,UEs-1);

%Go through all pilot transmissions
for n = 1:N
    
    %Compute the reflection coefficients for a certain pilot transmission
    reflectionCoefficients = RISvector(pilotMatrix(:,n),corrMatrix);
    
    %Compute the channels, received signals, and SNRs for all 50 UEs
    for index = 1:UEs-1
        
        hbar = F*(hd(:,index)+V(:,:,index).'*reflectionCoefficients);
        
        receivedSignal(:,n,index) = hbar.*transmitSignal + noiseSignal(:,n,index);
        
        SNRs(:,n,index) = abs(hbar.*transmitSignal).^2/N0;
        
    end
    
end


%Create the extended pilot matrix for Dataset1
pilotMatrix2 = -hadamard(N);
pilotMatrix3 = flipud(hadamard(N));
pilotMatrix4 = -flipud(hadamard(N));
pilotMatrix4N = [pilotMatrix pilotMatrix2 pilotMatrix3 pilotMatrix4];

%Generate all the noise realizations for Dataset1
noiseSignal4N = sqrt(N0/2)*(randn(K,4*N)+1i*randn(K,4*N));

%Prepare to save results for Dataset1
receivedSignal4N = zeros(K,4*N);


%Go through all pilot transmissions
for n = 1:4*N
    
    %Compute the reflection coefficients for a certain pilot transmission
    reflectionCoefficients = RISvector(pilotMatrix4N(:,n),corrMatrix);
    
    %Copmute the resulting channel
    hbar = F*(hd(:,51)+V(:,:,51).'*reflectionCoefficients);
    
    %Compute the received signal
    receivedSignal4N(:,n) = hbar.*transmitSignal + noiseSignal4N(:,n);
    
end



%Save Dataset1
save dataset1 K M N receivedSignal4N pilotMatrix4N transmitSignal;

%Save Dataset2
save dataset2 K M N nbrOfUsers receivedSignal pilotMatrix transmitSignal;

%Save the true parameters needed for evaluation
save trueParameters corrMatrix F hd K M N0 NLOSusers symboltime transmitSignal V;


