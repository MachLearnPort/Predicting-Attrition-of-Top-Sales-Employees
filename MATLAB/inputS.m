function [] = inputS(strat, header, Map, ScolO, PW)
% INPUT - generate input csv
headerI = header(1,:);
%Remap the numeric vars back into their categorial vals now that they have
%been passed into the GA
for k=1:size(strat,1)
    x=strat(k,:);
    x_w=array2table(x);
    for i=1:length(ScolO)
        for j=1:length(Map.(headerI{1,ScolO(i)}).code)
            if x(ScolO(i)) == Map.(headerI{1,ScolO(i)}).code(j,1)
                x_w.(sprintf('x%d',ScolO(i))) = Map.(headerI{1,ScolO(i)}).(sprintf('X%d',ScolO(i)))(j,1); %String is based on the csv2struct translation, with ScolO(i) pointing to the correct Xvar in the the Structure
            end
        end
    end
    x_wt=table2cell(x_w); %convert to table
    X_wt(k,:)=x_wt; %Concencate all of them
end

input_file=vertcat(headerI,X_wt);

cellwrite([PW, 'StratRisk.csv'], input_file);

end
