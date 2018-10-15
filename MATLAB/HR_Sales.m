%TPO - for IBM HR Dataset
%SUBPROCESS - Optimize candidate performance
%By: Jeff Schwartzentruber
% NOTE: Before executing, change PW to be the directory of HR_IBM folder,
% and make simialar change in the R-script that runs the ML models
clear;
clc;
close;
%Laptop
%PW='C:\Users\Jeff\Google Drive\Tailored Process Optimization\TPO\HR_Project\HR_Sales\';
%Desktop
PW='D:\Users\Jeff\Google Drive\Tailored Process Optimization\TPO\HR_Project\HR_Sales\';

clear_output(PW); %Clear all previous results from output folder to not disrupt the post processing
tic;

%% Declare Variables
Pop_size=15;
Gen_size=5;

%% Import dataset (or partial datset) and parse ** Change filename inside
% This function imports the total cleaned CSV file (called inside
% function). Afterwhich, it parses and codes and string structures into
% numeric (so that it can run with the GA) and outputs the a complete
% numeric dataset (X_map), the map to decode the mapping, the columns that
% had strings, along with the header of the dataset. Final output is the
% strcture in array form (X_MAP)

%*** This is not optimized, currently loading whole dataset when only 1
%line is needed, and the uppper and lower bounds extracted from the base
%line run. Fix in future releases

[X, header, Map, X_map, Scol, X_MAP] = importdata(PW);

%% Feature normalization
% get the mean and standard dev for later use before the cost function comp
% Needed step, so that each var gets viewed equally, until the weight start
% to play a role

[mu, sigma] = Feat_Norm(X_MAP);

%% Generate Attrition Rankings
[ risk ] = attritionPred(PW);

%% Create Salary vs Risk Ranking
%Generate RACH
%**** UPDATE BY FILTERING BY HIGHEST VALUE FIRST!!!!!
profit=X_MAP(:,29)./(X_MAP(:,15).*12); %Determin profitability P=Sales-Salary
profitNorm=profit./(max(profit)); %Normalize Profitability
riskNorm=risk./(max(risk)); %Normalize Risk
RAHC=riskNorm.*profitNorm; %Create RAHC
%Concecate ID X_MAP, risk, profit, riskNorm, profitNorm, RAHC
ID=(1:1:size(X_MAP,1))'; %Generate ID numbers
X_MAP_Tot = [ID, X_MAP, risk, profit, riskNorm, profitNorm, RAHC]; %Create total dataset ***might need to create another header structure to keep things organized
X_MAP_Tot=sortrows(X_MAP_Tot, 35, 'descend'); %Sort by RAHC decending

%Generate cut-off (Pareto 80%)
sumRAHC=sum(X_MAP_Tot(:,35)); %sum the RAHC to get the area under the Pareto curve
cutOff=0.8*sumRAHC; %80 percent cutoff
%Calc cumulative area marching from right to left on the pareto graph
cumlRAHC=zeros(size(X_MAP_Tot,1),1); %Preallocation 
for i=1:size(X_MAP_Tot, 1)
    if i==1
       cumlRAHC(i)=(X_MAP_Tot(i, 35));
    else
        cumlRAHC(i)=cumlRAHC(i-1)+(X_MAP_Tot(i, 35));
    end
end

%Determine index where 80% cutoff is
[c index] = min(abs(cumlRAHC-cutOff));

%Subset for people to optimize
X_risk=X_MAP_Tot(1:index,:); 

% Loop through the GA for each 

for j=1:size(X_risk,1)
%% GA - For providing recomendation on how to improve and employees performance
% Loop through high risk Candiate to reduce their risk of attrition
C_no=j; %Select candidate number j to perform optimization on
X0=X_MAP(j,:); %Make the canadiate of interest as the inital value

%Devleop an attrition (X2) improvement plan based influential factors
% of varibles we can affect - could add more, but for POC, stay with this
%X15: MonthlyIncome
%X17: Overtime
%X8: Enviorment Satisfaction

P_vars=[15, 17, 8]; %X vars being optimized
ScolO=(Scol(Scol~=0))'; %For keeping interger values in the GA
ScolOI=[1, 2]; %Set interger values for optimization of overtime and Buiness travel (indices of P_vars

% Create upper and lower bounds
LB=zeros(1,size(P_vars,2));
UB=zeros(1,size(P_vars,2));
for i=1:size(P_vars,2)
    LB(1,i)=min(X_MAP(:,P_vars(i)));
    UB(1,i)=max(X_MAP(:,P_vars(i)));
end

count=0; %Initalize count
fitval=100; %Initlaize

%Output function saves the state of the simualtion, so that later we can
%conduct post processing
options=gaoptimset('PopulationSize',Pop_size,'Generations',Gen_size,'Display','iter','PlotFcns', {@gaplotbestf,@gaplotmaxconstr,@gaplotscorediversity,@gaplotscores},'TolFun',1e-4, 'OutputFcns', @outputfcn);%,'InitialPopulation',X0);

% GA notes:
% Used modified anonmoyus function call to pass header and X_rec to GA
% Last bracket is IntCon, which holds those indicies in the x interger and is
% based on the Scol output
DB_stop=1;
[x,fval,output] = ga(@(x)Objectivefcn(x, header, Map, ScolO, mu, sigma, P_vars, X0, PW),length(LB),[],[],[],[],LB,UB,[], [ScolOI], options)

[X_rec, Y_rec] = postProcess(Gen_size, PW);

%Determin optimal index
[M, I]=min(Y_rec);
X_opt=X_rec(I,:); %Isolate optimal config

%Generate Strategy Dataset
%Take optimized X values and replace the original valus
X_OPT=X0;
X_OPT(15)=X_opt(1);
X_OPT(17)=X_opt(2);
X_OPT(8)=X_opt(3);
strat(j,:)=X_OPT;
end

%Create Attrition Reassessment CSV
DBstop=1;
inputS(strat, header, Map, ScolO, PW);

%Rerank their attrition
[ postRisk ] = attritionPredpost(PW);

%Post Strategy Attrition and Cost Analysis
[RiskResults] = compare(X_risk, postRisk);

%Tableau Exports - create tableau CSV exports
% !!! note: NEED TO ADD ID Column to Strat
% !!! Note: need to constrain the monthly income raise
tableauExports( X_MAP_Tot, X_risk, strat, RiskResults, header, Map, ScolO, PW);

