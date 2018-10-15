function [Pred_V, A] = readRanking(PW)
%READ- function reads in the H2O generated predictions files
%   Uses CSVtoStruct to put the csv files into a structured files and
%   outputs the prediction values

filenameA=[PW,'Predictions\StratRisk.csv']; %file dir of attrition prediction

% Import prediction CSV
[A_pred,~]=csv2struct(filenameA);

A=A_pred.X3; %Extract yes prediction probability from A_pred structure

Pred_V=A; %Generate prediction vector for later analysis
end

