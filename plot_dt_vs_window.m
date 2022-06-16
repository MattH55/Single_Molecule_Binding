function H = plot_dt_vs_window(window_size,dt_window,dt_window_error,mdl)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
xmax=25000;
xmin=1;
dt_result_error_sem=dt_window_error./sqrt(max(window_size)./window_size);


yfcn=@(b,x) b.*x.^(-1);
%xfit=linspace(1,min(max(window_size),xmax));
xfit=linspace(1,xmax);
yfit=yfcn(mdl,xfit);
close all;
H=errorbar(window_size/4,dt_window,dt_result_error_sem,'*');
xlabel('Number of binding sites in window');
ylabel('Time to next binding event (ms)');
%ylim([0 max(dt_window+3*dt_result_error_sem)])
ylim([0 1e4])
xlim([0 6000])
xline4=[4;4];
yline4=[0;10*max(dt_window+dt_window_error)];

hold on; 
H2=plot(xfit/4,yfit,xline4/4,yline4);
%set(gca, 'YScale', 'log')

filename=inputname(2);

saveas(gca,filename,"pdf")
saveas(gca,filename,"fig")
saveas(gca,filename,"png")

end