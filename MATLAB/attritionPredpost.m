function [ postRisk ] = attritionPredpost(PW)
%   ATTRITIONRANK ranks employees attrition risk
%   Used the GBM produced in H2O to make predictions on attrition risk

% Run risk R prediction R code
%Laptop
%dos('"C:\Program Files\R\R-3.4.0\bin\x64\Rscript" "C:\Users\Jeff\Google Drive\Tailored Process Optimization\TPO\HR_Project\HR_Sales\R_rankingPost.r"')
%Desktop
dos('"C:\Program Files\R\R-3.4.0\bin\x64\Rscript" "D:\Users\Jeff\Google Drive\Tailored Process Optimization\TPO\HR_Project\HR_Sales\R_rankingPost.r"')


[Pred_V, A] = readRankingPost(PW);

postRisk = A; 
end

