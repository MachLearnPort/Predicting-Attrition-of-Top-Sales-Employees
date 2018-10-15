 function [] = clear_output(PW)
%CLEAR_OUTPUT -  clears the output folder of all data from previous

    pathDir = [PW, 'MATLAB\Perf_sub\Output\']; %Output files path directory
    delete ([pathDir '*.mat']);

end