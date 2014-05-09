function result=isLearnOver(XoS,Roff,Ron,k,tt,fbset)
for index=1:1:2
    in=[0*XoS(1) 0*XoS(2) 1*XoS(3)];%Associate
    u=max(in);%乘以相应权值后取最大值作为N4的输入
    f=feedback(u,fbset);
    p=[0 0 1]-f;
    V=p;
    XoS(3)=XoS(3)+k*V(3)*tt/((Roff-XoS(3)*(Roff-Ron))*(Ron-Roff));
    XoS=max([0 0 0],min(XoS,[1 1 1]));
end
if XoS(3)>=0.5 
    result=1;
else
    result=0;
end
