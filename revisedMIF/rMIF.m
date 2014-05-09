%Associate learning & correcting in memristive NN
%Method used is MIF——Max-Input-Feedback.
%This is the release 2.0 version coded at 13'38'' on 2013 .6.23
function [na,nc]=rMIF(fbset,tt)
%仿真参数设置 RoS 是初始化的值
RoS=[80000 47700 95400];%S1~S3 三个突触的忆阻器阻值
Roff=160000;%高阻态
Ron=1000;%低阻态
D=10^-8;%忆阻器厚度
uv=10^-14;%电子迁移速率
XoS=(Roff-RoS)/(Roff-Ron);%S1~S3权值矩阵
l=uv*Ron/(D^2);
k=(Ron-Roff)*l;
% tt=0.1;%训练脉冲宽度
tu=10^-9;%使用时的脉冲宽度
costthreshold=20/tt;
nc=0;
na=0;
%初始化阶段1
in=[2*XoS(1) 0*XoS(2) 0*XoS(3)];%Initialize 1.1
u=max(in);%乘以相应权值后取最大值作为N4的输入
f=feedback(u,fbset);
p=[2 0 0]-f;
V=p;
XoS(1)=XoS(1)+k*V(1)*tt/((Roff-XoS(1)*(Roff-Ron))*(Ron-Roff));
RoS(1)=RoS(1)+k*V(1)*tt/RoS(1);
XoS=max([0 0 0],min(XoS,[1 1 1]));
RoS=max([Ron Ron Ron],min(RoS,[Roff Roff Roff]));

in=[0*XoS(1) 1*XoS(2) 0*XoS(3)];%Initialize 1.2
u=max(in);%乘以相应权值后取最大值作为N4的输入
f=feedback(u,fbset);
p=[0 1 0]-f;
V=p;
XoS(2)=XoS(2)+k*V(2)*tt/((Roff-XoS(2)*(Roff-Ron))*(Ron-Roff));
RoS(2)=RoS(2)+k*V(2)*tt/RoS(2);
XoS=max([0 0 0],min(XoS,[1 1 1]));
RoS=max([Ron Ron Ron],min(RoS,[Roff Roff Roff]));

in=[0*XoS(1) 0*XoS(2) 1*XoS(3)];%Initialize 1.3
u=max(in);%乘以相应权值后取最大值作为N4的输入
f=feedback(u,fbset);
p=[0 0 1]-f;
V=p;
XoS(3)=XoS(3)+k*V(3)*tt/((Roff-XoS(3)*(Roff-Ron))*(Ron-Roff));
RoS(3)=RoS(3)+k*V(3)*tt/RoS(3);
XoS=max([0 0 0],min(XoS,[1 1 1]));
RoS=max([Ron Ron Ron],min(RoS,[Roff Roff Roff]));

%初始化阶段2
for index=1:1:3
    in=[2*XoS(1) 1*XoS(2) 1*XoS(3)];%Initialize 2
    u=max(in);%乘以相应权值后取最大值作为N4的输入
    f=feedback(u,fbset);
    p=[2 1 1]-f;
    V=p;
    XoS(1)=XoS(1)+k*V(1)*tt/((Roff-XoS(1)*(Roff-Ron))*(Ron-Roff));
    XoS(2)=XoS(2)+k*V(2)*tt/((Roff-XoS(2)*(Roff-Ron))*(Ron-Roff));
    XoS(3)=XoS(3)+k*V(3)*tt/((Roff-XoS(3)*(Roff-Ron))*(Ron-Roff));
    RoS(1)=RoS(1)+k*V(1)*tt/RoS(1);
    RoS(2)=RoS(2)+k*V(2)*tt/RoS(2);
    RoS(3)=RoS(3)+k*V(3)*tt/RoS(3);
    XoS=max([0 0 0],min(XoS,[1 1 1]));
    RoS=max([Ron Ron Ron],min(RoS,[Roff Roff Roff]));
end
%Associate procedure 
% %XoS(3) >= 0.5时停止
while isLearnOver(XoS,Roff,Ron,k,tt,fbset) == 0 && na<=costthreshold
    na=na+1;%计数器自增1   
    if na > costthreshold %大于训练允许的次数认为无法实现
        disp('Cannot make learning!');
        %error('Cannot!');
        return;
    end
    in=[2*XoS(1) 0*XoS(2) 1*XoS(3)];%Associate
    u=max(in);%乘以相应权值后取最大值作为N4的输入
    %o=output(u);
    f=feedback(u,fbset);
    p=[2 0 1]-f;
    %学习过程中S2工作电压为0
    V=p;V(2)=0;
    %突触系数更改
    %若工作电压为0则系数无变化
    XoS(1)=XoS(1)+k*V(1)*tt/((Roff-XoS(1)*(Roff-Ron))*(Ron-Roff));
    XoS(2)=XoS(2)+k*V(2)*tt/((Roff-XoS(2)*(Roff-Ron))*(Ron-Roff));
    XoS(3)=XoS(3)+k*V(3)*tt/((Roff-XoS(3)*(Roff-Ron))*(Ron-Roff));
    %电阻更改
    RoS(1)=RoS(1)+k*V(1)*tt/RoS(1);
    RoS(2)=RoS(2)+k*V(2)*tt/RoS(2);
    RoS(3)=RoS(3)+k*V(3)*tt/RoS(3);
    %对权值&阻值进行限值
    XoS=max([0 0 0],min(XoS,[1 1 1]));
    RoS=max([Ron Ron Ron],min(RoS,[Roff Roff Roff]));
end
%Correct procedure 
%XoS(2) < 0.5时停止
while isCorrectOver(XoS) == 0 && nc<=costthreshold
    nc=nc+1;%计数器自增1
    if nc > costthreshold 
        disp('Cannot make correction!');
        return;
    end
    in=[0*XoS(1) 1*XoS(2) 0*XoS(3)];%Associate
    u=max(in);%乘以相应权值后取最大值作为N4的输入
    %o=output(u);
    f=feedback(u,fbset);
    p=[0 1 0]-f;
    %学习过程中S1 S3工作电压为0
    V=[0 0 0];V(2)=p(2);
    %突触系数更改
    %若工作电压为0则系数无变化
    XoS(1)=XoS(1)+k*V(1)*tt/((Roff-XoS(1)*(Roff-Ron))*(Ron-Roff));
    XoS(2)=XoS(2)+k*V(2)*tt/((Roff-XoS(2)*(Roff-Ron))*(Ron-Roff));
    XoS(3)=XoS(3)+k*V(3)*tt/((Roff-XoS(3)*(Roff-Ron))*(Ron-Roff));
    %电阻更改
    RoS(1)=RoS(1)+k*V(1)*tt/RoS(1);
    RoS(2)=RoS(2)+k*V(2)*tt/RoS(2);
    RoS(3)=RoS(3)+k*V(3)*tt/RoS(3);
    %对权值&阻值进行限值
    XoS=max([0 0 0],min(XoS,[1 1 1]));
    RoS=max([Ron Ron Ron],min(RoS,[Roff Roff Roff]));
end
%str=sprintf('Ron:  %17d Ω\nRoff:  %18d Ω\nTrain Pulse Width: %5.2f s\nAssociate Cost: %6d unit\nCorrect Cost: %8d unit\nSum Cost: %12d unit',Ron,Roff,tt,na,nc,na+nc);
%disp(str);
end




