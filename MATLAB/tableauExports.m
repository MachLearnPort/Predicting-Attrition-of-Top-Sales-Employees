function [] = tableauExports( X_MAP_Tot, X_risk, strat, RiskResults, header, Map, ScolO, PW)
%TABLEAUEXPORTS Create the csv files to be used in the Tableau report
%   Add headers, and convert the arrays to cells

%Convert Arrays to cells

%% X_risk conversion
headerXr = ['ID', header(1,:), 'risk', 'profit', 'riskNorm', 'profitNorm', 'R-score'];
X_riskd=X_risk(:,2:end); %Drop ID column so that I can convert the array back to string values
%Remap the numeric vars back into their categorial vals now that they have
%been passed into the GA
for k=1:size(X_riskd,1)
    x=X_riskd(k,:);
    x_w=array2table(x);
    for i=1:length(ScolO)
        for j=1:length(Map.(header{1,ScolO(i)}).code)
            if x(ScolO(i)) == Map.(header{1,ScolO(i)}).code(j,1)
                x_w.(sprintf('x%d',ScolO(i))) = Map.(header{1,ScolO(i)}).(sprintf('X%d',ScolO(i)))(j,1); %String is based on the csv2struct translation, with ScolO(i) pointing to the correct Xvar in the the Structure
            end
        end
    end
    x_wt=table2cell(x_w); %convert to table
    X_wt(k,:)=x_wt; %Concencate all of them
end

%Convert ID to cell value and add to front of row
ID=array2table(X_risk(:,1)); %Convert first col to table
IDc=table2cell(ID);
X_wt=horzcat(ID,X_wt); %Add id to front of table
X_wt=table2cell(X_wt); %X_wt in the previous operation gets converted from a cell back to a table, and we need it in cell form

X_risk_file=vertcat(headerXr,X_wt);

clear x_wt X_wt i j k ID IDc; %clear the X and counters vars to be used again 

%% Strat conversion

headerS = header(1,:);
%Remap the numeric vars back into their categorial vals now that they have
%been passed into the GA
for k=1:size(strat,1)
    x=strat(k,:);
    x_w=array2table(x);
    for i=1:length(ScolO)
        for j=1:length(Map.(headerS{1,ScolO(i)}).code)
            if x(ScolO(i)) == Map.(headerS{1,ScolO(i)}).code(j,1)
                x_w.(sprintf('x%d',ScolO(i))) = Map.(headerS{1,ScolO(i)}).(sprintf('X%d',ScolO(i)))(j,1); %String is based on the csv2struct translation, with ScolO(i) pointing to the correct Xvar in the the Structure
            end
        end
    end
    x_wt=table2cell(x_w); %convert to table
    X_wt(k,:)=x_wt; %Concencate all of them
end

strat_file=vertcat(headerS,X_wt);

clear x_wt X_wt i j k; %clear the X and counters vars to be used again 

%% X_risk_tot conversion

headerXr = ['ID', header(1,:), 'risk', 'profit', 'riskNorm', 'profitNorm', 'R-score'];
X_riskd=X_MAP_Tot(:,2:end); %Drop ID column so that I can convert the array back to string values
%Remap the numeric vars back into their categorial vals now that they have
%been passed into the GA
for k=1:size(X_riskd,1)
    x=X_riskd(k,:);
    x_w=array2table(x);
    for i=1:length(ScolO)
        for j=1:length(Map.(header{1,ScolO(i)}).code)
            if x(ScolO(i)) == Map.(header{1,ScolO(i)}).code(j,1)
                x_w.(sprintf('x%d',ScolO(i))) = Map.(header{1,ScolO(i)}).(sprintf('X%d',ScolO(i)))(j,1); %String is based on the csv2struct translation, with ScolO(i) pointing to the correct Xvar in the the Structure
            end
        end
    end
    x_wt=table2cell(x_w); %convert to table
    X_wt(k,:)=x_wt; %Concencate all of them
end

%Convert ID to cell value and add to front of row
ID=array2table(X_MAP_Tot(:,1)); %Convert first col to table
IDc=table2cell(ID);
X_wt=horzcat(ID,X_wt); %Add id to front of table
X_wt=table2cell(X_wt); %X_wt in the previous operation gets converted from a cell back to a table, and we need it in cell form

X_Total_file=vertcat(headerXr,X_wt);

clear x_wt X_wt i j k ID IDc; %clear the X and counters vars to be used again 

%% RiskResults conversion

headerRR = {'ID', 'Risk Before', 'Risk After', 'Profit', 'Risk Difference', 'Savings'}; %Create header
RiskResultsC=array2table(RiskResults); %convert Risk results
RiskResultsCc=table2cell(RiskResultsC);
Risk_Results_file=vertcat(headerRR,RiskResultsCc);

%% Export cells
exportFolder = 'MATLAB_Exports_for_tableau\'; %Export folder
cellwrite([PW,exportFolder,'X_risk.csv'], X_risk_file);
cellwrite([PW,exportFolder,'Strat.csv'], strat_file);
cellwrite([PW,exportFolder,'X_Total.csv'], X_Total_file);
cellwrite([PW,exportFolder,'Risk_results.csv'], Risk_Results_file);
end

