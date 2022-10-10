fileDamLOCE = dir('F:\GreenHydropowerV5\DamLCOE\D*.mat');

for i = 1:60
    
    DamLOCEname = strcat(fileDamLOCE(i).folder,'\',fileDamLOCE(i).name);
    load(DamLOCEname)
    
    damNum = size(damLCOE,1);
    dambestNodam = cell(damNum,4);
    
    for j = 1:damNum
        
        dambestNodam{j,1} = damLCOE{j,1};
        dambestNodam{j,2} = damLCOE{j,2};
        dambestNodam{j,3} = damLCOE{j,3};

        canalcheck = damLCOE{j,4};
        LOCENum = size(canalcheck,1);
        if LOCENum>0
            loce = canalcheck(:,15);
            LOCEMAX = max(loce);
            loce(loce==0) = LOCEMAX+1;
            [minValue,minIndex] = min(loce);
            if minValue<0.5
                dambestNodam{j,4} = [minValue,minIndex];
            end
        end
        
    end

    filenamedam = strcat('dambestNodam',fileDamLOCE(i).name(8:9),'.mat');
    save(filenamedam,'dambestNodam')
    

    dambestDam = cell(damNum,4);
    for j = 1:damNum
        
        dambestDam{j,1} = damLCOE{j,1};
        dambestDam{j,2} = damLCOE{j,2};
        dambestDam{j,3} = damLCOE{j,3};

        canalcheck = damLCOE{j,4};
        LOCENum = size(canalcheck,1);
        if LOCENum>0
            loce = canalcheck(:,15);
            LOCEMAX = max(loce);
            for k = 1:LOCENum
                if loce(k,1) == 0 || canalcheck(k,18)>0
                    loce(k,1) = LOCEMAX+1;
                end
            end
            [minValue,minIndex] = min(loce);
            if minValue<0.5
                dambestDam{j,4} = [minValue,minIndex];
            end
        end
        
    end

    filenamedam = strcat('dambestDam',fileDamLOCE(i).name(8:9),'.mat');
    save(filenamedam,'dambestDam')
    
end
clear
