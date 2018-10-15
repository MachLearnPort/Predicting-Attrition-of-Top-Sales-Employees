function [f] = Objectivefcn(x, header, Map, ScolO, mu, sigma, P_vars, X0, PW) %Need to make sure this function is the same as the anonymous call in the Ga

%Create the input file for candidate with the revisions from the GA
X=X0;
for i=1:size(P_vars,2) %For loop changes only X values considered in the 
    X(P_vars(i))=x(i);
end

% Generate input.csv file
inputT(X, header, Map, ScolO, PW);

% Run h2o R-scripts to extract objective function TPO features
%Laptop
%dos('"C:\Program Files\R\R-3.4.0\bin\x64\Rscript" "C:\Users\Jeff\Google Drive\Tailored Process Optimization\TPO\HR_Project\HR_Sales\R_master.r"')
%Desktop
dos('"C:\Program Files\R\R-3.4.0\bin\x64\Rscript" "D:\Users\Jeff\Google Drive\Tailored Process Optimization\TPO\HR_Project\HR_Sales\R_master.r"')


% Read generated Prediction Values - ** change file name inside
[Pred_V, A] = read(PW);

% Feature Normalization - Normalized about 1
for i=1:size(Pred_V,1)
    Pred_VN(:,i)=1+((Pred_V(i)-mu(i))/sigma(i)); %**** Verify Sigma and MU are in the same order as Pred_VN
end

%Weights
W1=1; %Attrition weight
W2=1; %Incentive cost weight

%Extract Monthly income raise and Normalize
C_n=abs(X(15)-X0(15))/X0(15); %Cost associated with increasing their monthly income

%Extract normailzed value
A_n=abs(Pred_VN(1,1));


% TPO function
f=W1*A_n+W2*C_n; %TPO function for optimizing A

toc;
end