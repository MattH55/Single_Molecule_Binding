function [avg_rate,error_avg_rate,mdl,mdl_errors,xfit,yfit] = footprint_norm_minimal(footprint_size_nm,window_size,dt_result)%,dt_result_error)
%UNTITLED3 Summary of this function goes here
%   footprint sizer ~4nm
yfcn = @(b,x) b(1).*(x).^b(2);
beta0=[ 7.654e+07,-1];
%W=1./(dt_result_error.^2);

%w = warning ('on','all');

%size(window_size'),size(dt_result)
%window_size,dt_result'

[mdl,R,J,CovB] = nlinfit(window_size,dt_result,yfcn,beta0);%,'Weights',W);
%warning(w)

mdl_errors=sqrt(diag(CovB));
avg_rate=yfcn(mdl,footprint_size_nm);
error_avg_rate=sqrt((mdl_errors(1)*footprint_size_nm^(-mdl(2))).^2+(mdl(1)*mdl(2)*(footprint_size_nm^(-mdl(2)-1))*mdl_errors(2))^2);

xfit=linspace(0,max(dt_result)*1.2);
yfit=yfcn(mdl,xfit);

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

