function result=isCorrectOver(XoS)
% for index=1:1:2
%     in=[0*XoS(1) 1*XoS(2) 0*XoS(3)];%Associate
%     u=max(in);%乘以相应权值后取最大值作为N4的输入
%     f=feedback(u,fbset);
%     p=[0 1 0]-f;
%     V=p;
%     XoS(2)=XoS(2)+k*V(2)*tt/((Roff-XoS(2)*(Roff-Ron))*(Ron-Roff));
%     XoS=max([0 0 0],min(XoS,[1 1 1]));
% end
if XoS(2)<0.5 
    result=1;
else
    result=0;
end
