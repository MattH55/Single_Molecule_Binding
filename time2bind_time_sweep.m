function  [inwindow,dt_to_nearest]=time2bind(t_start,xmean,t_vect, n_windows)
% Calculates distribution of nearest start times as a function of kymograph
% time
% 
%inputs
%t_start: units of ms, start times of trajectories
%xmean: Mean positions of trajectories, in nm
%t_vect: sweep times of kymograph
%n_windows: number of spatial windows

%window_size: units of nm

%outputs
%
%inwindow: shows which window a given trace is in
%dt_to_nearest: as function of time, shows time to next trajectory start
%
window_size=(max(xmean)-min(xmean))/n_windows;
window_lborder=min(xmean)-eps+(0:n_windows-1)*window_size;
window_lborder=[window_lborder,max(xmean)+eps];
inwindow=zeros(size(xmean))';

nt=numel(t_vect);




for i=1:n_windows
    for j=1:numel(xmean)
        if ((xmean(j)>=window_lborder(i)) && xmean(j)<=window_lborder(i+1))
            inwindow(j)=i;
        end
    end
end


%dt_to_nearest=[];



array1=[t_start,xmean,inwindow'];



sort_array=sortrows(array1,3);


dt_to_nearest=zeros(nt,n_windows);
for current_window=1:n_windows
   t_start_window=sort_array(sort_array(:,3)==current_window,1);
   xmean_window=sort_array(sort_array(:,3)==current_window,2);
   t_start_window_temp=t_start_window;
   for it=1:nt
       t_start_window_temp=t_start_window-t_vect(it);
       %size(dt_to_nearest(it)), size(min(t_start_window_temp(t_start_window_temp>0)))
       if numel(t_start_window_temp(t_start_window_temp>0)<1);
        dt_to_nearest(it,current_window)=min(t_start_window_temp(t_start_window_temp>0));
       else
           dt_to_nearest(it,current_window)=nan;
       end
   end
            
end
    


histogram(dt_to_nearest,'BinMethod','fd')

end

