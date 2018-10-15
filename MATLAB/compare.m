function [ RiskResults ] = compare( X_risk, postRisk )
%COMPARE Compares prediction values and esitmates cost savings
%    Compares the pre (X_risk) vs the post strat (strat) attrition
%    percentages and multiples it by their sales revenue

%Create array that concencates ID (col. 1 in X_risk), pre risk (col. 29
%in X_risk, post risk (only 1 col), and salary (col. 30 in X_risk) 
RiskResults = [X_risk(:,1), X_risk(:,31), postRisk(:,1), X_risk(:,30)]; %Concecate risk results
riskReduce = RiskResults(:,3)-RiskResults(:,2); % calculate risk reduction
Savings = (riskReduce.*RiskResults(4))*-1; %Calculate savings (-1 to siwthc the signs of the savings)
RiskResults = [RiskResults, riskReduce, Savings]; %Concecate results


end

