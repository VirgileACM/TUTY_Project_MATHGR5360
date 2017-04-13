%Kevin Jones
%Financial Price Analysis Project

%Code to generate our trading signals.
%Will use our boolean signals based on breakouts and stop percentage.

function [trade] = calculateTrades(t, stpPct, signal, open, close)

%Initialize our trade vector.
n = size(open, 1);
trade = zeros(n, 1);

currentPos = 0;
prevPeak = 0.00;
prevTrough = 0.00;

for i = (t+2):(n-1)
    
    %If we currently are flat, we need to simply look at our breakout
    %signals we generated in calculateSignal.
    if currentPos == 0
        
        %If the signal for the previous bar is 1, that is telling us there is a breakout to the
        %upside and to go long the future. Need to initialize prevPeak to
        %where we bought the futures contract at.
        if signal(i-1) == 1
            trade(i) = 1;
            currentPos = 1;
            prevPeak = open(i);
            
        %If the signal for the previous bar is -1, that is telling us there is a breakout to the
        %downside and to go short the future. Need to initialize prevTrough
        %to where we sold the futures ocntract at
        elseif signal(i-1) == -1
            trade(i) = -1;
            currentPos = -1;
            prevTrough = open(i);
        end
        
    %If we are currently long the futures contract, we now don't need to
    %look at the signal. We simply keep updating prevPeak (if necessary)
    %and exit the position when we hit our stop loss.   
    elseif currentPos == 1
        
        if close(i-1) > prevPeak
            prevPeak = close(i-1);
        elseif close(i-1) < (1-stpPct) * prevPeak
            trade(i) = -1;
            currentPos = 0;
        end
    
    %If we are currently short the futures contract, we now don't need to
    %look at the signal. We simply keep updating prevTrough (if necessary)
    %and exit the position when we hit our stop loss.   
    elseif currentPos == -1
        if close(i-1) < prevTrough
            prevTrough = close(i-1);
        elseif close(i-1) > (1+stpPct) * prevTrough
            trade(i) = 1;
            currentPos = 0;
        end
    end
end 

%Make sure we close out any position we have at the end of the sample.
if currentPos == 1
    trade(n) = -1;
elseif currentPos == -1
    trade(n) = 1;
end
        
        
        