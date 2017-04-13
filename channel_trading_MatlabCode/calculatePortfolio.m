%Kevin Jones
%Financial Price Analysis Project

%Code to generate our portfolio vector.

function [portValue] = calculatePortfolio(chnLen, stpPct, open, high, low, close, capital)

%Calculate our running max and min.
runningMax = calculateMax(chnLen, high);
runningMin = calculateMin(chnLen, low);

%Generate our breakout signal vector.
signal = calculateSignal(chnLen, runningMax, runningMin, high, low);

%Based off the signal and our stpPct, generate our trade vector.
trades = calculateTrades(chnLen, stpPct, signal, open, close);

%Initialize our portfolio vector
n = size(open, 1);
portValue = zeros(n, 1);
portValue(1:(chnLen+1)) = capital;

%Is having an initial starting capital necessary?
cash = capital;

%Contract size specifications from the professor's sheet
contractSize = 1000;

currentPos = 0;

for i = (chnLen+2):n
    
    %If our trade vector is telling us to buy:
    if trades(i) == 1
        
        %Increase our current position by one.
        currentPos = currentPos + 1;
        %Decrease our cash position by the total value of a contract.
        cash = cash - contractSize*open(i);
        
    %If our trade vector tells us to sell:     
    elseif trades(i) == -1
        
        %Decrease our current position by one.
        currentPos = currentPos - 1;
        %Increase our cash position by the total value of a contract
        cash = cash + contractSize*open(i);
    end
    
    %Calculate our portValue by adding cash to our position in the futures. 
    portValue(i) = cash + currentPos*contractSize*open(i);
end
    