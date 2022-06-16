function [window_size,dt_window,dt_window_unweighted,dt_window_error_weights,dt_window_error_var] = window_size_vs_time2bind(t_start,xmean,t_vect, n_windows_vect)

dt_window=zeros(numel(n_windows_vect),1);
dt_window_error_weights=zeros(size(dt_window));
dt_window_error_var=zeros(size(dt_window));
dt_window_unweighted=zeros(size(dt_window));
%size(dt_window),size(dt_window_error),
for i=1:numel(n_windows_vect)
    window_size=(max(xmean)-min(xmean))/n_windows_vect(i);
    window_lborder=min(xmean)+(0:n_windows_vect(i)-1)*window_size;
    window_lborder=[window_lborder,max(xmean)];
    inwindow=zeros(size(xmean))';

    [inwindow_temp,dt_to_nearest_temp]=time2bind_time_sweep(t_start,xmean,t_vect, n_windows_vect(i));
    
    dt_avg_lanes_temp=nan(numel(n_windows_vect(i)),numel(t_vect));
    dt_t_avg_lanes_temp_std=nan(size(dt_avg_lanes_temp));
    for j=1:n_windows_vect(i)
        %dt_t_avg_lanes_temp(j,:)=zeros(size(rmmissing(dt_to_nearest_temp(:,j))));
        %dt_t_avg_lanes_temp_std(j,:)=zeros(size(rmmissing(dt_to_nearest_temp(:,j))));
        dt_t_avg_lanes_temp(j,:)=expfit(rmmissing(dt_to_nearest_temp(:,j)));
        dt_t_avg_lanes_temp_std(j,:)=std(rmmissing(dt_to_nearest_temp(:,j)));

    end
    

    dt_window(i)=sum(dt_t_avg_lanes_temp./dt_t_avg_lanes_temp_std)/sum(1./dt_t_avg_lanes_temp_std);
    dt_window_unweighted(i)=mean(dt_t_avg_lanes_temp);
    % size(dt_window_error_weights(i)),size(1./sqrt(sum(1./dt_t_avg_lanes_temp_std)))
    dt_window_error_weights(i)=1./sqrt(sum(sum(1./dt_t_avg_lanes_temp_std)));
    if n_windows_vect(i)==1
        dt_window_error_var(i)=dt_t_avg_lanes_temp_std(1);
    else
        dt_window_error_var(i)=std(dt_t_avg_lanes_temp);
    end
end
window_size=(max(xmean)-min(xmean))./n_windows_vect';
 'wmean',dt_window
 'mean', dt_window_unweighted
 'error_w',dt_window_error_weights
'error_var',dt_window_error_var

%rmmissing(dt_to_nearest_temp)