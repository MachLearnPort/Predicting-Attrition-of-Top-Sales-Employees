function[Rank_score] = Cust_var(X_MAP, X_opt)
    
for i=1:size(X_MAP,2)
    X_var(:,i)=abs(X_MAP(:,i) - X_opt(i)); %Variance from the optimal configuration
end

%Generate weigths for factors
W_f=zeros(1,size(X_var,2)); %Weighted factors from GBM model
W_f(20)=1; %Overtime
W_f(3)=0.8669; %Buiness Travel
W_f(17)=0.8048; %Monthly income
W_f(1)=0.7631; %Age
W_f(18)=0.5535; %Monthly rate
W_f(16)=0.5332; %Marital status
W_f(4)=0.4919; %Daily rate
W_f(8)=0.4833; %Education feild
W_f(30)=0.4238; %Years since last promotion
W_f(12)=0.3949; %Job Involvment
W_f(15)=0.3264; %Job Satisfaction
W_f(23)=0.2588; %Relationship Satisfaction
W_f(29)=0.2431; %Years in current role
W_f(31)=0.2388; %Years with current manager
W_f(21)=0.2283; %Percent Salaray hike
W_f(6)=0.1198; %Distance from home
W_f(24)=0.1179; %Stock option level
W_f(7)=0.1077; %Education
W_f(10)=0.1064; %Gender
W_f(11)=0.0704; %Hourly rate  
W_f(28)=0.0405; %Years at company
W_f(25)=0.0285; %Total working years
W_f(19)=0.0258; %Numbers of companies worked for
W_f(26)=0.0099; %Number of training times last year

%Calculte variance rank scored

for i=1:size(X_var,1)
    Rank_score(i,1)=i; %Indices
    Rank_score(i,2)=sum(X_var(i,:).*W_f); %Ranking score
end

end

