fileCanalLCOE = dir('F:\GreenHydropowerV5\CanalLCOE\C*.mat');

for i = 1:60
    
    CanalLCOEname = strcat(fileCanalLCOE(i).folder,'\',fileCanalLCOE(i).name);

    load(CanalLCOEname)

    canalNum = size(canalLCOE,1);
    canalbestNodam = cell(canalNum,4);
    
    for j = 1:canalNum
        canalbestNodam{j,1} = canalLCOE{j,1};
        canalbestNodam{j,2} = canalLCOE{j,2};
        canalbestNodam{j,3} = canalLCOE{j,3};

        canalcheck = canalLCOE{j,9};
        LOCENum = size(canalcheck,1);
        if LOCENum>0
            loce = canalcheck(:,15);
            LOCEMAX = max(loce);
            loce(loce==0) = LOCEMAX+1;
            [minValue,minIndex] = min(loce);
            if minValue<0.5
                canalbestNodam{j,4} = [minValue,minIndex];
            end
        end
        
    end
    
    filenameNodam = strcat('canalbestNodam',fileCanalLCOE(i).name(10:11),'.mat');
    save(filenameNodam,'canalbestNodam')
    
    
    canalbestDam = cell(canalNum,4);
    
    for j = 1:canalNum
        canalbestDam{j,1} = canalLCOE{j,1};
        canalbestDam{j,2} = canalLCOE{j,2};
        canalbestDam{j,3} = canalLCOE{j,3};

        canalcheck = canalLCOE{j,9};
        LOCENum = size(canalcheck,1);
        if LOCENum>0
            loce = canalcheck(:,15);
            LOCEMAX = max(loce);
            for k = 1:LOCENum
                if loce(k,1) == 0 || canalcheck(k,17)>0
                    loce(k,1) = LOCEMAX+1;
                end
            end
            loce(loce==0) = LOCEMAX+1;
            [minValue,minIndex] = min(loce);
            if minValue<0.5
                canalbestDam{j,4} = [minValue,minIndex];
            end
        end
        
    end
    
    filenameNodam = strcat('canalbestDam',fileCanalLCOE(i).name(10:11),'.mat');
    save(filenameNodam,'canalbestDam')
    
end
clear
