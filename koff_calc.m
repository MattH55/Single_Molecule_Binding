function [bins_dt_hist,values_dt_hist,fit_single,fit_double] = koff_calc(dt)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ind = ~isnan(dt);
dt=dt(ind);



dt_hist=histogram(dt,'BinMethod','fd','Normalization','probability');
values_dt_hist=dt_hist.Values;
bins_dt_hist=0.5*(dt_hist.BinEdges(2:end)+dt_hist.BinEdges(1:end-1));
[parmhat,parmc1]=expfit(dt)

single_exp=@(b,x) b(1).*exp(-b(2).*x);
dbl_exp=@(b,x) b(1).*exp(-x.*b(2))+b(3).*exp(-x.*b(4));


fit_single=nlinfit(bins_dt_hist,values_dt_hist,single_exp,[max(values_dt_hist),parmhat]);

beta1=[fit_single,fit_single(1)*0.01,fit_single(2)*100];

fit_double=nlinfit(bins_dt_hist,values_dt_hist,single_exp,[beta1]);



end