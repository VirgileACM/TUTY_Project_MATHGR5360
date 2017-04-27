%Kevin Jones
%Financial Price Analysis Project

%Code to generate our portfolio vector.

function [portValue] = tradingCalculatePortfolio(start, stop, stpPct,...
           signal, runningMax, runningMin, open, high, low, close, capital, check)
%function [portValue] = tradingCalculatePortfolio(start, stop, index1, index2, ...
                        %open, high, low, close, capital)
                 
%Calculate our running max and min.
%runningMax = calculateMax(chnLen, high);
%runningMin = calculateMin(chnLen, low);

%Generate our breakout signal vector.
%signal = calculateSignal(chnLen, runningMax, runningMin, high, low);

%Based off the signal and our stpPct, generate our trade vector.
%global trades;
%global prices;
%global currentPosition;

global portTrades;
global portPrices;

[trades, prices] = tradingCalculateTrades(start, stop, stpPct, signal,...
                           runningMax, runningMin, open, high, low, close, check);                     
%tradingCalculateTrades(start, stop, index1, index2, open, high, low, close);                       

%Initialize our portfolio vector
n = size(open, 1);
portValue = zeros(n, 1);
%portValue(1) = capital;

%Is having an initial starting capital necessary?
%cash = capital;

%Contract size and margin specifications from the professor's sheet
%contractSize = 1000; % TY
%contractSize = 2000; % TU
%contractSize = 420; %HO
contractSize = 50; %PL
%contractSize = 1000; %CO

%Slippage from Professor's sheet.
%slippage = 19; %Tu/TY
%slippage = 70; %HO
slippage = 148; %PL
%slippage = 48; %CO

%pointValue = 100; %HO
pointValue = 1;

%margin = 1595; % TY
margin = 605; % TU

numContracts = (capital/margin)/2;
currentPos = 0;
portValue(start-1) = capital;
slippageThisTrade = 0;
priceTraded = 0;

for i = start:stop
    
    %First calculate the change in our portfolio from the price change from
    %the previous bar's close to this bar's open.
    portValue(i) = portValue(i-1) + currentPos*contractSize*(open(i)-close(i-1));
    
    %If our trade vector is telling us to buy:
    %if trades(j,k,i) == 1
    if trades(i) == 1
        
        %Increase our current position by one.
        currentPos = currentPos + 1;
        
        %Only have slippage is we're back to being flat.
        slippageThisTrade = (1-abs(currentPos))*slippage;
        %priceTraded = prices(j,k,i);
        priceTraded = prices(i);
        
        %If we traded back to flat, we need to calculate the price change
        %from where we traded and where the price opened.
        portValue(i) = portValue(i) - (1-abs(currentPos))*contractSize*(priceTraded - open(i));
        
        %If we traded to go long, we need to calculate the price change
        %from the close and where we traded.
        portValue(i) = portValue(i) + currentPos*contractSize*(close(i) - priceTraded);
        
    %If our trade vector tells us to sell:     
    %elseif trades(j,k,i) == -1
    elseif trades(i) == -1
        
        %Decrease our current position by one.
        currentPos = currentPos - 1;
        slippageThisTrade = (1-abs(currentPos))*slippage;
        %priceTraded = prices(j,k,i);
        priceTraded = prices(i);
        portValue(i) = portValue(i) + (1-abs(currentPos))*contractSize*(priceTraded - open(i));
        portValue(i) = portValue(i) + currentPos*contractSize*(close(i) - priceTraded);
        
    %elseif trades(j,k,i) == 0
    elseif trades(i) == 0
        slippageThisTrade = 0;
        portValue(i) = portValue(i) + currentPos*contractSize*(close(i) - open(i));
    end
    
    %Calculate our portValue by adding cash to our position in the futures.
    portValue(i) = portValue(i) - slippageThisTrade;

end

portValue(start-1) = 0;
    
