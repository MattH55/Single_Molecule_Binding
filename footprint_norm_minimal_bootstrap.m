function [avg_rate_bs,error_avg_rate_bs,mdl_bs,mdl_errors_bs,MSE_bs,xfit,yfit] = footprint_norm_minimal_bootstrap(footprint_size_nm,window_size,dt_result,dt_result_error,niter)
%UNTITLED3 Summary of this function goes here
%   footprint sizer ~4nm
yfcn = @(b,x) b(1).*(x).^b(2);
beta0=[ 7.654e+07,-1];
%W=1./(dt_result_error.^2);

%w = warning ('on','all');

%size(window_size'),size(dt_result)
%window_size,dt_result'
avg_rate_bs=zeros(niter,1);
mdl_errors_bs=zeros(niter,2);
mdl_bs=zeros(niter,2);
error_avg_rate_bs=zeros(niter,1);
MSE_bs=zeros(niter,1);

%nwindows_vect=max(window_size)./window_size
%dt_result_error_sem=dt_result_error;
dt_result_error_sem=dt_result_error./sqrt(max(window_size)./window_size);
for i=1:niter

    %warning('go');
    try
        [mdl_temp,R,J,CovB,MSE] = nlinfit(window_size,dt_result+randn(size(dt_result)).*(dt_result_error_sem),yfcn,beta0);%,'Weights',W);
    catch
        'Fitting Function Error, returning nans'
        mdl_bs(i,:)=nan(1,2);
        MSE_bs(i)=nan;
        mdl_errors_bs(i,:)=nan(1,2);
        avg_rate_bs(i)=nan;
        error_avg_rate_bs(i)=nan;
    end

    
        warning('go');
    if not(strcmp(lastwarn,'go'))
        mdl_bs(i,:)=nan(1,2);
        MSE_bs(i)=nan;
        mdl_errors_bs(i,:)=nan(1,2);
        avg_rate_bs(i)=nan;
        error_avg_rate_bs(i)=nan;
    else
        mdl_bs(i,:)=mdl_temp;
        MSE_bs(i)=MSE;
        mdl_errors_bs(i,:)=sqrt(diag(CovB));
        avg_rate_bs(i)=yfcn(mdl_bs(i,:),footprint_size_nm);
        error_avg_rate_bs(i)=sqrt((mdl_errors_bs(1)*footprint_size_nm^(-mdl_bs(2))).^2+(mdl_bs(1)*mdl_bs(2)*(footprint_size_nm^(-mdl_bs(2)-1))*mdl_errors_bs(2))^2);
    end
end
xfit=linspace(0,max(dt_result)*1.2);
yfit=yfcn(mean(mdl_bs,1),xfit);

%%str = "Power Law Fit: y=a*x^b";
%str=str+newline+"a="+num2str(mdl(1),'%.3e')+char(177)+num2str(mdl_errors(1),'%.3e');
%str=str+newline+"b="+num2str(mdl(2),'%.3e')+char(177)+num2str(mdl_errors(2),'%.3e');
%str=str+newline+newline+"Binding time per 4nm site (ms): "+newline+num2str(avg_rate,'%.3e')+char(177)+num2str(error_avg_rate,'%.3e')

%annotation('textbox',[0.6 0.7 0.1 0.1],'String',str,'FitBoxToText','on','LineWidth',3,...
%    'FontWeight','bold',...
%    'FontSize',12,...
%    'FontName','Arial');
%filename_str="plot_"+inputname(3);
%saveas(gcf,filename_str+'.fig');
%saveas(gcf,filename_str+'.eps');
%saveas(gcf,filename_str+'.pdf');


end

