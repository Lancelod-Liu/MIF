%Associate learning & correcting in memristive NN
%Method used is MIF——Max-Input-Feedback.
%This is the release 1.0 version coded at 21'29'' on 2013 .3.6
function N4_state=fiveMIF(traintime1,traintime2)
%仿真参数设置 RoS 是初始化的值
RoS=[80000 47700 95400];%S1~S3 三个突触的忆阻器值
Roff=160000;%高阻态
Ron=1000;%低阻态
D=10^-8;%忆阻器厚度
uv=10^-14;%电子迁移速率
X=(Roff-RoS)/(Roff-Ron);%S1~S3权值矩阵
l=uv*Ron/(D^2);
k=(Ron-Roff)*l;
t=0.1;%脉冲宽度
%一些常量
TrainTime1=traintime1;
TrainTime2=traintime2;
MaxLen=TrainTime1+TrainTime2+17;
%生成1行MaxLen列的向量用于存储状态
N1_state=zeros(1,MaxLen);
R1=zeros(1,MaxLen+1);
X1=zeros(1,MaxLen+1);
V1=zeros(1,MaxLen);
N2_state=zeros(1,MaxLen);
R2=zeros(1,MaxLen+1);
X2=zeros(1,MaxLen+1);
V2=zeros(1,MaxLen);
N3_state=zeros(1,MaxLen);
R3=zeros(1,MaxLen+1);
X3=zeros(1,MaxLen+1);
V3=zeros(1,MaxLen);
N4_state=zeros(1,MaxLen);
F4=zeros(1,MaxLen);


%初始化
N1_state(1)=2;
N1_state(5 : 7)=2;
N1_state(9 : 9+TrainTime1-1)=2; %N3训练长度为TrainTime1
N1_state(MaxLen-2)=2;
N2_state(2)=1;
N2_state(5 : 7)=1;
N2_state(TrainTime1+13: TrainTime1+13+TrainTime2-1)=1;%N2训练长度为TrainTime2
N2_state(MaxLen-1)=1;
N3_state(3)=1;
N3_state(5 : 7)=1;
N3_state(9 : 9+TrainTime1+2-1)=1;%N3训练长度为TrainTime1+2
N3_state(MaxLen)=1;
X1(1)=X(1);
X2(1)=X(2);
X3(1)=X(3);
R1(1)=RoS(1);
R2(1)=RoS(2);
R3(1)=RoS(3);
%训练
for ct=1:MaxLen
    inij=[N1_state(ct) N2_state(ct) N3_state(ct)];%取突触前输入序列
    in=[inij(1)*X1(ct) inij(2)*X2(ct) inij(3)*X3(ct)];
    u=max(in);%乘以相应权值后取最大值作为N4的输入
    o=o(u);
    feedback=f(u);
    %pij=f-inij;
    pij=inij-feedback;
    %突触工作电压记录
    %仅当输入电压不为0时才有工作电压 否则工作电压为0
    if inij(1) ~=0
    V1(ct)=pij(1);
    end
    if inij(2) ~=0
    V2(ct)=pij(2);
    end
    if inij(3) ~=0
    V3(ct)=pij(3);
    end
    %突触系数更改
    %若工作电压为0则系数无变化
    X1(ct+1)=X1(ct)+k*V1(ct)*t/((Roff-X1(ct)*(Roff-Ron))*(Ron-Roff));
    X2(ct+1)=X2(ct)+k*V2(ct)*t/((Roff-X2(ct)*(Roff-Ron))*(Ron-Roff));
    X3(ct+1)=X3(ct)+k*V3(ct)*t/((Roff-X3(ct)*(Roff-Ron))*(Ron-Roff));
    %电阻更改
    R1(ct+1)=R1(ct)+k*V1(ct)*t/R1(ct);
    R2(ct+1)=R2(ct)+k*V2(ct)*t/R2(ct);
    R3(ct+1)=R3(ct)+k*V3(ct)*t/R3(ct);
    %反馈电压记录
    F4(ct)=feedback;
    N4_state(ct)=o;%把输入写入N4
    %X=X+k*pij*t./((Roff-X*(Roff-Ron))*(Ron-Roff));
    %R=R+k*pij*t./R;
    if X1(ct+1)<0
        X1(ct+1)=0;
    end
     if X1(ct+1)>1
        X1(ct+1)=1;
     end
    if X2(ct+1)<0
        X2(ct+1)=0;
    end
     if X2(ct+1)>1
        X2(ct+1)=1;
     end
    if X3(ct+1)<0
        X3(ct+1)=0;
    end
     if X3(ct+1)>1
        X3(ct+1)=1;
     end
     
     if R1(ct+1)<Ron
        R1(ct+1)=Ron;
    end
     if R1(ct+1)>Roff
        R1(ct+1)=Roff;
     end
    if R2(ct+1)<Ron
        R2(ct+1)=Ron;
    end
     if R2(ct+1)>Roff
        R2(ct+1)=Roff;
     end
    if R3(ct+1)<Ron
        R3(ct+1)=Ron;
    end
     if R3(ct+1)>Roff
        R3(ct+1)=Roff;
     end
