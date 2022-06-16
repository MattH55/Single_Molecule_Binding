function [avg_k,sem_k,dt_dist_temp,bin_l_edges,bin_centers] = koff_position(dt_ms,xmean,nbins)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
binwidth=range(xmean)/nbins;

bin_l_edges=linspace(min(xmean),max(xmean)-binwidth,nbins);
bin_r_edges=bin_l_edges+binwidth;
bin_centers=bin_l_edges+binwidth/2;

%dt_bins=cell(nbins,1);


dt_dist_temp=nan(0,nbins);
ct=zeros(nbins,1);

npt=numel(dt_ms);

for i=1:nbins-1
    for j=1:npt
        if (xmean(j)>=bin_l_edges(i) & xmean(j)<bin_r_edges(i))
            ct(i)=ct(i)+1;
            if ct(i)==max(ct)
                dt_dist_temp=[dt_dist_temp;nan(1,nbins)];
            end
            dt_dist_temp(ct(i),i)=dt_ms(j);
        end
    end
end

avg_k=nanmean(dt_dist_temp,1);
sem_k=nanstd(dt_dist_temp,1,1)./sqrt(sum(~isnan(dt_dist_temp),1));

plot(bin_l_edges+binwidth/2,avg_k(1:end))

end