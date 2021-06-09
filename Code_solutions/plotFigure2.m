close all;
clear;


%Set range of frequencies (GHz)
fRange = linspace(3,5,101);

%Capacitance of state off
C_off = 0.37*1e-12;

%Capacitance of state on
C_on = 0.5*1e-12;

%Range of capacitance values
C_range = [C_off C_on]; 

%Compute reflection coefficients for all frequencies and capacitances
frequency_response = zeros(length(fRange),length(C_range));

%% Go through all frequencies
for k = 1:length(fRange)
    
    %Range of angular frequencies
    omega = 2*pi*fRange(k)*1e9;
    
    %Go through all capacitance values
    for m = 1:length(C_range)
        
        %Compute the reflection coefficients
        frequency_response(k,m) =  refcoefficient(C_range(m),omega);
        
    end
    
end


%% Plot simulation results
figure;
hold on; box on; grid on;
plot(fRange,(180/pi)*angle(frequency_response(:,1)),'k','LineWidth',2);
plot(fRange,(180/pi)*angle(frequency_response(:,2)),'r--','LineWidth',2);
plot(fRange(51),(180/pi)*angle(frequency_response(51,1)),'ko','LineWidth',2);
plot(fRange(51),(180/pi)*angle(frequency_response(51,2)),'ro--','LineWidth',2);
set(gca,'fontsize',16);
xlabel('Frequency ($f$) [GHz]','Interpreter','Latex');
ylabel('Phase response [degrees]','Interpreter','Latex');
legend({['Off: ' num2str(C_range(1)*1e12) ' pF'],['On: ' num2str(C_range(2)*1e12) ' pF']},'Interpreter','Latex','Location','NorthEast');
ylim([-180 180]);
yticks(-180:90:180);

figure;
hold on; box on; grid on;
plot(fRange,abs(frequency_response(:,1)),'k','LineWidth',2);
plot(fRange,abs(frequency_response(:,2)),'r--','LineWidth',2);
plot(fRange(51),abs(frequency_response(51,1)),'ko','LineWidth',2);
plot(fRange(51),abs(frequency_response(51,2)),'ro--','LineWidth',2);
set(gca,'fontsize',16);
xlabel('Frequency ($f$) [GHz]','Interpreter','Latex');
ylabel('Amplitude response','Interpreter','Latex');
legend({['Off: ' num2str(C_range(1)*1e12) ' pF'],['On: ' num2str(C_range(2)*1e12) ' pF']},'Interpreter','Latex','Location','SouthEast');
ylim([0.8 1]);
