map = zeros(R.RasterSize(1,1),R.RasterSize(1,2));
LCOEnew = [LCOENodam(:,1);LCOENodam(:,2)];
[LCOEsort,LCOEsortINDEX] = sort(LCOEnew);
actualNodamTech = cell(1,12);
countTech = 1;
actualNodamEcon = cell(1,12);
countEcon = 1;
for j = 1:damNum*2
    index = LCOEsortINDEX(j,1);
    loce = LCOEsort(j,1);
    if loce>1
        break
    end
    if index<damNum+0.5
        daminfoIndex = collectionNodam{index,1};
        damInundationIndex = collectionNodam{index,5}(1,2);
        damlocation = damInundation{daminfoIndex,1}{damInundationIndex,1};
        damlocationNum = size(damlocation,1);
        daminundationlocation = damInundation{daminfoIndex,2}{damInundationIndex,1};
        daminundationlocationNum = size(daminundationlocation,1);
        check = 0;
        for k = 1:damlocationNum
            check = check+map(damlocation(k,1),damlocation(k,2));
        end
        for k = 1:daminundationlocationNum
            check = check+map(daminundationlocation(k,1),daminundationlocation(k,2));
        end
        if check == 0
            for k = 1:damlocationNum
                map(damlocation(k,1),damlocation(k,2)) = 1;
            end
            for k = 1:daminundationlocationNum
                map(daminundationlocation(k,1),daminundationlocation(k,2)) = 1;
            end
            damid = PointInfo{daminfoIndex,1};
            riverid = mod(damid,1000000);
            actualNodamTech{countTech,1} = daminfoIndex;
            actualNodamTech{countTech,2} = damInundationIndex;
            actualNodamTech{countTech,3} = PointInfo{daminfoIndex,1};
            actualNodamTech{countTech,4} = PointInfo{daminfoIndex,2};
            actualNodamTech{countTech,5} = PointInfo{daminfoIndex,3};
            actualNodamTech{countTech,6} = PointInfo{daminfoIndex,4};
            actualNodamTech{countTech,7} = BasicInfo{riverid,8};
            actualNodamTech{countTech,8} = PointInfo{daminfoIndex,6};
            actualNodamTech{countTech,9} = PointInfo{daminfoIndex,7};
            actualNodamTech{countTech,10} = PointInfo{daminfoIndex,8};
            actualNodamTech{countTech,11} = 1;
            damresult = cell(5,1);
            damresult{1,1} = damLCOE{daminfoIndex,4}(damInundationIndex,16);
            damresult{2,1} = damlocation;
            damresult{3,1} = daminundationlocation;
            damresult{4,1} = DamCost{daminfoIndex,1}(damInundationIndex,:);
            damresult{5,1} = damLCOE{daminfoIndex,4}(damInundationIndex,:);
            actualNodamTech{countTech,12} = damresult;
            countTech = countTech+1;
            if loce<0.1
                actualNodamEcon{countEcon,1} = daminfoIndex;
                actualNodamEcon{countEcon,2} = damInundationIndex;
                actualNodamEcon{countEcon,3} = PointInfo{daminfoIndex,1};
                actualNodamEcon{countEcon,4} = PointInfo{daminfoIndex,2};
                actualNodamEcon{countEcon,5} = PointInfo{daminfoIndex,3};
                actualNodamEcon{countEcon,6} = PointInfo{daminfoIndex,4};
                actualNodamEcon{countEcon,7} = BasicInfo{riverid,8};
                actualNodamEcon{countEcon,8} = PointInfo{daminfoIndex,6};
                actualNodamEcon{countEcon,9} = PointInfo{daminfoIndex,7};
                actualNodamEcon{countEcon,10} = PointInfo{daminfoIndex,8};
                actualNodamEcon{countEcon,11} = 1;
                damresult = cell(5,1);
                damresult{1,1} = damLCOE{daminfoIndex,4}(damInundationIndex,16);
                damresult{2,1} = damlocation;
                damresult{3,1} = daminundationlocation;
                damresult{4,1} = DamCost{daminfoIndex,1}(damInundationIndex,:);
                damresult{5,1} = damLCOE{daminfoIndex,4}(damInundationIndex,:);
                actualNodamEcon{countEcon,12} = damresult;
                countEcon = countEcon+1;
            end
        end
    else
        index = index-damNum;
        daminfoIndex = collectionNodam{index,1};
        CannalStartIndex = collectionNodam{index,6}(1,2);
        RouteRiverLocation = canalInfo{daminfoIndex,5}{CannalStartIndex,2};
        PipeLocation = canalInfo{daminfoIndex,5}{CannalStartIndex,3};
        canalTotalLocation = [RouteRiverLocation;PipeLocation];
        canalTotalLocationNum = size(canalTotalLocation,1);
        checkCanal = 0;
        for N2 = 1:canalTotalLocationNum
            checkCanal = checkCanal+map(canalTotalLocation(N2,1),canalTotalLocation(N2,2));
        end
        if checkCanal == 0
            for N2 = 1:canalTotalLocationNum
                map(canalTotalLocation(N2,1),canalTotalLocation(N2,2)) = 1;
            end
            damid = PointInfo{daminfoIndex,1};
            riverid = mod(damid,1000000);
            actualNodamTech{countTech,1} = daminfoIndex;
            actualNodamTech{countTech,2} = CannalStartIndex;
            actualNodamTech{countTech,3} = PointInfo{daminfoIndex,1};
            actualNodamTech{countTech,4} = PointInfo{daminfoIndex,2};
            actualNodamTech{countTech,5} = PointInfo{daminfoIndex,3};
            actualNodamTech{countTech,6} = PointInfo{daminfoIndex,4};
            actualNodamTech{countTech,7} = BasicInfo{riverid,8};
            actualNodamTech{countTech,8} = PointInfo{daminfoIndex,6};
            actualNodamTech{countTech,9} = PointInfo{daminfoIndex,7};
            actualNodamTech{countTech,10} = PointInfo{daminfoIndex,8};
            actualNodamTech{countTech,11} = 2;
            canalresult = cell(3,1);
            canalresult{1,1} = canalInfo{daminfoIndex,4}(CannalStartIndex,:);
            canalresult{2,1} = canalLCOE{daminfoIndex,9}(CannalStartIndex,:);
            canalresult{3,1} = canalInfo{daminfoIndex,5}(CannalStartIndex,:);
            actualNodamTech{countTech,12} = canalresult;
            countTech = countTech+1;
            if loce<0.1
                damid = PointInfo{daminfoIndex,1};
                riverid = mod(damid,1000000);
                actualNodamEcon{countEcon,1} = daminfoIndex;
                actualNodamEcon{countEcon,2} = CannalStartIndex;
                actualNodamEcon{countEcon,3} = PointInfo{daminfoIndex,1};
                actualNodamEcon{countEcon,4} = PointInfo{daminfoIndex,2};
                actualNodamEcon{countEcon,5} = PointInfo{daminfoIndex,3};
                actualNodamEcon{countEcon,6} = PointInfo{daminfoIndex,4};
                actualNodamEcon{countEcon,7} = BasicInfo{riverid,8};
                actualNodamEcon{countEcon,8} = PointInfo{daminfoIndex,6};
                actualNodamEcon{countEcon,9} = PointInfo{daminfoIndex,7};
                actualNodamEcon{countEcon,10} = PointInfo{daminfoIndex,8};
                actualNodamEcon{countEcon,11} = 2;
                canalresult = cell(3,1);
                canalresult{1,1} = canalInfo{daminfoIndex,4}(CannalStartIndex,:);
                canalresult{2,1} = canalLCOE{daminfoIndex,9}(CannalStartIndex,:);
                canalresult{3,1} = canalInfo{daminfoIndex,5}(CannalStartIndex,:);
                actualNodamEcon{countEcon,12} = canalresult;
                countEcon = countEcon+1;
            end
        end
    end
