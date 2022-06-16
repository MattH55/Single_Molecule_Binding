function [avg_rate_t,error_avg_rate_t,mdl_t,mdl_errors_t,t_vect_wrt_t,avg_rate_median_harmonized,avg_rate_95CI] = avg_rate_wrt_time(t_start,xmean,t_vect, n_windows_spatial, nt,niter_bs)

%find last time

tbox_width=range(t_vect)/nt;
t_vect_tmp=t_vect;
t_vect_tmp(t_vect > max(t_vect)-tbox_width) = -inf;

[tmax,tmax_i]=max(t_vect_tmp);
t_vect_wrt_t=t_vect(1:tmax_i);
t_per_i=range(t_vect)/numel(t_vect);
i_per_wind=round(tbox_width/t_per_i);

avg_rate_t=zeros(tmax_i-1,niter_bs);
error_avg_rate_t=zeros(tmax_i-1,niter_bs);
mdl_t=zeros(tmax_i-1,niter_bs);
mdl_errors_t=zeros(tmax_i-1,niter_bs);
MSE=mdl_t;
avg_rate_median_harmonized=zeros(tmax_i-1,1);
avg_rate_95CI=zeros(tmax_i-1,2);


for i=1:tmax_i-1
    t_vect_t_wind=t_vect(i:i+i_per_wind);
    [window_size,dt_window,dt_window_unweighted,dt_window_error_weights,dt_window_error_var] = window_size_vs_time2bind(t_start,xmean,t_vect_t_wind, n_windows_spatial);
    [avg_rate_t(i,:),error_avg_rate_t(i,:),mdl_t(i,:),mdl_errors_t(i,:),MSE(i,:),xfit,yfit] = footprint_norm_minimal_bootstrap_fixedpower(4,window_size,dt_window,dt_window_error_var,niter_bs);
    avg_rate_median_harmonized(i)=nanmedian(avg_rate_t(i,:));
    avg_rate_95CI(i,1)=prctile(avg_rate_t(i,:),2.5);
    avg_rate_95CI(i,2)=prctile(avg_rate_t(i,:),97.5);
end

t_vect_wrt_t=t_vect_wrt_t(1:end-1);