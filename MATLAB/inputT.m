function [] = inputT(x, header, Map, ScolO, PW)
% INPUT - generate input csv
headerI = header(1,:);
%Remap the numeric vars back into their categorial vals now that they have
%been passed into the GA
x_w=array2table(x);
for i=1:length(ScolO)
    for j=1:length(Map.(headerI{1,ScolO(i)}).code)
    if x(ScolO(i)) == Map.(headerI{1,ScolO(i)}).code(j,1)
        x_w.(sprintf('x%d',ScolO(i))) = Map.(headerI{1,ScolO(i)}).(sprintf('X%d',ScolO(i)))(j,1); %String is based on the csv2struct translation, with ScolO(i) pointing to the correct Xvar in the the Structure
    end
    end
end

x_wt=table2cell(x_w);
input_file=vertcat(headerI,x_wt);

cellwrite([PW, 'input.csv'], input_file);

end