end
damNum = size(collectionDam,1);
map = double(DAM);
LCOEnew = [LCOEDam(:,1);LCOEDam(:,2)];
[LCOEsort,LCOEsortINDEX] = sort(LCOEnew);
actualDamTech = cell(1,12);
countTech = 1;
actualDamEcon = cell(1,12);
countEcon = 1;
for j = 1:damNum*2
    index = LCOEsortINDEX(j,1);
    loce = LCOEsort(j,1);
    if loce>1
        break
    end
    if index<damNum+0.5
        daminfoIndex = collectionDam{index,1};
        damInundationIndex = collectionDam{index,5}(1,2);
        damlocation = damInundation{daminfoIndex,1}{damInundationIndex,1};
        damlocationNum = size(damlocation,1);
        daminundationlocation = damInundation{daminfoIndex,2}{damInundationIndex,1};
        daminundationlocationNum = size(daminundationlocation,1);
        check = 0;
        for k = 1:damlocationNum
            check = check+map(damlocation(k,1),damlocation(k,2));
        end
        for k = 1:daminundationlocationNum
            check = check+map(daminundationlocation(k,1),daminundationlocation(k,2));
        end
        if check == 0
            for k = 1:damlocationNum
                map(damlocation(k,1),damlocation(k,2)) = 1;
            end
            for k = 1:daminundationlocationNum
                map(daminundationlocation(k,1),daminundationlocation(k,2)) = 1;
            end
            damid = PointInfo{daminfoIndex,1};
            riverid = mod(damid,1000000);
            actualDamTech{countTech,1} = daminfoIndex;
            actualDamTech{countTech,2} = damInundationIndex;
            actualDamTech{countTech,3} = PointInfo{daminfoIndex,1};
            actualDamTech{countTech,4} = PointInfo{daminfoIndex,2};
            actualDamTech{countTech,5} = PointInfo{daminfoIndex,3};
            actualDamTech{countTech,6} = PointInfo{daminfoIndex,4};
            actualDamTech{countTech,7} = BasicInfo{riverid,8};
            actualDamTech{countTech,8} = PointInfo{daminfoIndex,6};
            actualDamTech{countTech,9} = PointInfo{daminfoIndex,7};
            actualDamTech{countTech,10} = PointInfo{daminfoIndex,8};
            actualDamTech{countTech,11} = 1;
            damresult = cell(5,1);
            damresult{1,1} = damLCOE{daminfoIndex,4}(damInundationIndex,16);
            damresult{2,1} = damlocation;
            damresult{3,1} = daminundationlocation;
            damresult{4,1} = DamCost{daminfoIndex,1}(damInundationIndex,:);
            damresult{5,1} = damLCOE{daminfoIndex,4}(damInundationIndex,:);
            actualDamTech{countTech,12} = damresult;
            countTech = countTech+1;
            if loce<0.1
                actualDamEcon{countEcon,1} = daminfoIndex;
                actualDamEcon{countEcon,2} = damInundationIndex;
                actualDamEcon{countEcon,3} = PointInfo{daminfoIndex,1};
                actualDamEcon{countEcon,4} = PointInfo{daminfoIndex,2};
                actualDamEcon{countEcon,5} = PointInfo{daminfoIndex,3};
                actualDamEcon{countEcon,6} = PointInfo{daminfoIndex,4};
                actualDamEcon{countEcon,7} = BasicInfo{riverid,8};
                actualDamEcon{countEcon,8} = PointInfo{daminfoIndex,6};
                actualDamEcon{countEcon,9} = PointInfo{daminfoIndex,7};
                actualDamEcon{countEcon,10} = PointInfo{daminfoIndex,8};
                actualDamEcon{countEcon,11} = 1;
                damresult = cell(5,1);
                damresult{1,1} = damLCOE{daminfoIndex,4}(damInundationIndex,16);
                damresult{2,1} = damlocation;
                damresult{3,1} = daminundationlocation;
                damresult{4,1} = DamCost{daminfoIndex,1}(damInundationIndex,:);
                damresult{5,1} = damLCOE{daminfoIndex,4}(damInundationIndex,:);
                actualDamEcon{countEcon,12} = damresult;
                countEcon = countEcon+1;
            end
        end
    else
        index = index-damNum;
        daminfoIndex = collectionDam{index,1};
        CannalStartIndex = collectionDam{index,6}(1,2);
        RouteRiverLocation = canalInfo{daminfoIndex,5}{CannalStartIndex,2};
        PipeLocation = canalInfo{daminfoIndex,5}{CannalStartIndex,3};
        canalTotalLocation = [RouteRiverLocation;PipeLocation];
        canalTotalLocationNum = size(canalTotalLocation,1);
        checkCanal = 0;
        for N2 = 1:canalTotalLocationNum
            checkCanal = checkCanal+map(canalTotalLocation(N2,1),canalTotalLocation(N2,2));
        end
        if checkCanal == 0
            for N2 = 1:canalTotalLocationNum
                map(canalTotalLocation(N2,1),canalTotalLocation(N2,2)) = 1;
            end
            damid = PointInfo{daminfoIndex,1};
            riverid = mod(damid,1000000);
            actualDamTech{countTech,1} = daminfoIndex;
            actualDamTech{countTech,2} = CannalStartIndex;
            actualDamTech{countTech,3} = PointInfo{daminfoIndex,1};
            actualDamTech{countTech,4} = PointInfo{daminfoIndex,2};
            actualDamTech{countTech,5} = PointInfo{daminfoIndex,3};
            actualDamTech{countTech,6} = PointInfo{daminfoIndex,4};
            actualDamTech{countTech,7} = BasicInfo{riverid,8};
            actualDamTech{countTech,8} = PointInfo{daminfoIndex,6};
            actualDamTech{countTech,9} = PointInfo{daminfoIndex,7};
            actualDamTech{countTech,10} = PointInfo{daminfoIndex,8};
            actualDamTech{countTech,11} = 2;
            canalresult = cell(3,1);
            canalresult{1,1} = canalInfo{daminfoIndex,4}(CannalStartIndex,:);
            canalresult{2,1} = canalLCOE{daminfoIndex,9}(CannalStartIndex,:);
            canalresult{3,1} = canalInfo{daminfoIndex,5}(CannalStartIndex,:);
            actualDamTech{countTech,12} = canalresult;
            countTech = countTech+1;
            if loce<0.1
                damid = PointInfo{daminfoIndex,1};
                riverid = mod(damid,1000000);
                actualDamEcon{countEcon,1} = daminfoIndex;
                actualDamEcon{countEcon,2} = CannalStartIndex;
                actualDamEcon{countEcon,3} = PointInfo{daminfoIndex,1};
                actualDamEcon{countEcon,4} = PointInfo{daminfoIndex,2};
                actualDamEcon{countEcon,5} = PointInfo{daminfoIndex,3};
                actualDamEcon{countEcon,6} = PointInfo{daminfoIndex,4};
                actualDamEcon{countEcon,7} = BasicInfo{riverid,8};
                actualDamEcon{countEcon,8} = PointInfo{daminfoIndex,6};
                actualDamEcon{countEcon,9} = PointInfo{daminfoIndex,7};
                actualDamEcon{countEcon,10} = PointInfo{daminfoIndex,8};
                actualDamEcon{countEcon,11} = 2;
                canalresult = cell(3,1);
                canalresult{1,1} = canalInfo{daminfoIndex,4}(CannalStartIndex,:);
                canalresult{2,1} = canalLCOE{daminfoIndex,9}(CannalStartIndex,:);
                canalresult{3,1} = canalInfo{daminfoIndex,5}(CannalStartIndex,:);
                actualDamEcon{countEcon,12} = canalresult;
                countEcon = countEcon+1;
            end
        end
    end
end

