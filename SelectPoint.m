for j = 1:riverNum
    longtitude = BasicInfo{j,3};
    latitude = BasicInfo{j,4};
    if BasicInfo{j,7} == 2
        longtitude = fliplr(longtitude);
        latitude = fliplr(latitude);
    end
    pointNum = size(longtitude,2);
    numdam1 = ceil((pointNum-10)/50);
    if numdam1>0
        for k = 1:numdam1
            damlongtitude = longtitude(1,10+(k-1)*50);
            damlatitude = latitude(1,10+(k-1)*50);
            row = round((R.LatitudeLimits(1,2)+R.CellExtentInLatitude/2-damlatitude)/R.CellExtentInLatitude);
            column = round((damlongtitude-R.LongitudeLimits(1,1)+R.CellExtentInLatitude/2)/R.CellExtentInLatitude);
            if Country(row,column) ~= -9999 && DEM(row,column) ~= -9999 && GLWD(row,column) == 0 && Heritage(row,column) == 0 && WDPA(row,column) == 0 && BasicInfo{j,8}>0.2 && BasicInfo{j,9}>0.2
                count = count+1;
            end
        end
    end
end
PointInfo = cell(count,9);
count = 1;
for j = 1:riverNum
    longtitude = BasicInfo{j,3};
    latitude = BasicInfo{j,4};
    if BasicInfo{j,7} == 2
        longtitude = fliplr(longtitude);
        latitude = fliplr(latitude);
    end
    pointNum = size(longtitude,2);
    numdam1 = ceil((pointNum-10)/50);
    if numdam1>0
        for k = 1:numdam1
            damlongtitude = longtitude(1,10+(k-1)*50);
            damlatitude = latitude(1,10+(k-1)*50);
            row = round((R.LatitudeLimits(1,2)+R.CellExtentInLatitude/2-damlatitude)/R.CellExtentInLatitude);
            column = round((damlongtitude-R.LongitudeLimits(1,1)+R.CellExtentInLatitude/2)/R.CellExtentInLatitude);
            if Country(row,column) ~= -9999 && DEM(row,column) ~= -9999 && GLWD(row,column) == 0 && Heritage(row,column) == 0 && WDPA(row,column) == 0 && BasicInfo{j,8}>0.2 && BasicInfo{j,9}>0.2
                PointInfo{count,1} = BasicInfo{j,1};
                PointInfo{count,2} = damlongtitude;
                PointInfo{count,3} = damlatitude;
                PointInfo{count,4} = DEM(row,column);

                PointInfo{count,7} = Hazard(row,column);
                PointInfo{count,8} = Softrock(row,column);

                locUp(1,1) = damlongtitude;
                locUp(1,2) = damlatitude;
                for L1 = (9+(k-1)*50):-1:1
                    if longtitude(1,L1)<damlongtitude
                        locUp(1,1) = damlongtitude-1/1200;
                        break
                    elseif longtitude(1,L1)>damlongtitude
                        locUp(1,1) = damlongtitude+1/1200;
                        break
                    end
                end
                if locUp(1,1) == damlongtitude
                    for L1 = (11+(k-1)*50):pointNum
                        if longtitude(1,L1)<damlongtitude
                            locUp(1,1) = damlongtitude+1/1200;
                            break
                        elseif longtitude(1,L1)>damlongtitude
                            locUp(1,1) = damlongtitude-1/1200;
                            break
                        end
                    end
                end
                for L1 = (9+(k-1)*50):-1:1
                    if latitude(1,L1)<damlatitude
                        locUp(1,2) = damlatitude-1/1200;
                        break
                    elseif longtitude(1,L1)>damlatitude
                        locUp(1,2) = damlatitude+1/1200;
                        break
                    end
                end
                if locUp(1,1) == damlatitude
                    for L1 = (11+(k-1)*50):pointNum
                        if latitude(1,L1)<damlatitude
                            locUp(1,2) = damlatitude+1/1200;
                            break
                        elseif latitude(1,L1)>damlatitude
                            locUp(1,2) = damlatitude-1/1200;
                            break
                        end
                    end
                end
                PointInfo{count,5} = locUp;
                if BasicInfo{j,8}<1000
                    riverCanal(row,column) = BasicInfo{j,1};
                    PointInfo{count,9} = 1;
                else
                    PointInfo{count,9} = 0;
                end
                distance1 = zeros(indexNum1,1);
                for L = 1:indexNum1
                    distance1(L,1) = m_lldist([damlongtitude powerlineIndex1(L,1)],[damlatitude powerlineIndex1(L,2)]);
                end
                [~,index1] = min(distance1);
                powerlineIndex2 = powerlineIndex2Total{index1,1};
                indexNum2 = size(powerlineIndex2,1);
                distance2 = zeros(indexNum2,1);
                for L = 1:indexNum2
                    distance2(L,1) = m_lldist([damlongtitude powerlineIndex2(L,1)],[damlatitude powerlineIndex2(L,2)]);
                end
                [~,index2] = min(distance2);
                powerlineIndex3 = powerlineIndex3Total{index1,index2};
                indexNum3 = size(powerlineIndex3,1);
                distance3 = zeros(indexNum3,1);
                for L = 1:indexNum3
                    distance3(L,1) = m_lldist([damlongtitude powerlineIndex3(L,1)],[damlatitude powerlineIndex3(L,2)]);
                end
                PointInfo{count,6} = min(distance3);
                count = count+1;
            end
        end
    end
end