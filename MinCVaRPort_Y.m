function [wMin,VaR,CVaR]=MinCVaRPort_Y(S,Mu,Ret_lim,alpha)


[N,M]=size(S);
zeta=sdpvar(1);
w=sdpvar(M,1);
z=sdpvar(N,1);
R=sdpvar;


C1=[sum(w) == 1];
C2=[z >= -S*w - zeta];
C3=[Mu' * w >= Ret_lim];
C=[C1, C2, C3,w>=0,z>=0];


obj=zeta + (1./((1-alpha)*N)) * sum(z);
opt=sdpsettings('Solver','mosek','verbose',0);
optimize(C,obj,opt);
wMin=value(w);
VaR=value(zeta);
CVaR=value(obj);





