function [X, header, Map, X_map, Scol, X_MAP] = importdata(PW)
%Import - Imports data and classifies it as structured or unstructured
%   Imports the cleaned CSV file as structure, after which, a string
%   comparison of the data classes seperates them into two different
%   datasets

%** NOTE, when cleaning, see if variable dimensionality can be reduced, and
%the current dataset, they have hourly and monthly, these are redundant and
%can be interpolated from each other
filename = [PW,'HR_Sales.csv']; %This is the ranked dataset from the optimal TPO
[X,header]=csv2struct(filename);
fields = fieldnames(X);

Scol=zeros(numel(fields),1); %Initalize enum col

%Identify data types and convert to numeric so that we can translate
%between the enum and numeric features
for i=1:numel(fields)
    if strcmp(sprintf(class(X.(fields{i,1})(1,1))), 'double')==1
        X_map.(fields{i,1})=X.(fields{i,1});
        continue;
    else if strcmp(sprintf(class(X.(fields{i,1}){1,1})), 'char')==1
            Scol(i,1)=i;
            % Create MAP for non-numeric
            U=unique(X.(fields{i,1})); %Identify unique feilds to build map
            Map.(header{1,i}).(fields{i,1})=U; %create structure for U
            Map.(header{1,i}).code=(1:size(U,1))';
            %Change all Vars
            for j=1:length(X.(fields{i,1})) %Iteration through length of data structure
                for k=1:size(U,1) %Loop through all unique strings
                    if strcmp(X.(fields{i,1})(j,1), Map.(header{1,i}).(fields{i,1})(k,1)) == 1; %convert enum variable to numeric code
                    X_map.(fields{i,1})(j,1)=Map.(header{1,i}).code(k,1); %Update X_map to correct code                  
                    end
                end
            end
            continue;
        end
        fprintf('Unknown Datatype');
    end
end
X_Map=struct2table(X_map); %Convert structure to table, so that it can be converted into an Array
X_MAP=table2array(X_Map); %Convert table to array
end