end    
    %X=(Roff-R)/(Roff-Ron);
maxin=0.001:0.001:2;
fdbk=maxin;
k=1;
for i=maxin
    fdbk(k)=f(i);k=k+1;
end

%显示
subplot(2,1,1);
plot(X1,'m:.');
hold on
plot(X2,'k:.');
hold on
plot(X3,'b:.');
title('Weight');
legend('S1','S2','S3',0);
xlabel('\fontsize{10}Train Time','Color','k','FontWeight','Bold');
ylabel('\fontsize{10}Weight','Color','k','FontWeight','Bold');
hold;
subplot(2,1,2);
plot(maxin,fdbk,'k');
title('\fontsize{11}Feedback Function','FontWeight','Bold');
xlabel('\fontsize{10}Max Input','Color','k','FontWeight','Bold');
ylabel('\fontsize{10}Feedback Voltage','Color','k','FontWeight','Bold');
hold;
figure(2);
subplot(4,2,1);
bar(N1_state,'m');
title('N1 Food state','Color','r','FontWeight','Bold');
xlabel('\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel('\fontsize{10}State','Color','k','FontWeight','Bold');
subplot(4,2,3);
bar(N2_state,'k');
title('N2 Ring state','Color','r','FontWeight','Bold');
xlabel('\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel('\fontsize{10}State','Color','k','FontWeight','Bold');
subplot(4,2,5);
bar(N3_state,'b');
title('N3 Light state','Color','r','FontWeight','Bold');
xlabel('\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel('\fontsize{10}State','Color','k','FontWeight','Bold');
subplot(4,2,7);
bar(N4_state,'r');
title('N4 Salivation state','Color','r','FontWeight','Bold');
xlabel('\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel('\fontsize{10}State','Color','k','FontWeight','Bold');
subplot(4,2,2);
bar(V1,'m');
title('S1 food work voltage','Color','r','FontWeight','Bold');
xlabel('\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel('\fontsize{10}work voltage','Color','k','FontWeight','Bold');
subplot(4,2,4);
bar(V2,'k');
title('S2 ring work voltage','Color','r','FontWeight','Bold');
xlabel('\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel('\fontsize{10}work voltage','Color','k','FontWeight','Bold');
subplot(4,2,6);
bar(V3,'b');
title('S3 light work voltage','Color','r','FontWeight','Bold');
xlabel('\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel('\fontsize{10}work voltage','Color','k','FontWeight','Bold');
subplot(4,2,8);
bar(F4,'r');
title('N4 feedback voltage','Color','r','FontWeight','Bold');
xlabel('\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel('\fontsize{10}feedback voltage','Color','k','FontWeight','Bold');



function o=o(u)
if u<0.5
    o=0;
else if u <1
        o=1;
    else
        o=2;
    end
end

function f=f(u)
if u>=1
    f=0.8;
else if u >=0.75
        f=1.5;
else if u >=0.5
        f=1.3;
else if u >=0.25
        f=1.3;
else if u >0
        f=1.7;
else 
       f=0;
    end
    end
    end
    end

end

