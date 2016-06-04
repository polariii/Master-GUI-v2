function [wMin,VaR,CVaR]=minCVaRPort(S,Ret_lim,alpha)

[N,M]=size(S);

%Matrix manipulation to get on LP form
A1 = sparse([-mean(S) zeros(1,N+1)]);
A2 = sparse(-S);
A3 = -ones(N,1);
A4 = -speye(N,N);
A = sparse([A1; A2 A3 A4]);
b = sparse([-Ret_lim; zeros(N,1)]);
Aeq =sparse([ones(1,M) zeros(1, N +1)]);
beq = [1];

%Upper and lower bound
UB=1; LB=0;
UB = sparse([repmat(UB, 1, M) +Inf*ones(1,N+1)]);
LB = sparse([repmat(LB, 1, M) zeros(1, N +1)]);

%Objective : minimize CVaR on discrete form proposed by Rockafellar and
%Urjazev

objfun=sparse([zeros(1,M),1 ,1/(1 -alpha)*1/N*ones(1, N)]);

%Optimizing with MOSEK LP solver
options = mskoptimset('Simplex','on');
[w,fval,~,out]= linprog(objfun,A,b,Aeq,beq,LB,UB,[]);

%Getting wanted results from optimization solution
wMin=w(1:M);
VaR=w(M+1);
CVaR=fval;


