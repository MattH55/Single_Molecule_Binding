function [avg_rate_x,error_avg_rate_x,window_centers,mdl_x,mdl_errors_x,window_size,dt_window,dt_window_unweighted,dt_window_error_weights,dt_window_error_var] = kon_wrt_pos(t_start,xmean,t_vect, n_windows_spatial_subdiv, nx)

%find last time

%tbox_width=range(t_vect)/nt;
%t_vect_tmp=t_vect;
%t_vect_tmp(t_vect > max(t_vect)-tbox_width) = -inf;

total_width=range(xmean);
window_width=total_width/nx;
window_l_edges=min(xmean)+(0:nx-1)*total_width/(nx);
window_r_edges=window_l_edges+window_width;
window_centers=window_l_edges+window_width/2;


avg_rate_x=zeros(nx,1);
error_avg_rate_x=zeros(nx,1);
mdl_x=zeros(nx,1);
mdl_errors_x=zeros(nx,1);

window_size=zeros(nx,n_windows_spatial_subdiv);
dt_window=zeros(nx,n_windows_spatial_subdiv);
dt_window_unweighted=zeros(nx,n_windows_spatial_subdiv);
dt_window_error_weights=zeros(nx,n_windows_spatial_subdiv);
dt_window_error_var=zeros(nx,n_windows_spatial_subdiv);


%Select Events

for i=1:nx
    %Select Events
    t_start_temp=t_start(and(xmean>=window_l_edges(i),xmean<window_r_edges(i)));
    xmean_temp=xmean(and(xmean>=window_l_edges(i),xmean<window_r_edges(i)));
    [window_size(i,:),dt_window(i,:),dt_window_unweighted(i,:),dt_window_error_weights(i,:),dt_window_error_var(i,:)] = window_size_vs_time2bind(t_start_temp,xmean_temp,t_vect, n_windows_spatial_subdiv);
    [avg_rate_x(i),error_avg_rate_x(i),mdl_x(i),mdl_errors_x(i),xfit,yfit] = footprint_norm_minimal_fixed_power(4,window_size(i,:),dt_window(i,:),dt_window_error_var(i,:));
end

%t_vect_wrt_t=t_vect_wrt_t(1:end-1);