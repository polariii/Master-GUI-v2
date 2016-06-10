function [VaR,CVaR,CVaR_dev]=estimateCVaR(Scenarios,pwgt,alpha)

pnum = size(pwgt,2);

S = size(Scenarios,1);
ka = ceil(alpha*S)		% location of cut

CVaR = zeros(pnum, 1);

for i = 1:pnum					% loop over portfolios
	z = -Scenarios*pwgt(:,i);
	z = sort(z);
    %CVaR deviation
    Mu=mean(z);
    for j=1:size(z,2)
        z2(:,j)=z(:,j)-Mu(j);
    end
    VaR(i,1)=z(ka);
    (ka - S*alpha)*z(ka);
	if ka < S					
		CVaR(i) = ((ka - S*alpha)*z(ka) + sum(z(ka+1:S)))/(S*(1 - alpha));
        CVaR_dev(i) = ((ka - S*alpha)*z2(ka) + sum(z2(ka+1:S)))/(S*(1 - alpha));
	else
		CVaR(i) = z(ka);
	end
end

