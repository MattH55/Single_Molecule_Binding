function H = plot_dt_vs_window(window_size,dt_window,dt_window_error,mdl)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
xmax=25000;
xmin=1;
dt_result_error_sem=dt_window_error./sqrt(max(window_size)./window_size);

C = {'#808080','b','r','g','y',[.5 .6 .7],[.8 .2 .6]};

yfcn=@(b,x) b.*x.^(-1);
[BETA,R,J,COVB,MSE]=nlinfit(window_size,dt_window,yfcn,mdl,'Weights',1./dt_window_error)
%xfit=linspace(1,min(max(window_size),xmax));
xfit=linspace(1,xmax);
yfit=yfcn(BETA,xfit);
close all; figure(1);hold on;
for i=1:5
    errorbar(window_size(i)/4,dt_window(i),dt_result_error_sem(i),'.','MarkerSize',12,'Color',C{i});
end
errorbar(window_size(6:end)/4,dt_window(6:end),dt_result_error_sem(6:end),'.','MarkerSize',12,'Color','black');
    %colormap([128,128,128]',[0;0;128],[128;0;0])
xlabel('Number of binding sites in window');
ylabel('Time to next binding event (ms)');
%ylim([0 max(dt_window+3*dt_result_error_sem)])
ylim([0 5e3])
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