%Feature Normailization
function [mu, sigma] = Feat_Norm(X_MAP)
%FEAT_NORM Generates the Normalization parameters to be used before the
%vars are inputted in the GA. The features need to be normailzed in a way
%as to not generate negitive numbers, becuase the TPO function is about
%optimizing postiive numbers, as netgive numbers (like the negitives in the
%HR_IBM example MAY produce skewed results
%Thus, the solution is to normailize about 1 (during the feature norma script in the obejctive funtion, and make all predictions 
%absolute, as to promote growth in the upper bounds of the gaussian dist.

% Isolate Cost Variables
Ac=X_MAP(:,2); %Attribution column
Rc=X_MAP(:,11); %Rate column
Sc=X_MAP(:,15); %Satisfaction column
Pc=X_MAP(:,22); %Performance column

%Normalize the X

X=[Ac, Pc, Rc, Sc]; %Responses column - needs to be in the same order as the feature norm section in the GA
X_norm = X;
mu=mean(X)';
sigma=std(X)';
end