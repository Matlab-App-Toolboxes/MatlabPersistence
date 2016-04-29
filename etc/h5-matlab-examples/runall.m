
%% Run all the h5ex* examples in the current directory
%Create the h5ex*output.txt file for each with:
% 1. MATLAB display output
% 2. h5dump output on resulting file



dotMFiles=dir('h5ex*.m');

%% Just run it all
for fInd=1:length(dotMFiles)    
    fileName=dotMFiles(fInd).name;    
    functionName=fileName(1:end-2);
    disp('**************************************************************');
    disp(fileName);
    disp('**************************************************************');
    eval(functionName); %remove the extension and evaluate 
    disp('==============================================================');
    disp(fileName);
    disp('==============================================================');
end

%% Create output.txt files
for fInd=1:length(dotMFiles)    
    fileName=dotMFiles(fInd).name;    
    functionName=fileName(1:end-2);
    
    ftxt=fopen([functionName,'_output.txt'],'wt');
    disp(fileName);    
    matlabOutput=evalc(functionName); %remove the extension and evaluate 
    
    fprintf(ftxt,'\n');
    fprintf(ftxt,'*******************************\n');
    fprintf(ftxt,'*  Output of %s   *\n',functionName);
    fprintf(ftxt,'*******************************\n\n');
    fprintf(ftxt,'%s',matlabOutput);
    fprintf(ftxt,'\n\n\n');
    
    h5dumpTxt=evalc(['!h5dump ',functionName,'.h5']);
    fprintf(ftxt,'*******************************\n');
    fprintf(ftxt,'*  Output of h5dump           *\n');
    fprintf(ftxt,'*******************************\n\n');
    fprintf(ftxt,'%s',h5dumpTxt);
    fprintf(ftxt,'\n\n\n');
   
    
    fclose(ftxt);
end

