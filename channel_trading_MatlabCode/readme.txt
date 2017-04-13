--calculatePortfolio will generate a vector consisting of the value of the portfolio during each bar (5 minute window).
	-Takes in the following inputs:
		-chnLen is the channel length
		-stpPct is the stop loss percentage (in decimal format)
		-open is the vector of open prices the professor provided us
		-high is the vector of high prices the professor provided us
		-low is the vector of low prices the professor provided us
		-close is the vector of close prices the professor provided us
		-capital is the amount of capital we have to start (I'm not sure if this is necessary)

--calculateDrawdown will generate a vector consisting of the current drawdown of the portfolio for each bar (5 minute window).
	-Takes in the following inputs:
		-portfolio is the vector of portfolio values calculated from 'calculatePortfolio'

--Read_ascii_file was my matlab generate code to create vectors from the ascii_file the professor provided us
	-If you want to use, please read lines 7-10 to make the necessary updates for your computer.

--projectData_TU,TY contains the vectors already in a .m file so you don't have to use read_ascii_file

--calculateMax, calculateMin, calculateSignal, and calculateTrades are all helper functions used in calculatePortfolio.
	-Descriptions of each are located in the comments in the code