%collecting SP500 stocks
%Duration is how many years of data
%Frequence means daily('d') or weakily ('w') data from yahoo
%Random means collecting m random stocks from SP500, type 'on'. Else all SP
function [Adj_close,stock_names]=collectSP(duration,frequence,max,index_tick,NAN)

c=yahoo;
start=today-365.25*duration;
stop=today;

if strcmp(index_tick,'DAX')
    [~,stock_names]=xlsread('DAX_tick.xlsx');
    index_T='^GDAXI';
    index_N='DAX';
elseif strcmp(index_tick,'S&P500')
    [~,stock_names]=xlsread('s&p500.xlsx');
    index_T='^GSPC';
    index_N='SandP500';
elseif strcmp(index_tick,'S&P100')
    [~,stock_names]=xlsread('S&P100.xlsx');
    index_T='^OEX';
    index_N='SandP100';
    
end

Adj_close=fetch(c,index_T,'Adj Close',start,stop,frequence);
Adj_close=fints(Adj_close(:,1),Adj_close(:,2),index_N,frequence);


n=length(stock_names);
%total stocks
if ~isempty(max)
    m=max;
    stock_names=stock_names(1:m);
else
    m=n;
end

if NAN
    nan_method='intersection';
else
    nan_method='union';
end
I=[];
for i=1:m
    try
        tmp=fetch(c,stock_names(i),'Adj Close',start,stop,frequence);
        
        tmp_name=fetch(c,stock_names(i),'Name');
        tmp_name=regexprep(tmp_name.Name,'\W*','_');
        tmp_fts=fints(tmp(:,1),tmp(:,2),tmp_name,frequence);
        Adj_close=merge(Adj_close,tmp_fts,'DateSetMethod',nan_method,'SortColumns',0);
        
        
    catch ME
        warning('This stock is not in yahoo database')
        I=[I,i];
        
    end

end
if ~isempty(I)
    disp('Following stocks was not in yahoo database')
    disp(stock_names(I))
end

        
Adj_close=Adj_close;

end





