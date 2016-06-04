function [wMin,VaR,Return]=maxRetPort(S,CVaR_Lim,alpha)

[N,M]=size(S);

%Matrix manipulation to get on LP form
A1 = sparse([zeros(1,M),1 ,1/(1 - alpha)*1/N*ones(1, N)]);
A2 = -S;
A3 = -ones(N,1);
A4 = -speye(N,N);
A = sparse([A1; A2 A3 A4]);
Aeq =sparse([ones(1,M) zeros(1, N +1)]);
b = sparse([CVaR_Lim; zeros(N,1)]); beq = [1];

%Upper and lower bound
UB = sparse([ones(1,M) +Inf*ones(1,N+1)]);
LB = sparse([zeros(1,M) zeros(1, N+1)]);

%Ojbective : Maximize return for given level CVaR
objfun=-sparse([mean(S) zeros(1,N+1)]);

%Optimizing with MOSEK LP solver
options = mskoptimset('Simplex','on');
[w,fval,exitflag,out]= linprog(objfun,A,b,Aeq,beq,LB,UB,[]);

%Getting wanted results from optimization solution
wMin=w(1:M); VaR=w(M+1); Return=-fval;