function [X_rec, Y_rec] = postProcess(Gen_size, PW)
%POSTPROCESS Function processes GA output files
%   Generates matricies of the output sturcture created during the GA. THe
%   mode calls them from the output folder and creates large dataset to
%   compare the effect of variables.

%Initalize 
X_rec=[];
Y_rec=[];

W_dir=pwd; %Define master/working directory

for k = 1:Gen_size %Loop through the .mat files in the directoy and combine
    cd Output; %Change to output dir of output files
	% Create a mat filename, and load it into a structure called matData.
	matFileName = sprintf('%d.mat', k);
	if exist(matFileName, 'file')
		matData = load(matFileName);
	else
		fprintf('File %s does not exist.\n', matFileName);
    end	
  cd ..\; %Go back to master/working directory
  
   X_rec=[X_rec; matData.state.Population]; %Extract and build population matrix
   Y_rec=[Y_rec; matData.state.Score]; %Extract and build Score matrix
end
clear_output(PW); %Clear output folder of Mat_files;
end


