fileInundation = dir('F:\GreenHydropowerV5\Inundation\D*.mat');
fileLandcover = dir('F:\GreenHydropowerV5\LandCover\*.mat');
fileGDP = dir('F:\GreenHydropowerV5\GDP\*.mat');
filePopulation = dir('F:\GreenHydropowerV5\Population\*.mat');
fileDEM = dir('F:\GreenHydropowerV5\DEM\*.mat');
fileWDPA = dir('F:\GreenHydropowerV5\WDPA\*.mat');
fileSelectPoint = dir('F:\GreenHydropowerV5\SelectPoint\*.mat');
fileDischarge = dir('F:\GreenHydropowerV5\Discharge\*.mat');

load('F:\GreenHydropowerV5\DamLCOE\inflation.mat')
Efficiency = 0.7;
LifetimeYear = 40;

longGrid = m_lldist([0 0],[0 1/1200])*1000;

for i = 1:60
    
    Inundationname = strcat(fileInundation(i).folder,'\',fileInundation(i).name);
    Landcoverename = strcat(fileLandcover(i).folder,'\',fileLandcover(i).name);
    GDPname = strcat(fileGDP(i).folder,'\',fileGDP(i).name);
    Populationname = strcat(filePopulation(i).folder,'\',filePopulation(i).name);
    DEMname = strcat(fileDEM(i).folder,'\',fileDEM(i).name);
    WDPAName = strcat(fileWDPA(i).folder,'\',fileWDPA(i).name);
    PointInfoName = strcat(fileSelectPoint(i).folder,'\',fileSelectPoint(i).name);
    DischargeName = strcat(fileDischarge(i).folder,'\',fileDischarge(i).name);
    
    load(Inundationname)
    load(Landcoverename)
    load(GDPname)
    load(Populationname)
    load(DEMname)
    load(WDPAName)
    load(PointInfoName)
    load(DischargeName)
    
    DamNum = size(PointInfo,1);
    DamCost = cell(DamNum,1);
    
    for j = 1:DamNum
        
        daminformation = damInundation{j,1};
        damdesignNum = size(daminformation,1);
        widthGrid = m_lldist([PointInfo{j,2} PointInfo{j,2}+1/1200],[PointInfo{j,3} PointInfo{j,3}])*1000;
        AreaGrid = widthGrid*longGrid;

        if damdesignNum>0
            damcostsingle = zeros(damdesignNum,11);
            inuinformation = damInundation{j,2};
            for k = 1:damdesignNum
                
                damBody = daminformation{k,1};
                damBodyGridNum = size(damBody,1);
                damDEM = DEM(damBody(1,1),damBody(1,2));
                damcostsingle(k,3) = k*10;
                if damBody(1,1) == damBody(2,1)
                    damcostsingle(k,1) = 1;
                    damcostsingle(k,2) = widthGrid*damBodyGridNum;
                else
                    damcostsingle(k,1) = 2;
                    damcostsingle(k,2) = longGrid*damBodyGridNum;
                end
                
                damInundation1 = inuinformation{k,1};
                damInundationGridNum = size(damInundation1,1);
                damcostsingle(k,5) = damInundationGridNum*AreaGrid;
                damVolumn = 0;
                for L = 1:damInundationGridNum
                    gridVol = damDEM+damcostsingle(k,3)-DEM(damInundation1(L,1),damInundation1(L,2));
                    if gridVol<0
                        gridVol=0;
                    end
                    damVolumn = damVolumn+gridVol*AreaGrid;
                end
                damcostsingle(k,4) = damVolumn;
                
                damGDP = 0;
                damPopulation = 0;
                damForest = 0;
                damCrop = 0;
                damGrass = 0;
                damWDPA = 0;
                
                InuNew = [damBody;damInundation1];
                InuNewNum = size(InuNew,1);
                for L = 1:InuNewNum
                    damGDP = damGDP + GDP(InuNew(L,1),InuNew(L,2));
                    damPopulation = damPopulation + population(InuNew(L,1),InuNew(L,2));
                    damWDPA = damWDPA + WDPA(InuNew(L,1),InuNew(L,2));
                    
                    landcode = landcover(InuNew(L,1),InuNew(L,2));
                    if landcode == 10 || landcode == 20
                        damCrop = damCrop+AreaGrid;
                    elseif landcode == 30
                        damCrop = damCrop+AreaGrid*0.75;
                        damForest = damForest+AreaGrid*0.25;
                    elseif landcode == 40
                        damCrop = damCrop+AreaGrid*0.25;
                        damForest = damForest+AreaGrid*0.75;
                    elseif landcode == 12 || landcode == 50 || landcode == 60 || landcode == 61 || landcode == 62 || landcode == 70 || landcode == 71 || landcode == 72 || landcode == 80 || landcode == 81 || landcode == 82 || landcode == 90
                        damForest = damForest+AreaGrid;
                    elseif landcode == 100
                        damForest = damForest+AreaGrid*0.75;
                        damGrass = damGrass+AreaGrid*0.25;
                    elseif landcode == 110    
                        damForest = damForest+AreaGrid*0.25;
                        damGrass = damGrass+AreaGrid*0.75;
                    elseif landcode == 130    
                        damGrass = damGrass+AreaGrid;
                    end

                    damcostsingle(k,6) = damGDP;
                    damcostsingle(k,7) = damPopulation;
                    
                    if damWDPA>0
                        damcostsingle(k,11) = 1;
                    else
                        damcostsingle(k,11) = 0;
                    end
                    
                    damcostsingle(k,8) = damForest;
                    damcostsingle(k,9) = damCrop;
                    damcostsingle(k,10) = damGrass;
                end
            end
            DamCost{j,1} = damcostsingle;
        end
    end
    
    CostNum = size(DamCost,1);
    DamCostDam = cell(CostNum,1);
    for j = 1:CostNum
        a = DamCost{j,1};
        b = double(damInundation{j,3});
        Num = size(a);
        if Num>0
            for L = 1:Num
                a(L,12) = b(L,1);
            end
            DamCostDam{j,1} = a;
        end
    end
    clear DamCost
    DamCost = DamCostDam;
    clear DamCostDam

    filename = strcat('DamCost',fileGDP(i).name(4:5),'.mat');
    save(filename,'DamCost')
    

    
    damNum = size(PointInfo,1);
    damLCOE = cell(damNum,4);

    for j = 1:damNum
        
        COMID = PointInfo{j,1};
        riverid = mod(COMID,1000000);
        Hazard = PointInfo{j,7};
        Softrock = PointInfo{j,8};
        powerDistance = PointInfo{j,6};
        
        damLCOE{j,1} = PointInfo{j,1};
        damLCOE{j,2} = PointInfo{j,2};
        damLCOE{j,3} = PointInfo{j,3};
        
        damcostinfo = DamCost{j,1};
        damdesignNum = size(damcostinfo,1);
        if damdesignNum>0
            Q30 = prctile(Discharge(riverid,:),30);
            Q1 = Discharge(riverid,:) - Q30;
            Q1(Q1<=0)=[];
            Qd = prctile(Q1,97);
            Q1(Q1>Qd) = Qd;
            LCOEcaculation = zeros(damdesignNum,17);
            for k = 1:damdesignNum                          
                if damcostinfo(k,7)<50000 && damcostinfo(k,11) == 0
                    LCOEcaculation(k,16) = Qd;
                        
                    %涡轮机钱
                    Pt = Qd*damcostinfo(k,3)*9810*Efficiency*10^(-6);
                    P1 = 1.943*Pt^0.7634*10^6*prod(inflation(1:15,2));
                    LCOEcaculation(k,1) = P1;

                    %水电站钱
                    if Qd<50
                        P2 = (0.4948*Qd+1.7)*10^6*0.11*prod(inflation(1:10,2));
                    elseif Qd>=50 && Qd<500
                        P2 = (-0.0006*Qd^2+0.67*Qd-6.95)*10^6*0.11*prod(inflation(1:10,2));
                    else
                        P2 = 178.05*10^6*0.11*prod(inflation(1:10,2));
                    end
                    LCOEcaculation(k,2) = P2;

                    %电工设备钱
                    P3 = 3.9142*Pt^0.6622*10^6*0.11*prod(inflation(1:10,2));
                    LCOEcaculation(k,3) = P3;

                    %大坝钱
                    P4 = 0.72*damcostinfo(k,3)^1.8*damcostinfo(k,2)*10^3*0.11*prod(inflation(1:10,2));
                    LCOEcaculation(k,4) = P4;

                    %杂项钱
                    P5 = (-38.795*(log10(Qd))+309.89)*Pt*1000*0.11*prod(inflation(1:10,2));
                    LCOEcaculation(k,5) = P5;

                    %鱼道钱
                    P6 = 1.3*exp(1)^6*(Pt*1000)^0.56*prod(inflation(1:18,2));
                    LCOEcaculation(k,6) = P6;

                    %搭建电线钱
                    P7 = powerDistance*2*10^6*0.11*prod(inflation(1:10,2));
                    LCOEcaculation(k,7) = P7;

                    %抗震成本
                    if Hazard>0.7
                        P8 = 0.05*(P1+P2+P3+P4+P5+P6+P7);
                    else
                        P8 = 0;
                    end
                    LCOEcaculation(k,8) = P8;

                    %土质松软成本
                    if Softrock == 1
                        P9 = 0.05*(P1+P2+P3+P4+P5+P6+P7);
                    else
                        P9 = 0;
                    end
                    LCOEcaculation(k,9) = P9;

                    %拥有者成本钱
                    P10 = 0.2*(P1+P2+P3+P4+P5+P6+P7+P8+P9);
                    LCOEcaculation(k,10) = P10;

                    %运行成本钱
                    P11 = 0.02*(P1+P2+P3+P4+P5+P6+P7+P8+P9+P10);
                    LCOEcaculation(k,11) = P11;

                    %迁移成本钱和人口
                    P12 = 5*damcostinfo(k,6)*prod(inflation(1:10,2));
                    LCOEcaculation(k,12) = P12;
                    LCOEcaculation(k,17) = damcostinfo(k,7);

                    %土地成本钱
                    P13 = (damcostinfo(k,8)/10000)*(68+239+42)*prod(inflation(1:11,2))*1.5661*20 + damcostinfo(k,9)/4046.856*4100 + damcostinfo(k,10)/4046.856*1400;
                    LCOEcaculation(k,13) = P13;

                    %能发多少电
                    POWER = sum(Q1*damcostinfo(k,3)*9.81*Efficiency*24)/38;
                    LCOEcaculation(k,14) = POWER;

                    %LCOE
                    discount = 0.1;
                    Ecurrent = 0;
                    Runcunrrent = 0;
                    for L = 1:LifetimeYear
                        Ecurrent = Ecurrent + POWER*(1+discount)^(-L);
                        Runcunrrent = Runcunrrent + P11*(1+discount)^(-L);
                    end
                    LCOE = (P1+P2+P3+P4+P5+P6+P7+P8+P9+P10+P12+P13+Runcunrrent)/Ecurrent;
                    LCOEcaculation(k,15) = LCOE;
                end
            end
            damLCOE{j,4} = LCOEcaculation;
        end
    end
    
    LCOENum = size(damLCOE,1);
    DamCostDam = cell(LCOENum,4);
    for j = 1:LCOENum
        DamCostDam{j,1} = damLCOE{j,1};
        DamCostDam{j,2} = damLCOE{j,2};
        DamCostDam{j,3} = damLCOE{j,3};
        a = damLCOE{j,4};
        b = double(damInundation{j,3});
        Num = size(a);
        if Num>0
            for L = 1:Num
                a(L,18) = b(L,1);
            end
            DamCostDam{j,4} = a;
        end
    end
    clear damLCOE
    damLCOE = DamCostDam;
    clear DamCostDam
    
    filenameSAVE = strcat('DAMLCOE',fileDEM(i).name(4:5),'.mat');
    save(filenameSAVE,'damLCOE')
    i
    
end
clear

