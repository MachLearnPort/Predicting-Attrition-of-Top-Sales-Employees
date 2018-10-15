clear;
clc;

format shortg;
y=0;
while y == 0
    % c = [year month day hour minute seconds]
    c=clock;
    % Rounding every value to an integer
    c=fix(c);
    x.clock=c;
    % accessing the 4th column of c, i.e hours
    x.hours=c(:,4);
    % accessing the 5th column of c ,i.e minutes
    x.minutes=c(:,5);
    % accessing the 6th column of c, i.e seconds
    x.seconds=c(:,6);
    % converting x into JSON and writing as matlabData.json
    savejson('',x,'D:\Users\Jeff\Google Drive\Machine Learning\Node-server execute JAVA\matlab-mean-demo\data\matlabData.json');
end