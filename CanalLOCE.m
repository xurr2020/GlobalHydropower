for j = 1:canalNum
    canalLCOE{j,1} = canalInfo{j,1};
    canalLCOE{j,2} = canalInfo{j,2};
    canalLCOE{j,3} = canalInfo{j,3};
    powerDistance = PointInfo{j,6};
    canalLCOE{j,4} = powerDistance;
    Hazard = PointInfo{j,7};
    canalLCOE{j,5} = Hazard;
    SoftRock = PointInfo{j,8};
    canalLCOE{j,6} = SoftRock;
    Efficiency = 0.9;
    canalLCOE{j,7} = Efficiency;
    LifetimeYear = 40;
    canalLCOE{j,8} = LifetimeYear;
    canalStartInfo = canalInfo{j,4};
    canalStartInfoNum = size(canalStartInfo,1);
    if canalStartInfoNum>0
        LCOEcaculation = zeros(canalStartInfoNum,16);
        P6 = powerDistance*2*10^6*0.11*prod(inflation(1:10,2));
        for k = 1:canalStartInfoNum
            damid = canalStartInfo(k,1);
            riverid = mod(damid,1000000);
            Q30 = prctile(Discharge(riverid,:),30);
            Q1 = Discharge(riverid,:) - Q30;
            Q1(Q1<=0)=[];
            Q1 = 0.5*Q1;
            DischargeNum = size(Q1,2);
            Qd = prctile(Q1,97);
            if Qd>0
                Q1(Q1>Qd) = Qd;
                LCOEcaculation(k,16) = Qd;
                Pt = Qd*canalStartInfo(k,5)*9810*Efficiency*10^(-6);
                P1 = 1.943*Pt^0.7634*10^6*prod(inflation(1:15,2));
                LCOEcaculation(k,1) = P1;
                if Qd<50
                    P2 = (0.4948*Qd+1.7)*10^6*0.11*prod(inflation(1:10,2));
                elseif Qd>=50 && Qd<500
                    P2 = (-0.0006*Qd^2+0.67*Qd-6.95)*10^6*0.11*prod(inflation(1:10,2));
                else
                    P2 = 178.05*10^6*0.11*prod(inflation(1:10,2));
                end
                LCOEcaculation(k,2) = P2;
                P3 = 3.9142*Pt^0.6622*10^6*0.11*prod(inflation(1:10,2));
                LCOEcaculation(k,3) = P3;
                P4 = (-38.795*log10(Qd)+309.89)*Pt*1000*0.11*prod(inflation(1:10,2));
                LCOEcaculation(k,4) = P4;
                P5 = 1.3*exp(1)^6*(Pt*1000)^0.56*prod(inflation(1:18,2));
                LCOEcaculation(k,5) = P5;
                LCOEcaculation(k,6) = P6;
                L = PipeD(ceil(Qd),1);
                LCOEcaculation(k,7) = L;
                mt = 0.0054*(canalStartInfo(k,6))^2-0.0039*canalStartInfo(k,6)+0.9671;
                P7 = 219.99*pi*(L/2)^2+13658*mt*(canalStartInfo(k,6)*1000-canalStartInfo(k,5))*0.11*prod(inflation(1:10,2));
                LCOEcaculation(k,8) = P7;
                P8 = (6*L+9.4*canalStartInfo(k,5))*10^3*0.11*prod(inflation(1:10,2));
                LCOEcaculation(k,9) = P8;
                if PointInfo{j,7}>0.7
                    P9 = 0.05*(P1+P2+P3+P4+P5+P6+P7+P8);
                else
                    P9 = 0;
                end
                LCOEcaculation(k,10) = P9;
                if PointInfo{j,8} == 1
                    P10 = 0.05*(P1+P2+P3+P4+P5+P6+P7+P8);
                else
                    P10 = 0;
                end
                LCOEcaculation(k,11) = P10;
                P11 = 0.2*(P1+P2+P3+P4+P5+P6+P7+P8+P9+P10);
                LCOEcaculation(k,12) = P11;
                P12 = 0.02*(P1+P2+P3+P4+P5+P6+P7+P8+P9+P10+P11);
                LCOEcaculation(k,13) = P12;
                P13 = 0;
                At = pi*(L/2)^2;
                Hactual = canalStartInfo(k,5);
                for M = 1:DischargeNum
                    V = Q1(1,M)/At;
                    Re = V*100*100*L/0.0101;
                    lamda = 0.3164/(Re^0.25);
                    hf = lamda*10*1000*V^2/(L*2*9.8);
                    deltaH = Hactual-hf;
                    if deltaH<0
                        deltaH=0;
                    end
                    P13 = P13 + Q1(1,M)*deltaH*9.81*Efficiency*24;
                end
                P13 = P13/38;
                LCOEcaculation(k,14) = P13;

                %LCOE
                discount = 0.1;
                Ecurrent = 0;
                Runcunrrent = 0;
                for M = 1:LifetimeYear
                    Ecurrent = Ecurrent + P13*(1+discount)^(-M);
                    Runcunrrent = Runcunrrent + P12*(1+discount)^(-M);
                end
                LCOE = (P1+P2+P3+P4+P5+P6+P7+P8+P9+P10+P11+Runcunrrent)/Ecurrent;
                LCOEcaculation(k,15) = LCOE;
            end
        end
        canalLCOE{j,9} = LCOEcaculation;
    end
end


