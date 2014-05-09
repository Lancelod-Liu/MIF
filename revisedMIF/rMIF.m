%Associate learning & correcting in memristive NN
%Method used is MIF����Max-Input-Feedback.
%This is the release 2.0 version coded at 13'38'' on 2013 .6.23
function [na,nc]=rMIF(fbset,tt)
%����������� RoS �ǳ�ʼ����ֵ
RoS=[80000 47700 95400];%S1~S3 ����ͻ������������ֵ
Roff=160000;%����̬
Ron=1000;%����̬
D=10^-8;%���������
uv=10^-14;%����Ǩ������
XoS=(Roff-RoS)/(Roff-Ron);%S1~S3Ȩֵ����
l=uv*Ron/(D^2);
k=(Ron-Roff)*l;
% tt=0.1;%ѵ��������
tu=10^-9;%ʹ��ʱ��������
costthreshold=20/tt;
nc=0;
na=0;
%��ʼ���׶�1
in=[2*XoS(1) 0*XoS(2) 0*XoS(3)];%Initialize 1.1
u=max(in);%������ӦȨֵ��ȡ���ֵ��ΪN4������
f=feedback(u,fbset);
p=[2 0 0]-f;
V=p;
XoS(1)=XoS(1)+k*V(1)*tt/((Roff-XoS(1)*(Roff-Ron))*(Ron-Roff));
RoS(1)=RoS(1)+k*V(1)*tt/RoS(1);
XoS=max([0 0 0],min(XoS,[1 1 1]));
RoS=max([Ron Ron Ron],min(RoS,[Roff Roff Roff]));

in=[0*XoS(1) 1*XoS(2) 0*XoS(3)];%Initialize 1.2
u=max(in);%������ӦȨֵ��ȡ���ֵ��ΪN4������
f=feedback(u,fbset);
p=[0 1 0]-f;
V=p;
XoS(2)=XoS(2)+k*V(2)*tt/((Roff-XoS(2)*(Roff-Ron))*(Ron-Roff));
RoS(2)=RoS(2)+k*V(2)*tt/RoS(2);
XoS=max([0 0 0],min(XoS,[1 1 1]));
RoS=max([Ron Ron Ron],min(RoS,[Roff Roff Roff]));

in=[0*XoS(1) 0*XoS(2) 1*XoS(3)];%Initialize 1.3
u=max(in);%������ӦȨֵ��ȡ���ֵ��ΪN4������
f=feedback(u,fbset);
p=[0 0 1]-f;
V=p;
XoS(3)=XoS(3)+k*V(3)*tt/((Roff-XoS(3)*(Roff-Ron))*(Ron-Roff));
RoS(3)=RoS(3)+k*V(3)*tt/RoS(3);
XoS=max([0 0 0],min(XoS,[1 1 1]));
RoS=max([Ron Ron Ron],min(RoS,[Roff Roff Roff]));

%��ʼ���׶�2
for index=1:1:3
    in=[2*XoS(1) 1*XoS(2) 1*XoS(3)];%Initialize 2
    u=max(in);%������ӦȨֵ��ȡ���ֵ��ΪN4������
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
% %XoS(3) >= 0.5ʱֹͣ
while isLearnOver(XoS,Roff,Ron,k,tt,fbset) == 0 && na<=costthreshold
    na=na+1;%����������1   
    if na > costthreshold %����ѵ������Ĵ�����Ϊ�޷�ʵ��
        disp('Cannot make learning!');
        %error('Cannot!');
        return;
    end
    in=[2*XoS(1) 0*XoS(2) 1*XoS(3)];%Associate
    u=max(in);%������ӦȨֵ��ȡ���ֵ��ΪN4������
    %o=output(u);
    f=feedback(u,fbset);
    p=[2 0 1]-f;
    %ѧϰ������S2������ѹΪ0
    V=p;V(2)=0;
    %ͻ��ϵ������
    %��������ѹΪ0��ϵ���ޱ仯
    XoS(1)=XoS(1)+k*V(1)*tt/((Roff-XoS(1)*(Roff-Ron))*(Ron-Roff));
    XoS(2)=XoS(2)+k*V(2)*tt/((Roff-XoS(2)*(Roff-Ron))*(Ron-Roff));
    XoS(3)=XoS(3)+k*V(3)*tt/((Roff-XoS(3)*(Roff-Ron))*(Ron-Roff));
    %�������
    RoS(1)=RoS(1)+k*V(1)*tt/RoS(1);
    RoS(2)=RoS(2)+k*V(2)*tt/RoS(2);
    RoS(3)=RoS(3)+k*V(3)*tt/RoS(3);
    %��Ȩֵ&��ֵ������ֵ
    XoS=max([0 0 0],min(XoS,[1 1 1]));
    RoS=max([Ron Ron Ron],min(RoS,[Roff Roff Roff]));
end
%Correct procedure 
%XoS(2) < 0.5ʱֹͣ
while isCorrectOver(XoS) == 0 && nc<=costthreshold
    nc=nc+1;%����������1
    if nc > costthreshold 
        disp('Cannot make correction!');
        return;
    end
    in=[0*XoS(1) 1*XoS(2) 0*XoS(3)];%Associate
    u=max(in);%������ӦȨֵ��ȡ���ֵ��ΪN4������
    %o=output(u);
    f=feedback(u,fbset);
    p=[0 1 0]-f;
    %ѧϰ������S1 S3������ѹΪ0
    V=[0 0 0];V(2)=p(2);
    %ͻ��ϵ������
    %��������ѹΪ0��ϵ���ޱ仯
    XoS(1)=XoS(1)+k*V(1)*tt/((Roff-XoS(1)*(Roff-Ron))*(Ron-Roff));
    XoS(2)=XoS(2)+k*V(2)*tt/((Roff-XoS(2)*(Roff-Ron))*(Ron-Roff));
    XoS(3)=XoS(3)+k*V(3)*tt/((Roff-XoS(3)*(Roff-Ron))*(Ron-Roff));
    %�������
    RoS(1)=RoS(1)+k*V(1)*tt/RoS(1);
    RoS(2)=RoS(2)+k*V(2)*tt/RoS(2);
    RoS(3)=RoS(3)+k*V(3)*tt/RoS(3);
    %��Ȩֵ&��ֵ������ֵ
    XoS=max([0 0 0],min(XoS,[1 1 1]));
    RoS=max([Ron Ron Ron],min(RoS,[Roff Roff Roff]));
end
%str=sprintf('Ron:  %17d ��\nRoff:  %18d ��\nTrain Pulse Width: %5.2f s\nAssociate Cost: %6d unit\nCorrect Cost: %8d unit\nSum Cost: %12d unit',Ron,Roff,tt,na,nc,na+nc);
%disp(str);
end




