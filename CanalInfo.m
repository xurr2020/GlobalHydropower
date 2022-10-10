fileCanalSpatial = dir('F:\GreenHydropowerV5\CanalSpatial\*.mat');
fileDEM = dir('F:\GreenHydropowerV5\DEM\*.mat');
filePointInfo = dir('F:\GreenHydropowerV5\SelectPoint\*.mat');
fileBasicInfo = dir('F:\GreenHydropowerV5\BasicRiverInfo\*.mat');
fileR = dir('F:\GreenHydropowerV5\R\*.mat');
fileLandcover = dir('F:\GreenHydropowerV5\LandCover\*.mat');
cellSize = 1/1200;
fileDAM = dir('F:\GreenHydropowerV5\Dam\*.mat');

for i = 1:60
    
    CanalSpatialName = strcat(fileCanalSpatial(i).folder,'\',fileCanalSpatial(i).name);
    DEMname = strcat(fileDEM(i).folder,'\',fileDEM(i).name);
    PointInfoname = strcat(filePointInfo(i).folder,'\',filePointInfo(i).name);
    BasicInfoname = strcat(fileBasicInfo(i).folder,'\',fileBasicInfo(i).name);
    Rname = strcat(fileR(i).folder,'\',fileR(i).name);
    Landcoverename = strcat(fileLandcover(i).folder,'\',fileLandcover(i).name);
    DAMName = strcat(fileDAM(i).folder,'\',fileDAM(i).name);
    
    load(CanalSpatialName)
    load(DEMname)
    load(PointInfoname)
    load(BasicInfoname)
    load(Rname)
    load(Landcoverename)
    load(DAMName)
    
    [m,n] = size(landcover);
    
    for m1 = 1:m
        for n1 = 1:n
            if landcover(m1,n1) == 10 || landcover(m1,n1) == 20 || landcover(m1,n1) == 190
                landcover(m1,n1) = 1;
            else
                landcover(m1,n1) = 0;
            end
        end
    end
    
    
    PointNum = size(PointInfo,1);
    canalInfo = cell(PointNum,6);

    for j = 1:PointNum

        canalInfo{j,1} = PointInfo{j,1};
        canalInfo{j,2} = PointInfo{j,2};
        canalInfo{j,3} = PointInfo{j,3};
        
        if PointInfo{j,9} == 1
        
            COMID = PointInfo{j,1};

            row = round((R.LatitudeLimits(1,2) + R.CellExtentInLatitude/2 - canalInfo{j,3})/R.CellExtentInLatitude);
            column = round((canalInfo{j,2} - R.LongitudeLimits(1,1) + R.CellExtentInLongitude/2)/R.CellExtentInLatitude);
            dem = DEM(row,column);

            rowstart  = row-277;
            if rowstart<1
                rowstart = 1;
            end

            rowend = row+277;
            if rowend > size(DEM,1)
                rowend = size(DEM,1);
            end

            columnstart = column-277;
            if columnstart<1
                columnstart = 1;
            end

            columnend = column+277;
            if columnend > size(DEM,2)
                columnend = size(DEM,2);
            end

            riverCanalSmall = riverCanal(rowstart:rowend,columnstart:columnend);
            DEMsmall = DEM(rowstart:rowend,columnstart:columnend);
            landcoversmall = landcover(rowstart:rowend,columnstart:columnend);

            %连通性
            selectRiverID1 = unique(riverCanalSmall(riverCanalSmall>0));
            selectRiverID1(selectRiverID1==COMID)=[];
            selectRiverID = [COMID;selectRiverID1];
            selectRiverIDNumber = size(selectRiverID,1);
            ConnectionMatrix = zeros(selectRiverIDNumber,selectRiverIDNumber);

            for k = 1:selectRiverIDNumber
                riverid2 = mod(selectRiverID(k,1),1000000);
                ConnectionInfo = BasicInfo{riverid2,10};
                ConnectionInfoNum = size(ConnectionInfo,1);
                if ConnectionInfoNum>0
                    for L = 1:ConnectionInfoNum
                        connectLocation = find(selectRiverID==ConnectionInfo(L,1));
                        if size(connectLocation,1)>0
                            ConnectionMatrix(k,connectLocation) = 1;
                        end
                    end
                end
            end

            count = 0;
            for k = 1:selectRiverIDNumber
                [cost,route] = dijkstra(ConnectionMatrix,1,k);
                if isinf(cost) == 0
                    count = count+1;
                end
            end

            if count>0
                selectRiverIDConnect = zeros(count,1);
                selectRiverIDRoute = cell(count,1);
                count = 1;
                for k = 1:selectRiverIDNumber
                    [cost,route] = dijkstra(ConnectionMatrix,1,k);
                    if isinf(cost) == 0
                        selectRiverIDConnect(count,1) =  selectRiverID(k,1);
                        routeNum = size(route,2);
                        for L = 1:routeNum
                            route(1,L) = selectRiverID(route(1,L),1);
                        end
                        selectRiverIDRoute{count,1} = route;
                        count = count+1;
                    end
                end
            end

            [m,n] = size(riverCanalSmall);
            startLocation = zeros(0,7);
            RouteRiver = cell(0,3);
            count = 1;
            for k = 1:m
                for L = 1:n
                    if riverCanalSmall(k,L)>0
                        checkConnection = find(selectRiverIDConnect==riverCanalSmall(k,L));
                        if DEMsmall(k,L)>dem && size(checkConnection,1)>0

                            %检查管道是否经过农田和城市
                            check = 0;
                            distance = ((k-278)^2+(L-278)^2)^0.5;
                            sinRow = (k-278)/distance;
                            sinColumn = (L-278)/distance;
                            Gappoint = floor(distance);
                            PipeLocation = zeros(Gappoint,2);
                            countPipe = 1;
                            for M = 1:Gappoint
                                RowEatra = round(278+M*sinRow);
                                ColumnEatra = round(278+M*sinColumn);
                                PipeLocation(countPipe,1) = RowEatra+rowstart-1;
                                PipeLocation(countPipe,2) = ColumnEatra+columnstart-1;
                                check = check + landcoversmall(RowEatra,ColumnEatra);
                                countPipe = countPipe+1;
                            end

                            if check == 0

                                riverid1 = mod(riverCanalSmall(k,L),1000000);
                                Qd = BasicInfo{riverid1,9};

                                if Qd>0.2

                                    row1 = rowstart+k-1;
                                    column1 = columnstart+L-1;
                                    startLatitude = R.LatitudeLimits(1,2)+ R.CellExtentInLatitude/2 - row1*R.CellExtentInLatitude;
                                    startLongtitude = R.LongitudeLimits(1,1) - R.CellExtentInLatitude/2 + column1*R.CellExtentInLatitude;
                                    routeRiver = selectRiverIDRoute{checkConnection,1};
                                    RouteRiverNum = size(routeRiver,2);
                                    riveridPipe = mod(routeRiver,1000000);
                                    RouteRiverLocation = zeros(2000,2);
                                    RouteRiverLocationCount = 1;

                                    for N = 1:RouteRiverNum
                                        if BasicInfo{riveridPipe(1,N),7} == 1
                                            RouteRiverRowSingle = BasicInfo{riveridPipe(1,N),5};
                                            RouteRiverColumnSingle = BasicInfo{riveridPipe(1,N),6};
                                        else
                                            RouteRiverRowSingle = fliplr(BasicInfo{riveridPipe(1,N),5});
                                            RouteRiverColumnSingle = fliplr(BasicInfo{riveridPipe(1,N),6});
                                        end
                                        SingleNum = size(RouteRiverRowSingle,2);
                                        for N1 = 1:SingleNum
                                            RouteRiverLocation(RouteRiverLocationCount,1) = RouteRiverRowSingle(1,N1);
                                            RouteRiverLocation(RouteRiverLocationCount,2) = RouteRiverColumnSingle(1,N1);
                                            RouteRiverLocationCount = RouteRiverLocationCount+1;
                                        end
                                    end
                                    RouteRiverLocation(all(RouteRiverLocation==0,2),:) = [];

                                    RouteendMatrix = sum([abs(RouteRiverLocation(:,1)-row),abs(RouteRiverLocation(:,2)-column)],2);
                                    [~,RouteEnd] = min(RouteendMatrix);
                                    RouteStartMatrix = sum([abs(RouteRiverLocation(:,1)-row1),abs(RouteRiverLocation(:,2)-column1)],2);
                                    [~,RouteStart] = min(RouteStartMatrix);

                                    if RouteStart<RouteEnd
                                        RouteRiverLocation(RouteEnd+1:end,:) =[];
                                        RouteRiverLocation(1:RouteStart-1,:) =[];
                                        RouteRiver{count,2} = RouteRiverLocation;
                                        RouteRiver{count,1} = routeRiver;
                                        RouteRiver{count,3} = PipeLocation;
                                        startLocation(count,1) = riverCanalSmall(k,L);
                                        startLocation(count,2) = startLongtitude;
                                        startLocation(count,3) = startLatitude;
                                        startLocation(count,4) = DEMsmall(k,L);
                                        startLocation(count,5) = DEMsmall(k,L)-dem;
                                        startLocation(count,6) = m_lldist([canalInfo{j,2} startLongtitude],[canalInfo{j,3} startLatitude]);
                                        startLocation(count,7) = BasicInfo{riverid1,8};

                                        count = count+1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
            canalInfo{j,4} = startLocation;
            canalInfo{j,5} = RouteRiver;
        end
        strcat(num2str(i),'-',num2str(j),'-',num2str(PointNum))
    end
    
    DAM = double(DAM);
    PiointNum = size(canalInfo,1);
    for j = 1:PiointNum
        a = canalInfo{j,5};
        num = size(a,1);
        if num>0
            damcheck  = zeros(num,1,'logical');
            for k = 1:num
                c = a{k,2};
                d = a{k,3};
                num2 = size(c,1);
                num3 = size(d,1);
                check = 0;
                for L = 1:num2
                    check = check+DAM(c(L,1),c(L,2));
                end
                for L = 1:num3
                    check = check+DAM(d(L,1),d(L,2));
                end
                if check>0
                    damcheck(k,1) = 1;
                end
            end
            canalInfo{j,6} = damcheck;
        end
    end
    
    filename = strcat('canalInfo',fileR(i).name(2:3),'.mat');
    save(filename,'canalInfo')
    clear canalInfo
end

clear

