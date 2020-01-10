

function copy_tcga_slides(Datasetpath,start_path)

%topLevelFolder=uigetdir(start_path);
topLevelFolder=start_path;
if topLevelFolder==0
    return;
end

% get list of all subfolders
allSubFolders=genpath(topLevelFolder);
remain=allSubFolders;
listOfFolderNames={};
while true
    [singleSubFolder,remain]=strtok(remain,';');
    if isempty(singleSubFolder)
        break;
    end
    listOfFolderNames=[listOfFolderNames singleSubFolder];
end
numberOfFolders=length(listOfFolderNames);

id=1;
patientNum=0;
unusedNum=0;
for k=1:numberOfFolders
    thisFolder=listOfFolderNames{k};
    fprintf('Processing folder %s\n', thisFolder);
    
    % get filenames of all .svs files
    filePattern=sprintf('%s/*.svs',thisFolder);
    baseFileNames=dir(filePattern);
    numberOfFiles=length(baseFileNames);
    
    if numberOfFiles==1
        fprintf('the %d subfile with .svs\n',id);
        id=id+1;
        
        fullFileName=fullfile(thisFolder,baseFileNames.name);
        filename=baseFileNames.name;
        patientID=filename(1:23);
        
        copyfile(fullFileName,strcat(Datasetpath,baseFileNames.name));
        patientNum=patientNum+1;
        
    elseif  numberOfFiles>1
        fprintf('the %d subfile with .svs\n',id);
        id=id+1;
        for f=1:numberOfFiles
            fullFileName=fullfile(thisFolder,baseFileNames(f).name);
            filename=baseFileNames(f).name;
            patientID=filename(1:12);
            
            if f==1
                copyfile(fullFileName,strcat(Datasetpath,baseFileNames(f).name));
                patientNum=patientNum+1;
            else
                
                copyfile(fullFileName,strcat(Unusedpath,baseFileNames(f).name));
                unusedNum=unusedNum+1;
            end
            
        end
    else
        disp('no svs file under this folder!!!');
    end
end
